Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BEC4D27DB
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiCIEJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 23:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiCIEJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 23:09:12 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89C8DF69
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 20:08:06 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso1174251pjo.5
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 20:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UoMVyk7iHpEwVUGG6NwstSCG9lGUKBy4piLb3DfEp2I=;
        b=cAAWgYJYs3sgY0HvPgWwx3fo93eqn/MlO13fFGttcekqVGbQTvMSyKHtS/UUqA4H1K
         GVq6hbRMhnHrVISFRKBvY/37PATcFq4QN1jff8v85US0BjMPy4gHzCjaQZ/WXEmsxRgs
         NibXZQwOhcnw2HlEZJk2KVaCWAZHPCb4Sg7yilqHYbm6hoY9ly2NnTmhLAxW/jb7iLrs
         n19y1BhsUlHBSQdEjFQ2TVKTJQMko9xbIdrPAYlU9BvLD836i855zhLWWi17km/zwYNF
         QJSLAhC6K0w9hMyRRBiJfKU0md/hfbHMlVr4c5Qe42LnTJiwPmW7T788v+AtH5GFDCR6
         CeYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UoMVyk7iHpEwVUGG6NwstSCG9lGUKBy4piLb3DfEp2I=;
        b=dvBcUTJ0xKr43oas1WWeP1yrJyyJ2EqUeWDSolFNT9AB3siUvbrw8rRUa45iLWoMTI
         fo0q/weCfgBoe8YNcMv6uWKG6UBovPUU+hEYakvkFlc4hywgNuNfRxDVo1iYJXI3ea3c
         bziuDAws+Xa9XVpDlrNx5oeXsPx/MUHyeNmCtBKURqmy0J/qBGLVZ3kbygbWT4+2y2Eb
         5FxnKAp9gH+KSJA4J+VwBDwV1OUTErPJeM5PSmG/gy/07R3RIrpiG6Yz7EyRILC4Ptma
         Gzf5ZEcFiIrPx1sGb68FMNvrxCOfltklo7G+PmJKsF/g9agrUeYlExlcj2W0Adf/jVgy
         +wkg==
X-Gm-Message-State: AOAM531WymovYiT4bIgMgCu5M4rTMu+TtzD9joXL9eHZiqLxUn3CytYl
        sO+PCep1Xce/SqYyKvtD4Ji8wf+g0pawbg2Bovo=
X-Google-Smtp-Source: ABdhPJygIqfMIGLj3lAymTRCIVrZQSOjGcoi/9v4J8wR0U9RB9EX2ae1sVJf1wxK8fHF36XRRsiGDw==
X-Received: by 2002:a17:90a:aa8c:b0:1bf:5273:ba28 with SMTP id l12-20020a17090aaa8c00b001bf5273ba28mr8277424pjq.226.1646798884509;
        Tue, 08 Mar 2022 20:08:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c5-20020a056a00248500b004f6b5ddcc65sm663368pfv.199.2022.03.08.20.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 20:08:04 -0800 (PST)
