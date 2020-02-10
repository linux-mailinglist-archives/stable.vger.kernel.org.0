Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F21A156D95
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 03:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgBJCUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 21:20:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34833 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgBJCUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 21:20:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id w12so5608277wrt.2
        for <stable@vger.kernel.org>; Sun, 09 Feb 2020 18:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UP3bPm6F3D/i2LuHzS/XLXIAMo3zixzwkSSWyjs+R4g=;
        b=DNElen6bw7lObZA9HkMcdqyniyUoMOOcWHBxslJ9uzEqgaOwwuyp0EkEyAOXVwH6Aw
         YnR9sRgXdNWPM/V75bDVV6XK4UhL6HInnii3Tj0o0TZFf1wqwrILl+d9Jt9316hGn29A
         ttP04eY8RO0izvrudLJ3SxCCqOyKQierCi7yS7VSvl/2akWwRvD7UphkOJx4GBBYiXYt
         7MqVb23q5JziQYntVi1BTyQ/WaXSSNWeVsm1F20244fK9EihoRsXsPkUpF/Z9qzsp2V0
         YAE891SYsJlT9jwm/rW/n/CIHkkF4ggAAbWreWBtQojUT9SzEtA2uUaFOQzVfDEzk+Wn
         +PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UP3bPm6F3D/i2LuHzS/XLXIAMo3zixzwkSSWyjs+R4g=;
        b=qaGYE4Yvzi0hrQRC6c4cPxRpJCRD5nooRee+FoGfm0uRDM8vzNY8lzc5GuKIIfv2H3
         kxEDP5cucZ1wnpAiRqmr+FeTTUL1y//8mM/jUNbcUG7LP+yWRMJD163t+e5qKPmkEs2q
         gsP58E5fq1mGfBASiWoXTfpGtQ2gi5iKXpZEwZQ5lbkh5rIIR1/v0AG5siHYHiWm0bBO
         L8n/sRvX1Nr4g3Ipo/yGGbSEVmbDpW5d4aM7eYvCI9TeKOSE3C2CPn8aKHwhBLDWVxKT
         ySQa7kHpJ8AoKr5K1AxvUJybOI2X/Jpk58WRfIlEKcjWZB0rBkq2OsjVqwK/7RBuN2Dv
         +WDg==
X-Gm-Message-State: APjAAAWyt+7V2RGUhF0jA67bqTJHSVEhp5SSfZax/egfdVQGuFrMXO1+
        YlIsZca1XFbSGU2xK2Swk3lAEe+dLSI=
X-Google-Smtp-Source: APXvYqy6PL6VDgYaSUEtGjRR4nI/GnxNoDs5Nt9Dt52TupZTUMquwwHLCRvAvHuXc5GXe/L7SB37kg==
X-Received: by 2002:adf:f401:: with SMTP id g1mr13614460wro.129.1581301210532;
        Sun, 09 Feb 2020 18:20:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w22sm12946647wmk.34.2020.02.09.18.20.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2020 18:20:10 -0800 (PST)
Message-ID: <5e40bdda.1c69fb81.1b429.839c@mx.google.com>
Date:   Sun, 09 Feb 2020 18:20:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.18-307-gdb4707481a60
Subject: stable-rc/linux-5.4.y build: 119 builds: 79 failed, 40 passed,
 91 errors, 131 warnings (v5.4.18-307-gdb4707481a60)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y build: 119 builds: 79 failed, 40 passed, 91 errors, 1=
31 warnings (v5.4.18-307-gdb4707481a60)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.18-307-gdb4707481a60/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.18-307-gdb4707481a60
Git Commit: db4707481a6070d76e871be6339139c4af547dec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-8) FAIL
    axs103_defconfig: (gcc-8) FAIL
    haps_hs_defconfig: (gcc-8) FAIL
    nsim_hs_smp_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL

arm64:
    tinyconfig: (gcc-8) FAIL

arm:
    aspeed_g4_defconfig: (gcc-8) FAIL
    aspeed_g5_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    efm32_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    footbridge_defconfig: (gcc-8) FAIL
    hackkit_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    mps2_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vf610m4_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    xcep_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    i386_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    allnoconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
    malta_defconfig: (gcc-8) FAIL
    malta_kvm_guest_defconfig: (gcc-8) FAIL
    malta_qemu_32r6_defconfig: (gcc-8) FAIL
    maltaaprp_defconfig: (gcc-8) FAIL
    maltasmvp_eva_defconfig: (gcc-8) FAIL
    maltaup_defconfig: (gcc-8) FAIL
    maltaup_xpa_defconfig: (gcc-8) FAIL
    mpc30x_defconfig: (gcc-8) FAIL
    msp71xx_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    omega2p_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    vocore2_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

