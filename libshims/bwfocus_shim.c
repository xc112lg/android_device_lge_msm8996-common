/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include <stdint.h>

enum {
    ANDROID_CPU_FAMILY_ARM = 1,
};

enum {
    ANDROID_CPU_ARM_FEATURE_ARMv7       = (1 << 0),
    ANDROID_CPU_ARM_FEATURE_VFPv3       = (1 << 1),
    ANDROID_CPU_ARM_FEATURE_NEON        = (1 << 2),
    ANDROID_CPU_ARM_FEATURE_LDREX_STREX = (1 << 3),
    ANDROID_CPU_ARM_FEATURE_VFPv2       = (1 << 4),
    ANDROID_CPU_ARM_FEATURE_VFP_D32     = (1 << 5),
    ANDROID_CPU_ARM_FEATURE_VFP_FP16    = (1 << 6),
    ANDROID_CPU_ARM_FEATURE_VFP_FMA     = (1 << 7),
    ANDROID_CPU_ARM_FEATURE_NEON_FMA    = (1 << 8),
    ANDROID_CPU_ARM_FEATURE_IDIV_ARM    = (1 << 9),
    ANDROID_CPU_ARM_FEATURE_IDIV_THUMB2 = (1 << 10),
    ANDROID_CPU_ARM_FEATURE_AES         = (1 << 12),
    ANDROID_CPU_ARM_FEATURE_PMULL       = (1 << 13),
    ANDROID_CPU_ARM_FEATURE_SHA1        = (1 << 14),
    ANDROID_CPU_ARM_FEATURE_SHA2        = (1 << 15),
    ANDROID_CPU_ARM_FEATURE_CRC32       = (1 << 16),
};

uint64_t android_getCpuFeatures(void) {
    return ANDROID_CPU_ARM_FEATURE_ARMv7 |
           ANDROID_CPU_ARM_FEATURE_VFPv3 |
           ANDROID_CPU_ARM_FEATURE_NEON |
           ANDROID_CPU_ARM_FEATURE_LDREX_STREX |
           ANDROID_CPU_ARM_FEATURE_VFPv2 |
           ANDROID_CPU_ARM_FEATURE_VFP_D32 |
           ANDROID_CPU_ARM_FEATURE_VFP_FP16 |
           ANDROID_CPU_ARM_FEATURE_VFP_FMA |
           ANDROID_CPU_ARM_FEATURE_NEON_FMA |
           ANDROID_CPU_ARM_FEATURE_IDIV_ARM |
           ANDROID_CPU_ARM_FEATURE_IDIV_THUMB2 |
           ANDROID_CPU_ARM_FEATURE_AES |
           ANDROID_CPU_ARM_FEATURE_PMULL |
           ANDROID_CPU_ARM_FEATURE_SHA1 |
           ANDROID_CPU_ARM_FEATURE_SHA2 |
           ANDROID_CPU_ARM_FEATURE_CRC32;
}

int android_getCpuFamily(void) {
    return ANDROID_CPU_FAMILY_ARM;
}

int android_getCpuCount(void) {
    return 4;
}
