#!/bin/bash
read -rp "Process name to monitor: " PROCESS_NAME
read -rp "Sample interval [Seconds]: " INTERVAL
INTERVAL=${INTERVAL:-2}
OUTPUT_FILE="cpu_log.txt"
CORES=$(nproc)
START_TIME=$(date +%s)
SAMPLE=0

# ── summary printed on Ctrl+C ─────────────────────────────────────
trap '
    ELAPSED=$(( $(date +%s) - START_TIME ))
    ELAPSED_FMT=$(printf "%02d:%02d:%02d" $((ELAPSED/3600)) $((ELAPSED%3600/60)) $((ELAPSED%60)))
    echo ""
    echo    "════════════════════════════════════"
    echo    "║           FINAL SUMMARY          ║"
    echo    "════════════════════════════════════"
    printf  "Process  : %-20s  \n" "$PROCESS_NAME"
    printf  "Runtime  : %-20s  \n" "$ELAPSED_FMT"
    printf  "Samples  : %-20s  \n" "$SAMPLE"
    echo    "════════════════════════════════════"
    awk -F"|" -v cores="$CORES" "NR>1 {
        s1=\$2+0; s_all=\$3+0
        sum1+=s1; sum_all+=s_all; count++
        if (s1    > max1    || max1==\"\")    max1=s1
        if (s1    < min1    || min1==\"\")    min1=s1
        if (s_all > max_all || max_all==\"\") max_all=s_all
        if (s_all < min_all || min_all==\"\") min_all=s_all
    } END {
        printf \"════════════════════════════════════\n\"
        printf \"  ── 1 core ──                     \n\"
        printf \"  Avg : %-20.4f%%  \n\", sum1/count
        printf \"  Min : %-20.4f%%  \n\", min1
        printf \"  Max : %-20.4f%%  \n\", max1
        printf \"════════════════════════════════════\n\"
        printf \"  ── all %d cores ──              \n\", cores
        printf \"  Avg : %-20.4f%%  \n\", sum_all/count
        printf \"  Min : %-20.4f%%  \n\", min_all
        printf \"  Max : %-20.4f%%  \n\", max_all
        printf \"════════════════════════════════════\n\"
    }" "$OUTPUT_FILE"
    exit
' INT

# ── header ────────────────────────────────────────────────────────
clear
echo   "════════════════════════════════════"
echo   "║         CPU MONITOR              ║"
echo   "════════════════════════════════════"
printf "  Process  : %-20s    \n" "$PROCESS_NAME"
printf "  Interval : %-17s    \n" "$INTERVAL"
printf "  Cores    : %-20s    \n" "$CORES"
echo   "════════════════════════════════════"
echo ""

echo "Timestamp  |  1-core%  |  all-cores%" > "$OUTPUT_FILE"

# ── main loop ─────────────────────────────────────────────────────
while true; do
    PID=$(pgrep "$PROCESS_NAME" | head -1)

    if [[ -z "$PID" ]]; then
        echo "⚠  Process not found — retrying in ${INTERVAL}s"
        sleep "$INTERVAL"
        continue
    fi

    STAT1=$(cat /proc/$PID/stat 2>/dev/null)
    TIME1=$(date +%s%N)
    sleep "$INTERVAL"
    STAT2=$(cat /proc/$PID/stat 2>/dev/null)
    TIME2=$(date +%s%N)

    if [[ -z "$STAT1" || -z "$STAT2" ]]; then
        echo "⚠  Process ended mid-sample"
        continue
    fi

    TICKS1=$(echo "$STAT1" | awk '{print $14+$15}')
    TICKS2=$(echo "$STAT2" | awk '{print $14+$15}')
    ELAPSED_S=$(echo "scale=6; ($TIME2 - $TIME1) / 1000000000" | bc)
    HZ=100

    ONE_CORE=$(echo "scale=4; ($TICKS2 - $TICKS1) / $HZ / $ELAPSED_S * 100" | bc)
    ALL_CORES=$(echo "scale=4; $ONE_CORE / $CORES" | bc)

    TIMESTAMP=$(date '+%H:%M:%S')
    ELAPSED=$(( $(date +%s) - START_TIME ))
    ELAPSED_FMT=$(printf "%02d:%02d:%02d" $((ELAPSED/3600)) $((ELAPSED%3600/60)) $((ELAPSED%60)))
    SAMPLE=$(( SAMPLE + 1 ))

    printf "───────────────────────────────────\n"
    printf "  Sample %-5s     \n" "#$SAMPLE"
    printf "  running %-8s    \n" "$ELAPSED_FMT"
    printf "  Time   : %-22s \n" "$TIMESTAMP"
    printf "───────────────────────────────────\n"
    printf "  1 core    : %-18s%% \n" "$ONE_CORE"
    printf "  all cores : %-18s%% \n" "$ALL_CORES"
    printf "───────────────────────────────────\n"

    echo "$TIMESTAMP  |  $ONE_CORE  |  $ALL_CORES" >> "$OUTPUT_FILE"
done