riscv:
    allnoconfig: (gcc-8) FAIL
    defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 error, 2 warnings
    axs103_defconfig (gcc-8): 1 error, 2 warnings
    haps_hs_defconfig (gcc-8): 1 error, 2 warnings
    hsdk_defconfig (gcc-8): 2 warnings
    nsim_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    nsimosci_hs_defconfig (gcc-8): 1 error, 2 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    tinyconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_defconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_smp_defconfig (gcc-8): 3 errors, 4 warnings

arm64:
    defconfig (gcc-8): 12 warnings
    tinyconfig (gcc-8): 1 error, 1 warning

arm:
    aspeed_g4_defconfig (gcc-8): 1 error, 1 warning
    aspeed_g5_defconfig (gcc-8): 1 error, 1 warning
    axm55xx_defconfig (gcc-8): 1 error, 1 warning
    badge4_defconfig (gcc-8): 1 error, 1 warning
    cm_x2xx_defconfig (gcc-8): 1 error, 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    cns3420vb_defconfig (gcc-8): 2 errors, 2 warnings
    colibri_pxa270_defconfig (gcc-8): 1 error, 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    efm32_defconfig (gcc-8): 1 error, 1 warning
    em_x270_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 error, 1 warning
    eseries_pxa_defconfig (gcc-8): 1 error, 1 warning
    footbridge_defconfig (gcc-8): 1 error, 1 warning
    hackkit_defconfig (gcc-8): 1 error, 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 warning
    iop32x_defconfig (gcc-8): 1 error, 1 warning
    jornada720_defconfig (gcc-8): 1 error, 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 error, 1 warning
    mini2440_defconfig (gcc-8): 1 error, 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 1 error, 1 warning
    mps2_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 error, 1 warning
    palmz72_defconfig (gcc-8): 1 error, 1 warning
    prima2_defconfig (gcc-8): 3 errors, 3 warnings
    pxa168_defconfig (gcc-8): 1 error, 1 warning
    pxa255-idp_defconfig (gcc-8): 1 error, 1 warning
    qcom_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 2 errors, 2 warnings
    s3c6400_defconfig (gcc-8): 2 errors, 2 warnings
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    simpad_defconfig (gcc-8): 1 error, 1 warning
    spear13xx_defconfig (gcc-8): 1 error, 1 warning
    spear3xx_defconfig (gcc-8): 1 error, 1 warning
    spear6xx_defconfig (gcc-8): 1 error, 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tct_hammer_defconfig (gcc-8): 1 error, 1 warning
    tegra_defconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 error, 1 warning
    versatile_defconfig (gcc-8): 1 error, 1 warning
    vf610m4_defconfig (gcc-8): 1 error, 1 warning
    viper_defconfig (gcc-8): 1 error, 1 warning
    xcep_defconfig (gcc-8): 1 error, 1 warning
    zx_defconfig (gcc-8): 3 errors, 3 warnings

i386:
    i386_defconfig (gcc-8): 2 errors, 2 warnings

mips:
    32r2el_defconfig (gcc-8): 1 error, 1 warning
    allnoconfig (gcc-8): 1 error, 1 warning
    ath79_defconfig (gcc-8): 1 error, 1 warning
    bmips_be_defconfig (gcc-8): 1 error, 1 warning
    bmips_stb_defconfig (gcc-8): 1 error, 1 warning
    cavium_octeon_defconfig (gcc-8): 1 error, 1 warning
    db1xxx_defconfig (gcc-8): 2 errors, 2 warnings
    fuloong2e_defconfig (gcc-8): 1 error, 1 warning
    ip27_defconfig (gcc-8): 2 errors, 1 warning
    lemote2f_defconfig (gcc-8): 1 error, 1 warning
    malta_defconfig (gcc-8): 1 error, 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 error, 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 1 error, 1 warning
    maltaaprp_defconfig (gcc-8): 1 error, 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 error, 1 warning
    maltaup_defconfig (gcc-8): 1 error, 1 warning
    maltaup_xpa_defconfig (gcc-8): 1 error, 1 warning
    mpc30x_defconfig (gcc-8): 1 error, 1 warning
    msp71xx_defconfig (gcc-8): 1 error, 1 warning
    nlm_xlp_defconfig (gcc-8): 1 error, 1 warning
    omega2p_defconfig (gcc-8): 1 error, 1 warning
    rbtx49xx_defconfig (gcc-8): 1 error, 1 warning
    rm200_defconfig (gcc-8): 1 error, 1 warning
    sb1250_swarm_defconfig (gcc-8): 1 error, 1 warning
    tb0226_defconfig (gcc-8): 1 error, 1 warning
    tb0287_defconfig (gcc-8): 1 error, 1 warning
    vocore2_defconfig (gcc-8): 1 error, 1 warning
    xway_defconfig (gcc-8): 1 error, 1 warning

