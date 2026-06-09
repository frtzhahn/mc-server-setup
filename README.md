# Minecraft Purpur 1.21.1 Deployment Blueprint

A production-ready, highly optimized open-source deployment blueprint for a Minecraft server running **Purpur 1.21.1**. This repository serves as a portable host-independent template designed to be easily cloned, configured, and run across multiple platforms.

---

## 1. Overview & Highlights

This blueprint outlines a high-performance **22-plugin server architecture** built on top of **Purpur 1.21.1** (a highly optimized fork of Paper designed for maximum customization and performance). It provides out-of-the-box cross-play support, high-end anti-cheat integration, and automated packet interception.

### Core Architectural Highlights
*   **Engine & Runtime**: Purpur 1.21.1 running on OpenJDK 21. Purpur offers extensive configuration handles (`purpur.yml`) to disable features that consume unnecessary ticks, while maintaining vanilla mechanics.
*   **Geyser & Floodgate Cross-Play**: Standalone cross-play integration mapping Bedrock Edition network packets to Java Edition protocols. This allows players on consoles, mobile devices, and Windows 10/11 Bedrock client versions to connect seamlessly to this Java-based server.
*   **GrimAC Anti-Cheat Protection Matrix**: A predictive, multi-threaded anti-cheat engine. By running checks asynchronously, GrimAC minimizes the main thread performance cost typical of legacy anti-cheat systems. It monitors player movement and interaction packets, comparing them against simulated physics models.
*   **Custom FreecamShield Packet Wrapper**: A custom lightweight packet wrapper located under `/FreecamShield`. By utilizing a low-level packet listener from **ProtocolLib**, it intercept client-side logic on `PacketType.Play.Client.USE_ITEM_ON`. It calculates the precise Euclidean distance between the player's execution location and the target block coordinates. If the calculated distance exceeds **15.0 blocks**, the interaction is cancelled, a warning is sent to the server console, and the client receives an interaction block notification:
    $$\text{Distance}^2 = \Delta x^2 + \Delta y^2 + \Delta z^2 > 225.0$$

---

## 2. Repository Structure Blueprint

The repository is organized to separate code profiles and configurations from stateful database maps and compiled core binaries:

```text
├── .gitignore                      # Global repository filter matrix
├── README.md                       # Master configuration and deployment manual
├── server.properties               # Core server properties configuration
├── bukkit.yml                      # Bukkit-specific settings
├── spigot.yml                      # Spigot performance/mechanical tweaks
├── paper.yml                       # Paper global/world-specific configurations
├── purpur.yml                      # Purpur-specific customization options
├── pufferfish.yml                  # Pufferfish-specific asynchronous optimization options
├── start.sh                        # Linux start script (Arch, CachyOS, Ubuntu)
├── start.bat                       # Windows Command Prompt startup script
├── start-termux.sh                 # Android Termux startup script
├── FreecamShield/                  # Custom plugin Maven project source directory
│   ├── pom.xml                     # Maven project configuration file
│   └── src/                        # Custom packet listener source code
└── plugins/                        # Config profiles directory (binary jars excluded)
    ├── AuthMe/                     # User registration & session security configs
    ├── Chunky/                     # World pre-generation parameters
    ├── Citizens/                   # Non-Player Character (NPC) layouts
    ├── DiscordSRV/                 # Discord-to-game chat bridge configuration
    ├── Geyser-Spigot/              # Bedrock-to-Java translation properties
    ├── GrimAC/                     # Anti-cheat checks and detection tuning
    └── ...                         # Remaining configurations for the 22 plugins
```

> [!IMPORTANT]
> **Portability Exclusion Rule**: Core server binaries (`purpur-1.21.1.jar`), world database arrays (`world/`, `world_nether/`, `world_the_end/`), log directories (`logs/`), and active third-party plugin `.jar` files are explicitly excluded via `.gitignore` to maintain repository portability, eliminate mutable host dependencies, and conform to open-source licensing compliance.

---

## 3. Universal Host Prerequisites

To deploy this blueprint, the host machine must satisfy the following hardware and software requirements:

### Software Logic (Operating System & JVM)
*   **Runtime Environment**: **Java 21 OpenJDK** (specifically 64-bit).
*   **Operating System**: Linux kernel 5.15+ (Arch Linux, CachyOS, Ubuntu, Debian), Windows 10/11 (Version 21H2 or newer), or Android 10+ with Termux.
*   **Port Allocations**: 
    *   **Java Minecraft**: Port `25565` (TCP)
    *   **Bedrock Minecraft (Geyser)**: Port `19132` (UDP)

