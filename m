Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C04532AEDF
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbhCCAGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377386AbhCBIed (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 03:34:33 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD98EC061756
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 00:33:48 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id i4-20020a17090a7184b02900bfb60fbc6bso914727pjk.0
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 00:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I7XuzHebk3YFhg0kphh19rp6DKsLHXiiDc4Ljn1ewvQ=;
        b=aI2W87w0Gv6L67wvjTEWey6Fw6fQ1exs2ecoC2WRUQBZ1j03oZ/LFgFGZUdqSSZMIR
         0ZrgQ618+00H/5z35cnCH8ImTTYNzQN+VY5YCFPADaXvawNzhtT6Aj6Q1TbAUM6GhKu0
         tHTFgw9GaxZROg0HzEZaOPwoawBZIqG6y3IQkKkoSVFmq1MAHfLsrV1BT/6stnDt+VTf
         p2a5mTiKxIS7vG43Y9wks2wymINgHgC+ceLaNIXHISxBI/2Nh27C1HOmm0GurnTYycK/
         xVQQUWsksNEekNCkS624esJrwfKB+3/QYa3Lii4VxRia74aujKVcv6HiYkr7pB1+1GPL
         j1kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I7XuzHebk3YFhg0kphh19rp6DKsLHXiiDc4Ljn1ewvQ=;
        b=HQAmoN6lqX46KkxeREI6WOJ8alEAW/xvL38uvNp2s9JdpSVCH3GBk3mteNW/Wi9riM
         xbgESZG8yh/n+cs16mSEiD1MK2aHOg/VdzSTOZbLSEDPl7yNOq6XAQeNC26coUzTDVSL
         es/JOGCbPv0N7r+T0qlqlj0+GqCF5D+yDc5nAkdGe1RNzxK7kA4vmU9uzNnJ0gLTU8d6
         nvZzjOpdB6mgdKEP26oez/3VDaLlC0POGD4qei5idiH4sgAqY6AlBOCqS4LVwoV8SFFB
         KBM50V6BOB4K+43KDdrJNmy6s1SGjilx6JK93HLnHLmmZjkKQZLVsbMUHHxCJgfAqCYo
         l62Q==
X-Gm-Message-State: AOAM530vlPGeu4oIv+foPKB8vnjk+VsRjlUJp5OwLXA+S9TN/wz2/A20
        p950Vq7kOYiXNulY5oGni5orNtOgi0qTDQ==
X-Google-Smtp-Source: ABdhPJwHxaiQ4kkyTbZWhQ48erheWGukXLPVdvK8UHkG1Zv+41I1l56nsPTneFZ+6FV1wTsYLXzrRg==
X-Received: by 2002:a17:90b:941:: with SMTP id dw1mr3362260pjb.35.1614674025674;
        Tue, 02 Mar 2021 00:33:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cp22sm2154745pjb.15.2021.03.02.00.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 00:33:45 -0800 (PST)
Message-ID: <603df869.1c69fb81.2d981.5317@mx.google.com>
Date:   Tue, 02 Mar 2021 00:33:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-339-g325244caeb991
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y build: 200 builds: 125 failed, 75 passed,
 136 errors, 204 warnings (v5.4.101-339-g325244caeb991)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y build: 200 builds: 125 failed, 75 passed, 136 errors,=
 204 warnings (v5.4.101-339-g325244caeb991)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.101-339-g325244caeb991/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.101-339-g325244caeb991
Git Commit: 325244caeb991825c73fdeaedc753104bde5799d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-8) FAIL
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
    haps_hs_defconfig: (gcc-8) FAIL
    haps_hs_smp_defconfig: (gcc-8) FAIL
    nsim_hs_defconfig: (gcc-8) FAIL
    nsim_hs_smp_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL

