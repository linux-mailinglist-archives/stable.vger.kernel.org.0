Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE17F1C7DE9
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgEFXc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgEFXcz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 19:32:55 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BE2C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 16:32:55 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y25so1980166pfn.5
        for <stable@vger.kernel.org>; Wed, 06 May 2020 16:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BluWapEotddbVwS/iTBAuDOMAfRwgwqactbWN6dPhn8=;
        b=EN7WtUtxka9+W5W8pV5tkriiegMoiFnGNmvRFofPr+S6EQ+5w4l+Csje/jjeRCgUTh
         ptEU3GEgu5Hrwx5hpoXXKuAG9u/UsIh8hjAYmKLQkGqN0N5ysWp3NFPKYd5d3ad110Vu
         MtnApxh4zelt5c346n/uZlh1P8pp0cjY68/9HPxFu3SFNADudZyCzC+kT+GLKuE6WjQ0
         1q9wmanLECG8XVZsMukwxSBOEmIuw485VBRE0QEi9P2d0SZVqmXVN2ctj0jvADLAkEzP
         liaagVag6/nk8jLotguEi5I0R2di5n6VEGEyToCYheCzEYF0hbRLCJOp6thRG+RmO6yG
         sOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BluWapEotddbVwS/iTBAuDOMAfRwgwqactbWN6dPhn8=;
        b=SICrx6t/0jfMFlN3GL7PdCKQD9Ga/UlS666VqXSqCL24ooAGHw4kdX3w8RxDzyeYMy
         6IdabtLo0lWMfhhu/uwpn+7CL5egIt+Qsm/vIelxmNSjMRhzBG9FwGB4WUlcz6StnfqZ
         Hj5kCp1wu4mHNKz5SG2BgTZqk2EWy/AWuoMUBJ7O2+gq/RYEZsT0tdlcCFuXvvypiuU4
         49RAl8RUfK+ouNRzpEB5/05/eCuG2O1n+8VccNZP2d/uM+97SmG1IYB4yhQTB0wZahQB
         bLKbdKGjsRuht5TggaV8++oeLm+TsZfszYF8SPDLOsK13ByNlkGXsu2XAGkVqNPvT4Ma
         JRWg==
X-Gm-Message-State: AGi0PuZ3MoOXSiWfnRfN3ZKzUCE/MRO5o87PXglv68t6QcNiYLrBMMhj
        8ZPen60hKAhnKYHqy8Xl8c7I2qgjEbqXgg==
X-Google-Smtp-Source: APiQypLOQ/qFvp9a8T4h0YhqLx8ke0Y8s/BWXWarXJSPg+NHi1SmCfxvtA2XepFDUgSZR/Kd3vLkMg==
X-Received: by 2002:a63:cf10:: with SMTP id j16mr194055pgg.201.1588807971160;
        Wed, 06 May 2020 16:32:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z190sm2892187pfz.84.2020.05.06.16.32.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 16:32:50 -0700 (PDT)
