#
# Automatically generated file. DO NOT MODIFY
#

PRODUCT_SOONG_NAMESPACES += \
    vendor/xiaomi/miuigallery-rubyx

PRODUCT_PACKAGES += \
    MiuiGallery \
    MIMediaEditorGlobal \
    privapp-com.miui.gallery.xml \
    config-com.miui.gallery.xml \
    default-com.miui.gallery.xml \
    micloud-sdk.xml

PRODUCT_COPY_FILES += \
    vendor/xiaomi/miuigallery-rubyx/proprietary/system/framework/micloud-sdk.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/micloud-sdk.jar \
    vendor/xiaomi/miuigallery-rubyx/proprietary/system/framework/security-device-credential-sdk.jar:$(TARGET_COPY_OUT_SYSTEM)/framework/security-device-credential-sdk.jar \
    vendor/xiaomi/miuigallery-rubyx/proprietary/product/etc/device_features/ruby.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/device_features/ruby.xml \
    vendor/xiaomi/miuigallery-rubyx/proprietary/product/etc/device_features/rubypro.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/device_features/rubypro.xml \
    vendor/xiaomi/miuigallery-rubyx/proprietary/product/etc/device_features/rubyplus.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/device_features/rubyplus.xml
