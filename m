Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0928549774
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355371AbiFMLkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355651AbiFMLjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6009C2C64D
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 03:49:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z14so506064pjb.4
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 03:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VMMNcoMCZ8+r9m23ocjWmhU2Cq+S+MMUkad4aXGGawE=;
        b=nA9AKXN70I/PrGb7zPKOJh75+mtZtE1birj9l5Rg6ddfUaUD6soFaYLxKmppuahgYS
         J0LIyvXjNSRhscnngM+pDmYlwihk88LEhgbDo2hLqPG9MLE8OlxDCFqdcsmGfFhGEwn+
         oDsLJA4KNY1zB998aFiJVJRTXFsZ6wZ7TuZTkH1zX1HXEkveQsTTrT4IYzO40YMLKMTn
         kwnpBETwxJ0Di4AIHynnobiKqsk67q+/g1D8VpwYNI1hwO7jRlSX0L6Z6tq8o+9OgffC
         rT4sQDBNYDNbCNCB2m8ieVsJiehC20ML0OASENpxL1C3oj64qoYE1s8IKntnfWWZeGZO
         45Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VMMNcoMCZ8+r9m23ocjWmhU2Cq+S+MMUkad4aXGGawE=;
        b=fbWjbKg4pnnF8D9Au/UZP1tud0zQVloRnD3iFLtPV5bTAuo7DmE1st8zYGk90jl41w
         /iwgdbM8m2Mt+yKOU6GRV54FUIR45kZJw0MIqXZgmcMj969oKLgTSBl2vZVnYkh+CXtn
         Cr8h3Ukg4LEa1yvhqGLOOU+9iLYN7JkbWaE6zlxK8gigsqoq7v1t/tZXh7Q6Yml5ZP6C
         PJ5JvBg12XOrnGqlnUcLKBJzOkf1orq9cbqAnxLILDZR224WvYHtCGLCuYizQGrxphcd
         228JSryB8M/vuyD8+j+WGGIhwJCux/vKfPV3lp4TjNUAU5bMN3QujL//awnLyLzGlaI3
         Jheg==
X-Gm-Message-State: AOAM5305WIG7TUPHN4gTqr5GbG3kcmWQQhCx0FgC4JoV+yKfRtW8/ghC
        EWvqmAUKR3uHIMP44IttwNbaAC8VV8e65DNe1ec=
X-Google-Smtp-Source: ABdhPJy4a9ZVe2TKzPrXzzqj91mWMRRyxI4qyoaUbFCZ20lsgsfhCRzZoDzXG7bSp8mgI0kXOhE6Jg==
X-Received: by 2002:a17:902:ccd0:b0:168:db72:15e with SMTP id z16-20020a170902ccd000b00168db72015emr5769853ple.63.1655117369469;
        Mon, 13 Jun 2022 03:49:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902f2cb00b00163aba9a2a5sm4764959plc.106.2022.06.13.03.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 03:49:29 -0700 (PDT)
Message-ID: <62a71639.1c69fb81.fb823.56fc@mx.google.com>
Date:   Mon, 13 Jun 2022 03:49:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.18.2-1217-gb6d3927fce460
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 build: 175 builds: 3 failed, 172 passed, 8 errors,
 334 warnings (v5.18.2-1217-gb6d3927fce460)
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

stable-rc/queue/5.18 build: 175 builds: 3 failed, 172 passed, 8 errors, 334=
 warnings (v5.18.2-1217-gb6d3927fce460)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
8/kernel/v5.18.2-1217-gb6d3927fce460/

Tree: stable-rc
Branch: queue/5.18
Git Describe: v5.18.2-1217-gb6d3927fce460
Git Commit: b6d3927fce4608940f5959377a788b1615e5d5a8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