### Hardware Logic (Host Infrastructure)
*   **Processor (CPU)**: 
    *   *Minimum*: 2 physical cores, 4 threads @ 2.5 GHz+ (Intel 6th Gen Core / AMD Ryzen 1000 series / ARM Cortex-A72 equivalent).
    *   *Recommended*: High single-thread performance CPU @ 3.5 GHz+ (Intel 12th Gen Core / AMD Ryzen 5000 series or newer) to process tick physics without delay.
*   **System Memory (RAM)**:
    *   *Minimum*: 6 GB physical RAM (allocating 4 GB for JVM heap, leaving 2 GB for host OS overhead).
    *   *Recommended*: 8 GB to 16 GB physical RAM. High-frequency or ECC RAM is recommended for long-term server stability.
*   **Storage (Disk I/O)**:
    *   Solid State Drive (SSD) or Non-Volatile Memory Express (NVMe) with at least 100 MB/s sustained random write speeds. Minecraft world saving and chunk loading are heavily bound by disk write-ahead log (`-wal`) latency.
*   **System Firmware (BIOS/UEFI)**: Ensure the host CPU virtualization settings (Intel VT-x / AMD-V) are enabled. CPU frequency governors must be set to `performance` mode rather than `powersave` at the kernel or BIOS level to prevent clock speed throttling during high server loads.

---

## 4. Deep-Dive Platform Setup Guides

### A. Linux Distributions (Arch, CachyOS, Ubuntu, Debian)
Ensure Java 21 OpenJDK is installed and configured on the system.

1.  **Install OpenJDK 21**:
    *   **Arch Linux / CachyOS**:
        ```bash
        sudo pacman -Syu jdk21-openjdk
        ```
    *   **Ubuntu / Debian / Linux Mint**:
        ```bash
        sudo apt update
        sudo apt install openjdk-21-jre-headless
        ```
2.  **Verify the Java Installation**:
    ```bash
    java -version
    ```
    Ensure the output displays Java version `21`.
3.  **Execute the Initialization Script**:
    Configure executable permissions and launch:
    ```bash
    chmod +x start.sh
    ./start.sh
    ```

---

### B. Windows Platforms (10 / 11)
Windows environments require manually ensuring the Java executable is added to the system's Environment Variables.

