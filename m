Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A33548E80
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385887AbiFMOws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385900AbiFMOvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:51:01 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67B32ED51
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:55:34 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id e11so5533780pfj.5
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RTHjKTFMw/2HrOCweRgemradZmY5ghHR4LgsSmBGBVM=;
        b=QZEalYhdYFpwUnJWsknXKkt1jB5cy5YVAoR4fzBX4T+eOk3Y9yNOH/j76ea/VOBgNA
         nYYHGxj4Xl/nyB0SXiItzqEL3iN8nXAPYcsOpbI3ix81FEV8/eMo0LDVD6wCHrIN8MPq
         jBHFxpP6cAEy3sWGvWnspP2lk29WpIVGh8rGkcgjD2Ot1dsMPx+4284NI9iLIp6QnLHc
         aF0KWBTbXdKdqGPpeVdgSmfFStyW8c58ryq+sOODPULfPJHgc2TvCbSd+LzoLZLC4nR2
         8nFaZmI3CAz3cze6p2pt4ZEhK3X44ElbziaB7KhUGSj/Lx3UXiSMjLuVrMbmFlm3xLRk
         QxBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RTHjKTFMw/2HrOCweRgemradZmY5ghHR4LgsSmBGBVM=;
        b=almusYEKDfA9pjT+9PSpNeJie+LQOSQUzDI/Ek+/fUiCD5gIQ1LK1HOSYwUAjSygLb
         PzrFxF9Ox0zfe0acrb37da3Mx5XtZr2iw9yIMh0v4BUg94K9MS08oMXg2aCHArxj6wIe
         luuSdC3Omij7OYIFM2jVj0T5RmvhYpjzXRnK2jRujD6/uC3xE3sa+rGNy6bbrWJMvuJs
         2HJAWnGTkkzznGhtVLg7qy6ediAi3vkfcp6f5h3YHw1DvF8LIjSAbSCf3ujzPW0RlndB
         boIGLGrMkh4nUxBosxrpQiFwG8xs3XdgKsq8JKwNAh6H/nnZY11kjmvSTVVGNBeQiNH0
         jvmQ==
X-Gm-Message-State: AOAM531eH8mL9RJsdq129B3+mSJ777niw3U0EpWXFHV82Sw+63Y8SIjA
        gvTRnGgWopXys8671IFJn7VDfvSW0a1dRQ/DCiQ=
X-Google-Smtp-Source: ABdhPJwpkErc+k6KUnyB7zJS2GBGq0e46riQhL4N3XFOEtFAeQuOmuhSw/u0rrGwhhus5n7dSdLYTw==
X-Received: by 2002:a63:9143:0:b0:3fc:52b8:401a with SMTP id l64-20020a639143000000b003fc52b8401amr50984697pge.401.1655121332999;
        Mon, 13 Jun 2022 04:55:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902ab8400b00161a40b2135sm4898270plr.104.2022.06.13.04.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 04:55:32 -0700 (PDT)
Message-ID: <62a725b4.1c69fb81.2b4ca.5c93@mx.google.com>
Date:   Mon, 13 Jun 2022 04:55:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.17.13-1070-g8734870d7c3b5
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 build: 151 builds: 2 failed, 149 passed, 4 errors,
 286 warnings (v5.17.13-1070-g8734870d7c3b5)
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

stable-rc/queue/5.17 build: 151 builds: 2 failed, 149 passed, 4 errors, 286=
 warnings (v5.17.13-1070-g8734870d7c3b5)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
7/kernel/v5.17.13-1070-g8734870d7c3b5/

