ifneq ($(AUDIO_USE_STUB_HAL), true)
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CFLAGS := -DLIB_AUDIO_HAL="/vendor/lib/hw/audio.primary."$(TARGET_BOARD_PLATFORM)".so"
LOCAL_CFLAGS += -DPLATFORM_NAME=$(TARGET_BOARD_PLATFORM)
LOCAL_CFLAGS += -Wno-unused-variable
LOCAL_CFLAGS += -Wno-sign-compare
LOCAL_CFLAGS += -Wno-unused-parameter
LOCAL_CFLAGS += -Wno-unused-label
LOCAL_CFLAGS += -Wno-gnu-designator
LOCAL_CFLAGS += -Wno-typedef-redefinition
LOCAL_CFLAGS += -Wno-shorten-64-to-32
LOCAL_CFLAGS += -Wno-tautological-compare
LOCAL_CFLAGS += -Wno-unused-function
LOCAL_CFLAGS += -Wno-unused-local-typedef
LOCAL_CFLAGS += -Wno-format
LOCAL_CFLAGS += -Wno-unused-value
LOCAL_CFLAGS += -Wall
LOCAL_CFLAGS += -Werror

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_PROXY_DEVICE)),true)
    LOCAL_CFLAGS += -DAFE_PROXY_ENABLED
endif

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_GKI)),true)
    LOCAL_CFLAGS += -DAUDIO_GKI_ENABLED
endif

LOCAL_SRC_FILES:= \
        bundle.c \
        equalizer.c \
        bass_boost.c \
        virtualizer.c \
        reverb.c \
        effect_api.c \
        effect_util.c

# HW_ACCELERATED has been disabled by default since msm8996. File doesn't
# compile cleanly on tip so don't want to include it, but keeping this
# as a reference.
# LOCAL_SRC_FILES += hw_accelerator.c

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_INSTANCE_ID)), true)
    LOCAL_CFLAGS += -DINSTANCE_ID_ENABLED
endif

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_GCOV)),true)
    LOCAL_CFLAGS += --coverage -fprofile-arcs -ftest-coverage
    LOCAL_CPPFLAGS += --coverage -fprofile-arcs -ftest-coverage
    LOCAL_STATIC_LIBRARIES += libprofile_rt
endif

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_INSTANCE_ID)), true)
    LOCAL_CFLAGS += -DINSTANCE_ID_ENABLED
endif

LOCAL_CFLAGS+= -O2 -fvisibility=hidden

ifneq ($(strip $(AUDIO_FEATURE_DISABLED_DTS_EAGLE)),true)
    LOCAL_CFLAGS += -DDTS_EAGLE
endif

LOCAL_HEADER_LIBRARIES := libhardware_headers \
                          libsystem_headers \
                          libacdb_headers \
                          libarpal_headers \
                          libutils_headers \
                          qti_audio_kernel_uapi \
                          libaudio_extn_headers \
                          libaudio_hal_headers

LOCAL_SHARED_LIBRARIES := \
        libcutils \
        liblog \
        libar-pal \
        libdl

LOCAL_MODULE_TAGS := optional

LOCAL_MODULE_RELATIVE_PATH := soundfx
LOCAL_MODULE:= libqcompostprocbundle
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := qti

LOCAL_ADDITIONAL_DEPENDENCIES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_C_INCLUDES := \
        $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include \
        $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/audio \
        $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/techpack/audio/include \
        $(call include-path-for, audio-effects)

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_DLKM)),true)
  LOCAL_HEADER_LIBRARIES += audio_kernel_headers
endif

ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
        LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/techpack/audio/include
        LOCAL_ADDITIONAL_DEPENDENCIES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif

include $(BUILD_SHARED_LIBRARY)


ifeq ($(strip $(AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS)),true)
include $(CLEAR_VARS)

LOCAL_CFLAGS += -Wno-unused-variable
LOCAL_CFLAGS += -Wno-sign-compare
LOCAL_CFLAGS += -Wno-unused-parameter
LOCAL_CFLAGS += -Wno-unused-label
LOCAL_CFLAGS += -Wno-gnu-designator
LOCAL_CFLAGS += -Wno-typedef-redefinition
LOCAL_CFLAGS += -Wno-shorten-64-to-32
LOCAL_CFLAGS += -Wno-tautological-compare
LOCAL_CFLAGS += -Wno-unused-function
LOCAL_CFLAGS += -Wno-unused-local-typedef
LOCAL_CFLAGS += -Wno-format
LOCAL_SRC_FILES := EffectsHwAcc.cpp

