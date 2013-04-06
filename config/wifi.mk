SAHA_FR_DSRC_SSID.package: BEAUTY="wifi network SSID"
SAHA_FR_DSRC_SSID.package:

SAHA_FR_DSRC_CHANNEL.package:

SAHA_FR_DSRC_BSSID.package:

SAHA_FR_DSRC_COUNTRY_RU.package:

SAHA_FR_DSRC_COUNTRY_NL.package:

SAHA_FR_DSRC_COUNTRY_FI.package:

SAHA_FR_DSRC_PROTO.package:

FLEXROAD_WIFI_NONE.package:

ifeq ($(FR_DSRC_COUNTRY),RU)
country: SAHA_FR_DSRC_COUNTRY_RU.set-config
endif
ifeq ($(FR_DSRC_COUNTRY),NL)
country: SAHA_FR_DSRC_COUNTRY_NL.set-config
endif
ifeq ($(FR_DSRC_COUNTRY),FI)
country: SAHA_FR_DSRC_COUNTRY_FI.set-config
endif



apply_wifi_none_switch: \
	FLEXROAD_WIFI_NONE.set-config
