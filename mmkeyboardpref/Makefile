include theos/makefiles/common.mk

BUNDLE_NAME = mmkeyboardpref
mmkeyboardpref_FILES = mmkeyboardpref.mm
mmkeyboardpref_INSTALL_PATH = /Library/PreferenceBundles
mmkeyboardpref_FRAMEWORKS = UIKit
mmkeyboardpref_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/mmkeyboardpref.plist$(ECHO_END)
