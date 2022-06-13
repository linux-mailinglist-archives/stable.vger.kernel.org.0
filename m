Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCABB548162
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 10:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiFMI0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 04:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiFMI0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 04:26:16 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3A41EED1
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:26:13 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id k5-20020a17090a404500b001e8875e6242so5242003pjg.5
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 01:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+tRydqXjfczMtVI6iC4WBhqEJPFzVnwpm2oV22Uf364=;
        b=S5AAtVSSAmpIdm2SuoxDkhqJL+ZanzfxMZaKcZZotNE4nsQhHzxwo1vIrTifc+fyKo
         m6hjWt8vNM1ZeXOFUNJHQgxDh1fVwH93lP21Z3uOaKTQQPTNDJRyFoyNigWGJkjKypV1
         cagreGliqrLzF3idj0+rIJy+IZjasXV99fk7YvjMKfSxYsE86r7FdVwnx9/K9MmTovW6
         x2vO9d1+tni7MYSQL6CvzK2vBD5E0WhSXDow6WFXXOJITMHO71yNvgGlI2WrWouraTUL
         uno+yUNd9M09CqqyW8d9cWY04RB/owbda2NHghS9yWMPBZfnnGrKfaMTpg1upflfAIHf
         B+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+tRydqXjfczMtVI6iC4WBhqEJPFzVnwpm2oV22Uf364=;
        b=D8IXvVSJp+R5PJnFwt1JJSvbIuktYnPtWxoe8h5K2W2JCv+T5ddvFHux66QyiRUr4a
         Iah6rK5OKLbmOjs/DSexXm6pRwCmlBDc+VE2HkWaMSEiJ2YaENU+HIx8U8mfmRyNVyXo
         qaBWB1jZeHJD2DVud9ROb/cRAkpeOEEgRtKrBKuERedPpAN3brzFzc1helLG/UNgOogb
         YYr7oLBr4cvAc+cJWSPwT9BdlPaBA/EbZEpTU5OXJtULHYBHe8txpvlNWs8g1/dG0H2m
         Lo+pdNvA6beu3KdUR7UeNwOab9P2K+hUJ6by8z4QbOZJriYG7u1OH4DZ4YKB9e79EMpH
         mDOg==
X-Gm-Message-State: AOAM532g8nwuzgKw7idjXy4Lg2NUIALLRAdBLKazQxXb+ZZOFOiORWgl
        ueg8FDotNipJf6BXGhhERMFnecbeLarG/f9BOZI=
X-Google-Smtp-Source: ABdhPJyUCzf0Jw34sPoclAc+G2/auzB8lw6ApL3+G15+QvN/hVsQWa6TwdvBWnEUNo2w+LtfpGsHhA==
X-Received: by 2002:a17:90a:5e0c:b0:1ea:91d4:5a90 with SMTP id w12-20020a17090a5e0c00b001ea91d45a90mr12242364pjf.134.1655108771798;
        Mon, 13 Jun 2022 01:26:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4-20020a170902780400b001640ab19773sm4441547pll.58.2022.06.13.01.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 01:26:11 -0700 (PDT)
Message-ID: <62a6f4a3.1c69fb81.bff38.5791@mx.google.com>
Date:   Mon, 13 Jun 2022 01:26:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.45-889-g4600c62eaa695
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 build: 175 builds: 4 failed, 171 passed,
 14 errors, 313 warnings (v5.15.45-889-g4600c62eaa695)
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

stable-rc/queue/5.15 build: 175 builds: 4 failed, 171 passed, 14 errors, 31=
3 warnings (v5.15.45-889-g4600c62eaa695)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.45-889-g4600c62eaa695/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.45-889-g4600c62eaa695
Git Commit: 4600c62eaa6953f94bb36da266699a6e73d0fb26
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

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
    tinyconfig (gcc-10): 3 warnings
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
    cm_x300_defconfig (gcc-10): 2 warnings
    colibri_pxa270_defconfig (gcc-10): 2 warnings
    colibri_pxa300_defconfig (gcc-10): 2 warnings
    collie_defconfig (gcc-10): 2 warnings
    corgi_defconfig (gcc-10): 2 warnings
    davinci_all_defconfig (gcc-10): 2 warnings
    dove_defconfig (gcc-10): 2 warnings
    ep93xx_defconfig (gcc-10): 2 warnings
    eseries_pxa_defconfig (gcc-10): 2 warnings
    exynos_defconfig (gcc-10): 2 warnings
    ezx_defconfig (gcc-10): 2 warnings
    footbridge_defconfig (gcc-10): 2 warnings
    gemini_defconfig (gcc-10): 2 warnings
    h3600_defconfig (gcc-10): 2 warnings
    h5000_defconfig (gcc-10): 2 warnings
    hackkit_defconfig (gcc-10): 2 warnings
    hisi_defconfig (gcc-10): 2 warnings
    imote2_defconfig (gcc-10): 2 warnings
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
    nhk8815_defconfig (gcc-10): 2 warnings
    omap1_defconfig (gcc-10): 2 warnings
    omap2plus_defconfig (gcc-10): 2 warnings
    orion5x_defconfig (gcc-10): 2 warnings
    oxnas_v6_defconfig (gcc-10): 2 warnings
    palmz72_defconfig (gcc-10): 2 warnings
    pcm027_defconfig (gcc-10): 2 warnings
    pleb_defconfig (gcc-10): 2 warnings
    pxa168_defconfig (gcc-10): 2 warnings
    pxa3xx_defconfig (gcc-10): 2 warnings
    pxa910_defconfig (gcc-10): 2 warnings
    pxa_defconfig (gcc-10): 2 warnings
    qcom_defconfig (gcc-10): 2 warnings
    realview_defconfig (gcc-10): 2 warnings
    rpc_defconfig (gcc-10): 4 errors
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
    trizeps4_defconfig (gcc-10): 2 warnings
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
    i386_defconfig (gcc-10): 2 warnings
    tinyconfig (gcc-10): 2 warnings

