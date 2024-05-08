# Fix theming problems with qt5
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || export QT_QPA_PLATFORMTHEME="qt5ct"

# Append $HOME/bin to PATH if it exists
if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin:${PATH}"
fi

# Append $HOME/.local/bin to PATH if it exists
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:${PATH}"
fi
