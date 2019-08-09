# .xinitrc
# IM Settings
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export XMODIFIERS="@im=ibus"

# Fix Discord
export PULSE_LATENCY_MSEC=90

exec i3
