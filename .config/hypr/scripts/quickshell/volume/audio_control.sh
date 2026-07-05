#!/usr/bin/env bash

ACTION=$1
TYPE=$2
ID=$3
VAL=$4

case $ACTION in
    set-volume)
        # Intercept master slider to use wpctl
        if [[ "$ID" == "@DEFAULT@" ]]; then
            if [[ "$TYPE" == "sink" ]]; then
                wpctl set-volume @DEFAULT_AUDIO_SINK@ "$VAL%"
            elif [[ "$TYPE" == "source" ]]; then
                wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "$VAL%"
            fi
        else
            # Background specific sliders still use pactl
            pactl set-$TYPE-volume "$ID" "$VAL%"
        fi
        ;;
    toggle-mute)
        if [[ "$ID" == "@DEFAULT@" ]]; then
            if [[ "$TYPE" == "sink" ]]; then
                wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            elif [[ "$TYPE" == "source" ]]; then
                wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
            fi
        else
            pactl set-$TYPE-mute "$ID" toggle
        fi
        ;;
    set-default)
        # pactl is still preferred for setting defaults by name
        pactl set-default-$TYPE "$ID"
        ;;
    move)
        # Route a single stream to a different device and persist the choice.
        # TYPE=sink-input, ID=pulse sink-input index, VAL=target sink node-name.
        # NOTE: pactl move-sink-input is inert under this WirePlumber setup, so
        # we relink at the PipeWire level (pw-link) and set target.node metadata
        # so WirePlumber saves the target for future runs (no "switching back").
        python3 - "$ID" "$VAL" <<'PY'
import json, subprocess, sys
si_index, target_name = sys.argv[1], sys.argv[2]

def pj(cmd):
    try:
        return json.loads(subprocess.check_output(cmd, shell=True, stderr=subprocess.DEVNULL))
    except Exception:
        return []

# 1. sink-input by pulse index -> app name + current sink (pulse index == object.serial)
si = next((s for s in pj("pactl -f json list sink-inputs") if str(s.get("index")) == si_index), None)
if not si:
    sys.exit("stream not found")
app_name = si.get("properties", {}).get("application.name")
cur_sink_serial = str(si.get("sink", ""))

dump = {o["id"]: o for o in pj("pw-dump")}

def node_props(oid):
    return (dump.get(oid, {}).get("info", {}).get("props", {}) or {})

# 2. current sink serial -> bound-id
cur_sink_bid = None
for oid, o in dump.items():
    if o.get("type") == "PipeWire:Interface:Node" and \
       node_props(oid).get("media.class") == "Audio/Sink" and \
       str(node_props(oid).get("object.serial")) == cur_sink_serial:
        cur_sink_bid = oid
        break

# which sink bound-ids each stream node feeds
feeds = {}
for o in dump.values():
    if o.get("type") == "PipeWire:Interface:Link":
        feeds.setdefault(o["info"]["output-node-id"], set()).add(o["info"]["input-node-id"])

# 3. stream node: match app name, prefer the one linked to the current sink
cands = [oid for oid, o in dump.items()
         if o.get("type") == "PipeWire:Interface:Node"
         and node_props(oid).get("media.class") == "Stream/Output/Audio"
         and node_props(oid).get("application.name") == app_name]
if not cands:
    sys.exit("stream node not found")
stream_id = next((c for c in cands if cur_sink_bid in feeds.get(c, set())), cands[0])

# 4. target sink node-name -> bound-id
target_bid = next((oid for oid, o in dump.items()
                   if o.get("type") == "PipeWire:Interface:Node"
                   and node_props(oid).get("media.class") == "Audio/Sink"
                   and node_props(oid).get("node.name") == target_name), None)
if target_bid is None:
    sys.exit("target sink not found: " + target_name)

# 5. drop current output links, relink to target, persist via metadata
for o in dump.values():
    if o.get("type") == "PipeWire:Interface:Link" and o["info"]["output-node-id"] == stream_id:
        subprocess.run(["pw-cli", "destroy", str(o["id"])], stderr=subprocess.DEVNULL)
subprocess.run(["pw-link", str(stream_id), str(target_bid)], stderr=subprocess.DEVNULL)
subprocess.run(["pw-metadata", "-n", "default", str(stream_id), "target.node", str(target_bid)], stderr=subprocess.DEVNULL)
PY
        ;;
esac