1.  **Install OpenJDK 21**:
    *   Download the official MSI installer from a distribution repository (e.g., [Eclipse Temurin](https://adoptium.net/) or [Microsoft Build of OpenJDK](https://learn.microsoft.com/en-us/semantic-kernel/)).
    *   Run the installer, ensuring the option **"Add to PATH"** is selected.
2.  **Configure System Environment Paths manually (if necessary)**:
    *   Open **System Properties** > **Advanced** > **Environment Variables**.
    *   Under **System Variables**, select **Path** and click **Edit**.
    *   Ensure the path to the JDK bin directory (e.g., `C:\Program Files\Eclipse Foundation\jdk-21.x.x-hotspot\bin`) is listed.
3.  **Execute the Script**:
    *   Open Command Prompt (CMD) in the server directory and execute:
        ```cmd
        start.bat
        ```
    *   Alternatively, double-click `start.bat` from Windows File Explorer.

---

### C. Android Termux Installations
Android devices run in a sandbox user environment. You must allocate resources properly to prevent processes from being terminated.

1.  **Configure Termux Repositories and Update**:
    ```bash
    pkg update && pkg upgrade -y
    ```
2.  **Install OpenJDK 21**:
    ```bash
    pkg install openjdk-21 -y
    ```
3.  **Request Storage Allocation**:
    Grants Termux access to local device folders (required to read/write map profiles if desired):
    ```bash
    termux-setup-storage
    ```
4.  **Execute the Script**:
    Configure script permissions and boot:
    ```bash
    chmod +x start-termux.sh
    ./start-termux.sh
    ```
    *(Note: Ensure you run `termux-wake-lock` in the Termux terminal to prevent the Android OS from sleeping or putting the process in a low-power CPU state when the screen is turned off.)*

---

## 5. Complete Initialization & Deployment Steps

Follow these exact steps to download the engine files, establish external network routing, and boot the server.

### Step 1: Download the Purpur Server Engine
Download the latest Purpur 1.21.1 binary using `curl` or `wget`. Ensure it is placed directly in the root directory:
```bash
curl -o purpur-1.21.1.jar https://api.purpurmc.org/v2/purpur/1.21.1/latest/download
```

### Step 2: Compile the Custom FreecamShield Plugin
If you wish to compile the custom anti-cheat wrapper:
1.  Ensure **Maven** is installed on the build machine.
2.  Navigate to the project folder, build the package, and move it to your plugins folder:
    ```bash
    cd FreecamShield
    mvn clean package
    cp target/FreecamShield-1.0-SNAPSHOT.jar ../plugins/
    cd ..
    ```

### Step 3: Setup the playit.gg Tunneling Agent
To expose the server to the internet without configuring router port-forwarding:

1.  **Download the playit binary**:
    *   **Linux**:
        ```bash
        curl -o playit https://github.com/playit-cloud/playit-agent/releases/latest/download/playit-linux-amd64
        chmod +x playit
        ```
    *   **Android (Termux)**:
        ```bash
        pkg install playit -y
        ```
    *   **Windows**: Download the Windows executable from [playit.gg](https://playit.gg/download) and place it in the root folder.
2.  **Reset and Re-authenticate the Tunnel Configuration**:
    Run the reset command to clear out stale bindings or credentials:
    ```bash
    ./playit reset
    ```
3.  **Boot the Tunnel Agent**:
    ```bash
    ./playit
    ```
    *   This will display an authentication URL in the terminal console (e.g., `https://playit.gg/claim/xxxx-xxxx`).
    *   Copy and open the link in your web browser.
    *   Log in to your playit.gg account to bind this server agent.
4.  **Create Routing Tunnels on the Dashboard**:
    *   **Java Tunnel**: Add a tunnel with type `Minecraft Java`, mapping local port `25565` (TCP) to a random public IP on the playit WAN.
    *   **Bedrock Tunnel**: Add a second tunnel with type `Minecraft Bedrock` (or custom UDP), mapping local port `19132` (UDP) to expose cross-play connections.
    *   Save the configurations on the website. Playit will assign a permanent domain address (e.g., `example.ply.gg:12345`).

### Step 4: Accept the Minecraft EULA
Before running the engine for the first time, you must accept the EULA:
1.  Run the start script once (`./start.sh`, `start.bat`, or `./start-termux.sh`). The engine will shut down immediately and generate `eula.txt`.
2.  Open `eula.txt` and change the parameter:
    ```text
    eula=true
    ```

### Step 5: Final Boot
Re-run the corresponding startup script to generate the world files, initialize the 22-plugin directories, and load the engine.

---

## 6. Local Infrastructure Troubleshooting

### A. Fixing playit.gg Data Desync Loops
*   **Symptom**: The console displays `playit` agent connection errors, or the web dashboard indicates the agent is offline even when running locally.
*   **Cause**: A configuration state mismatch between `playit.toml` and the remote router node.
*   **Resolution**:
    1.  Terminate the `playit` process.
    2.  Locate and delete the `playit.toml` configuration file in your directory (on Linux, it may also exist at `~/.config/playit/playit.toml` or `/etc/playit/playit.toml`).
    3.  Run the reset command: `playit reset` or `./playit reset`.
    4.  Restart the agent via `./playit` and complete the claim link process again.

### B. Resolving Anti-Cheat False Positives (GrimAC)
*   **Symptom**: Legitimate players are kicked or dragged back (rubberbanded) when using certain custom furniture items, traversing specific block types, or running with high network latency.
*   **Resolution**:
    1.  Find the exact check identifier. In the console, execute `/grim verbose` or scan the log files (`logs/latest.log`) for messages containing `[GrimAC] <Player> failed <CheckName>`.
    2.  Locate `plugins/GrimAC/config.yml`.
    3.  Locate the specific check block (e.g., `reach`, `simulation`, `badpackets`, or `boat`).
    4.  Increase the violation threshold for that check, or change its state to log-only:
        ```yaml
        # Example modification inside GrimAC config
        checks:
          reach:
            enabled: true
            threshold: 10 # Increase to reduce false positives
        ```
    5.  Execute `/grim reload` in the console to apply changes without restarting.

### C. Managing Cross-Play Connection Failures (Geyser/Floodgate)
*   **Symptom**: Bedrock Edition players receive "Unable to connect to world" or "Connection Timed Out" errors when attempting to join.
*   **Resolution**:
    1.  **Check Tunnels**: Ensure your `playit` agent is running a UDP tunnel on port `19132` (Geyser default Bedrock port). A TCP tunnel alone will not forward Bedrock packets.
    2.  **Verify Floodgate Identity Keys**: Confirm the file `floodgate-spigot.jar` is present in the `plugins/` folder and that `plugins/floodgate/key.pem` is loaded. Geyser uses this key to sign Bedrock authentication packets.
    3.  **Confirm Authentication Mode**:
        *   Since `server.properties` is configured with `online-mode=false` (to support AuthMe registration), ensure that `auth-type` inside `plugins/Geyser-Spigot/config.yml` is configured to `floodgate`:
            ```yaml
            # config.yml inside plugins/Geyser-Spigot
            remote:
              auth-type: floodgate
            ```
        *   This routes authentication checks through Floodgate rather than checking with Mojang's official servers directly.

---

## 7. Master Plugin Index & Infrastructure Mapping

The following table indexes all 22 plugins deployed in this server configuration, along with their core infrastructure function:

| Index | Plugin Name | Category | Primary Infrastructure Purpose |
|---|---|---|---|
| 1 | **AuthMe** | Security | Handles player registration and password encryption (`bcrypt`) for offline-mode servers. |
| 2 | **Chunky** | Optimization | Pre-generates world chunks via a command-line queue to eliminate CPU spikes caused by on-the-fly chunk generation during exploration. |
| 3 | **Citizens** | Gameplay | Spawns persistent non-player characters (NPCs) that act as trading merchants, quest givers, or server guides. |
| 4 | **DiscordSRV** | Integration | Establishes a socket bridge between the Minecraft server console/in-game chat and a remote Discord channel. |
| 5 | **FurnitureLib** | Framework | A system wrapper designed to inject custom 3D models and furniture objects without modifying base game assets. |
| 6 | **GSit** | Gameplay | Provides custom pose modifiers allowing players to sit, crawl, or lay down on blocks. |
| 7 | **Geyser-Spigot** | Cross-Play | Translates Bedrock Edition UDP packets into Java Edition TCP packets on the fly. |
| 8 | **floodgate** | Cross-Play | Complements Geyser by injecting custom UUIDs, bypassing the Mojang login checks for Bedrock players. |
| 9 | **GrimAC** | Anti-Cheat | Analyzes player packets on an asynchronous thread to block exploits (speed, fly, reach) via server-side physics simulation. |
| 10 | **Harbor** | Gameplay | A sleep coordinator that calculates player sleep ratios and skips the night cycle when thresholds are met. |
| 11 | **LuckPerms** | Administration | An advanced permission manager using SQL/JSON backends to assign permission nodes, groups, and inheritances. |
| 12 | **ProtocolLib** | Library | An API framework that allows plugins to monitor, intercept, and edit low-level network packets (used by GrimAC and FreecamShield). |
| 13 | **Shopkeepers** | Gameplay | Interfaces with Citizens to manage customized trading inventories for player-owned stores. |
| 14 | **SkinsRestorer** | Customization | Fetches skin profiles from the Mojang API using nickname signatures and applies them to offline-mode profiles. |
| 15 | **Vault** | Library | A permission, chat, and economy hook API that links plugin services under a unified framework. |
| 16 | **ViaVersion** | Compatibility | Enables newer Minecraft clients (e.g., 1.21.x+) to connect to older server engine runtimes. |
| 17 | **ViaBackwards** | Compatibility | Enables older Minecraft clients (e.g., 1.20.x) to connect to newer server engine runtimes. |
| 18 | **ViewDistanceTweaks**| Optimization | Dynamically reduces simulation and view distances when server TPS drops below 19.0, restoring them as performance improves. |
| 19 | **spark** | Profiling | A high-precision profiler recording CPU usage, thread dumps, memory allocation rates, and garbage collection frequency. |
| 20 | **squaremap** | Mapping | Renders a 2D map of the server worlds to a web browser via an internal lightweight HTTP daemon. |
| 21 | **PlaceholderAPI** | Library | Resolves internal values into readable text placeholders, enabling unified display boards. |
| 22 | **PlayTime** | Administration | Records player session durations to a local database for tracking player retention and milestones. |