Message-ID: <62282824.1c69fb81.8c2e.2a9f@mx.google.com>
Date:   Tue, 08 Mar 2022 20:08:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.27-41-g5ad72e40dcac
Subject: stable-rc/linux-5.15.y build: 181 builds: 37 failed, 144 passed,
 93 errors, 9 warnings (v5.15.27-41-g5ad72e40dcac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y build: 181 builds: 37 failed, 144 passed, 93 errors,=
 9 warnings (v5.15.27-41-g5ad72e40dcac)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.15.=
y/kernel/v5.15.27-41-g5ad72e40dcac/

Tree: stable-rc
Branch: linux-5.15.y
Git Describe: v5.15.27-41-g5ad72e40dcac
Git Commit: 5ad72e40dcac0cb04181911a748786e78a9d37ec
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    aspeed_g5_defconfig: (gcc-10) FAIL
    axm55xx_defconfig: (gcc-10) FAIL
    bcm2835_defconfig: (gcc-10) FAIL
    clps711x_defconfig: (gcc-10) FAIL
    cns3420vb_defconfig: (gcc-10) FAIL
    dove_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    hisi_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    keystone_defconfig: (gcc-10) FAIL
    milbeaut_m10v_defconfig: (gcc-10) FAIL
    mmp2_defconfig: (gcc-10) FAIL
    multi_v7_defconfig: (gcc-10) FAIL
    mvebu_v7_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    oxnas_v6_defconfig: (gcc-10) FAIL
    pxa168_defconfig: (gcc-10) FAIL
    pxa910_defconfig: (gcc-10) FAIL
    qcom_defconfig: (gcc-10) FAIL
    realview_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    s5pv210_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    sama7_defconfig: (gcc-10) FAIL
    shmobile_defconfig: (gcc-10) FAIL
    socfpga_defconfig: (gcc-10) FAIL
    spear13xx_defconfig: (gcc-10) FAIL
    sunxi_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    u8500_defconfig: (gcc-10) FAIL
    vexpress_defconfig: (gcc-10) FAIL
    vt8500_v6_v7_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    tinyconfig (gcc-10): 1 warning

arm64:

arm:
    aspeed_g5_defconfig (gcc-10): 10 errors
    axm55xx_defconfig (gcc-10): 1 error
    bcm2835_defconfig (gcc-10): 2 errors
    clps711x_defconfig (gcc-10): 1 error
    cns3420vb_defconfig (gcc-10): 2 errors
    dove_defconfig (gcc-10): 1 error
    exynos_defconfig (gcc-10): 1 error
    hisi_defconfig (gcc-10): 1 error
    imx_v6_v7_defconfig (gcc-10): 3 errors
    keystone_defconfig (gcc-10): 1 error
    milbeaut_m10v_defconfig (gcc-10): 1 error
    mmp2_defconfig (gcc-10): 1 error
    multi_v7_defconfig (gcc-10): 1 error
    mvebu_v7_defconfig (gcc-10): 1 error
    omap2plus_defconfig (gcc-10): 14 errors
    oxnas_v6_defconfig (gcc-10): 2 errors
    pxa168_defconfig (gcc-10): 1 error
    pxa910_defconfig (gcc-10): 1 error
    qcom_defconfig (gcc-10): 1 error
    realview_defconfig (gcc-10): 7 errors
    rpc_defconfig (gcc-10): 4 errors
    s5pv210_defconfig (gcc-10): 1 error
    sama5_defconfig (gcc-10): 1 error
    sama7_defconfig (gcc-10): 1 error
    shmobile_defconfig (gcc-10): 1 error
    socfpga_defconfig (gcc-10): 1 error
    spear13xx_defconfig (gcc-10): 1 error
    sunxi_defconfig (gcc-10): 1 error
    tegra_defconfig (gcc-10): 1 error
    u8500_defconfig (gcc-10): 1 error
    vexpress_defconfig (gcc-10): 1 error
    vt8500_v6_v7_defconfig (gcc-10): 10 errors

i386:

mips:
    32r2el_defconfig (gcc-10): 1 warning
    bigsur_defconfig (gcc-10): 1 error, 1 warning
    cavium_octeon_defconfig (gcc-10): 1 error
    decstation_64_defconfig (gcc-10): 1 error
    fuloong2e_defconfig (gcc-10): 1 error, 1 warning
    gpr_defconfig (gcc-10): 3 errors, 1 warning
    ip32_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson2k_defconfig (gcc-10): 1 error, 1 warning
    loongson3_defconfig (gcc-10): 1 error
    mtx1_defconfig (gcc-10): 3 errors, 1 warning
    nlm_xlp_defconfig (gcc-10): 1 error
    rm200_defconfig (gcc-10): 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 error

riscv:

x86_64:

Errors summary:

    23   arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=
=99 before =E2=80=98}=E2=80=99 token
    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    8    arch/arm/kernel/entry-common.S:175: Error: co-processor register e=
