Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D9FF70E3
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 10:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfKKJel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 04:34:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55388 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfKKJel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 04:34:41 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so12472525wmb.5
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 01:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1axuyDRAMbf9gT6IQs/yYMN2oCMDJ3EXIBuO7LjTHN0=;
        b=zDEMP73fkDGfRI0bxpr41yjqLULxrbRa+55oojkilmgzpA8bd3zq/jGYUBipZR70dX
         c8pnFn9iaW/MPs2zsm8QdgXOvwKiOAZ9PSmB2XHbj8wAyyIq1R5qXuPE0tLUSORlM6hU
         6VuUkJxduly7pA+BZidQ8cOAbZxMGyW+KGrwRNxyqvpPb+NR4F2yrPWdQR2U5eXx0IQb
         Z38AxDSQAWDxQXvCQjQOvGEH37jvOD1mmh2QAOrHf6mTVbyvL3tkAhEyNZJ3n7hd3IIV
         7x878poepvrBBJQ9w7nY2vBbjNpHLw3GTxmZHktM3uEm6NtGGuS0sF3ZAMHmuf6ua+9j
         gMdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1axuyDRAMbf9gT6IQs/yYMN2oCMDJ3EXIBuO7LjTHN0=;
        b=M0UDtdDFlSChV8U5TEWWxjtfgNwvT0h5czklqsaUnpojI62pjyYe+/iloCPjJhpT3S
         0b2KSZ2S6852qk7MllY+cSPyZnwXbdvpWfBV9bxyENjQEIYZ3leGrPv9Kuooco0gYTv+
         CuUPo7nimgbvfS3OCv4UwCxSXrsX4DesTV9ePbMgeIOkMrZV0Rz3JzbDg8Cb4bc4FIi6
         AITwr4QS6A2VfbWM97qEqoHiY1F6liMtDDeq5i0Jifp59rWF82tYzMq03BVmFNMr/0af
         5C43FkL8RPqIRnlvIqvmDAAgQJAYPC/4dnNp1MWkglxOKM0V3DpVt++BiUW6qGRLRFrZ
         cW0Q==
X-Gm-Message-State: APjAAAUuG+tirztI1Jm4fbRZIoBl5zF07zOJtspU+T/zstFDos5c9dWs
        jrpio79t02Jr12yqBM4Ri268fXJ1U84=
X-Google-Smtp-Source: APXvYqxMI7uX2X55hZYxeaytM8kEyltztEazuWWjJMOWm/ay92DbwnF+pUwq5/caU7sdhUmcEB659g==
X-Received: by 2002:a1c:48c4:: with SMTP id v187mr19932879wma.27.1573464867424;
        Mon, 11 Nov 2019 01:34:27 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l26sm7429506wme.6.2019.11.11.01.34.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 01:34:26 -0800 (PST)
