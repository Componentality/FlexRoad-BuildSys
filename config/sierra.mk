# configure modem settings

SAHA_FR_GW_SIERRA_APN.set-cfg-value: ID=\"$(FR_SIERRA_APN)\"
SAHA_FR_GW_SIERRA_APN.package:

SAHA_FR_GW_SIERRA_USER.set-cfg-value: ID=\"$(FR_SIERRA_USER)\"
SAHA_FR_GW_SIERRA_USER.package:

SAHA_FR_GW_SIERRA_PWD.set-cfg-value: ID=\"$(FR_SIERRA_PASS)\"
SAHA_FR_GW_SIERRA_PWD.package:

SAHA_FR_GW_SIERRA.package:
SAHA_FR_GW_SIERRA_START.package:
SAHA_FR_GW_SIERRA_DEFAULT.package:

saha-config-sierra.package:

ifeq ($(FR_SIERRA),y)
sierra:SAHA_FR_GW_SIERRA.set-config \
	saha-config-sierra.s-top-package
else
sierra:SAHA_FR_GW_SIERRA.unset-config
endif

ifeq ($(FR_SIERRA_DEFAULT),y)
sierra_default:SAHA_FR_GW_SIERRA_DEFAULT.set-config
else
sierra_default:SAHA_FR_GW_SIERRA_DEFAULT.unset-config
endif

ifeq ($(FR_SIERRA_AUTO),y)
sierra_auto:SAHA_FR_GW_SIERRA_START.set-config
else
sierra_auto:SAHA_FR_GW_SIERRA_START.unset-config
endif

sierra_apply_switch:\
	sierra

sierra_apply_settings:\
	SAHA_FR_GW_SIERRA_APN.set-cfg-value \
	SAHA_FR_GW_SIERRA_USER.set-cfg-value \
	SAHA_FR_GW_SIERRA_PWD.set-cfg-value \
	sierra_auto sierra_default