Tree: stable-rc
Branch: queue/5.17
Git Describe: v5.17.13-1070-g8734870d7c3b5
Git Commit: 8734870d7c3b56701bbcc264fca8539110393f8f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-10): 2 warnings
    axs103_smp_defconfig (gcc-10): 2 warnings
    haps_hs_defconfig (gcc-10): 2 warnings
    hsdk_defconfig (gcc-10): 2 warnings
    nsimosci_hs_defconfig (gcc-10): 2 warnings
    nsimosci_hs_smp_defconfig (gcc-10): 2 warnings
    tinyconfig (gcc-10): 2 warnings
    vdk_hs38_defconfig (gcc-10): 2 warnings

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
    ezx_defconfig (gcc-10): 3 warnings
    footbridge_defconfig (gcc-10): 2 warnings
    gemini_defconfig (gcc-10): 2 warnings
    h3600_defconfig (gcc-10): 2 warnings
    h5000_defconfig (gcc-10): 2 warnings
    hackkit_defconfig (gcc-10): 2 warnings
    hisi_defconfig (gcc-10): 2 warnings
    imote2_defconfig (gcc-10): 3 warnings
    imx_v6_v7_defconfig (gcc-10): 2 warnings
    integrator_defconfig (gcc-10): 2 warnings
    iop32x_defconfig (gcc-10): 2 warnings
    ixp4xx_defconfig (gcc-10): 2 warnings
    jornada720_defconfig (gcc-10): 2 warnings
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
    shmobile_defconfig (gcc-10): 2 warnings
    simpad_defconfig (gcc-10): 2 warnings
    socfpga_defconfig (gcc-10): 2 warnings
    spear13xx_defconfig (gcc-10): 2 warnings
    spear6xx_defconfig (gcc-10): 2 warnings
    spitz_defconfig (gcc-10): 2 warnings
    stm32_defconfig (gcc-10): 2 warnings
    sunxi_defconfig (gcc-10): 2 warnings
    tct_hammer_defconfig (gcc-10): 2 warnings
    trizeps4_defconfig (gcc-10): 3 warnings
    u8500_defconfig (gcc-10): 2 warnings
    versatile_defconfig (gcc-10): 2 warnings
    vexpress_defconfig (gcc-10): 2 warnings
    vf610m4_defconfig (gcc-10): 2 warnings
    viper_defconfig (gcc-10): 2 warnings
    vt8500_v6_v7_defconfig (gcc-10): 2 warnings
    xcep_defconfig (gcc-10): 2 warnings

i386:
    allnoconfig (gcc-10): 2 warnings
    i386_defconfig (gcc-10): 2 warnings
    tinyconfig (gcc-10): 2 warnings

mips:
    32r2el_defconfig (gcc-10): 3 warnings
    ar7_defconfig (gcc-10): 2 warnings
    ath79_defconfig (gcc-10): 2 warnings
    bcm47xx_defconfig (gcc-10): 2 warnings
    bcm63xx_defconfig (gcc-10): 2 warnings
    bmips_be_defconfig (gcc-10): 3 warnings
    bmips_stb_defconfig (gcc-10): 3 warnings
    capcella_defconfig (gcc-10): 2 warnings
    ci20_defconfig (gcc-10): 2 warnings
    cobalt_defconfig (gcc-10): 2 warnings
    cu1000-neo_defconfig (gcc-10): 2 warnings
    decstation_defconfig (gcc-10): 2 warnings
    decstation_r4k_defconfig (gcc-10): 2 warnings
    e55_defconfig (gcc-10): 2 warnings
    fuloong2e_defconfig (gcc-10): 1 error, 1 warning
    gcw0_defconfig (gcc-10): 2 warnings
    ip22_defconfig (gcc-10): 3 warnings
    ip32_defconfig (gcc-10): 1 warning
    jazz_defconfig (gcc-10): 3 warnings
    jmr3927_defconfig (gcc-10): 2 warnings
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson1b_defconfig (gcc-10): 2 warnings
    loongson1c_defconfig (gcc-10): 2 warnings
    loongson2k_defconfig (gcc-10): 1 warning
    loongson3_defconfig (gcc-10): 1 warning
    malta_kvm_defconfig (gcc-10): 2 warnings
    maltaaprp_defconfig (gcc-10): 3 warnings
    maltasmvp_defconfig (gcc-10): 3 warnings
    maltaup_defconfig (gcc-10): 3 warnings
    maltaup_xpa_defconfig (gcc-10): 2 warnings
    mpc30x_defconfig (gcc-10): 2 warnings
    mtx1_defconfig (gcc-10): 3 warnings
    omega2p_defconfig (gcc-10): 2 warnings
    pic32mzda_defconfig (gcc-10): 2 warnings
    rbtx49xx_defconfig (gcc-10): 2 warnings
    rs90_defconfig (gcc-10): 2 warnings
    rt305x_defconfig (gcc-10): 2 warnings
    tb0226_defconfig (gcc-10): 2 warnings
    vocore2_defconfig (gcc-10): 2 warnings
    workpad_defconfig (gcc-10): 2 warnings

riscv:
    rv32_defconfig (gcc-10): 2 warnings

x86_64:

Errors summary:

    2    cc1: error: =E2=80=98-mloongson-mmi=E2=80=99 must be used with =E2=
=80=98-mhard-float=E2=80=99
    1    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r7,=
=3D0x'
    1    arch/arm/kernel/head.S:319: Error: missing expression -- `ldr r3,=
=3D0x'

Warnings summary:

    264  include/linux/minmax.h:20:28: warning: comparison of distinct poin=
ter types lacks a cast
    21   fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=
=E2=80=99 [-Wunused-variable]
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
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

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
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

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
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sect=
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
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

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
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

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
    fs/cifs/connect.c:3426:7: warning: unused variable =E2=80=98nodfs=E2=80=
=99 [-Wunused-variable]
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
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
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
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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

---
For more info write to <info@kernelci.org>
