# FlexRoad configuration


DEBUG:=n

# LAN settings
FR_LAN_TYPE:=static
FR_LAN_IP:=""
FR_LAN_MASK:=""
FR_LAN_DNS:=""
FR_LAN_GW:=""


# DSRC settings
FR_DSRC:=y
FR_DSRC_SSID:="MESH-802.11P"
FR_DSRC_CHANNEL:=178
FR_DSRC_PROTO:="11a"
FR_DSRC_BSSID:="02:12:34:56:78:9a"
FR_DSRC_COUNTRY:=RU
FR_DSRC_CHAINBW:=y
FR_DSRC_GW:=y
FR_DSRC_BLA:=y
FR_DSRC_VIS_SRV:=y
FR_DSRC_VIS_CLI:=y


#configure tracker settings
FR_TRACKER:=n
FR_DISTANCE:=n

include $(TOPDIR)/config/dsrc.mk
include $(TOPDIR)/config/sierra.mk
include $(TOPDIR)/config/lan.mk

apply_switch: \
	dsrc_apply_switch \
	lan_apply_switch
#	sierra_apply_switch

apply_settings: \
	apply_switch \
	dsrc_apply_settings \
	lan_apply_settings
#	sierra_apply_settings

software:
intro:
	@echo
	@echo "Makefile for FlexRoad DSRC Router"
	@echo
	@echo "Wi-Fi 802.11p/B.A.T.M.A.N. config:"
	@echo "    BLA=$(FR_DSRC_BLA), COUNTRY=$(FR_DSRC_COUNTRY), CHANNEL=$(FR_DSRC_CHANNEL)"
	@echo
	@echo "LAN config ($(FR_LAN_TYPE)):"
	@echo "    IP=$(FR_LAN_IP)"
	@echo