LOCAL_C_INCLUDES := \
    $(call include-path-for, audio-effects)

LOCAL_HEADER_LIBRARIES := libhardware_headers \
                          libsystem_headers \
                          libutils_headers

LOCAL_SHARED_LIBRARIES := \
    liblog \
    libeffects

LOCAL_MODULE_TAGS := optional

LOCAL_CFLAGS += -O2 -fvisibility=hidden

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_DTS_EAGLE)), true)
LOCAL_CFLAGS += -DHW_ACC_HPX
endif

LOCAL_MODULE:= libhwacceffectswrapper
LOCAL_VENDOR_MODULE := true

include $(BUILD_STATIC_LIBRARY)
endif



################################################################################

include $(CLEAR_VARS)

LOCAL_CFLAGS := -DLIB_AUDIO_HAL="/vendor/lib/hw/audio.primary."$(TARGET_BOARD_PLATFORM)".so"
LOCAL_CFLAGS += -DPLATFORM_NAME=$(TARGET_BOARD_PLATFORM)
LOCAL_CFLAGS += -Wno-unused-variable
LOCAL_CFLAGS += -Wno-sign-compare
LOCAL_CFLAGS += -Wno-unused-parameter
LOCAL_CFLAGS += -Wno-unused-label
LOCAL_CFLAGS += -Wno-gnu-designator
LOCAL_CFLAGS += -Wno-typedef-redefinition
LOCAL_CFLAGS += -Wno-shorten-64-to-32
LOCAL_CFLAGS += -Wno-tautological-compare
LOCAL_CFLAGS += -Wno-unused-function
LOCAL_CFLAGS += -Wno-unused-local-typedef
LOCAL_CFLAGS += -Wno-format
LOCAL_CFLAGS += -Wall
LOCAL_CFLAGS += -Werror

LOCAL_SRC_FILES:= \
        volume_listener.c

LOCAL_CFLAGS+= -O2 -fvisibility=hidden

LOCAL_HEADER_LIBRARIES := libhardware_headers \
                          libsystem_headers \
                          libarpal_headers \
                          libutils_headers \
                          libaudio_extn_headers \
                          libaudio_hal_headers

LOCAL_SHARED_LIBRARIES := \
        libcutils \
        liblog \
        libdl \
        libar-pal \
        libaudioutils

LOCAL_MODULE_RELATIVE_PATH := soundfx
LOCAL_MODULE:= libvolumelistener
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := qti

LOCAL_ADDITIONAL_DEPENDENCIES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_C_INCLUDES := \
        $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include \
        $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/audio \
        $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/techpack/audio/include \
        $(call include-path-for, audio-effects) \
        $(call include-path-for, audio-route) \
        system/media/audio_utils/include

ifeq ($(strip $(AUDIO_FEATURE_ENABLED_DLKM)),true)
  LOCAL_HEADER_LIBRARIES += audio_kernel_headers
endif

ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
        LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/techpack/audio/include
        LOCAL_ADDITIONAL_DEPENDENCIES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif

include $(BUILD_SHARED_LIBRARY)


################################################################################
ifeq ($(strip $(AUDIO_FEATURE_ENABLED_MAXX_AUDIO)), true)

include $(CLEAR_VARS)

LOCAL_CFLAGS := -D HAL_LIB_NAME=\"audio.primary."$(TARGET_BOARD_PLATFORM)".so\"

LOCAL_SRC_FILES:= \
    ma_listener.c

LOCAL_CFLAGS += $(qcom_post_proc_common_cflags)

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    liblog \
    libdl

LOCAL_MODULE_RELATIVE_PATH := soundfx
LOCAL_MODULE:= libmalistener
LOCAL_MODULE_OWNER := google
LOCAL_PROPRIETARY_MODULE := true

LOCAL_C_INCLUDES := \
    hardware/qcom/audio/hal \
    system/media/audio/include/system \
    $(call include-path-for, audio-effects)

LOCAL_HEADER_LIBRARIES += libhardware_headers
LOCAL_HEADER_LIBRARIES += libsystem_headers

include $(BUILD_SHARED_LIBRARY)

endif
endif