mips:
    32r2el_defconfig (gcc-10): 3 warnings
    ar7_defconfig (gcc-10): 2 warnings
    ath25_defconfig (gcc-10): 2 warnings
    ath79_defconfig (gcc-10): 2 warnings
    bcm47xx_defconfig (gcc-10): 2 warnings
    bigsur_defconfig (gcc-10): 1 error
    bmips_be_defconfig (gcc-10): 2 warnings
    bmips_stb_defconfig (gcc-10): 2 warnings
    capcella_defconfig (gcc-10): 2 warnings
    cavium_octeon_defconfig (gcc-10): 1 error
    ci20_defconfig (gcc-10): 2 warnings
    cobalt_defconfig (gcc-10): 2 warnings
    cu1000-neo_defconfig (gcc-10): 2 warnings
    cu1830-neo_defconfig (gcc-10): 2 warnings
    db1xxx_defconfig (gcc-10): 2 warnings
    decstation_64_defconfig (gcc-10): 1 error
    decstation_defconfig (gcc-10): 2 warnings
    decstation_r4k_defconfig (gcc-10): 2 warnings
    e55_defconfig (gcc-10): 2 warnings
    fuloong2e_defconfig (gcc-10): 1 error
    gcw0_defconfig (gcc-10): 2 warnings
    gpr_defconfig (gcc-10): 2 warnings
    ip22_defconfig (gcc-10): 2 warnings
    ip32_defconfig (gcc-10): 1 error
    jazz_defconfig (gcc-10): 2 warnings
    jmr3927_defconfig (gcc-10): 2 warnings
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson1b_defconfig (gcc-10): 2 warnings
    loongson1c_defconfig (gcc-10): 2 warnings
    loongson2k_defconfig (gcc-10): 1 error, 1 warning
    loongson3_defconfig (gcc-10): 1 error
    malta_defconfig (gcc-10): 2 warnings
    malta_kvm_defconfig (gcc-10): 2 warnings
    malta_qemu_32r6_defconfig (gcc-10): 2 warnings
    maltaaprp_defconfig (gcc-10): 2 warnings
    maltasmvp_defconfig (gcc-10): 2 warnings
    maltasmvp_eva_defconfig (gcc-10): 2 warnings
    maltaup_defconfig (gcc-10): 2 warnings
    maltaup_xpa_defconfig (gcc-10): 2 warnings
    mpc30x_defconfig (gcc-10): 2 warnings
    mtx1_defconfig (gcc-10): 2 warnings
    nlm_xlp_defconfig (gcc-10): 1 error
    nlm_xlr_defconfig (gcc-10): 2 warnings
    omega2p_defconfig (gcc-10): 2 warnings
    pic32mzda_defconfig (gcc-10): 2 warnings
    qi_lb60_defconfig (gcc-10): 2 warnings
    rb532_defconfig (gcc-10): 2 warnings
    rbtx49xx_defconfig (gcc-10): 2 warnings
    rm200_defconfig (gcc-10): 3 warnings
    rs90_defconfig (gcc-10): 2 warnings
    sb1250_swarm_defconfig (gcc-10): 1 error
    tb0219_defconfig (gcc-10): 2 warnings
    tb0226_defconfig (gcc-10): 2 warnings
    tb0287_defconfig (gcc-10): 2 warnings
    vocore2_defconfig (gcc-10): 2 warnings
    workpad_defconfig (gcc-10): 2 warnings

riscv:
    rv32_defconfig (gcc-10): 2 warnings

x86_64:

Errors summary:

    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    308  include/linux/minmax.h:20:28: warning: comparison of distinct poin=
ter types lacks a cast
    2    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes =
is larger than 1024 bytes [-Wframe-larger-than=3D]
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
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

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
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
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
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
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
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnin=
gs, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings=
, 0 section mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
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
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

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
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, =
0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

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
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section mi=
smatches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''
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
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast
    include/linux/minmax.h:20:28: warning: comparison of distinct pointer t=
ypes lacks a cast

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
