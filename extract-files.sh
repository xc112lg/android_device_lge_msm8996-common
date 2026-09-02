#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ANDROID_ROOT="$MY_DIR/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
source "$HELPER"

function blob_fixup() {
    case "${1}" in
    system_ext/etc/permissions/qti_libpermissions.xml)
        sed -i "s/name=\"android.hidl.manager-V1.0-java/name=\"android.hidl.manager@1.0-java/g" "${2}"
        ;;
    system/lib/libdovi.so|system/lib64/libdovi.so)
        grep -q libgui_shim.so "${2}" || "${PATCHELF_0_18}" --add-needed "libgui_shim.so" "${2}"
        ;;
    system/lib/libkeystore_binder.so|system/lib64/libkeystore_binder.so)
        "${PATCHELF_0_18}" --replace-needed "libbinder.so" "libbinder-v32.so" "${2}"
        "${PATCHELF_0_18}" --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-v29.so" "${2}"
        ;;
    system/lib/liblgkm.so|system/lib64/liblgkm.so)
        grep -q libbase_shim.so "${2}" || "${PATCHELF_0_18}" --add-needed "libbase_shim.so" "${2}"
        ;;
    system_ext/etc/init/dpmd.rc|system_ext/etc/permissions/dpmapi.xml)
        sed -i "s#/system/product/#/system/system_ext/#g" "${2}"
        ;;
    system_ext/etc/permissions/qcrilhook.xml)
        sed -i "s#/product/framework#/system/system_ext/framework#g" "${2}"
        ;;
    system_ext/lib64/libdpmframework.so)
        "${PATCHELF_0_18}" --replace-needed "libhidltransport.so" "libcutils-v29.so" "${2}"
        ;;
    vendor/bin/hw/vendor.display.color@1.0-service|vendor/lib/vendor.display.color@1.0.so|vendor/lib/vendor.display.color@1.1.so|vendor/lib/vendor.display.color@1.2.so|vendor/lib/vendor.display.postproc@1.0.so|vendor/lib/vendor.qti.hardware.radio.am@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.atcmdfwd@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.ims@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.lpa@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.qcrilhook@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.qtiradio@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.uim@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.uim_remote_client@1.0_vendor.so|vendor/lib/vendor.qti.hardware.radio.uim_remote_server@1.0_vendor.so|vendor/lib/vendor.qti.hardware.tui_comm@1.0_vendor.so|vendor/lib64/libsecureui_svcsock.so|vendor/lib64/vendor.display.color@1.0.so|vendor/lib64/vendor.display.color@1.1.so|vendor/lib64/vendor.display.color@1.2.so|vendor/lib64/vendor.display.postproc@1.0.so|vendor/lib64/vendor.qti.hardware.radio.am@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.atcmdfwd@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.ims@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.lpa@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.qcrilhook@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.qtiradio@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.uim@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.uim_remote_client@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.radio.uim_remote_server@1.0_vendor.so|vendor/lib64/vendor.qti.hardware.tui_comm@1.0_vendor.so)
        "${PATCHELF_0_18}" --replace-needed "libhidlbase.so" "libhidlbase-v32.so" "${2}"
        ;;
    vendor/bin/pm-service)
        grep -q libutils-v33.so "${2}" || "${PATCHELF_0_18}" --add-needed "libutils-v33.so" "${2}"
        ;;
    vendor/lib/hw/camera.msm8996.so)
        sed -i "s/service.bootanim.exit/service.bootanim.zzzz/g" "${2}"
        grep -q libshim_camera.so "${2}" || "${PATCHELF_0_18}" --add-needed "libshim_camera.so" "${2}"
        grep -q libfence_shim.so "${2}" || "${PATCHELF_0_18}" --add-needed "libfence_shim.so" "${2}"
        "${PATCHELF_0_18}" --replace-needed "libandroid.so" "libsensorndkbridge.so" "${2}"
        "${PATCHELF_0_18}" --replace-needed "libcamera_client.so" "libcamera_client_vendor.so" "${2}"
        ;;
    vendor/lib/libcamera_client_vendor.so|vendor/lib64/libcamera_client_vendor.so)
        grep -q libgui_shim_vendor.so "${2}" || "${PATCHELF_0_18}" --add-needed "libgui_shim_vendor.so" "${2}"
        ;;
    vendor/lib/libarcsoft_beauty_shot.so)
        "${PATCHELF_0_18}" --replace-needed "libandroid.so" "libsensorndkbridge.so" "${2}"
        "${PATCHELF_0_18}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
        ;;
    vendor/lib/libAutoContrast.so|vendor/lib/libCmcPdaf.so|vendor/lib/libSJFingerDetect.so|vendor/lib/libarcsoft_object_tracking.so|vendor/lib/libchromaflash.so|vendor/lib/libcir_driver.so|vendor/lib/libfilm_emulation.so|vendor/lib/libHDR.so|vendor/lib/liblgmda.so|vendor/lib/liblghdri.so|vendor/lib/libmorpho_image_stab31.so|vendor/lib/libmorpho_superzoom.so|vendor/lib/libmpbase.so|vendor/lib/liboptizoom.so|vendor/lib/libseemore.so|vendor/lib/libtrueportrait.so|vendor/lib/libts_detected_face_hal.so|vendor/lib/libts_face_beautify_hal.so|vendor/lib/libubifocus.so|vendor/lib64/libcir_driver.so|vendor/lib64/libseemore.so|vendor/lib64/libts_detected_face_hal.so|vendor/lib64/libts_face_beautify_hal.so)
        "${PATCHELF_0_18}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
        ;;
    vendor/lib/libdovi.so|vendor/lib64/libdovi.so)
        grep -q libgui_shim_vendor.so "${2}" || "${PATCHELF_0_18}" --add-needed "libgui_shim_vendor.so" "${2}"
        ;;
    vendor/lib/libmmcamera_faceproc2.so)
        "${PATCHELF_0_18}" --set-soname "libmmcamera_faceproc2.so" "${2}"
        ;;
    vendor/lib/libbwfocuspeaking.so)
        if [ "${DEVICE_COMMON}" = "g5-common" ] || [ "${DEVICE_COMMON}" = "v20-common" ]; then
            grep -q libshim_bwfocus.so "${2}" || "${PATCHELF_0_18}" --add-needed "libshim_bwfocus.so" "${2}"
        fi
        ;;
    vendor/lib/libmmcamera_hdr_gb_lib.so)
        "${PATCHELF_0_18}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
        grep -q liblog.so "${2}" || "${PATCHELF_0_18}" --add-needed "liblog.so" "${2}"
        ;;
    vendor/lib/libmmcamera_ppeiscore.so)
        grep -q libshim_camera.so "${2}" || "${PATCHELF_0_18}" --add-needed "libshim_camera.so" "${2}"
        ;;
    vendor/lib/libfpfactory_jni.so|vendor/lib/liblgae_main.so|vendor/lib/liblgawb_main.so|vendor/lib/libmmcamera_pdaf.so|vendor/lib/libmmcamera_pdafcamif.so|vendor/lib/libmmcamera_tintless_bg_pca_algo.so|vendor/lib64/libfpfactory_jni.so)
        grep -q liblog.so "${2}" || "${PATCHELF_0_18}" --add-needed "liblog.so" "${2}"
        ;;
    vendor/lib/vulkan.msm8996.so|vendor/lib64/vulkan.msm8996.so)
        "${PATCHELF_0_18}" --set-soname "vulkan.msm8996.so" "${2}"
        ;;
    vendor/lib64/libril-qc-hal-qmi.so|vendor/lib64/libsettings.so)
        "${PATCHELF_0_18}" --replace-needed "libprotobuf-cpp-full.so" "libprotobuf-cpp-full-v29.so" "${2}"
        ;;
    vendor/lib/libsymphony-1.1.1.so)
        "${PATCHELF_0_18}" --set-soname "libsymphony-1.1.1.so" "${2}"
        ;;
    vendor/lib/libsymphonypower-1.1.1.so)
        "${PATCHELF_0_18}" --set-soname "libsymphonypower-1.1.1.so" "${2}"
        ;;
    vendor/lib64/libwvhidl.so|vendor/lib64/mediadrm/libwvdrmengine.so)
        "${PATCHELF_0_18}" --replace-needed "libprotobuf-cpp-lite.so" "libprotobuf-cpp-lite-v29.so" "${2}"
         grep -q libcrypto_shim.so "${2}" || "${PATCHELF_0_18}" --add-needed "libcrypto_shim.so" "${2}"
        ;;
    esac
}

