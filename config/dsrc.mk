#configure dsrc settings
FLEXROAD_DSRC.package:
FLEXROAD_DSRC.package: BEAUTY="B.A.T.M.A.N. capability"

SAHA_FR_BATMAN_DEBUG.package:
KMOD_BATMAN_ADV_DEBUG_LOG.package:
FLEXROAD_DSRC_GW.package:
SAHA_FR_GW_BLA.package:
saha-config-dsrc.package:
SAHA_FR_VIS_SERVER.package:
SAHA_FR_VIS_CLIENT.package:

SAHA_FR_DSRC_SSID.set-cfg-value: ID=\"$(FR_DSRC_SSID)\"
SAHA_FR_DSRC_BSSID.set-cfg-value: ID=\"$(FR_DSRC_BSSID)\"
SAHA_FR_DSRC_CHANNEL.set-cfg-value: ID=\"$(FR_DSRC_CHANNEL)\"
SAHA_FR_DSRC_PROTO.set-cfg-value: ID=\"$(FR_DSRC_PROTO)\"


ifeq ($(FR_DSRC_VIS_SRV),y)
vis: SAHA_FR_VIS_SERVER.set-config
else
vis: SAHA_FR_VIS_SERVER.unset-config
endif

ifeq ($(FR_DSRC_VIS_CLI),y)
visc: SAHA_FR_VIS_CLIENT.set-config
else
visc: SAHA_FR_VIS_CLIENT.unset-config
endif

ifeq ($(FR_DSRC_GW),y)
dsrc-gw:FLEXROAD_DSRC_GW.set-config
else
dsrc-gw:FLEXROAD_DSRC_GW.unset-config
endif

ifeq ($(FR_DSRC_BLA),y)
dsrc-bla:SAHA_FR_GW_BLA.set-config
else
dsrc-bla:SAHA_FR_GW_BLA.unset-config
endif

ifeq ($(DEBUG),y)
dsrc-debug: SAHA_FR_BATMAN_DEBUG.set-config KMOD_BATMAN_ADV_DEBUG_LOG.set-config
else
dsrc-debug: SAHA_FR_BATMAN_DEBUG.unset-config KMOD_BATMAN_ADV_DEBUG_LOG.unset-config
endif


echo_country:
	@echo COUNTRY SET TO -$(FR_DSRC_COUNTRY)-

include $(TOPDIR)/config/wifi.mk


ifeq ($(FR_DSRC),y)
dsrc:FLEXROAD_DSRC.set-config \
	saha-config-dsrc.s-top-package

dsrc_apply_settings:\
	SAHA_FR_DSRC_SSID.set-cfg-value\
	SAHA_FR_DSRC_BSSID.set-cfg-value\
	SAHA_FR_DSRC_PROTO.set-cfg-value\
	SAHA_FR_DSRC_CHANNEL.set-cfg-value\
	echo_country country\
	dsrc-debug \
	vis visc dsrc-gw dsrc-bla

else
dsrc:FLEXROAD_DSRC.unset-config \
	saha-config-dsrc.dpackage

dsrc_apply_settings:\
	SAHA_FR_BATMAN_DEBUG.unset-config \
	KMOD_BATMAN_ADV_DEBUG_LOG.unset-config \
	SAHA_FR_VIS_SERVER.unset-config \
	SAHA_FR_VIS_CLIENT.unset-config \
	vis visc dsrc-gw dsrc-bla

endif

dsrc_apply_switch:\
	dsrc