i386:
    i386_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-10): 2 warnings
    axs103_defconfig (gcc-10): 2 warnings
    axs103_smp_defconfig (gcc-10): 2 warnings
    haps_hs_defconfig (gcc-10): 2 warnings
    haps_hs_smp_defconfig (gcc-10): 2 warnings
    hsdk_defconfig (gcc-10): 2 warnings
    nsimosci_hs_defconfig (gcc-10): 2 warnings
    nsimosci_hs_smp_defconfig (gcc-10): 2 warnings
    tinyconfig (gcc-10): 2 warnings
    vdk_hs38_defconfig (gcc-10): 2 warnings
    vdk_hs38_smp_defconfig (gcc-10): 2 warnings

arm64:

arm:
    am200epdkit_defconfig (gcc-10): 2 warnings
    aspeed_g4_defconfig (gcc-10): 2 warnings
    aspeed_g5_defconfig (gcc-10): 2 warnings
    assabet_defconfig (gcc-10): 2 warnings
    at91_dt_defconfig (gcc-10): 2 warnings
    axm55xx_defconfig (gcc-10): 2 warnings
    badge4_defconfig (gcc-10): 2 warnings
    bcm2835_defconfig (gcc-10): 2 warnings
    cerfcube_defconfig (gcc-10): 2 warnings
    cm_x300_defconfig (gcc-10): 3 warnings
    colibri_pxa270_defconfig (gcc-10): 2 warnings
    colibri_pxa300_defconfig (gcc-10): 2 warnings
    collie_defconfig (gcc-10): 2 warnings
    corgi_defconfig (gcc-10): 2 warnings
    davinci_all_defconfig (gcc-10): 2 warnings
    dove_defconfig (gcc-10): 2 warnings
    ep93xx_defconfig (gcc-10): 2 warnings
    eseries_pxa_defconfig (gcc-10): 2 warnings
    exynos_defconfig (gcc-10): 2 warnings
    ezx_defconfig (gcc-10): 3 warnings
    footbridge_defconfig (gcc-10): 2 warnings
    gemini_defconfig (gcc-10): 2 warnings
    h3600_defconfig (gcc-10): 2 warnings
    h5000_defconfig (gcc-10): 2 warnings
    hackkit_defconfig (gcc-10): 2 warnings
    hisi_defconfig (gcc-10): 2 warnings
    imx_v4_v5_defconfig (gcc-10): 2 warnings
    imx_v6_v7_defconfig (gcc-10): 2 warnings
    integrator_defconfig (gcc-10): 2 warnings
    iop32x_defconfig (gcc-10): 2 warnings
    ixp4xx_defconfig (gcc-10): 2 warnings
    jornada720_defconfig (gcc-10): 2 warnings
    keystone_defconfig (gcc-10): 2 warnings
    lart_defconfig (gcc-10): 2 warnings
    lpc18xx_defconfig (gcc-10): 2 warnings
    lpc32xx_defconfig (gcc-10): 2 warnings
    lpd270_defconfig (gcc-10): 2 warnings
    lubbock_defconfig (gcc-10): 2 warnings
    magician_defconfig (gcc-10): 2 warnings
    mainstone_defconfig (gcc-10): 2 warnings
    milbeaut_m10v_defconfig (gcc-10): 2 warnings
    mini2440_defconfig (gcc-10): 2 warnings
    mmp2_defconfig (gcc-10): 2 warnings
    moxart_defconfig (gcc-10): 2 warnings
    mps2_defconfig (gcc-10): 2 warnings
    multi_v4t_defconfig (gcc-10): 2 warnings
    multi_v5_defconfig (gcc-10): 2 warnings
    multi_v7_defconfig (gcc-10): 2 warnings
    mvebu_v5_defconfig (gcc-10): 2 warnings
    mvebu_v7_defconfig (gcc-10): 2 warnings
    mxs_defconfig (gcc-10): 2 warnings
    neponset_defconfig (gcc-10): 2 warnings
    netwinder_defconfig (gcc-10): 2 warnings
    nhk8815_defconfig (gcc-10): 3 warnings
    omap1_defconfig (gcc-10): 2 warnings
    omap2plus_defconfig (gcc-10): 2 warnings
    orion5x_defconfig (gcc-10): 2 warnings
    oxnas_v6_defconfig (gcc-10): 2 warnings
    palmz72_defconfig (gcc-10): 2 warnings
    pcm027_defconfig (gcc-10): 2 warnings
    pleb_defconfig (gcc-10): 2 warnings
    pxa168_defconfig (gcc-10): 2 warnings
    pxa255-idp_defconfig (gcc-10): 2 warnings
    pxa3xx_defconfig (gcc-10): 2 warnings
    pxa910_defconfig (gcc-10): 2 warnings
    pxa_defconfig (gcc-10): 3 warnings
    qcom_defconfig (gcc-10): 3 warnings
    realview_defconfig (gcc-10): 2 warnings
    rpc_defconfig (gcc-10): 2 errors
    s3c2410_defconfig (gcc-10): 3 warnings
    s3c6400_defconfig (gcc-10): 2 warnings
    s5pv210_defconfig (gcc-10): 2 warnings
    sama5_defconfig (gcc-10): 2 warnings
    sama7_defconfig (gcc-10): 2 warnings
    shannon_defconfig (gcc-10): 2 warnings
    shmobile_defconfig (gcc-10): 2 warnings
    simpad_defconfig (gcc-10): 2 warnings
    socfpga_defconfig (gcc-10): 2 warnings
    spear13xx_defconfig (gcc-10): 2 warnings
    spear3xx_defconfig (gcc-10): 2 warnings
    spear6xx_defconfig (gcc-10): 2 warnings
    spitz_defconfig (gcc-10): 2 warnings
    stm32_defconfig (gcc-10): 2 warnings
    sunxi_defconfig (gcc-10): 2 warnings
    tct_hammer_defconfig (gcc-10): 2 warnings
    tegra_defconfig (gcc-10): 2 warnings
    trizeps4_defconfig (gcc-10): 3 warnings
    u8500_defconfig (gcc-10): 2 warnings
    versatile_defconfig (gcc-10): 2 warnings
    vexpress_defconfig (gcc-10): 2 warnings
    vf610m4_defconfig (gcc-10): 2 warnings
    viper_defconfig (gcc-10): 2 warnings
    vt8500_v6_v7_defconfig (gcc-10): 2 warnings
    xcep_defconfig (gcc-10): 2 warnings
    zeus_defconfig (gcc-10): 2 warnings