riscv:
    allnoconfig (gcc-8): 1 error, 1 warning
    defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 error, 1 warning

Errors summary:

    90   include/linux/regulator/consumer.h:600:1: error: expected identifi=
er or =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    1    arch/mips/pci/pci-xtalk-bridge.c:287:9: error: =E2=80=98struct bri=
dge_irq_chip_data=E2=80=99 has no member named =E2=80=98nnasid=E2=80=99; di=
d you mean =E2=80=98nasid=E2=80=99?

Warnings summary:

    90   include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regula=
tor_is_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [=
-Wunused-function]
    15   WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL
    11   <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    2    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_=
min_dma_period=E2=80=99 defined but not used [-Wunused-function]
    2    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_=
format): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address=
-cells =3D=3D 2, #size-cells =3D=3D 2)
    1    arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning (reg_form=
at): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cel=
ls =3D=3D 2, #size-cells =3D=3D 2)
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (spi_bus_=
reg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (pci_devi=
ce_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (i2c_bus_=
reg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_r=
eg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (pci_devic=
e_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_r=
eg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_re=
g): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (pci_device=
_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_re=
g): Failed prerequisite 'reg_format'
    1    .config:1158:warning: override: UNWINDER_GUESS changes choice state

Section mismatches summary:

    2    WARNING: vmlinux.o(.text.unlikely+0x8c4): Section mismatch in refe=
rence from the function free_memmap() to the function .meminit.text:membloc=
k_free()
    1    WARNING: vmlinux.o(.text.unlikely+0x8e4): Section mismatch in refe=
rence from the function free_memmap() to the function .meminit.text:membloc=
k_free()
    1    WARNING: vmlinux.o(.text.unlikely+0x3598): Section mismatch in ref=
erence from the function pmax_setup_memory_region() to the function .init.t=
ext:add_memory_region()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mis=
matches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 se=
ction mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x3598): Section mismatch in referenc=
e from the function pmax_setup_memory_region() to the function .init.text:a=
dd_memory_region()

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, 0 section m=
ismatches

Warnings:
    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_forma=
t): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cell=
s =3D=3D 2, #size-cells =3D=3D 2)
    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (pci_device_bus_=
num): Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_reg): F=
ailed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_reg): F=
ailed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_forma=
t): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cell=
s =3D=3D 2, #size-cells =3D=3D 2)
    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (pci_device_bus=
_num): Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_reg): =
Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_reg): =
Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning (reg_format): =
/gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cells =
=3D=3D 2, #size-cells =3D=3D 2)
    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (pci_device_bu=
s_num): Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (i2c_bus_reg):=
 Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (spi_bus_reg):=
 Failed prerequisite 'reg_format'

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    arch/mips/pci/pci-xtalk-bridge.c:287:9: error: =E2=80=98struct bridge_i=
rq_chip_data=E2=80=99 has no member named =E2=80=98nnasid=E2=80=99; did you=
 mean =E2=80=98nasid=E2=80=99?
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x8c4): Section mismatch in reference=
 from the function free_memmap() to the function .meminit.text:memblock_fre=
e()

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings,=
 0 section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 3 warnings, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x8e4): Section mismatch in reference=
 from the function free_memmap() to the function .meminit.text:memblock_fre=
e()

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x8c4): Section mismatch in reference=
 from the function free_memmap() to the function .meminit.text:memblock_fre=
e()

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1158:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mism=
atches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 3 errors, 4 warnings, 0=
 section mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 3 warnings, 0 section m=
ismatches

Errors:
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token
    include/linux/regulator/consumer.h:600:1: error: expected identifier or=
 =E2=80=98(=E2=80=99 before =E2=80=98{=E2=80=99 token

Warnings:
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]
    include/linux/regulator/consumer.h:599:1: warning: =E2=80=98regulator_i=
s_equal=E2=80=99 declared =E2=80=98static=E2=80=99 but never defined [-Wunu=
sed-function]

---
For more info write to <info@kernelci.org>
