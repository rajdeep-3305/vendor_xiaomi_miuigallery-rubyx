# HyperOS Gallery & Media Editor for Redmi Note 12 Pro / Pro+ / Discovery 5G (`rubyx`)

This repository (`vendor_xiaomi_miuigallery-rubyx`) provides prebuilt packages and proprietary assets to integrate the HyperOS / MIUI Gallery application and Media Editor directly into custom ROM builds (LineageOS / AOSP) for the **Xiaomi Redmi Note 12 Pro / Pro+ / Discovery 5G** (`ruby`, `rubypro`, `rubyplus` unified as `rubyx`).

---

## Included Components

- **MiuiGallery**: HyperOS Gallery prebuilt application (`proprietary/system/priv-app/MiuiGallery/`)
- **MIMediaEditorGlobal**: HyperOS Media Editor prebuilt application (`proprietary/system/app/MIMediaEditorGlobal/`)
- **Patched Framework Stubs**:
  - `micloud-sdk.jar`: Patched stub providing cloud SDK classes to prevent crashes on AOSP
  - `security-device-credential-sdk.jar`: Patched security credential stub
- **Device Features**: Prebuilt device feature configurations for the device variants (`ruby`, `rubypro`, and `rubyplus`)
- **Permissions & Sysconfig**:
  - `privapp-com.miui.gallery.xml`
  - `config-com.miui.gallery.xml`
  - `default-com.miui.gallery.xml`
  - `micloud-sdk.xml`

---

## Integration into `rubyx`

### 1. Local Manifest

Add this repository to your ROM source tree using a local manifest file at `.repo/local_manifests/miuigallery-rubyx.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <project name="rajdeep-3305/vendor_xiaomi_miuigallery-rubyx"
             path="vendor/xiaomi/miuigallery-rubyx"
             remote="github"
             revision="lineage-24.0" />
</manifest>
```

Alternatively, clone directly into your workspace:

```bash
git clone https://github.com/rajdeep-3305/vendor_xiaomi_miuigallery-rubyx.git vendor/xiaomi/miuigallery-rubyx -b lineage-24.0
```

### 2. Inherit Product in Device Tree

In `device/xiaomi/rubyx/device.mk`, inherit the gallery vendor makefile:

```makefile
# Inherit HyperOS Gallery
$(call inherit-product-if-exists, vendor/xiaomi/miuigallery-rubyx/miuigallery-vendor.mk)
```

### 3. Priv-App Permissions

To prevent bootloops caused by strict enforcement of priv-app permissions on AOSP, ensure the following property override is present in `device/xiaomi/rubyx/device.mk`:

```makefile
# Prevent bootloops for MIUI Gallery
PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=log
```

---

## SELinux Policy (`device/xiaomi/rubyx/sepolicy`)

To ensure the Gallery and Media Editor operate properly with SELinux in `Enforcing` mode, include the following rules in your device tree:

In `device/xiaomi/rubyx/sepolicy/vendor/priv_app.te` (or `device/xiaomi/rubyx/sepolicy/private/priv_app.te`):

```te
# HyperOS Gallery
get_prop(priv_app, vendor_display_prop)
get_prop(priv_app, vendor_camera_prop)
get_prop(priv_app, qemu_hw_prop)
get_prop(priv_app, vendor_default_prop)
get_prop(priv_app, userdebug_or_eng_prop)

allow priv_app sysfs:file { open getattr };
allow priv_app app_data_file:file execute;
allow priv_app proc_stat:file { open read };

allow priv_app app_data_file:dir { getattr search };
allow priv_app system_data_file:dir read;
allow priv_app privapp_data_file:dir map;

allow priv_app default_android_service:service_manager find;
binder_call(priv_app, hal_memtrack_default)
```

In `device/xiaomi/rubyx/sepolicy/vendor/crash_dump.te` (or `device/xiaomi/rubyx/sepolicy/private/crash_dump.te`):

```te
# HyperOS Gallery
get_prop(crash_dump, packagemanager_config_prop)
get_prop(crash_dump, media_variant_prop)
```

---

## Credits

- **Xiaomi**: HyperOS Gallery & Media Editor applications
- **LineageOS / AOSP**: Custom ROM ecosystem
