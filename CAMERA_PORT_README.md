# Camera fix for device/lge/msm8996-common — ported from device/xiaomi/msm8996-common

## Root cause (from a.log)

```
F linker  : CANNOT LINK EXECUTABLE "/vendor/bin/mm-qcamera-daemon":
            library "libandroid.so" not found: needed by
            /system/vendor/lib/libmmcamera2_stats_modules.so in namespace (default)
```

`vendor.qcamerasvr` (`mm-qcamera-daemon`) and `vendor.camera-provider-2-4` crash-loop
on boot, `apexd` reverts the update after 4 failures, and the camera never comes up.
Two separate problems combine here:

1. **`libandroid.so` isn't visible to the vendor linker namespace.** The
   Qualcomm-provided `libmmcamera2_stats_modules.so` blob still references
   symbols from `libandroid.so` (an old NDK library), but under Treble/VNDK
   that library isn't exposed to `/vendor` binaries unless explicitly listed.
2. **The LGE tree uses the closed prebuilt HAL, not the open-source one.**
   `device/lge/msm8996-common` builds `camera.device@3.2-impl` (a prebuilt
   blob) plus a hand-written ABI shim (`libshim_camera_system` /
   `camera_shim.cpp`) to keep it linkable against modern `libgui`/`libui`.
   `device/xiaomi/msm8996-common` instead builds the **open-source QCamera2
   HAL** (`camera.$(TARGET_BOARD_PLATFORM)` → `camera.msm8996`) straight from
   source (`camera/QCamera2`, `mm-camera-interface`, `mm-jpeg-interface`,
   `mm-lib2d-interface`, `mm-image-codec`), which needs no ABI shim and is
   what's actively maintained/fixed upstream for msm8996 devices today.

## What this patch does

- **Copies `camera/`** (QCamera2 HAL + mm-camera/jpeg/lib2d interfaces +
  mm-image-codec) verbatim from `android_device_xiaomi_msm8996-common-lineage-23.2`
  into `device/lge/msm8996-common/camera/`. No device-specific paths inside it —
  it only depends on `hardware/qcom-caf/msm8996`, which both trees already
  declare as a vendor import.
- **`BoardConfigCommon.mk`**: removes `USE_CAMERA_STUB := true`, adds
  `BOARD_QTI_CAMERA_32BIT_ONLY := true` and `TARGET_SUPPORT_HAL1 := false`
  (matches xiaomi's HAL3-only build).
- **`msm8996.mk`**: swaps `camera.device@3.2-impl` (+ its `libshim_camera_system`,
  `libui_shim`, `libexif_32`, `libyuv_32` support libs) for `camera.msm8996`
  (+ `libgui_vendor`, `libion.vendor`, `libstdc++_vendor`), and installs a new
  `public.libraries.txt` to `/vendor/etc/` so `libandroid.so` is reachable
  from the vendor namespace.
- **`configs/public.libraries.txt`** (new file): lists `libandroid.so`.
- **`libshims/`**: removes `camera_shim.cpp` and its `Android.bp` entry —
  it existed only to patch the old prebuilt HAL's ABI and is unused once
  `camera.msm8996` is built from source. `libshim_bwfocus` is untouched.

Full mechanical diff (excluding the new `camera/` tree, which is a verbatim
copy) is in `lge_camera_port.diff`.

## What you still need to check before flashing

These couldn't be verified without an actual AOSP build/target:

1. **`vendor/lib/libshim_camera.so`** in `proprietary-files.txt` (a *prebuilt*
   vendor-side shim, separate from the `libshims/` source one removed above)
   was left in place — it may back the closed `mm-qcamera-daemon`/`libmmcamera2_*`
   blobs rather than the HAL itself. Build once, and if `libshim_camera.so`
   turns out unreferenced, drop that `proprietary-files.txt` line.
2. **`libexif_32` / `libyuv_32`** were removed from the camera `PRODUCT_PACKAGES`
   block because they supported the old prebuilt HAL — double-check nothing
   else in the tree (gallery/media packages) still expects them pulled in
   from here.
3. **Treble level mismatch**: `device/lge/msm8996-common` is a legacy
   (non-Treble) tree (`sepolicy-legacy-um`, `SELINUX_IGNORE_NEVERALLOWS := true`),
   while `device/xiaomi/msm8996-common` is full Treble (`BOARD_VNDK_VERSION := current`).
   The camera source itself doesn't care, but if you still see `libandroid.so`
   or other namespace errors after this patch, it likely needs an additional
   `ld.config.txt`/linker-namespace override rather than just `public.libraries.txt`.
4. **sepolicy**: `hal_camera_default.te`, `mm-qcamerad.te`, `hal_camera.te`,
   `cameraserver.te` in the LGE tree were left as-is (they're LGE-specific,
   e.g. perfd hooks) — only add rules from xiaomi's minimal versions if you
   see `avc: denied` lines for camera in logcat/dmesg after rebuilding.

## Recommended validation

```
mmm device/lge/msm8996-common/camera
# then a full build + flash, and watch:
adb logcat | grep -iE "camera|qcamera|linker"
```