i386:
    allnoconfig (gcc-10): 2 warnings
    i386_defconfig (gcc-10): 2 errors, 1 warning
    tinyconfig (gcc-10): 2 warnings

mips:
    32r2el_defconfig (gcc-10): 3 warnings
    ar7_defconfig (gcc-10): 2 warnings
    ath25_defconfig (gcc-10): 2 warnings
    ath79_defconfig (gcc-10): 2 warnings
    bcm47xx_defconfig (gcc-10): 2 warnings
    bcm63xx_defconfig (gcc-10): 2 warnings
    bmips_be_defconfig (gcc-10): 3 warnings
    bmips_stb_defconfig (gcc-10): 3 warnings
    capcella_defconfig (gcc-10): 2 warnings
    ci20_defconfig (gcc-10): 2 warnings
    cobalt_defconfig (gcc-10): 2 warnings
    cu1000-neo_defconfig (gcc-10): 2 warnings
    cu1830-neo_defconfig (gcc-10): 2 warnings
    db1xxx_defconfig (gcc-10): 2 warnings
    decstation_defconfig (gcc-10): 2 warnings
    decstation_r4k_defconfig (gcc-10): 2 warnings
    e55_defconfig (gcc-10): 2 warnings
    fuloong2e_defconfig (gcc-10): 1 error, 1 warning
    gcw0_defconfig (gcc-10): 2 warnings
    gpr_defconfig (gcc-10): 2 warnings
    ip22_defconfig (gcc-10): 3 warnings
    ip32_defconfig (gcc-10): 1 warning
    jazz_defconfig (gcc-10): 3 warnings
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson1b_defconfig (gcc-10): 2 warnings
    loongson1c_defconfig (gcc-10): 2 warnings
    loongson2k_defconfig (gcc-10): 1 error, 1 warning
    loongson3_defconfig (gcc-10): 1 error, 1 warning
    malta_defconfig (gcc-10): 2 warnings
    malta_kvm_defconfig (gcc-10): 2 warnings
    malta_qemu_32r6_defconfig (gcc-10): 3 warnings
    maltaaprp_defconfig (gcc-10): 3 warnings
    maltasmvp_defconfig (gcc-10): 3 warnings
    maltasmvp_eva_defconfig (gcc-10): 3 warnings
    maltaup_defconfig (gcc-10): 3 warnings
    maltaup_xpa_defconfig (gcc-10): 2 warnings
    mpc30x_defconfig (gcc-10): 2 warnings
    mtx1_defconfig (gcc-10): 3 warnings
    omega2p_defconfig (gcc-10): 2 warnings
    pic32mzda_defconfig (gcc-10): 2 warnings
    qi_lb60_defconfig (gcc-10): 2 warnings
    rb532_defconfig (gcc-10): 3 warnings
    rbtx49xx_defconfig (gcc-10): 2 warnings
    rm200_defconfig (gcc-10): 3 warnings
    rs90_defconfig (gcc-10): 2 warnings
    rt305x_defconfig (gcc-10): 2 warnings
    tb0219_defconfig (gcc-10): 2 warnings
    tb0226_defconfig (gcc-10): 2 warnings
    tb0287_defconfig (gcc-10): 2 warnings
    vocore2_defconfig (gcc-10): 2 warnings
    workpad_defconfig (gcc-10): 2 warnings