# ═══════════════════════════════════════════════════════════════════════════
# FIX: Function to correct Android.bp syntax errors after generation
# ═══════════════════════════════════════════════════════════════════════════

function fix_android_bp() {
    local BP_FILE="${1}/Android.bp"

    if [ ! -f "$BP_FILE" ]; then
        return 0
    fi

    # Check if the file has empty architecture names in target blocks
    if grep -q '^\t\t: {' "$BP_FILE"; then
        echo "Fixing Android.bp: Correcting empty architecture names..."

        # Backup the original file
        cp "$BP_FILE" "$BP_FILE.backup"

        # Create a temporary file for processing
        local temp_file=$(mktemp)

        while IFS= read -r line; do
            # Check if this line is an empty target key
            if [[ "$line" =~ ^[[:space:]]*:[[:space:]]*\{ ]]; then
                # Read next line to determine architecture
                if IFS= read -r next_line; then
                    # Check if the next line contains lib64 path
                    if [[ "$next_line" =~ lib64 ]]; then
                        echo -e "\t\tandroid_arm64: {" >> "$temp_file"
                    else
                        echo -e "\t\tandroid_arm: {" >> "$temp_file"
                    fi
                    echo "$next_line" >> "$temp_file"
                else
                    # Fallback if we can't read next line
                    echo -e "\t\tandroid_arm: {" >> "$temp_file"
                fi
            else
                echo "$line" >> "$temp_file"
            fi
        done < "$BP_FILE"

        mv "$temp_file" "$BP_FILE"

        # Verify the fix was applied
        if ! grep -q '^\t\t: {' "$BP_FILE"; then
            echo "✓ Android.bp fixed successfully"
            return 0
        else
            echo "✗ Warning: Some issues may remain. Please review $BP_FILE"
            return 1
        fi
    fi
}

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_EXTRACT=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common )
                ONLY_COMMON=true
                ;;
        --only-device-common )
                ONLY_DEVICE_COMMON=true
                ;;
        --only-extract )
                ONLY_EXTRACT=true
                ;;
        --only-target )
                ONLY_TARGET=true
                ;;
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