arm64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm:
    allnoconfig: (gcc-8) FAIL
    am200epdkit_defconfig: (gcc-8) FAIL
    assabet_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    cerfcube_defconfig: (gcc-8) FAIL
    clps711x_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    efm32_defconfig: (gcc-8) FAIL
    em_x270_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    footbridge_defconfig: (gcc-8) FAIL
    h3600_defconfig: (gcc-8) FAIL
    h5000_defconfig: (gcc-8) FAIL
    hackkit_defconfig: (gcc-8) FAIL
    imx_v4_v5_defconfig: (gcc-8) FAIL
    integrator_defconfig: (gcc-8) FAIL
    ixp4xx_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc18xx_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    milbeaut_m10v_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    mps2_defconfig: (gcc-8) FAIL
    multi_v4t_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    neponset_defconfig: (gcc-8) FAIL
    netwinder_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa910_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
    realview_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    stm32_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tango4_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    vf610m4_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    xcep_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

mips:
    allnoconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm63xx_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    ci20_defconfig: (gcc-8) FAIL
    cobalt_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
    lasat_defconfig: (gcc-8) FAIL
    loongson1b_defconfig: (gcc-8) FAIL
    loongson1c_defconfig: (gcc-8) FAIL
    mpc30x_defconfig: (gcc-8) FAIL
    msp71xx_defconfig: (gcc-8) FAIL
    omega2p_defconfig: (gcc-8) FAIL
    pic32mzda_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    vocore2_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

riscv:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

x86_64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 error, 2 warnings
    axs103_defconfig (gcc-8): 1 error, 2 warnings
    axs103_smp_defconfig (gcc-8): 1 error, 2 warnings
    haps_hs_defconfig (gcc-8): 1 error, 2 warnings
    haps_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    hsdk_defconfig (gcc-8): 2 warnings
    nsim_hs_defconfig (gcc-8): 1 error, 2 warnings
    nsim_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    nsimosci_hs_defconfig (gcc-8): 2 errors, 3 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    tinyconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_defconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_smp_defconfig (gcc-8): 1 error, 2 warnings

arm64:
    allnoconfig (gcc-8): 2 errors, 2 warnings
    defconfig (gcc-8): 14 warnings
    tinyconfig (gcc-8): 1 error, 1 warning

arm:
    allnoconfig (gcc-8): 1 error, 1 warning
    am200epdkit_defconfig (gcc-8): 1 error, 1 warning
    assabet_defconfig (gcc-8): 1 error, 1 warning
    at91_dt_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 error, 1 warning
    badge4_defconfig (gcc-8): 1 error, 1 warning
    cerfcube_defconfig (gcc-8): 1 error, 1 warning
    clps711x_defconfig (gcc-8): 1 error, 1 warning
    cm_x2xx_defconfig (gcc-8): 1 error, 1 warning
    cm_x300_defconfig (gcc-8): 1 error, 1 warning
    cns3420vb_defconfig (gcc-8): 1 error, 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 error, 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    collie_defconfig (gcc-8): 1 error, 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 error, 1 warning
    efm32_defconfig (gcc-8): 1 error, 1 warning
    em_x270_defconfig (gcc-8): 1 error, 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 error, 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    footbridge_defconfig (gcc-8): 1 error, 1 warning
    h3600_defconfig (gcc-8): 1 error, 1 warning
    h5000_defconfig (gcc-8): 1 error, 1 warning
    hackkit_defconfig (gcc-8): 1 error, 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 error, 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 error, 1 warning
    ixp4xx_defconfig (gcc-8): 1 error, 1 warning
    jornada720_defconfig (gcc-8): 1 error, 1 warning
    keystone_defconfig (gcc-8): 1 warning
    lart_defconfig (gcc-8): 1 error, 1 warning
    lpc18xx_defconfig (gcc-8): 1 error, 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 error, 1 warning
    magician_defconfig (gcc-8): 1 error, 1 warning
    mainstone_defconfig (gcc-8): 1 error, 1 warning
    milbeaut_m10v_defconfig (gcc-8): 1 error, 1 warning
    mini2440_defconfig (gcc-8): 1 error, 1 warning
    mmp2_defconfig (gcc-8): 1 error, 1 warning
    moxart_defconfig (gcc-8): 1 error, 1 warning
    mps2_defconfig (gcc-8): 1 error, 1 warning
    multi_v4t_defconfig (gcc-8): 1 error, 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v5_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 error, 1 warning
    neponset_defconfig (gcc-8): 1 error, 1 warning
    netwinder_defconfig (gcc-8): 1 error, 1 warning
    nhk8815_defconfig (gcc-8): 1 error, 1 warning
    omap1_defconfig (gcc-8): 1 warning
    omap2plus_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 error, 1 warning
    oxnas_v6_defconfig (gcc-8): 1 warning
    palmz72_defconfig (gcc-8): 1 error, 1 warning
    pcm027_defconfig (gcc-8): 1 error, 1 warning
    pleb_defconfig (gcc-8): 1 error, 1 warning
    prima2_defconfig (gcc-8): 1 error, 1 warning
    pxa168_defconfig (gcc-8): 1 error, 1 warning
    pxa255-idp_defconfig (gcc-8): 1 error, 1 warning
    pxa3xx_defconfig (gcc-8): 1 error, 1 warning
    pxa910_defconfig (gcc-8): 1 error, 1 warning
    pxa_defconfig (gcc-8): 1 error, 1 warning
    qcom_defconfig (gcc-8): 1 error, 1 warning
    realview_defconfig (gcc-8): 1 error, 1 warning
    s3c6400_defconfig (gcc-8): 1 error, 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 error, 1 warning
    simpad_defconfig (gcc-8): 1 error, 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    spear3xx_defconfig (gcc-8): 1 error, 1 warning
    spear6xx_defconfig (gcc-8): 1 error, 1 warning
    stm32_defconfig (gcc-8): 1 error, 1 warning
    sunxi_defconfig (gcc-8): 1 error, 1 warning
    tango4_defconfig (gcc-8): 1 error, 1 warning
    tct_hammer_defconfig (gcc-8): 1 error, 1 warning
    tegra_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    trizeps4_defconfig (gcc-8): 1 error, 1 warning
    u300_defconfig (gcc-8): 1 error, 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 error, 1 warning
    vexpress_defconfig (gcc-8): 1 error, 1 warning
    vf610m4_defconfig (gcc-8): 1 error, 1 warning
    viper_defconfig (gcc-8): 1 error, 1 warning
    xcep_defconfig (gcc-8): 1 error, 1 warning
    zeus_defconfig (gcc-8): 1 error, 1 warning
    zx_defconfig (gcc-8): 1 error, 1 warning