riscv:
    rv32_defconfig (gcc-10): 2 warnings

x86_64:

Errors summary:

    4    cc1: error: =E2=80=98-mloongson-mmi=E2=80=99 must be used with =E2=
=80=98-mhard-float=E2=80=99
    2    include/linux/minmax.h:20:28: error: comparison of distinct pointe=
r types lacks a cast [-Werror]
    1    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r7,=
=3D0x'
    1    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r3,=
=3D0x'

Warnings summary:

    308  include/linux/minmax.h:20:28: warning: comparison of distinct poin=
ter types lacks a cast
    23   fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=
=E2=80=99 [-Wunused-variable]
    1    cc1: warning: result of =E2=80=98-117440512 << 16=E2=80=99 require=
s 44 bits to represent, but =E2=80=98int=E2=80=99 only has 32 bits [-Wshift=
-overflow=3D]
    1    cc1: all warnings being treated as errors
    1    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_devic=
e_reg): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expec=
ted "0,0"

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 s=
ection mismatches

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings=
, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings=
, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warning=
s, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section=
 mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    cc1: error: =E2=80=98-mloongson-mmi=E2=80=99 must be used with =E2=80=
=98-mhard-float=E2=80=99

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/minmax.h:20:28: error: comparison of distinct pointer typ=
es lacks a cast [-Werror]
    include/linux/minmax.h:20:28: error: comparison of distinct pointer typ=
es lacks a cast [-Werror]

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    cc1: error: =E2=80=98-mloongson-mmi=E2=80=99 must be used with =E2=80=
=98-mhard-float=E2=80=99

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    cc1: error: =E2=80=98-mloongson-mmi=E2=80=99 must be used with =E2=80=
=98-mhard-float=E2=80=99

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    cc1: error: =E2=80=98-mloongson-mmi=E2=80=99 must be used with =E2=80=
=98-mhard-float=E2=80=99

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnin=
gs, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings=
, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, =
0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings,=
 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

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
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warning=
s, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section=
 mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    cc1: warning: result of =E2=80=98-117440512 << 16=E2=80=99 requires 44 =
bits to represent, but =E2=80=98int=E2=80=99 only has 32 bits [-Wshift-over=
flow=3D]
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r7,=3D0x'
    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r3,=3D0x'

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section mi=
smatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, =
0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, =
0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---
For more info write to <info@kernelci.org>