if [ -z "${ONLY_TARGET}" ] && [ -z "${ONLY_DEVICE_COMMON}" ]; then
# Initialize the helper for common platform
setup_vendor "$PLATFORM_COMMON" "$VENDOR" "$ANDROID_ROOT" true $CLEAN_VENDOR

extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"
fi

if [ -z "${ONLY_TARGET}" ] && [ -z "${ONLY_COMMON}" ]; then
# Initialize the helper for common device
setup_vendor "$DEVICE_COMMON" "$VENDOR" "$ANDROID_ROOT" true $CLEAN_VENDOR

extract "$MY_DIR/../$DEVICE_COMMON/proprietary-files.txt" "$SRC" "$SECTION"
fi

if [ -z "${ONLY_COMMON}" ] && [ -z "${ONLY_DEVICE_COMMON}" ] && [ -s "${MY_DIR}/../${DEVICE}/proprietary-files.txt" ]; then
# Reinitialize the helper for device
setup_vendor "$DEVICE" "$VENDOR" "$ANDROID_ROOT" false $CLEAN_VENDOR

extract "$MY_DIR/../$DEVICE/proprietary-files.txt" "$SRC" "$SECTION"
fi

if [ -z "${ONLY_EXTRACT}" ]; then
    "$MY_DIR"/setup-makefiles.sh

    # ═══════════════════════════════════════════════════════════════════════════
    # FIX: Auto-correct Android.bp after generation
    # ═══════════════════════════════════════════════════════════════════════════

    echo ""
    echo "==================================================================="
    echo "Verifying and fixing generated Android.bp files..."
    echo "==================================================================="

    # Fix platform common Android.bp
    fix_android_bp "vendor/$VENDOR/$PLATFORM_COMMON"

    # Fix device common Android.bp  
    fix_android_bp "vendor/$VENDOR/$DEVICE_COMMON"

    # Fix device-specific Android.bp
    fix_android_bp "vendor/$VENDOR/$DEVICE"

    echo ""
fi