Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1157813A73
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 15:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfEDNvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 09:51:25 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:39074 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfEDNvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 09:51:24 -0400
Received: by mail-wm1-f42.google.com with SMTP id n25so9790161wmk.4
        for <stable@vger.kernel.org>; Sat, 04 May 2019 06:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5jqzKuxMHBk/lp1xJcV7KQ5gZf9v9XQHiRoFKtW/3LY=;
        b=xgRqxkDRqXP6RZVSUbizXrI7tbiwoGyokNXEZ7p786qRNyra0uGbsEqD7et1qrIb6z
         h4W5Zi0H7SwCbmd9814tOP7eHRF2mH9ruR4vAQX33Olto34VgBNsLZoQYQUEVyQRfxoq
         EiliKama6srIJPAku12+3EqsQLuYAVqlSjwy+J9ZiD5HTVaiRuaMxKe62mR4BRiioIB7
         AECl9UXAnJeQDFCL22P/Ow0sBbFl0siYnBgGN6glVg3k4pEXIqz6ISe0+wHfKtGQ5vnF
         3iKafkFWEUXVc+nh+qnmu+VaxSXyT/RSyNLRl4GWydTzKCILeMqtz2FDtdbrz1OUJhsH
         qARA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5jqzKuxMHBk/lp1xJcV7KQ5gZf9v9XQHiRoFKtW/3LY=;
        b=pLloFjDZlTVJcZi7uqXuQ93f/mMYT2/AxHRcDi14wlHXTdtXNfVjhl2mBHs+zpua+1
         SxvxPf9WsgTkFqLPcBID8RYpZ/CfLbmX1RJSC1CAM4OhkxpjrMEFlkrl3q+nW/ssNjbm
         cKqe1MbqYIpHEAcPaNWzbezwuk7HuG+LNRkqlD0o//NzNoH+m+RDnHPjm4nDFQm4s//a
         40chaa6DeGYSUVDsmKnHfTaoCnPDjc6cAYaKVHOBSHAoGvM6dtwtpALcwro7wapttB8x
         6Lo/O5MP7S6Tl9GvikFoFzuuuF/rtaBvvSSk4TVGyb+wJXC79s9lD6rMTrhjj7e7W3B+
         a7hA==
X-Gm-Message-State: APjAAAV5qDCwPK0byAA8wcCbwmOl0yk4p+zgymkA6p0ZpMBkmjXpYftn
        b28X4+LvSgzcjEWL3FafjuTkxmynkpo=
X-Google-Smtp-Source: APXvYqxDj8xTMH26EwHxvpQ5Un7SlmMIrNbj1HUr16GFDZTDjhkr6fSPI7q+nC0soWgyOnXJP+EseQ==
X-Received: by 2002:a1c:43c2:: with SMTP id q185mr10378740wma.53.1556977879102;
        Sat, 04 May 2019 06:51:19 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v9sm8799848wrg.20.2019.05.04.06.51.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:51:18 -0700 (PDT)
