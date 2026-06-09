@echo off
rem ============================================================================
 rem Purpur 1.21.1 Windows Startup Script
 rem ============================================================================
 rem Purpose: Launches the Purpur Minecraft server with optimized Aikar's G1GC flags.
 rem Use Case: Windows Command Prompt (CMD) environments.
 rem Hardware Layer Note: Allocations represent Software-level limits; ensure host physical
 rem RAM has at least 1-2GB overhead beyond this JVM allocation.
 rem ============================================================================

set MEMORY=4G
set JAR_FILE=purpur-1.21.1.jar

echo ========================================================
echo Starting Purpur Minecraft Server with %MEMORY% allocation...
echo ========================================================

java -Xms%MEMORY% -Xmx%MEMORY% -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8m -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar %JAR_FILE% nogui

echo.
echo Server execution terminated.
pause