Message-ID: <5eb34922.1c69fb81.53739.98b0@mx.google.com>
Date:   Wed, 06 May 2020 16:32:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.222-166-g7ab45cabed0b
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-4.4.y build: 190 builds: 65 failed, 125 passed,
 1872 errors, 13 warnings (v4.4.222-166-g7ab45cabed0b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 65 failed, 125 passed, 1872 errors=
, 13 warnings (v4.4.222-166-g7ab45cabed0b)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.222-166-g7ab45cabed0b/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.222-166-g7ab45cabed0b
Git Commit: 7ab45cabed0becc5018c917eb494b860da28dd02
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    cm_x300_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL

mips:
    allnoconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bcm63xx_defconfig: (gcc-8) FAIL
    bigsur_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    ci20_defconfig: (gcc-8) FAIL
    cobalt_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
    lasat_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
    loongson3_defconfig: (gcc-8) FAIL
    ls1b_defconfig: (gcc-8) FAIL
    malta_defconfig: (gcc-8) FAIL
    malta_kvm_defconfig: (gcc-8) FAIL
    malta_kvm_guest_defconfig: (gcc-8) FAIL
    malta_qemu_32r6_defconfig: (gcc-8) FAIL
    maltaaprp_defconfig: (gcc-8) FAIL
    maltasmvp_defconfig: (gcc-8) FAIL
    maltasmvp_eva_defconfig: (gcc-8) FAIL
    maltaup_defconfig: (gcc-8) FAIL
    maltaup_xpa_defconfig: (gcc-8) FAIL
    markeins_defconfig: (gcc-8) FAIL
    mips_paravirt_defconfig: (gcc-8) FAIL
    mpc30x_defconfig: (gcc-8) FAIL
    msp71xx_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    sead3_defconfig: (gcc-8) FAIL
    sead3micro_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 3 warnings
    tinyconfig (gcc-8): 4 warnings

arm64:

arm:
    clps711x_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 error
    davinci_all_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v7_defconfig (gcc-8): 2 errors, 1 warning
    mxs_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 error
    raumfeld_defconfig (gcc-8): 1 error

i386:

mips:
    allnoconfig (gcc-8): 16 errors
    ar7_defconfig (gcc-8): 32 errors
    ath79_defconfig (gcc-8): 32 errors
    bcm47xx_defconfig (gcc-8): 34 errors
    bcm63xx_defconfig (gcc-8): 32 errors
    bigsur_defconfig (gcc-8): 32 errors
    bmips_be_defconfig (gcc-8): 48 errors
    bmips_stb_defconfig (gcc-8): 48 errors
    capcella_defconfig (gcc-8): 16 errors
    cavium_octeon_defconfig (gcc-8): 48 errors
    ci20_defconfig (gcc-8): 50 errors
    cobalt_defconfig (gcc-8): 48 errors
    db1xxx_defconfig (gcc-8): 50 errors
    decstation_defconfig (gcc-8): 48 errors
    e55_defconfig (gcc-8): 16 errors
    fuloong2e_defconfig (gcc-8): 32 errors
    gpr_defconfig (gcc-8): 32 errors
    ip22_defconfig (gcc-8): 32 errors
    ip27_defconfig (gcc-8): 50 errors
    ip28_defconfig (gcc-8): 32 errors
    ip32_defconfig (gcc-8): 34 errors
    jazz_defconfig (gcc-8): 48 errors
    jmr3927_defconfig (gcc-8): 48 errors
    lasat_defconfig (gcc-8): 32 errors
    lemote2f_defconfig (gcc-8): 16 errors
    loongson3_defconfig (gcc-8): 48 errors
    ls1b_defconfig (gcc-8): 48 errors
    malta_defconfig (gcc-8): 16 errors
    malta_kvm_defconfig (gcc-8): 16 errors
    malta_kvm_guest_defconfig (gcc-8): 50 errors
    malta_qemu_32r6_defconfig (gcc-8): 16 errors
    maltaaprp_defconfig (gcc-8): 16 errors
    maltasmvp_defconfig (gcc-8): 16 errors
    maltasmvp_eva_defconfig (gcc-8): 16 errors
    maltaup_defconfig (gcc-8): 16 errors
    maltaup_xpa_defconfig (gcc-8): 16 errors
    markeins_defconfig (gcc-8): 50 errors
    mips_paravirt_defconfig (gcc-8): 34 errors
    mpc30x_defconfig (gcc-8): 16 errors
    msp71xx_defconfig (gcc-8): 16 errors
    mtx1_defconfig (gcc-8): 32 errors
    nlm_xlp_defconfig (gcc-8): 50 errors
    nlm_xlr_defconfig (gcc-8): 16 errors
    pistachio_defconfig (gcc-8): 16 errors
    pnx8335_stb225_defconfig (gcc-8): 16 errors
    qi_lb60_defconfig (gcc-8): 48 errors
    rb532_defconfig (gcc-8): 50 errors
    rbtx49xx_defconfig (gcc-8): 48 errors
    rm200_defconfig (gcc-8): 16 errors
    rt305x_defconfig (gcc-8): 16 errors
    sb1250_swarm_defconfig (gcc-8): 34 errors
    sead3_defconfig (gcc-8): 50 errors
    sead3micro_defconfig (gcc-8): 16 errors
    tb0219_defconfig (gcc-8): 16 errors
    tb0226_defconfig (gcc-8): 16 errors
    tb0287_defconfig (gcc-8): 16 errors
    tinyconfig (gcc-8): 50 errors
    workpad_defconfig (gcc-8): 16 errors
    xilfpga_defconfig (gcc-8): 16 errors
    xway_defconfig (gcc-8): 32 errors

x86_64:

Errors summary:

    920  arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=
=80=99 or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    920  arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=
=80=99 or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    13   arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=
=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98MI=
PS_PWCTL_PSN_MASK=E2=80=99?
    13   arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=
=E2=80=99 undeclared (first use in this function); did you mean =E2=80=98MI=
PS_PWSIZE_PTW_MASK=E2=80=99?
    3    drivers/mtd/nand/pxa3xx_nand.c:1753:7: error: =E2=80=98np=E2=80=99=
 undeclared (first use in this function); did you mean =E2=80=98nop=E2=80=
=99?
    2    drivers/net/ethernet/marvell/mvneta.c:3442:3: error: implicit decl=
aration of function =E2=80=98of_phy_deregister_fixed_link=E2=80=99; did you=
 mean =E2=80=98of_phy_register_fixed_link=E2=80=99? [-Werror=3Dimplicit-fun=
ction-declaration]
    1    drivers/mtd/nand/pxa3xx_nand.c:1753:7: error: =E2=80=98np=E2=80=99=
 undeclared (first use in this function); did you mean =E2=80=98up=E2=80=99?

Warnings summary:

    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    2    cc1: some warnings being treated as errors
    1    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate =E2=80=98c=
onst=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate =E2=80=
=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate =E2=80=
=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate=
 =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 section =
mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section mi=
smatches

Warnings:
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 34 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings=
, 0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate =E2=
=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/mtd/nand/pxa3xx_nand.c:1753:7: error: =E2=80=98np=E2=80=99 unde=
clared (first use in this function); did you mean =E2=80=98nop=E2=80=99?

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate =E2=80=98con=
st=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0=
 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 34 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate =E2=80=98con=
st=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnin=
gs, 0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnin=
gs, 0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings=
, 0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, =
0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 34 errors, 0 warnings=
, 0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    drivers/net/ethernet/marvell/mvneta.c:3442:3: error: implicit declarati=
on of function =E2=80=98of_phy_deregister_fixed_link=E2=80=99; did you mean=
 =E2=80=98of_phy_register_fixed_link=E2=80=99? [-Werror=3Dimplicit-function=
-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    drivers/mtd/nand/pxa3xx_nand.c:1753:7: error: =E2=80=98np=E2=80=99 unde=
clared (first use in this function); did you mean =E2=80=98up=E2=80=99?
    drivers/net/ethernet/marvell/mvneta.c:3442:3: error: implicit declarati=
on of function =E2=80=98of_phy_deregister_fixed_link=E2=80=99; did you mean=
 =E2=80=98of_phy_register_fixed_link=E2=80=99? [-Werror=3Dimplicit-function=
-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate =E2=80=98const=
=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warning=
s, 0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/mtd/nand/pxa3xx_nand.c:1753:7: error: =E2=80=98np=E2=80=99 unde=
clared (first use in this function); did you mean =E2=80=98nop=E2=80=99?

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/mtd/nand/pxa3xx_nand.c:1753:7: error: =E2=80=98np=E2=80=99 unde=
clared (first use in this function); did you mean =E2=80=98nop=E2=80=99?

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 48 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 34 errors, 0 warnings,=
 0 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
sead3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
sead3micro_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0=
 section mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 50 errors, 0 warnings, 0 section m=
ismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/mm/tlbex.c:2334:13: error: =E2=80=98MIPS_PWSIZE_PS_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWS=
IZE_PTW_MASK=E2=80=99?
    arch/mips/mm/tlbex.c:2350:13: error: =E2=80=98MIPS_PWCTL_XU_MASK=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98MIPS_PWC=
TL_PSN_MASK=E2=80=99?
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mis=
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

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 32 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:204:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99
    arch/mips/include/asm/msa.h:219:2: error: expected =E2=80=98:=E2=80=99 =
or =E2=80=98)=E2=80=99 before =E2=80=98_ASM_INSN_IF_MIPS=E2=80=99

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