Message-ID: <5ccd98d6.1c69fb81.7d15d.1e50@mx.google.com>
Date:   Sat, 04 May 2019 06:51:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.116-2-g6a60e13ec3d7
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y build: 201 builds: 4 failed, 197 passed,
 10 errors, 135 warnings (v4.14.116-2-g6a60e13ec3d7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 4 failed, 197 passed, 10 errors, =
135 warnings (v4.14.116-2-g6a60e13ec3d7)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.116-2-g6a60e13ec3d7/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.116-2-g6a60e13ec3d7
Git Commit: 6a60e13ec3d792233fabad80f8472958fdddc6f8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

mips:    mips-linux-gnu-gcc (Debian 7.3.0-28) 7.3.0

    bigsur_defconfig: FAIL
    decstation_defconfig: FAIL
    jmr3927_defconfig: FAIL
    sb1250_swarm_defconfig: FAIL

Errors and Warnings Detected:

arc:    arc-linux-gcc (ARCv2 ISA Linux uClibc toolchain 2017.09) 7.1.1 2017=
0710

    axs103_defconfig: 3 warnings
    axs103_smp_defconfig: 3 warnings
    haps_hs_defconfig: 1 warning
    haps_hs_smp_defconfig: 1 warning
    hsdk_defconfig: 3 warnings
    nsim_hs_defconfig: 1 warning
    nsim_hs_smp_defconfig: 1 warning
    nsimosci_hs_defconfig: 3 warnings
    nsimosci_hs_smp_defconfig: 3 warnings
    vdk_hs38_defconfig: 4 warnings
    vdk_hs38_smp_defconfig: 4 warnings

arm64:    aarch64-linux-gnu-gcc (Debian 7.4.0-1) 7.4.0

    defconfig: 1 warning

arm:    arm-linux-gnueabihf-gcc (Debian 7.4.0-1) 7.4.0

    acs5k_defconfig: 1 warning
    acs5k_tiny_defconfig: 1 warning
    aspeed_g4_defconfig: 1 warning
    aspeed_g5_defconfig: 1 warning
    assabet_defconfig: 1 warning
    axm55xx_defconfig: 1 warning
    badge4_defconfig: 1 warning
    cerfcube_defconfig: 1 warning
    clps711x_defconfig: 1 warning
    cm_x300_defconfig: 1 warning
    cns3420vb_defconfig: 1 warning
    colibri_pxa270_defconfig: 1 warning
    colibri_pxa300_defconfig: 1 warning
    collie_defconfig: 1 warning
    corgi_defconfig: 1 warning
    davinci_all_defconfig: 1 warning
    dove_defconfig: 1 warning
    ebsa110_defconfig: 1 warning
    ep93xx_defconfig: 1 warning
    eseries_pxa_defconfig: 1 warning
    exynos_defconfig: 1 warning
    ezx_defconfig: 1 warning
    footbridge_defconfig: 1 warning
    gemini_defconfig: 1 warning
    h3600_defconfig: 1 warning
    hackkit_defconfig: 1 warning
    hisi_defconfig: 1 warning
    imote2_defconfig: 1 warning
    imx_v6_v7_defconfig: 1 warning
    integrator_defconfig: 1 warning
    iop13xx_defconfig: 1 warning
    iop32x_defconfig: 1 warning
    iop33x_defconfig: 1 warning
    ixp4xx_defconfig: 1 warning
    jornada720_defconfig: 1 warning
    keystone_defconfig: 1 warning
    ks8695_defconfig: 1 warning
    lart_defconfig: 1 warning
    lpd270_defconfig: 1 warning
    lubbock_defconfig: 1 warning
    magician_defconfig: 1 warning
    mainstone_defconfig: 1 warning
    mini2440_defconfig: 1 warning
    mmp2_defconfig: 1 warning
    moxart_defconfig: 1 warning
    multi_v4t_defconfig: 1 warning
    multi_v5_defconfig: 1 warning
    multi_v7_defconfig: 1 warning
    mv78xx0_defconfig: 1 warning
    mvebu_v5_defconfig: 1 warning
    mvebu_v7_defconfig: 1 warning
    mxs_defconfig: 1 warning
    neponset_defconfig: 1 warning
    netwinder_defconfig: 1 warning
    netx_defconfig: 1 warning
    nhk8815_defconfig: 1 warning
    nuc910_defconfig: 1 warning
    nuc950_defconfig: 1 warning
    nuc960_defconfig: 1 warning
    omap2plus_defconfig: 1 warning
    orion5x_defconfig: 1 warning
    palmz72_defconfig: 1 warning
    pcm027_defconfig: 1 warning
    prima2_defconfig: 1 warning
    pxa168_defconfig: 1 warning
    pxa255-idp_defconfig: 1 warning
    pxa3xx_defconfig: 1 warning
    pxa910_defconfig: 1 warning
    pxa_defconfig: 1 warning
    qcom_defconfig: 1 warning
    raumfeld_defconfig: 1 warning
    realview_defconfig: 1 warning
    rpc_defconfig: 1 warning
    s3c2410_defconfig: 1 warning
    s3c6400_defconfig: 1 warning
    s5pv210_defconfig: 1 warning
    sama5_defconfig: 1 warning
    shannon_defconfig: 1 warning
    simpad_defconfig: 1 warning
    socfpga_defconfig: 1 warning
    spear13xx_defconfig: 1 warning
    spear3xx_defconfig: 1 warning
    spear6xx_defconfig: 1 warning
    spitz_defconfig: 1 warning
    sunxi_defconfig: 1 warning
    tango4_defconfig: 1 warning
    tegra_defconfig: 1 warning
    trizeps4_defconfig: 1 warning
    u300_defconfig: 1 warning
    u8500_defconfig: 1 warning
    versatile_defconfig: 1 warning
    vexpress_defconfig: 1 warning
    vt8500_v6_v7_defconfig: 1 warning
    zeus_defconfig: 1 warning
    zx_defconfig: 1 warning

i386:    gcc (Debian 7.4.0-2) 7.4.0

    i386_defconfig: 1 warning

mips:    mips-linux-gnu-gcc (Debian 7.3.0-28) 7.3.0

    bigsur_defconfig: 1 error, 4 warnings
    decstation_defconfig: 4 errors
    jmr3927_defconfig: 4 errors
    malta_qemu_32r6_defconfig: 1 warning
    sb1250_swarm_defconfig: 1 error, 4 warnings

x86_64:    gcc (Debian 7.4.0-2) 7.4.0

    tinyconfig: 1 warning
    x86_64_defconfig: 1 warning

Errors summary:

    4    cc1: error: '-march=3Dr3900' requires '-mfp32'
    4    cc1: error: '-march=3Dr3000' requires '-mfp32'
    2    (.text+0x1c0): undefined reference to `iommu_is_span_boundary'

Warnings summary:

    98   fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
    14   arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is n=
ot used [-Wunused-value]
    11   net/ipv4/tcp_input.c:4275:49: warning: array subscript is above ar=
ray bounds [-Warray-bounds]
    8    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOT=
LB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (C=
AVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NL=
M_XLR_BOARD)
    2    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined =
but not used [-Wunused-function]
    1    {standard input}:29: Warning: macro instruction expanded into mult=
iple instructions
    1    .config:1023:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 3 warnings, 0 s=
ection mismatches

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-7) =E2=80=94 FAIL, 1 error, 4 warnings, 0 secti=
on mismatches

Errors:
    (.text+0x1c0): undefined reference to `iommu_is_span_boundary'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-7) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 =
section mismatches

Errors:
    cc1: error: '-march=3Dr3000' requires '-mfp32'
    cc1: error: '-march=3Dr3000' requires '-mfp32'
    cc1: error: '-march=3Dr3000' requires '-mfp32'
    cc1: error: '-march=3Dr3000' requires '-mfp32'

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section=
 mismatches

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-7) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    cc1: error: '-march=3Dr3900' requires '-mfp32'
    cc1: error: '-march=3Dr3900' requires '-mfp32'
    cc1: error: '-march=3Dr3900' requires '-mfp32'
    cc1: error: '-march=3Dr3900' requires '-mfp32'

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    {standard input}:29: Warning: macro instruction expanded into multiple =
instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 3 warnings=
, 0 section mismatches

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-7) =E2=80=94 FAIL, 1 error, 4 warnings, 0=
 section mismatches

Errors:
    (.text+0x1c0): undefined reference to `iommu_is_span_boundary'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1023:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sec=
tion mismatches

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-7) =E2=80=94 PASS, 0 errors, 4 warnings, 0=
 section mismatches

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    net/ipv4/tcp_input.c:4275:49: warning: array subscript is above array b=
ounds [-Warray-bounds]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-7) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-7) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
