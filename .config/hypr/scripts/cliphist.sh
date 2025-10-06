#!/usr/bin/env bash
#   ____ _ _       _     _     _
#  / ___| (_)_ __ | |__ (_)___| |_
# | |   | | | '_ \| '_ \| / __| __|
# | |___| | | |_) | | | | \__ \ |_
#  \____|_|_| .__/|_| |_|_|___/\__|
#           |_|
#
#  Wofi version for Wayland/Hyprland + swaync 🪄
#  by Camila Vertiz 💻

case $1 in
    d)
        # 🗑 Delete a single selected entry
        selected=$(cliphist list | wofi -S dmenu --prompt "🗑 Eliminar entrada" --allow-markup --style ~/.config/wofi/style-cliphist.css)
        if [ -z "$selected" ]; then
            # Se presionó ESC o no se eligió nada
            exit 0
        fi

        cliphist delete <<< "$selected"
	cliphist wipe
	notify-send "Cliphist" "Historial limpiado 🧹"

        ;;

    w)
        # 🧹 Wipe entire history (confirmation)
        choice=$(echo -e "🧹 Limpiar todo\n❌ Cancelar" | wofi -S dmenu --prompt "Historial del portapapeles")
        if [ -z "$choice" ] || [[ "$choice" == "❌ Cancelar" ]]; then
            notify-send "Cliphist" "Acción cancelada ❌"
            exit 0
        fi

        cliphist wipe
        notify-send "Cliphist" "Historial limpiado 🧹"
        ;;

    *)
        # 📋 Default: select and copy
        selected=$(cliphist list | wofi -S dmenu --prompt "Historial 📋" --allow-markup --style ~/.config/wofi/style-cliphist.css)
        if [ -z "$selected" ]; then
            # Se presionó ESC o no se eligió nada
            exit 0
        fi

        cliphist decode <<< "$selected" | wl-copy
        notify-send "Cliphist" "Texto copiado al portapapeles ✅"
        ;;
esac

