GO_EASY_ON_ME = 1

include theos/makefiles/common.mk
TWEAK_NAME = SafariUniBar
GO_EASY_ON_ME = 1

SafariUniBar_FILES = Tweak.xm
SafariUniBar_FRAMEWORKS = UIKit Foundation CoreFoundation CoreGraphics
include $(THEOS_MAKE_PATH)/tweak.mk
