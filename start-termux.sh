#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Purpur 1.21.1 Android Termux Startup Script
# ==============================================================================
# Purpose: Launches the Purpur Minecraft server with optimized Aikar's G1GC flags inside Termux.
# Use Case: Termux environments on Android (ARM64 architecture).
# Hardware Layer Note: Termux runs inside Android's user space. Mobile OS process managers
# (like LMK/Phantom Process Killer) may kill high-resource background tasks.
# ==============================================================================

# Reference standard Termux execution path for OpenJDK java executable
JAVA_BIN="/data/data/com.termux/files/usr/bin/java"
if [ ! -f "$JAVA_BIN" ]; then
  # Fallback to standard path-resolved command if termux-exec or alternative root is used
  JAVA_BIN="java"
fi

# Memory allocation (Flexible base of 4G; scale down to 2G/3G if Android system memory is limited)
MEMORY="4G"
JAR_FILE="purpur-1.21.1.jar"

echo "========================================================"
echo "Starting Purpur Minecraft Server on Termux..."
echo "Using Java Binary: ${JAVA_BIN}"
echo "Memory Allocation: ${MEMORY}"
echo "========================================================"

# Run server with identical optimized Aikar's G1GC flags.
# -XX:SurvivorRatio=32 is correctly configured for heap survival limits.
exec "$JAVA_BIN" -Xms${MEMORY} -Xmx${MEMORY} \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+DisableExplicitGC \
  -XX:+AlwaysPreTouch \
  -XX:G1NewSizePercent=30 \
  -XX:G1MaxNewSizePercent=40 \
  -XX:G1HeapRegionSize=8m \
  -XX:G1ReservePercent=20 \
  -XX:G1HeapWastePercent=5 \
  -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=15 \
  -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 \
  -XX:SurvivorRatio=32 \
  -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1 \
  -Dusing.aikars.flags=https://mcflags.emc.gs \
  -Daikars.new.flags=true \
  -jar "${JAR_FILE}" nogui
