package de.mocha.freecamshield;

import org.bukkit.Location;
import org.bukkit.entity.Player;
import org.bukkit.plugin.java.JavaPlugin;
import com.comphenix.protocol.PacketType;
import com.comphenix.protocol.ProtocolLibrary;
import com.comphenix.protocol.ProtocolManager;
import com.comphenix.protocol.events.ListenerPriority;
import com.comphenix.protocol.events.PacketAdapter;
import com.comphenix.protocol.events.PacketContainer;
import com.comphenix.protocol.events.PacketEvent;
import com.comphenix.protocol.wrappers.BlockPosition;

public class FreecamShield extends JavaPlugin {
    @Override
    public void onEnable() {
        getLogger().info("FreecamShield starting up...");
        ProtocolManager protocolManager = ProtocolLibrary.getProtocolManager();
        protocolManager.addPacketListener(new PacketAdapter(this, ListenerPriority.NORMAL, PacketType.Play.Client.USE_ITEM_ON) {
            @Override
            public void onPacketReceiving(PacketEvent event) {
                Player player = event.getPlayer();
                if (player == null) return;

                PacketContainer packet = event.getPacket();
                BlockPosition blockPos = packet.getBlockPositionModifier().readSafely(0);
                if (blockPos == null) {
                    return;
                }

                Location playerLoc = player.getLocation();
                double dx = playerLoc.getX() - (blockPos.getX() + 0.5);
                double dy = playerLoc.getY() - (blockPos.getY() + 0.5);
                double dz = playerLoc.getZ() - (blockPos.getZ() + 0.5);
                double distanceSquared = dx * dx + dy * dy + dz * dz;

                // Enforce a 15.0 block radius clamp (15.0 * 15.0 = 225.0)
                if (distanceSquared > 225.0) {
                    event.setCancelled(true);
                    player.sendMessage("§cInteraction blocked: Click distance exceeds 15.0 blocks.");
                    getLogger().warning(String.format("Blocked suspicious interaction from %s: click at [%d, %d, %d] is %.2f blocks away (player at [%.1f, %.1f, %.1f])",
                            player.getName(), blockPos.getX(), blockPos.getY(), blockPos.getZ(), Math.sqrt(distanceSquared),
                            playerLoc.getX(), playerLoc.getY(), playerLoc.getZ()));
                }
            }
        });
        getLogger().info("FreecamShield successfully hook to PacketType.Play.Client.USE_ITEM_ON.");
    }

    @Override
    public void onDisable() {
        getLogger().info("FreecamShield disabling...");
    }
}