i386:
    allnoconfig (gcc-8): 2 errors, 2 warnings
    tinyconfig (gcc-8): 1 error, 1 warning

mips:
    allnoconfig (gcc-8): 1 error, 1 warning
    ar7_defconfig (gcc-8): 1 error, 1 warning
    ath25_defconfig (gcc-8): 2 errors, 2 warnings
    ath79_defconfig (gcc-8): 2 errors, 2 warnings
    bcm63xx_defconfig (gcc-8): 1 error, 1 warning
    capcella_defconfig (gcc-8): 1 error, 1 warning
    ci20_defconfig (gcc-8): 1 error, 1 warning
    cobalt_defconfig (gcc-8): 1 error, 1 warning
    e55_defconfig (gcc-8): 1 error, 1 warning
    fuloong2e_defconfig (gcc-8): 2 errors, 2 warnings
    gpr_defconfig (gcc-8): 1 error, 1 warning
    ip28_defconfig (gcc-8): 2 errors, 2 warnings
    jmr3927_defconfig (gcc-8): 1 error, 1 warning
    lasat_defconfig (gcc-8): 1 error, 1 warning
    loongson1b_defconfig (gcc-8): 1 error, 1 warning
    loongson1c_defconfig (gcc-8): 1 error, 1 warning
    mpc30x_defconfig (gcc-8): 1 error, 1 warning
    msp71xx_defconfig (gcc-8): 1 error, 1 warning
    omega2p_defconfig (gcc-8): 1 error, 1 warning
    pic32mzda_defconfig (gcc-8): 1 error, 1 warning
    pnx8335_stb225_defconfig (gcc-8): 1 error, 1 warning
    qi_lb60_defconfig (gcc-8): 1 error, 1 warning
    rb532_defconfig (gcc-8): 1 error, 1 warning
    rbtx49xx_defconfig (gcc-8): 1 error, 1 warning
    rt305x_defconfig (gcc-8): 1 error, 1 warning
    sb1250_swarm_defconfig (gcc-8): 2 errors, 2 warnings
    tb0219_defconfig (gcc-8): 1 error, 1 warning
    tb0226_defconfig (gcc-8): 2 errors, 2 warnings
    tb0287_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    vocore2_defconfig (gcc-8): 1 error, 1 warning
    workpad_defconfig (gcc-8): 1 error, 1 warning
    xway_defconfig (gcc-8): 2 errors, 2 warnings

