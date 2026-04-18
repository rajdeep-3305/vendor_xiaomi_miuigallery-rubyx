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

### 3. Prevent Priv-App Bootloops (Important)
Because MIUI Gallery is installed as a privileged app, missing or strictly enforced permissions can cause bootloops. To prevent this, you must set the following property in your device tree.

Add this line to your `system.prop` or directly into your `device.mk`:

```makefile
# Prevent bootloop for MIUI Gallery
PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=log
```

## Credits
* [Reiryuki](https://github.com/reiryuki/Miui-Gallery-Magisk-Module) for the original Magisk module and extraction.
* Xiaomi for the MIUI Gallery application.