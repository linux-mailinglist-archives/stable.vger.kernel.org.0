Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27C732AEBC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbhCCAEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbhCBDml (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 22:42:41 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623A7C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 19:42:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id i4-20020a17090a7184b02900bfb60fbc6bso561444pjk.0
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 19:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0IIJjfSFqa1VygemenQgAl+7qsy8ie8kBySPVFzFlj4=;
        b=Ms7sXjMEGhxHU3udh4mUiyKW3JzH3KvCb4eDNPWWKyohHR7pQRgfxQ13cDK7jw1Qrl
         t1e2C984b7Hb3MKZrjsTVPZr7dKFDFxJFek8sIwQk4YtFCXV9v9ASEsiUa09s6EBPNSu
         SEjZfB4u8/lI1VnCtJd8xXd8J7oKQ12ME3gJiF57MmuVC/fORv3HLOjKDtBJSHKqBHWo
         PUDE0+CCoTfGRNt6uezOIY2E0/QJZJGiFuxeXWdnYBdHvwZKs23/TTEAUYbVgaN2ixJG
         BxmBJ8REn6ChfzNsr2ZX96ufgnI2QYq952gJZ7cypBWRhdToZmiRuD97by3KPwj8sel0
         Ty5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0IIJjfSFqa1VygemenQgAl+7qsy8ie8kBySPVFzFlj4=;
        b=b+igSG3Xpp7HvnZvdC2YfhOmGgeG4Ep4G1z4SkDwe/+rdAVV7L4GFey+P/jmL1iRSM
         x+nbkUTO0W2+jLVBjHLMGmevS84ilFyMz26l82hX6jWQGPpUrwExVW2SpQdVgE4JwsmI
         hy574tbQ0/FwRGi7kk9smM1rnq2EIyd4oKHEcLbTNledu/qFwkIfog7IjkRPCNJDCZCA
         nxRS+C1Yg3hiKD5K9niv9M0A4ofd2Bv+THB5A8MKMg06v366NMg9PRjcreIOzmOtl6lO
         Aif7bp5nU6zkOoeTs/7MJG0s3qw07g9NCsJsLUFLsksWDEaYWPaxf0sh7fdX80CwmxiA
         R23w==
X-Gm-Message-State: AOAM530Xvfa0ojYWc1aG5JvvKmJyhEbCkbKL86LoKr6hR20N1yor1CBB
        Vx5UzolQXt5F1FRFRS7237DUcVLYtThMNg==
X-Google-Smtp-Source: ABdhPJyOyY+3koWOy09IegGceEvxy0JtDVijXLZOaCX3+ArYCiCsTsQ+gi3yJeCUrvawEqY6YmekIQ==
X-Received: by 2002:a17:902:8687:b029:e1:601e:bd29 with SMTP id g7-20020a1709028687b02900e1601ebd29mr18547731plo.47.1614656518097;
        Mon, 01 Mar 2021 19:41:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm19536478pfi.15.2021.03.01.19.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 19:41:57 -0800 (PST)
Message-ID: <603db405.1c69fb81.35f39.ed0e@mx.google.com>
Date:   Mon, 01 Mar 2021 19:41:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-247-g0e2d946bd3c89
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y build: 206 builds: 130 failed, 76 passed,
 142 errors, 179 warnings (v4.19.177-247-g0e2d946bd3c89)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 206 builds: 130 failed, 76 passed, 142 errors=
, 179 warnings (v4.19.177-247-g0e2d946bd3c89)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.177-247-g0e2d946bd3c89/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.177-247-g0e2d946bd3c89
Git Commit: 0e2d946bd3c89bee5a98375b218dcf9c2d3d5f50
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
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
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
    ks8695_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc18xx_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
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
    nuc910_defconfig: (gcc-8) FAIL
    nuc950_defconfig: (gcc-8) FAIL
    nuc960_defconfig: (gcc-8) FAIL
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
    allnoconfig (gcc-8): 1 error, 1 warning
    axs103_defconfig (gcc-8): 1 error, 1 warning
    axs103_smp_defconfig (gcc-8): 1 error, 1 warning
    haps_hs_defconfig (gcc-8): 1 error, 1 warning
    haps_hs_smp_defconfig (gcc-8): 1 error, 1 warning
    hsdk_defconfig (gcc-8): 1 warning
    nsim_hs_defconfig (gcc-8): 1 error, 1 warning
    nsim_hs_smp_defconfig (gcc-8): 1 error, 1 warning
    nsimosci_hs_defconfig (gcc-8): 1 error, 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    vdk_hs38_defconfig (gcc-8): 1 error, 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 2 errors, 2 warnings

arm64:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

arm:
    acs5k_defconfig (gcc-8): 1 error, 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 error, 1 warning
    allnoconfig (gcc-8): 1 error, 1 warning
    am200epdkit_defconfig (gcc-8): 1 error, 1 warning
    assabet_defconfig (gcc-8): 1 error, 1 warning
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
    corgi_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 error, 1 warning
    efm32_defconfig (gcc-8): 1 error, 1 warning
    em_x270_defconfig (gcc-8): 1 error, 1 warning
    eseries_pxa_defconfig (gcc-8): 1 error, 1 warning
    footbridge_defconfig (gcc-8): 1 error, 1 warning
    h3600_defconfig (gcc-8): 1 error, 1 warning
    h5000_defconfig (gcc-8): 1 error, 1 warning
    hackkit_defconfig (gcc-8): 1 error, 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 error, 1 warning
    integrator_defconfig (gcc-8): 1 error, 1 warning
    ixp4xx_defconfig (gcc-8): 1 error, 1 warning
    jornada720_defconfig (gcc-8): 1 error, 1 warning
    ks8695_defconfig (gcc-8): 1 error, 1 warning
    lart_defconfig (gcc-8): 1 error, 1 warning
    lpc18xx_defconfig (gcc-8): 1 error, 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 error, 1 warning
    magician_defconfig (gcc-8): 1 error, 1 warning
    mainstone_defconfig (gcc-8): 1 error, 1 warning
    mini2440_defconfig (gcc-8): 1 error, 1 warning
    mmp2_defconfig (gcc-8): 1 error, 1 warning
    moxart_defconfig (gcc-8): 1 error, 1 warning
    mps2_defconfig (gcc-8): 1 error, 1 warning
    multi_v4t_defconfig (gcc-8): 1 error, 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v5_defconfig (gcc-8): 1 error, 1 warning
    mxs_defconfig (gcc-8): 1 error, 1 warning
    neponset_defconfig (gcc-8): 1 error, 1 warning
    netwinder_defconfig (gcc-8): 1 error, 1 warning
    nhk8815_defconfig (gcc-8): 1 error, 1 warning
    nuc910_defconfig (gcc-8): 1 error, 1 warning
    nuc950_defconfig (gcc-8): 1 error, 1 warning
    nuc960_defconfig (gcc-8): 1 error, 1 warning
    orion5x_defconfig (gcc-8): 1 error, 1 warning
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
    raumfeld_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 1 error, 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 error, 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 error, 1 warning
    simpad_defconfig (gcc-8): 1 error, 1 warning
    spear3xx_defconfig (gcc-8): 1 error, 1 warning
    spear6xx_defconfig (gcc-8): 1 error, 1 warning
    spitz_defconfig (gcc-8): 1 warning
    stm32_defconfig (gcc-8): 1 error, 1 warning
    sunxi_defconfig (gcc-8): 1 error, 1 warning
    tango4_defconfig (gcc-8): 1 error, 1 warning
    tct_hammer_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    trizeps4_defconfig (gcc-8): 1 error, 1 warning
    u300_defconfig (gcc-8): 1 error, 1 warning
    versatile_defconfig (gcc-8): 1 error, 1 warning
    vexpress_defconfig (gcc-8): 1 error, 1 warning
    vf610m4_defconfig (gcc-8): 1 error, 1 warning
    viper_defconfig (gcc-8): 1 error, 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 1 error, 1 warning
    zeus_defconfig (gcc-8): 1 error, 1 warning
    zx_defconfig (gcc-8): 1 error, 1 warning

i386:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

mips:
    allnoconfig (gcc-8): 1 error, 1 warning
    ar7_defconfig (gcc-8): 1 error, 1 warning
    ath25_defconfig (gcc-8): 1 error, 1 warning
    ath79_defconfig (gcc-8): 1 error, 1 warning
    bcm63xx_defconfig (gcc-8): 2 errors, 2 warnings
    capcella_defconfig (gcc-8): 2 errors, 2 warnings
    ci20_defconfig (gcc-8): 1 error, 1 warning
    cobalt_defconfig (gcc-8): 1 error, 1 warning
    db1xxx_defconfig (gcc-8): 1 warning
    e55_defconfig (gcc-8): 2 errors, 2 warnings
    fuloong2e_defconfig (gcc-8): 2 errors, 2 warnings
    gcw0_defconfig (gcc-8): 1 warning
    gpr_defconfig (gcc-8): 2 errors, 2 warnings
    ip28_defconfig (gcc-8): 2 errors, 2 warnings
    jmr3927_defconfig (gcc-8): 2 errors, 2 warnings
    lasat_defconfig (gcc-8): 1 error, 1 warning
    lemote2f_defconfig (gcc-8): 1 warning
    loongson1b_defconfig (gcc-8): 2 errors, 2 warnings
    loongson1c_defconfig (gcc-8): 1 error, 1 warning
    loongson3_defconfig (gcc-8): 2 warnings
    malta_defconfig (gcc-8): 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 2 warnings
    maltaaprp_defconfig (gcc-8): 1 warning
    maltasmvp_defconfig (gcc-8): 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 warning
    maltaup_defconfig (gcc-8): 1 warning
    maltaup_xpa_defconfig (gcc-8): 1 warning
    mpc30x_defconfig (gcc-8): 1 error, 1 warning
    msp71xx_defconfig (gcc-8): 1 error, 1 warning
    nlm_xlp_defconfig (gcc-8): 1 warning
    omega2p_defconfig (gcc-8): 1 error, 1 warning
    pic32mzda_defconfig (gcc-8): 2 errors, 2 warnings
    pnx8335_stb225_defconfig (gcc-8): 1 error, 1 warning
    qi_lb60_defconfig (gcc-8): 2 errors, 2 warnings
    rb532_defconfig (gcc-8): 1 error, 1 warning
    rbtx49xx_defconfig (gcc-8): 1 error, 1 warning
    rt305x_defconfig (gcc-8): 1 error, 1 warning
    sb1250_swarm_defconfig (gcc-8): 2 errors, 2 warnings
    tb0219_defconfig (gcc-8): 1 error, 1 warning
    tb0226_defconfig (gcc-8): 1 error, 1 warning
    tb0287_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    vocore2_defconfig (gcc-8): 1 error, 1 warning
    workpad_defconfig (gcc-8): 1 error, 1 warning
    xway_defconfig (gcc-8): 1 error, 1 warning

riscv:
    allnoconfig (gcc-8): 1 error, 4 warnings
    defconfig (gcc-8): 4 warnings
    tinyconfig (gcc-8): 1 error, 4 warnings

x86_64:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 2 warnings

Errors summary:

    142  ./include/linux/icmpv6.h:70:2: error: implicit declaration of func=
tion =E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    139  cc1: some warnings being treated as errors
    21   drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 de=
fined but not used [-Wunused-variable]
    3    net/core/rtnetlink.c:3191:1: warning: the frame size of 1312 bytes=
 is larger than 1024 bytes [-Wframe-larger-than=3D]
    3    cc1: all warnings being treated as errors
    3    ./include/linux/of_clk.h:13:31: warning: =E2=80=98struct of_device=
_id=E2=80=99 declared inside parameter list will not be visible outside of =
this definition or declaration
    3    ./include/linux/of_clk.h:12:43: warning: =E2=80=98struct device_no=
de=E2=80=99 declared inside parameter list will not be visible outside of t=
his definition or declaration
    3    ./include/linux/of_clk.h:11:45: warning: =E2=80=98struct device_no=
de=E2=80=99 declared inside parameter list will not be visible outside of t=
his definition or declaration
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_propert=
y): /wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 =
or bad phandle (referred from clocks[0])
    1    .config:1010:warning: override: UNWINDER_GUESS changes choice state

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
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
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
allnoconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 4 warnings, 0 section m=
ismatches

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
allnoconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

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
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
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
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
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
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sec=
tion mismatches

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
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 se=
ction mismatches

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
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

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
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mi=
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
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

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
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 section=
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
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 section=
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
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

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
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sec=
tion mismatches

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
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/rtnetlink.c:3191:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 =
section mismatches

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
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    net/core/rtnetlink.c:3191:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

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
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

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
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warning=
s, 0 section mismatches

Warnings:
    {standard input}:131: Warning: macro instruction expanded into multiple=
 instructions
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_property): /=
wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 or ba=
d phandle (referred from clocks[0])

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
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/rtnetlink.c:3191:1: warning: the frame size of 1312 bytes is l=
arger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 s=
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
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 sec=
tion mismatches

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
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

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
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

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
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

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
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
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
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section misma=
tches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
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
tinyconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section m=
ismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    .config:1010:warning: override: UNWINDER_GUESS changes choice state
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
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0=
 section mismatches

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
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=E2=80=99 defined=
 but not used [-Wunused-variable]

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
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    ./include/linux/icmpv6.h:70:2: error: implicit declaration of function =
=E2=80=98__icmpv6_send=E2=80=99; did you mean =E2=80=98icmpv6_send=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]

Warnings:
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
