#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

# NOTE: the original bash extract-files.sh guarded the libbwfocuspeaking.so
# add-needed fixup behind `[ "${DEVICE_COMMON}" = "g5-common" ] || [ "${DEVICE_COMMON}" = "v20-common" ]`.
# That check only ever fired for the alice (g5) / elsa (v20) common trees,
# never for g6-common/lucye, so it's intentionally dropped here. If/when
# g5-common or v20-common are migrated to extract-files.py, re-add the
# fixup there (or make it conditional the same way g4-common's blob_fixup
# does with a `#FIX ME` marker) rather than carrying it in this shared file.
blob_fixups: blob_fixups_user_type = {
    'system_ext/etc/permissions/qti_libpermissions.xml': blob_fixup()
        .regex_replace(
            r'name="android\.hidl\.manager-V1\.0-java',
            'name="android.hidl.manager@1.0-java',
        ),
    (
        'system/lib/libdovi.so',
        'system/lib64/libdovi.so',
    ): blob_fixup()
        .add_needed('libgui_shim.so'),
    (
        'system/lib/libkeystore_binder.so',
        'system/lib64/libkeystore_binder.so',
    ): blob_fixup()
        .replace_needed('libbinder.so', 'libbinder-v32.so')
        .replace_needed('libprotobuf-cpp-lite.so', 'libprotobuf-cpp-lite-v29.so'),
    (
        'system/lib/liblgkm.so',
        'system/lib64/liblgkm.so',
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
    (
        'system_ext/etc/init/dpmd.rc',
        'system_ext/etc/permissions/dpmapi.xml',
    ): blob_fixup()
        .regex_replace('/system/product/', '/system/system_ext/'),
    'system_ext/etc/permissions/qcrilhook.xml': blob_fixup()
        .regex_replace('/product/framework', '/system/system_ext/framework'),
    'system_ext/lib64/libdpmframework.so': blob_fixup()
        .replace_needed('libhidltransport.so', 'libcutils-v29.so'),
    (
        'vendor/bin/hw/vendor.display.color@1.0-service',
        'vendor/lib/vendor.display.color@1.0.so',
        'vendor/lib/vendor.display.color@1.1.so',
        'vendor/lib/vendor.display.color@1.2.so',
        'vendor/lib/vendor.display.postproc@1.0.so',
        'vendor/lib/vendor.qti.hardware.radio.am@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.atcmdfwd@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.ims@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.lpa@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.qcrilhook@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.qtiradio@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.uim@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.uim_remote_client@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.radio.uim_remote_server@1.0_vendor.so',
        'vendor/lib/vendor.qti.hardware.tui_comm@1.0_vendor.so',
        'vendor/lib64/libsecureui_svcsock.so',
        'vendor/lib64/vendor.display.color@1.0.so',
        'vendor/lib64/vendor.display.color@1.1.so',
        'vendor/lib64/vendor.display.color@1.2.so',
        'vendor/lib64/vendor.display.postproc@1.0.so',
        'vendor/lib64/vendor.qti.hardware.radio.am@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.atcmdfwd@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.ims@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.lpa@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.qcrilhook@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.qtiradio@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.uim@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.uim_remote_client@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.radio.uim_remote_server@1.0_vendor.so',
        'vendor/lib64/vendor.qti.hardware.tui_comm@1.0_vendor.so',
    ): blob_fixup()
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so'),
    'vendor/bin/pm-service': blob_fixup()
        .add_needed('libutils-v33.so'),
    'vendor/lib/hw/camera.msm8996.so': blob_fixup()
        .binary_regex_replace(b'service.bootanim.exit', b'service.bootanim.zzzz')
        .add_needed('libshim_camera.so'),
    (
        'vendor/lib/libAutoContrast.so',
        'vendor/lib/libCmcPdaf.so',
        'vendor/lib/libSJFingerDetect.so',
        'vendor/lib/libarcsoft_beauty_shot.so',
        'vendor/lib/libarcsoft_object_tracking.so',
        'vendor/lib/libchromaflash.so',
        'vendor/lib/libcir_driver.so',
        'vendor/lib/libfilm_emulation.so',
        'vendor/lib/libHDR.so',
        'vendor/lib/liblgmda.so',
        'vendor/lib/liblghdri.so',
        'vendor/lib/libmorpho_image_stab31.so',
        'vendor/lib/libmorpho_superzoom.so',
        'vendor/lib/libmpbase.so',
        'vendor/lib/liboptizoom.so',
        'vendor/lib/libseemore.so',
        'vendor/lib/libtrueportrait.so',
        'vendor/lib/libts_detected_face_hal.so',
        'vendor/lib/libts_face_beautify_hal.so',
        'vendor/lib/libubifocus.so',
        'vendor/lib64/libcir_driver.so',
        'vendor/lib64/libseemore.so',
        'vendor/lib64/libts_detected_face_hal.so',
        'vendor/lib64/libts_face_beautify_hal.so',
    ): blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    (
        'vendor/lib/libdovi.so',
        'vendor/lib64/libdovi.so',
    ): blob_fixup()
        .add_needed('libgui_shim_vendor.so'),
    'vendor/lib/libmmcamera_faceproc2.so': blob_fixup()
        .fix_soname(),
    'vendor/lib/libmmcamera_hdr_gb_lib.so': blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so')
        .add_needed('liblog.so'),
    'vendor/lib/libmmcamera_ppeiscore.so': blob_fixup()
        .add_needed('libshim_camera.so'),
    (
        'vendor/lib/libfpfactory_jni.so',
        'vendor/lib/liblgae_main.so',
        'vendor/lib/liblgawb_main.so',
        'vendor/lib/libmmcamera_pdaf.so',
        'vendor/lib/libmmcamera_pdafcamif.so',
        'vendor/lib/libmmcamera_tintless_bg_pca_algo.so',
        'vendor/lib64/libfpfactory_jni.so',
    ): blob_fixup()
        .add_needed('liblog.so'),
    (
        'vendor/lib/vulkan.msm8996.so',
        'vendor/lib64/vulkan.msm8996.so',
    ): blob_fixup()
        .fix_soname(),
    (
        'vendor/lib64/libril-qc-hal-qmi.so',
        'vendor/lib64/libsettings.so',
    ): blob_fixup()
        .replace_needed('libprotobuf-cpp-full.so', 'libprotobuf-cpp-full-v29.so'),
    'vendor/lib/libsymphony-1.1.1.so': blob_fixup()
        .fix_soname(),
    'vendor/lib/libsymphonypower-1.1.1.so': blob_fixup()
        .fix_soname(),
    (
        'vendor/lib64/libwvhidl.so',
        'vendor/lib64/mediadrm/libwvdrmengine.so',
    ): blob_fixup()
        .replace_needed('libprotobuf-cpp-lite.so', 'libprotobuf-cpp-lite-v29.so')
        .add_needed('libcrypto_shim.so'),
}  # fmt: skip


module = ExtractUtilsModule(
    'msm8996-common',
    'lge',
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
