RKFACE_SITE = $(TOPDIR)/../framework/rkface
RKFACE_SITE_METHOD = local
RKFACE_INSTALL_STAGING = YES

# add dependencies
RKFACE_DEPENDENCIES = libion rv1108_vendor_storage

RKFACE_CONFIGURE_DEP_CONFIGS += BR2_PACKAGE_RKFACE_AUTHORIZATION

ifeq ($(BR2_PACKAGE_RKFACE), y)
    RKFACE_CONF_OPTS += -DENABLE_RKFACE=1

ifeq ($(BR2_PACKAGE_RKFACE_AUTHORIZATION), y)
    RKFACE_CONF_OPTS += -DENABLE_RKFACE_AUTH=1
endif

ifeq ($(BR2_PACKAGE_RKFACE_DETECTION),y)
    RKFACE_CONF_OPTS += -DENABLE_RKFACE_DETECTION=1
endif

ifeq ($(BR2_PACKAGE_RKFACE_RECOGNITION),y)
    RKFACE_CONF_OPTS += -DENABLE_RKFACE_RECOGNITION=1
endif

ifeq ($(BR2_PACKAGE_RKLIVE_DETECTION_2D),y)
    RKFACE_CONF_OPTS += -DENABLE_RKLIVE_DETECTION_2D=1
endif

ifeq (${RK_HAS_DEPTH_CAMERA},y)
    RKFACE_CONF_OPTS += -DRK_LIVE_DETECTION=3D
endif
endif

$(eval $(cmake-package))