xpected -- `mcr p15,0,r0,c7,r5,4'
    8    arch/arm/kernel/entry-common.S:166: Error: co-processor register e=
xpected -- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -=
- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:42: Error: co-processor register expected -=
- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:312: Error: co-processor register expected =
-- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:179: Error: co-processor register expected =
-- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:142: Error: co-processor register expected =
-- `mcr p15,0,r0,c7,r5,4'
    2    drivers/net/slip/slip.c:960:7: error: =E2=80=98END=E2=80=99 undecl=
ared (first use in this function)
    2    drivers/net/slip/slip.c:930:11: error: =E2=80=98END=E2=80=99 undec=
lared (first use in this function)
    2    drivers/net/slip/slip.c:1393:54: error: =E2=80=98END=E2=80=99 unde=
clared (first use in this function)
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99
    2    arch/arm/common/secure_cntvoff.S:29: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    2    arch/arm/common/secure_cntvoff.S:27: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    2    arch/arm/common/secure_cntvoff.S:24: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-omap2/sleep44xx.S:91: Error: co-processor register e=
xpected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-omap2/sleep44xx.S:342: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-omap2/sleep44xx.S:274: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-omap2/sleep44xx.S:223: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-omap2/sleep44xx.S:205: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-omap2/sleep44xx.S:193: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-omap2/sleep44xx.S:131: Error: co-processor register =
expected -- `mcr p15,0,r0,c7,r5,4'
    1    arch/arm/mach-imx/suspend-imx6.S:315: Error: co-processor register=
 expected -- `mcr p15,0,r0,c7,r5,4'

Warnings summary:

    2    net/mac80211/mlme.c:4370:1: warning: the frame size of 1200 bytes =
is larger than 1024 bytes [-Wframe-larger-than=3D]
    2    drivers/net/slip/slip.h:44: warning: "END" redefined
    2    arch/mips/include/asm/asm.h:68: warning: "END" redefined
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_devic=
e_reg): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expec=
ted "0,0"
    1    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' i=
s unknown, fallback to ''

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 10 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:42: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    drivers/net/slip/slip.h:44: warning: "END" redefined

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warn=
ings, 0 section mismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    drivers/net/slip/slip.h:44: warning: "END" redefined

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 1 warning, 0 section=
 mismatches

Errors:
    drivers/net/slip/slip.c:930:11: error: =E2=80=98END=E2=80=99 undeclared=
 (first use in this function)
    drivers/net/slip/slip.c:960:7: error: =E2=80=98END=E2=80=99 undeclared =
(first use in this function)
    drivers/net/slip/slip.c:1393:54: error: =E2=80=98END=E2=80=99 undeclare=
d (first use in this function)

Warnings:
    arch/mips/include/asm/asm.h:68: warning: "END" redefined

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mach-imx/suspend-imx6.S:315: Error: co-processor register expe=
cted -- `mcr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4370:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4370:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    drivers/net/slip/slip.c:930:11: error: =E2=80=98END=E2=80=99 undeclared=
 (first use in this function)
    drivers/net/slip/slip.c:960:7: error: =E2=80=98END=E2=80=99 undeclared =
(first use in this function)
    drivers/net/slip/slip.c:1393:54: error: =E2=80=98END=E2=80=99 undeclare=
d (first use in this function)

Warnings:
    arch/mips/include/asm/asm.h:68: warning: "END" redefined

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_sdcard_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 war=
nings, 0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 14 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:42: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mach-omap2/sleep44xx.S:91: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mach-omap2/sleep44xx.S:131: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mach-omap2/sleep44xx.S:193: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mach-omap2/sleep44xx.S:205: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mach-omap2/sleep44xx.S:223: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mach-omap2/sleep44xx.S:274: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mach-omap2/sleep44xx.S:342: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 7 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:42: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, =
0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 10 errors, 0 warnings,=
 0 section mismatches

Errors:
    arch/arm/kernel/entry-common.S:166: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:175: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/common/secure_cntvoff.S:24: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/common/secure_cntvoff.S:27: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/common/secure_cntvoff.S:29: Error: co-processor register expec=
ted -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:42: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:69: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:142: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:179: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:312: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
0 warnings, 0 section mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---
For more info write to <info@kernelci.org>
