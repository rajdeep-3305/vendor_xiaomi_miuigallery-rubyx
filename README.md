# MIUI Gallery for Custom ROMs

This repository provides a vendor tree to build the MIUI Gallery app directly into Android custom ROMs, bypassing the need for Magisk modules. It includes the necessary APK and the `priv-app` permission XML files to ensure the app works seamlessly as a system app.

## How to use

Follow these steps to integrate the MIUI Gallery into your ROM source:

### 1. Clone via Local Manifest
Add this repository to your ROM source by creating or modifying a local manifest file. 

Create a file at `.repo/local_manifests/miuigallery.xml` and add the following:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <project name="Harshith-10/vendor_xiaomi_miuigallery" path="vendor/xiaomi/miuigallery" remote="github" revision="main" />
</manifest>
```
*After adding this, run `repo sync` to download the repository.*

### 2. Inherit the Product
You need to tell your device tree to include the Gallery packages in the build. 

Open your device's makefile (e.g., `device.mk`, `evolution_marble.mk`, or `aosp_marble.mk`) and add the following line:

```makefile
# MIUI Gallery
$(call inherit-product, vendor/xiaomi/miuigallery/miuigallery-vendor.mk)
```

### 3. Prevent Priv-App Bootloops
Because MIUI Gallery is installed as a privileged app, missing or strictly enforced permissions can cause bootloops. To prevent this, you must set the following property in your device tree.

Add this line to your `system.prop` or directly into your `device.mk`:

```makefile
# Prevent bootloop for MIUI Gallery
PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=log
```

---

## SELinux Policies (Crucial)

Because you are compiling this directly into the ROM (not using a Magisk live-patch), you **must** add the following SELinux rules to your device tree to prevent the app from crashing in `Enforcing` mode. 

**Note:** We use `get_prop` macros instead of direct file reads to avoid `neverallow` build errors during ROM compilation.

Add these rules to your device tree's `sepolicy/vendor/priv_app.te` (or `sepolicy/private/priv_app.te`):

```te
# MIUI Gallery Permissions

# Properties
get_prop(priv_app, vendor_display_prop)
get_prop(priv_app, vendor_camera_prop)
get_prop(priv_app, qemu_hw_prop)
get_prop(priv_app, vendor_default_prop)
get_prop(priv_app, userdebug_or_eng_prop)

# Files
allow priv_app sysfs:file { open getattr };
allow priv_app app_data_file:file execute;
allow priv_app proc_stat:file { open read };

# Directories
allow priv_app app_data_file:dir { getattr search };
allow priv_app system_data_file:dir read;
allow priv_app privapp_data_file:dir map;

# Binder & Services
allow priv_app default_android_service:service_manager find;
binder_call(priv_app, hal_memtrack_default)
```

Add this to your `sepolicy/vendor/crash_dump.te` (or `sepolicy/private/crash_dump.te`):

```te
# MIUI Gallery
get_prop(crash_dump, packagemanager_config_prop)
get_prop(crash_dump, media_variant_prop)
```

## Credits
* [Reiryuki](https://github.com/reiryuki/Miui-Gallery-Magisk-Module) for the original Magisk module and extraction base.
* Xiaomi for the MIUI Gallery application.