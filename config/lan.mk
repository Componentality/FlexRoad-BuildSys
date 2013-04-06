#configure lan settings
SAHA_FR_GW_LAN_STATIC.package:
SAHA_FR_GW_LAN_IP.package:
SAHA_FR_GW_LAN_MASK.package:
SAHA_FR_GW_LAN_DEFAULT_GW.package:
SAHA_FR_GW_LAN_DNS.package:

SAHA_FR_GW_LAN_IP.set-cfg-value: ID=\"$(FR_LAN_IP)\"
SAHA_FR_GW_LAN_MASK.set-cfg-value: ID=\"$(FR_LAN_MASK)\"
SAHA_FR_GW_LAN_DEFAULT_GW.set-cfg-value: ID=\"$(FR_LAN_GW)\"
SAHA_FR_GW_LAN_DNS.set-cfg-value: ID=\"$(FR_LAN_DNS)\"

ifeq ($(FR_LAN_TYPE),dhcp)
lan:SAHA_FR_GW_LAN_STATIC.unset-config
else
lan:SAHA_FR_GW_LAN_STATIC.set-config
endif

lan_apply_switch:\
	lan

lan_apply_settings:\
	SAHA_FR_GW_LAN_IP.set-cfg-value\
	SAHA_FR_GW_LAN_MASK.set-cfg-value\
	SAHA_FR_GW_LAN_DEFAULT_GW.set-cfg-value\
	SAHA_FR_GW_LAN_DNS.set-cfg-value

