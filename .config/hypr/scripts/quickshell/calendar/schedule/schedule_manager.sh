#!/usr/bin/env bash

TODAY=$(date +"%Y-%m-%d")
TOMORROW=$(date -d "+1 day" +"%Y-%m-%d")
DOW=$(date +"%A")

TMPFILE=$(mktemp)
gcalcli agenda --tsv --nostarted --calendar emipon2832@gmail.com "${TODAY}" "${TOMORROW}" > "$TMPFILE" 2>/dev/null

if [ $? -ne 0 ] || [ ! -s "$TMPFILE" ]; then
    echo "{\"header\":\"${DOW} - No events\",\"link\":\"https://calendar.google.com\",\"lessons\":[]}"
    rm -f "$TMPFILE"
    exit 0
fi

awk -F'\t' '
BEGIN {
    first = 1
    prev_end = ""
    printf "{\"header\":\"'"${DOW}"' - Google Calendar\",\"link\":\"https://calendar.google.com\",\"lessons\":["
}
NR > 1 && NF >= 5 {
    title = $5
    gsub(/"/, "\\\"", title)
    gsub(/[\r\n]/, "", title)

    start_date = $1
    start_time = $2
    end_date = $3
    end_time = $4

    if (start_time == "") {
        cmd = "date -d \"" start_date " 00:00\" +%s"
        cmd | getline start_ts
        close(cmd)
        cmd = "date -d \"" end_date " 00:00\" +%s"
        cmd | getline end_ts
        close(cmd)
        time_str = "All day"
    } else {
        cmd = "date -d \"" start_date " " start_time "\" +%s"
        cmd | getline start_ts
        close(cmd)
        cmd = "date -d \"" end_date " " end_time "\" +%s"
        cmd | getline end_ts
        close(cmd)
        cmd = "date -d @" start_ts " +\"%H:%M\""
        cmd | getline ts_start_fmt
        close(cmd)
        cmd = "date -d @" end_ts " +\"%H:%M\""
        cmd | getline ts_end_fmt
        close(cmd)
        time_str = ts_start_fmt " - " ts_end_fmt
    }

    if (prev_end != "" && (start_ts - prev_end) > 600) {
        gap = int((start_ts - prev_end) / 60)
        if (!first) printf ","
        printf "{\"type\":\"break\",\"desc\":\"Break (%d min)\",\"start\":%s,\"end\":%s}", gap, prev_end, start_ts
        first = 0
    }

    if (!first) printf ","
    printf "{\"type\":\"class\",\"subject\":\"%s\",\"start\":%s,\"end\":%s,\"time\":\"%s\",\"room\":\"\",\"is_compact\":false,\"desc\":\"\"}", title, start_ts, end_ts, time_str
    first = 0
    prev_end = end_ts
}
END {
    printf "]}"
}
' "$TMPFILE"

rm -f "$TMPFILE"