riscv:
    allnoconfig (gcc-8): 2 errors, 5 warnings
    defconfig (gcc-8): 3 warnings
    rv32_defconfig (gcc-8): 9 warnings
    tinyconfig (gcc-8): 1 error, 4 warnings

x86_64:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 2 warnings

Errors summary:

    136  ./include/linux/icmpv6.h:70:2: error: implicit declaration of func=
tion =E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    133  cc1: some warnings being treated as errors
    21   WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL
    16   <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    4    ./include/linux/of_clk.h:13:31: warning: =E2=80=98struct of_device=
_id=E2=80=99 declared inside parameter list will not be visible outside of =
this definition or declaration
    4    ./include/linux/of_clk.h:12:43: warning: =E2=80=98struct device_no=
de=E2=80=99 declared inside parameter list will not be visible outside of t=
his definition or declaration
    4    ./include/linux/of_clk.h:11:45: warning: =E2=80=98struct device_no=
de=E2=80=99 declared inside parameter list will not be visible outside of t=
his definition or declaration
    3    cc1: all warnings being treated as errors
    2    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_=
format): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address=
-cells =3D=3D 2, #size-cells =3D=3D 2)
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    2    ./arch/arm64/include/asm/memory.h:238:15: warning: cast from point=
er to integer of different size [-Wpointer-to-int-cast]
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
    1    .config:1156:warning: override: UNWINDER_GUESS changes choice state

Section mismatches summary:

    1    WARNING: vmlinux.o(.text.unlikely+0x3484): Section mismatch in ref=
erence from the function pmax_setup_memory_region() to the function .init.t=
ext:add_memory_region()
    1    WARNING: vmlinux.o(.text.unlikely+0x3110): Section mismatch in ref=
erence from the function pmax_setup_memory_region() to the function .init.t=
ext:add_memory_region()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 FAIL, 2 errors, 5 warnings, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    ./include/linux/of_clk.h:11:45: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:12:43: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:13:31: warning: =E2=80=98struct of_device_id=
=E2=80=99 declared inside parameter list will not be visible outside of thi=
s definition or declaration
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x3484): Section mismatch in referenc=
e from the function pmax_setup_memory_region() to the function .init.text:a=
dd_memory_region()

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x3110): Section mismatch in referenc=
e from the function pmax_setup_memory_region() to the function .init.text:a=
dd_memory_region()

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section mi=
smatches

Warnings:
    ./include/linux/of_clk.h:11:45: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:12:43: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:13:31: warning: =E2=80=98struct of_device_id=
=E2=80=99 declared inside parameter list will not be visible outside of thi=
s definition or declaration

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 14 warnings, 0 section m=
ismatches

Warnings:
    ./arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to=
 integer of different size [-Wpointer-to-int-cast]
    ./arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to=
 integer of different size [-Wpointer-to-int-cast]
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
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 s=
ection mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 3 warnings, 0 =
section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings,=
 0 section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 9 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    ./include/linux/of_clk.h:11:45: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:12:43: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:13:31: warning: =E2=80=98struct of_device_id=
=E2=80=99 declared inside parameter list will not be visible outside of thi=
s definition or declaration
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, =
0 section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 4 warnings, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    ./include/linux/of_clk.h:11:45: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:12:43: warning: =E2=80=98struct device_node=E2=
=80=99 declared inside parameter list will not be visible outside of this d=
efinition or declaration
    ./include/linux/of_clk.h:13:31: warning: =E2=80=98struct of_device_id=
=E2=80=99 declared inside parameter list will not be visible outside of thi=
s definition or declaration

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    .config:1156:warning: override: UNWINDER_GUESS changes choice state
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section misma=
tches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 =
section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
