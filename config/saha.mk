.SUFFIXES: .package .ipackage .s-top-package .set-config .spackage .set-cfg-value \
	.d-top-package .dpackage .unset-config .upackage

# supplied make variables
#
OWRT_CONFIG:= $(OPENWRT_AA)/.config
FEED:=        $(OPENWRT_AA)/scripts/feeds

#.spackage target causes previously disabled package to be set to 'Y'
%.s-top-package: PKG=$(subst .s-top-package,,$@)
%.s-top-package: %.package
	@echo Enable $(PKG) in .config;
	@sed "s/.*CONFIG_\([A-Z]\+\)_$(PKG) .*/CONFIG_\1_$(PKG)=y/" $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,}
	@$(FEED) update -i &> /dev/null

%.set-config: PKG=$(subst .set-config,,$@)
%.set-config: %.package
	@echo Enable $(PKG) in .config
	@sed "s/.*CONFIG_$(PKG) .*/CONFIG_$(PKG)=y/" $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,}

%.spackage: PKG=$(subst .spackage,,$@)
%.spackage: %.package
	@echo Enable $(PKG) in .config
	@sed "s/.*CONFIG_\([A-Z]\+\)_$(PKG) .*/CONFIG_\1_$(PKG)=y/" $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,}

# MESH_BSSD_ID.set-cfg-value: ID=MESH-802.11P
%.set-cfg-value: PKG=$(subst .set-cfg-value,,$@)
%.set-cfg-value: %.package
	$(if $ID,,$(error ID variable must be set in order to update .config settings))
	@echo Set $(PKG) to $(ID)
	@sed "s/.*CONFIG_$(PKG)[^_]*/CONFIG_$(PKG)=$(ID)/" $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,}

#.dpackage target sets feature to 'is not set' state
%.d-top-package: PKG=$(subst .d-top-package,,$@)
%.d-top-package: %.package
	@echo Set $(PKG) to disabled in .config
	@sed "s/CONFIG_\([A-Z]\+\)_$(PKG)=y/# CONFIG_\1_$(PKG) is not set/" $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,};
	@$(FEED) update -i &> /dev/null

%.dpackage: PKG=$(subst .dpackage,,$@)
%.dpackage: %.package
	@echo Set $(PKG) to disabled in .config
	@sed "s/CONFIG_\([A-Z]\+\)_$(PKG)=y/# CONFIG_\1_$(PKG) is not set/" $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,};


%.unset-config: PKG=$(subst .unset-config,,$@)
%.unset-config: %.package
	@echo Set $(PKG) to disabled in .config
	@sed "s/CONFIG_$(PKG)=y/# CONFIG_$(PKG) is not set/" $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,};

#installs package
%.ipackage: PKG=$(subst .ipackage,,$@)
%.ipackage: %.package
	@echo [PKG] installing $(PKG);
	@sed /CONFIG_PACKAGE_$(PKG)\=/d $(OWRT_CONFIG) > $(OWRT_CONFIG).sv; \
		mv $(OWRT_CONFIG){.sv,}
	@$(FEED) install -d y $(PKG) &> packages.log

#uninstall package
%.upackage: PKG=$(subst .upackage,,$@)
%.upackage: %.package
	@echo [PKG] uninstalling $(PKG);\
		$(FEED) uninstall $(PKG) &> /dev/null

