export GO_EASY_ON_ME=1
export SDKVERSION=5.0

include theos/makefiles/common.mk
TWEAK_NAME = mmkeyboard
mmkeyboard_FILES = mmkeyboard_tweak.xm
mmkeyboard_FRAMEWORKS = UIKit QuartzCore

SUBPROJECTS = mmkeyboardpref installer remover

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