Message-ID: <5dc92b22.1c69fb81.eec20.eb97@mx.google.com>
Date:   Mon, 11 Nov 2019 01:34:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.4.200-23-g4cb9b88c651a
Subject: stable-rc/linux-4.4.y build: 190 builds: 13 failed, 177 passed,
 2 errors, 203 warnings (v4.4.200-23-g4cb9b88c651a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 13 failed, 177 passed, 2 errors, 2=
03 warnings (v4.4.200-23-g4cb9b88c651a)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.200-23-g4cb9b88c651a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.200-23-g4cb9b88c651a
Git Commit: 4cb9b88c651a2fff886dd64b6d797343e7ddb4dd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

i386:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

mips:
    allnoconfig: (gcc-8) FAIL
    sead3micro_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

x86_64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 4 warnings
    axs103_defconfig (gcc-8): 1 warning
    axs103_smp_defconfig (gcc-8): 1 warning
    nsim_hs_defconfig (gcc-8): 1 warning
    nsim_hs_smp_defconfig (gcc-8): 1 warning
    nsimosci_hs_defconfig (gcc-8): 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 5 warnings
    vdk_hs38_defconfig (gcc-8): 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 1 warning

arm64:
    allnoconfig (gcc-8): 1 warning
    defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning

arm:
    acs5k_defconfig (gcc-8): 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 warning
    allnoconfig (gcc-8): 1 warning
    am200epdkit_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    at91_dt_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 warning
    badge4_defconfig (gcc-8): 1 warning
    bcm2835_defconfig (gcc-8): 1 warning
    bcm_defconfig (gcc-8): 1 warning
    cerfcube_defconfig (gcc-8): 1 warning
    clps711x_defconfig (gcc-8): 2 warnings
    cm_x2xx_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    cns3420vb_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    collie_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 2 warnings
    dove_defconfig (gcc-8): 1 warning
    ebsa110_defconfig (gcc-8): 1 warning
    efm32_defconfig (gcc-8): 1 warning
    em_x270_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    footbridge_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    h5000_defconfig (gcc-8): 1 warning
    hackkit_defconfig (gcc-8): 1 warning
    hisi_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    iop13xx_defconfig (gcc-8): 1 warning
    iop32x_defconfig (gcc-8): 1 warning
    iop33x_defconfig (gcc-8): 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    jornada720_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    ks8695_defconfig (gcc-8): 1 warning
    lart_defconfig (gcc-8): 1 warning
    lpc18xx_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 2 warnings
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 2 warnings
    neponset_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    netx_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    nuc910_defconfig (gcc-8): 1 warning
    nuc950_defconfig (gcc-8): 1 warning
    nuc960_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 1 warning
    omap2plus_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    palmz72_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    pleb_defconfig (gcc-8): 1 warning
    prima2_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa255-idp_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    qcom_defconfig (gcc-8): 1 warning
    raumfeld_defconfig (gcc-8): 1 warning
    realview-smp_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 1 warning
    rpc_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    shmobile_defconfig (gcc-8): 1 warning
    simpad_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    spear6xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 1 warning
    stm32_defconfig (gcc-8): 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tct_hammer_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u300_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    vf610m4_defconfig (gcc-8): 1 warning
    viper_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning
    zx_defconfig (gcc-8): 1 warning

i386:
    allnoconfig (gcc-8): 1 warning
    i386_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning

mips:
    allnoconfig (gcc-8): 1 warning
    ar7_defconfig (gcc-8): 1 warning
    ath79_defconfig (gcc-8): 1 warning
    bcm47xx_defconfig (gcc-8): 1 warning
    bcm63xx_defconfig (gcc-8): 1 warning
    bigsur_defconfig (gcc-8): 1 warning
    bmips_be_defconfig (gcc-8): 1 warning
    bmips_stb_defconfig (gcc-8): 1 warning
    capcella_defconfig (gcc-8): 1 warning
    cavium_octeon_defconfig (gcc-8): 1 warning
    ci20_defconfig (gcc-8): 1 warning
    cobalt_defconfig (gcc-8): 1 warning
    db1xxx_defconfig (gcc-8): 1 warning
    decstation_defconfig (gcc-8): 1 warning
    e55_defconfig (gcc-8): 1 warning
    fuloong2e_defconfig (gcc-8): 1 warning
    gpr_defconfig (gcc-8): 1 warning
    ip22_defconfig (gcc-8): 2 warnings
    ip27_defconfig (gcc-8): 1 warning
    ip28_defconfig (gcc-8): 2 warnings
    ip32_defconfig (gcc-8): 1 warning
    jazz_defconfig (gcc-8): 1 warning
    jmr3927_defconfig (gcc-8): 1 warning
    lasat_defconfig (gcc-8): 1 warning
    lemote2f_defconfig (gcc-8): 1 warning
    loongson3_defconfig (gcc-8): 1 warning
    ls1b_defconfig (gcc-8): 1 warning
    malta_defconfig (gcc-8): 1 warning
    malta_kvm_defconfig (gcc-8): 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 1 warning
    maltaaprp_defconfig (gcc-8): 1 warning
    maltasmvp_defconfig (gcc-8): 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 warning
    maltaup_defconfig (gcc-8): 1 warning
    maltaup_xpa_defconfig (gcc-8): 1 warning
    markeins_defconfig (gcc-8): 1 warning
    mips_paravirt_defconfig (gcc-8): 1 warning
    mpc30x_defconfig (gcc-8): 1 warning
    msp71xx_defconfig (gcc-8): 1 warning
    mtx1_defconfig (gcc-8): 1 warning
    nlm_xlp_defconfig (gcc-8): 1 warning
    nlm_xlr_defconfig (gcc-8): 1 warning
    pistachio_defconfig (gcc-8): 1 warning
    pnx8335_stb225_defconfig (gcc-8): 1 warning
    qi_lb60_defconfig (gcc-8): 1 warning
    rb532_defconfig (gcc-8): 1 warning
    rbtx49xx_defconfig (gcc-8): 1 warning
    rm200_defconfig (gcc-8): 1 warning
    rt305x_defconfig (gcc-8): 1 warning
    sb1250_swarm_defconfig (gcc-8): 1 warning
    sead3_defconfig (gcc-8): 1 warning
    sead3micro_defconfig (gcc-8): 2 errors, 1 warning
    tb0219_defconfig (gcc-8): 1 warning
    tb0226_defconfig (gcc-8): 1 warning
    tb0287_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning
    workpad_defconfig (gcc-8): 1 warning
    xilfpga_defconfig (gcc-8): 1 warning
    xway_defconfig (gcc-8): 1 warning

x86_64:
    allnoconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 warning

Errors summary:

    1    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode

Warnings summary:

    190  mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    2    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argum=
ent 5 of 'dma_free_attrs' makes pointer from integer without a cast [-Wint-=
conversion]
    1    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' de=
claration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate 'const'=
 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate 'const'=
 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate=
 'const' declaration specifier [-Wduplicate-decl-specifier]

Section mismatches summary:

    179  WARNING: modpost: Found 1 section mismatch(es).
    12   FATAL: modpost: Section mismatches detected.
    9    WARNING: modpost: Found 2 section mismatch(es).
    1    WARNING: vmlinux.o(.text+0x8a6a0): Section mismatch in reference f=
rom the function drain_all_pages() to the function .meminit.text:zone_pcp_u=
pdate()
    1    WARNING: mm/built-in.o(.text+0x8380): Section mismatch in referenc=
e from the function drain_all_pages() to the function .meminit.text:zone_pc=
p_update()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 4 warnings, 0 section mi=
smatches

Warnings:
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate 'con=
st' declaration specifier [-Wduplicate-decl-specifier]
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]
    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]
    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argument 5=
 of 'dma_free_attrs' makes pointer from integer without a cast [-Wint-conve=
rsion]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]
    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argument 5=
 of 'dma_free_attrs' makes pointer from integer without a cast [-Wint-conve=
rsion]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' declara=
tion specifier [-Wduplicate-decl-specifier]
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: mm/built-in.o(.text+0x8380): Section mismatch in reference fro=
m the function drain_all_pages() to the function .meminit.text:zone_pcp_upd=
ate()
    WARNING: vmlinux.o(.text+0x8a6a0): Section mismatch in reference from t=
he function drain_all_pages() to the function .meminit.text:zone_pcp_update=
()

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sead3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sead3micro_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another ISA =
mode
    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another ISA =
mode

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 5 warnings, 0 section mis=
matches

Warnings:
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 2 section mismatch(es).

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    mm/page_alloc.c:2024:2: warning: ISO C90 forbids mixed declarations and=
 code [-Wdeclaration-after-statement]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---
For more info write to <info@kernelci.org>
