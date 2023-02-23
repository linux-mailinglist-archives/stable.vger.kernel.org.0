Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3EE6A0B60
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjBWN71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjBWN70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:59:26 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3642D176
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:59:21 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z2so13092417plf.12
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=b4HdSsvUayG9x0xG2yFWYeNArltUyPiaXralKvUSO6Q=;
        b=ARZas7cIvQrsQr8yaecRyxtG/E+k+YCG6rDpzcSHRxc5ILjf13eDeGNTl9aWkP1Lt0
         fXmV0zaaylm2Oi7OyV7O2QuehuQp2K1Tnm6hdKjkIcy349gM1PrT7RCslnTFlSF4VVBM
         IorPXCGk5eT4PJRQQ3SH4fu+GZgOPTHH8L6yF1BNnn2PkLvkzEQ+Z9uBOrszmeVxsGUh
         XxwHFHT2AbDPT0zbnbgyhKUmna5n5fysEEJCzDmNNdArNFqso8UgtTmcbmSBqXZK7hyv
         JS31UqN8mZdP7l8tfBT5NKMigmAGlUf8VE1npkh3SF3yVji+REBmDaNmr20CDXkdslPz
         EtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4HdSsvUayG9x0xG2yFWYeNArltUyPiaXralKvUSO6Q=;
        b=NbRdHDir7ajrMSVxDXKT7vdFAaAbrI5woFUxVT+7NkfshXZ5JE4QjqmC/m9ierqe3C
         +FaViyE3CufORIP8JuDl2Id7cvgR6/ire63wbP7kPNElsrIoA8C7smXsz8Jj/SCGYIi0
         B1zg5oUBGNkkdzBO8Ze0n2E/kMr6yRMU2259NVzU1xFAJ9XavWr0rTqHMW/WDUj8vBSp
         He4NaDGj76jBkl3w2Si7pm0Wm2IwSiGTOCXaqiAWbnwFn2gNy4Bh/0MFXPAaci1sLTNt
         Rf74L87NthrgcRTNU1tVrpugKv0cxbjYZIgPoEQr3vfh3zC52yWnPFsi27QebDBic9F0
         OGjw==
X-Gm-Message-State: AO0yUKUPkgz5D3X1qcmZtShHz3qS/7VOfpwbd+Zhw/tTj3Pp3aMefUWL
        KoVZPcZaRBDZpG+m2Px3tEO74A/tY458UIv8bOHjbA==
X-Google-Smtp-Source: AK7set/Lzd1CJJ5hYfIZI5gltWmkTck0/goLuO9IhCOs8HKxKVlB+joJSE8s6x5EXLVPeZMAE1R14A==
X-Received: by 2002:a05:6a21:78a4:b0:c7:40f8:73d3 with SMTP id bf36-20020a056a2178a400b000c740f873d3mr14395745pzc.33.1677160759550;
        Thu, 23 Feb 2023 05:59:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x15-20020a62fb0f000000b005d3fdf7515esm3520186pfm.81.2023.02.23.05.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 05:59:19 -0800 (PST)
Message-ID: <63f77137.620a0220.84ec1.6c4c@mx.google.com>
Date:   Thu, 23 Feb 2023 05:59:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.13-46-g0e1d6482dfa3
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/6.1 build: 173 builds: 155 failed, 18 passed,
 155 errors, 172 warnings (v6.1.13-46-g0e1d6482dfa3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 build: 173 builds: 155 failed, 18 passed, 155 errors, 1=
72 warnings (v6.1.13-46-g0e1d6482dfa3)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F6.1=
/kernel/v6.1.13-46-g0e1d6482dfa3/

Tree: stable-rc
Branch: queue/6.1
Git Describe: v6.1.13-46-g0e1d6482dfa3
Git Commit: 0e1d6482dfa39b647d685f572a437bb43eeb896b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    axs103_defconfig: (gcc-10) FAIL
    axs103_smp_defconfig: (gcc-10) FAIL
    haps_hs_defconfig: (gcc-10) FAIL
    haps_hs_smp_defconfig: (gcc-10) FAIL
    hsdk_defconfig: (gcc-10) FAIL
    nsimosci_hs_defconfig: (gcc-10) FAIL
    nsimosci_hs_smp_defconfig: (gcc-10) FAIL
    vdk_hs38_defconfig: (gcc-10) FAIL
    vdk_hs38_smp_defconfig: (gcc-10) FAIL

arm64:
    defconfig: (gcc-10) FAIL
    defconfig+arm64-chromebook: (gcc-10) FAIL

arm:
    am200epdkit_defconfig: (gcc-10) FAIL
    aspeed_g4_defconfig: (gcc-10) FAIL
    aspeed_g5_defconfig: (gcc-10) FAIL
    assabet_defconfig: (gcc-10) FAIL
    at91_dt_defconfig: (gcc-10) FAIL
    axm55xx_defconfig: (gcc-10) FAIL
    badge4_defconfig: (gcc-10) FAIL
    bcm2835_defconfig: (gcc-10) FAIL
    cerfcube_defconfig: (gcc-10) FAIL
    clps711x_defconfig: (gcc-10) FAIL
    cm_x300_defconfig: (gcc-10) FAIL
    colibri_pxa270_defconfig: (gcc-10) FAIL
    colibri_pxa300_defconfig: (gcc-10) FAIL
    collie_defconfig: (gcc-10) FAIL
    corgi_defconfig: (gcc-10) FAIL
    davinci_all_defconfig: (gcc-10) FAIL
    dove_defconfig: (gcc-10) FAIL
    ep93xx_defconfig: (gcc-10) FAIL
    eseries_pxa_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    ezx_defconfig: (gcc-10) FAIL
    footbridge_defconfig: (gcc-10) FAIL
    gemini_defconfig: (gcc-10) FAIL
    h3600_defconfig: (gcc-10) FAIL
    h5000_defconfig: (gcc-10) FAIL
    hackkit_defconfig: (gcc-10) FAIL
    hisi_defconfig: (gcc-10) FAIL
    imx_v4_v5_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    imxrt_defconfig: (gcc-10) FAIL
    integrator_defconfig: (gcc-10) FAIL
    iop32x_defconfig: (gcc-10) FAIL
    ixp4xx_defconfig: (gcc-10) FAIL
    jornada720_defconfig: (gcc-10) FAIL
    keystone_defconfig: (gcc-10) FAIL
    lart_defconfig: (gcc-10) FAIL
    lpc18xx_defconfig: (gcc-10) FAIL
    lpc32xx_defconfig: (gcc-10) FAIL
    lpd270_defconfig: (gcc-10) FAIL
    lubbock_defconfig: (gcc-10) FAIL
    magician_defconfig: (gcc-10) FAIL
    mainstone_defconfig: (gcc-10) FAIL
    mini2440_defconfig: (gcc-10) FAIL
    mmp2_defconfig: (gcc-10) FAIL
    moxart_defconfig: (gcc-10) FAIL
    mps2_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    multi_v7_defconfig: (gcc-10) FAIL
    mv78xx0_defconfig: (gcc-10) FAIL
    mvebu_v5_defconfig: (gcc-10) FAIL
    mvebu_v7_defconfig: (gcc-10) FAIL
    mxs_defconfig: (gcc-10) FAIL
    neponset_defconfig: (gcc-10) FAIL
    netwinder_defconfig: (gcc-10) FAIL
    nhk8815_defconfig: (gcc-10) FAIL
    omap1_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    orion5x_defconfig: (gcc-10) FAIL
    oxnas_v6_defconfig: (gcc-10) FAIL
    palmz72_defconfig: (gcc-10) FAIL
    pcm027_defconfig: (gcc-10) FAIL
    pleb_defconfig: (gcc-10) FAIL
    pxa168_defconfig: (gcc-10) FAIL
    pxa255-idp_defconfig: (gcc-10) FAIL
    pxa3xx_defconfig: (gcc-10) FAIL
    pxa910_defconfig: (gcc-10) FAIL
    pxa_defconfig: (gcc-10) FAIL
    qcom_defconfig: (gcc-10) FAIL
    realview_defconfig: (gcc-10) FAIL
    s3c2410_defconfig: (gcc-10) FAIL
    s5pv210_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    sama7_defconfig: (gcc-10) FAIL
    shannon_defconfig: (gcc-10) FAIL
    shmobile_defconfig: (gcc-10) FAIL
    simpad_defconfig: (gcc-10) FAIL
    socfpga_defconfig: (gcc-10) FAIL
    spear13xx_defconfig: (gcc-10) FAIL
    spear3xx_defconfig: (gcc-10) FAIL
    spear6xx_defconfig: (gcc-10) FAIL
    spitz_defconfig: (gcc-10) FAIL
    sunxi_defconfig: (gcc-10) FAIL
    tct_hammer_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    trizeps4_defconfig: (gcc-10) FAIL
    u8500_defconfig: (gcc-10) FAIL
    versatile_defconfig: (gcc-10) FAIL
    vexpress_defconfig: (gcc-10) FAIL
    viper_defconfig: (gcc-10) FAIL
    vt8500_v6_v7_defconfig: (gcc-10) FAIL
    xcep_defconfig: (gcc-10) FAIL
    zeus_defconfig: (gcc-10) FAIL

mips:
    32r2el_defconfig: (gcc-10) FAIL
    ar7_defconfig: (gcc-10) FAIL
    ath25_defconfig: (gcc-10) FAIL
    ath79_defconfig: (gcc-10) FAIL
    bcm47xx_defconfig: (gcc-10) FAIL
    bcm63xx_defconfig: (gcc-10) FAIL
    bigsur_defconfig: (gcc-10) FAIL
    bmips_be_defconfig: (gcc-10) FAIL
    bmips_stb_defconfig: (gcc-10) FAIL
    cavium_octeon_defconfig: (gcc-10) FAIL
    ci20_defconfig: (gcc-10) FAIL
    cobalt_defconfig: (gcc-10) FAIL
    cu1000-neo_defconfig: (gcc-10) FAIL
    cu1830-neo_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    decstation_64_defconfig: (gcc-10) FAIL
    decstation_defconfig: (gcc-10) FAIL
    decstation_r4k_defconfig: (gcc-10) FAIL
    fuloong2e_defconfig: (gcc-10) FAIL
    gcw0_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip22_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    ip32_defconfig: (gcc-10) FAIL
    jazz_defconfig: (gcc-10) FAIL
    lemote2f_defconfig: (gcc-10) FAIL
    loongson1b_defconfig: (gcc-10) FAIL
    loongson1c_defconfig: (gcc-10) FAIL
    loongson2k_defconfig: (gcc-10) FAIL
    loongson3_defconfig: (gcc-10) FAIL
    malta_defconfig: (gcc-10) FAIL
    malta_kvm_defconfig: (gcc-10) FAIL
    malta_qemu_32r6_defconfig: (gcc-10) FAIL
    maltaaprp_defconfig: (gcc-10) FAIL
    maltasmvp_defconfig: (gcc-10) FAIL
    maltasmvp_eva_defconfig: (gcc-10) FAIL
    maltaup_defconfig: (gcc-10) FAIL
    maltaup_xpa_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL
    omega2p_defconfig: (gcc-10) FAIL
    qi_lb60_defconfig: (gcc-10) FAIL
    rb532_defconfig: (gcc-10) FAIL
    rbtx49xx_defconfig: (gcc-10) FAIL
    rm200_defconfig: (gcc-10) FAIL
    rs90_defconfig: (gcc-10) FAIL
    rt305x_defconfig: (gcc-10) FAIL
    sb1250_swarm_defconfig: (gcc-10) FAIL
    vocore2_defconfig: (gcc-10) FAIL
    xway_defconfig: (gcc-10) FAIL

riscv:
    defconfig: (gcc-10) FAIL
    rv32_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-10): 1 error, 1 warning
    axs103_smp_defconfig (gcc-10): 1 error, 1 warning
    haps_hs_defconfig (gcc-10): 1 error, 1 warning
    haps_hs_smp_defconfig (gcc-10): 1 error, 1 warning
    hsdk_defconfig (gcc-10): 1 error, 1 warning
    nsimosci_hs_defconfig (gcc-10): 1 error, 1 warning
    nsimosci_hs_smp_defconfig (gcc-10): 1 error, 1 warning
    vdk_hs38_defconfig (gcc-10): 1 error, 1 warning
    vdk_hs38_smp_defconfig (gcc-10): 1 error, 1 warning

arm64:
    defconfig (gcc-10): 1 error, 1 warning
    defconfig+arm64-chromebook (gcc-10): 1 error, 1 warning

arm:
    am200epdkit_defconfig (gcc-10): 1 error, 1 warning
    aspeed_g4_defconfig (gcc-10): 1 error, 1 warning
    aspeed_g5_defconfig (gcc-10): 1 error, 1 warning
    assabet_defconfig (gcc-10): 1 error, 1 warning
    at91_dt_defconfig (gcc-10): 1 error, 1 warning
    axm55xx_defconfig (gcc-10): 1 error, 1 warning
    badge4_defconfig (gcc-10): 1 error, 1 warning
    bcm2835_defconfig (gcc-10): 1 error, 1 warning
    cerfcube_defconfig (gcc-10): 1 error, 1 warning
    clps711x_defconfig (gcc-10): 1 error, 1 warning
    cm_x300_defconfig (gcc-10): 1 error, 1 warning
    colibri_pxa270_defconfig (gcc-10): 1 error, 1 warning
    colibri_pxa300_defconfig (gcc-10): 1 error, 1 warning
    collie_defconfig (gcc-10): 1 error, 1 warning
    corgi_defconfig (gcc-10): 1 error, 1 warning
    davinci_all_defconfig (gcc-10): 1 error, 1 warning
    dove_defconfig (gcc-10): 1 error, 1 warning
    ep93xx_defconfig (gcc-10): 1 error, 1 warning
    eseries_pxa_defconfig (gcc-10): 1 error, 1 warning
    exynos_defconfig (gcc-10): 1 error, 1 warning
    ezx_defconfig (gcc-10): 1 error, 1 warning
    footbridge_defconfig (gcc-10): 1 error, 1 warning
    gemini_defconfig (gcc-10): 1 error, 1 warning
    h3600_defconfig (gcc-10): 1 error, 1 warning
    h5000_defconfig (gcc-10): 1 error, 1 warning
    hackkit_defconfig (gcc-10): 1 error, 1 warning
    hisi_defconfig (gcc-10): 1 error, 1 warning
    imx_v4_v5_defconfig (gcc-10): 1 error, 1 warning
    imx_v6_v7_defconfig (gcc-10): 1 error, 1 warning
    imxrt_defconfig (gcc-10): 1 error, 1 warning
    integrator_defconfig (gcc-10): 1 error, 1 warning
    iop32x_defconfig (gcc-10): 1 error, 1 warning
    ixp4xx_defconfig (gcc-10): 1 error, 1 warning
    jornada720_defconfig (gcc-10): 1 error, 1 warning
    keystone_defconfig (gcc-10): 1 error, 1 warning
    lart_defconfig (gcc-10): 1 error, 1 warning
    lpc18xx_defconfig (gcc-10): 1 error, 1 warning
    lpc32xx_defconfig (gcc-10): 1 error, 1 warning
    lpd270_defconfig (gcc-10): 1 error, 1 warning
    lubbock_defconfig (gcc-10): 1 error, 1 warning
    magician_defconfig (gcc-10): 1 error, 1 warning
    mainstone_defconfig (gcc-10): 1 error, 1 warning
    mini2440_defconfig (gcc-10): 1 error, 1 warning
    mmp2_defconfig (gcc-10): 1 error, 1 warning
    moxart_defconfig (gcc-10): 1 error, 1 warning
    mps2_defconfig (gcc-10): 1 error, 1 warning
    multi_v5_defconfig (gcc-10): 1 error, 1 warning
    multi_v7_defconfig (gcc-10): 1 error, 1 warning
    mv78xx0_defconfig (gcc-10): 1 error, 1 warning
    mvebu_v5_defconfig (gcc-10): 1 error, 1 warning
    mvebu_v7_defconfig (gcc-10): 1 error, 1 warning
    mxs_defconfig (gcc-10): 1 error, 1 warning
    neponset_defconfig (gcc-10): 1 error, 1 warning
    netwinder_defconfig (gcc-10): 1 error, 1 warning
    nhk8815_defconfig (gcc-10): 1 error, 1 warning
    omap1_defconfig (gcc-10): 1 error, 1 warning
    omap2plus_defconfig (gcc-10): 1 error, 1 warning
    orion5x_defconfig (gcc-10): 1 error, 1 warning
    oxnas_v6_defconfig (gcc-10): 1 error, 1 warning
    palmz72_defconfig (gcc-10): 1 error, 1 warning
    pcm027_defconfig (gcc-10): 1 error, 1 warning
    pleb_defconfig (gcc-10): 1 error, 1 warning
    pxa168_defconfig (gcc-10): 1 error, 1 warning
    pxa255-idp_defconfig (gcc-10): 1 error, 1 warning
    pxa3xx_defconfig (gcc-10): 1 error, 1 warning
    pxa910_defconfig (gcc-10): 1 error, 1 warning
    pxa_defconfig (gcc-10): 1 error, 1 warning
    qcom_defconfig (gcc-10): 1 error, 1 warning
    realview_defconfig (gcc-10): 1 error, 1 warning
    s3c2410_defconfig (gcc-10): 1 error, 1 warning
    s5pv210_defconfig (gcc-10): 1 error, 1 warning
    sama5_defconfig (gcc-10): 1 error, 1 warning
    sama7_defconfig (gcc-10): 1 error, 1 warning
    shannon_defconfig (gcc-10): 1 error, 1 warning
    shmobile_defconfig (gcc-10): 1 error, 1 warning
    simpad_defconfig (gcc-10): 1 error, 1 warning
    socfpga_defconfig (gcc-10): 1 error, 1 warning
    spear13xx_defconfig (gcc-10): 1 error, 1 warning
    spear3xx_defconfig (gcc-10): 1 error, 1 warning
    spear6xx_defconfig (gcc-10): 1 error, 1 warning
    spitz_defconfig (gcc-10): 1 error, 1 warning
    sunxi_defconfig (gcc-10): 1 error, 1 warning
    tct_hammer_defconfig (gcc-10): 1 error, 1 warning
    tegra_defconfig (gcc-10): 1 error, 1 warning
    trizeps4_defconfig (gcc-10): 1 error, 1 warning
    u8500_defconfig (gcc-10): 1 error, 1 warning
    versatile_defconfig (gcc-10): 1 error, 1 warning
    vexpress_defconfig (gcc-10): 1 error, 1 warning
    viper_defconfig (gcc-10): 1 error, 1 warning
    vt8500_v6_v7_defconfig (gcc-10): 1 error, 1 warning
    xcep_defconfig (gcc-10): 1 error, 1 warning
    zeus_defconfig (gcc-10): 1 error, 1 warning

i386:

mips:
    32r2el_defconfig (gcc-10): 1 error, 2 warnings
    ar7_defconfig (gcc-10): 1 error, 1 warning
    ath25_defconfig (gcc-10): 1 error, 1 warning
    ath79_defconfig (gcc-10): 1 error, 1 warning
    bcm47xx_defconfig (gcc-10): 1 error, 1 warning
    bcm63xx_defconfig (gcc-10): 1 error, 1 warning
    bigsur_defconfig (gcc-10): 1 error, 1 warning
    bmips_be_defconfig (gcc-10): 1 error, 9 warnings
    bmips_stb_defconfig (gcc-10): 1 error, 9 warnings
    cavium_octeon_defconfig (gcc-10): 1 error, 1 warning
    ci20_defconfig (gcc-10): 1 error, 1 warning
    cobalt_defconfig (gcc-10): 1 error, 1 warning
    cu1000-neo_defconfig (gcc-10): 1 error, 1 warning
    cu1830-neo_defconfig (gcc-10): 1 error, 1 warning
    db1xxx_defconfig (gcc-10): 1 error, 1 warning
    decstation_64_defconfig (gcc-10): 1 error, 1 warning
    decstation_defconfig (gcc-10): 1 error, 1 warning
    decstation_r4k_defconfig (gcc-10): 1 error, 1 warning
    fuloong2e_defconfig (gcc-10): 1 error, 1 warning
    gcw0_defconfig (gcc-10): 1 error, 1 warning
    gpr_defconfig (gcc-10): 1 error, 1 warning
    ip22_defconfig (gcc-10): 1 error, 1 warning
    ip27_defconfig (gcc-10): 1 error, 1 warning
    ip28_defconfig (gcc-10): 1 error, 1 warning
    ip32_defconfig (gcc-10): 1 error, 1 warning
    jazz_defconfig (gcc-10): 1 error, 1 warning
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson1b_defconfig (gcc-10): 1 error, 1 warning
    loongson1c_defconfig (gcc-10): 1 error, 1 warning
    loongson2k_defconfig (gcc-10): 1 error, 1 warning
    loongson3_defconfig (gcc-10): 1 error, 1 warning
    malta_defconfig (gcc-10): 1 error, 1 warning
    malta_kvm_defconfig (gcc-10): 1 error, 1 warning
    malta_qemu_32r6_defconfig (gcc-10): 1 error, 1 warning
    maltaaprp_defconfig (gcc-10): 1 error, 1 warning
    maltasmvp_defconfig (gcc-10): 1 error, 1 warning
    maltasmvp_eva_defconfig (gcc-10): 1 error, 1 warning
    maltaup_defconfig (gcc-10): 1 error, 1 warning
    maltaup_xpa_defconfig (gcc-10): 1 error, 1 warning
    mtx1_defconfig (gcc-10): 1 error, 1 warning
    omega2p_defconfig (gcc-10): 1 error, 1 warning
    qi_lb60_defconfig (gcc-10): 1 error, 1 warning
    rb532_defconfig (gcc-10): 1 error, 1 warning
    rbtx49xx_defconfig (gcc-10): 1 error, 1 warning
    rm200_defconfig (gcc-10): 1 error, 1 warning
    rs90_defconfig (gcc-10): 1 error, 1 warning
    rt305x_defconfig (gcc-10): 1 error, 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 error, 1 warning
    vocore2_defconfig (gcc-10): 1 error, 1 warning
    xway_defconfig (gcc-10): 1 error, 1 warning

riscv:
    defconfig (gcc-10): 1 error, 1 warning
    rv32_defconfig (gcc-10): 1 error, 1 warning

x86_64:

Errors summary:

    146  kernel/bpf/core.c:1911:3: error: implicit declaration of function =
=E2=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]
    9    kernel/bpf/core.c:1911:3: error: implicit declaration of function =
'barrier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    155  cc1: some warnings being treated as errors
    2    arch/mips/boot/dts/brcm/bcm63268.dtsi:115.5-22: Warning (reg_forma=
t): /ubus/timer-mfd@10000080/watchdog@1c:reg: property has invalid length (=
8 bytes) (#address-cells =3D=3D 2, #size-cells =3D=3D 1)
    2    arch/mips/boot/dts/brcm/bcm63268.dtsi:113.21-121.6: Warning (avoid=
_default_addr_size): /ubus/timer-mfd@10000080/watchdog@1c: Relying on defau=
lt #size-cells value
    2    arch/mips/boot/dts/brcm/bcm63268.dtsi:113.21-121.6: Warning (avoid=
_default_addr_size): /ubus/timer-mfd@10000080/watchdog@1c: Relying on defau=
lt #address-cells value
    2    arch/mips/boot/dts/brcm/bcm63268.dtsi:111.4-35: Warning (ranges_fo=
rmat): /ubus/timer-mfd@10000080:ranges: "ranges" property has invalid lengt=
h (12 bytes) (parent #address-cells =3D=3D 1, child #address-cells =3D=3D 2=
, #size-cells =3D=3D 1)
    2    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (s=
pi_bus_reg): Failed prerequisite 'reg_format'
    2    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (p=
ci_device_reg): Failed prerequisite 'reg_format'
    2    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (p=
ci_device_bus_num): Failed prerequisite 'reg_format'
    2    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (i=
2c_bus_reg): Failed prerequisite 'reg_format'
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
32r2el_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 9 warnings, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    arch/mips/boot/dts/brcm/bcm63268.dtsi:115.5-22: Warning (reg_format): /=
ubus/timer-mfd@10000080/watchdog@1c:reg: property has invalid length (8 byt=
es) (#address-cells =3D=3D 2, #size-cells =3D=3D 1)
    arch/mips/boot/dts/brcm/bcm63268.dtsi:111.4-35: Warning (ranges_format)=
: /ubus/timer-mfd@10000080:ranges: "ranges" property has invalid length (12=
 bytes) (parent #address-cells =3D=3D 1, child #address-cells =3D=3D 2, #si=
ze-cells =3D=3D 1)
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (pci_de=
vice_reg): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (pci_de=
vice_bus_num): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (i2c_bu=
s_reg): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (spi_bu=
s_reg): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268.dtsi:113.21-121.6: Warning (avoid_defa=
ult_addr_size): /ubus/timer-mfd@10000080/watchdog@1c: Relying on default #a=
ddress-cells value
    arch/mips/boot/dts/brcm/bcm63268.dtsi:113.21-121.6: Warning (avoid_defa=
ult_addr_size): /ubus/timer-mfd@10000080/watchdog@1c: Relying on default #s=
ize-cells value
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 9 warnings, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    arch/mips/boot/dts/brcm/bcm63268.dtsi:115.5-22: Warning (reg_format): /=
ubus/timer-mfd@10000080/watchdog@1c:reg: property has invalid length (8 byt=
es) (#address-cells =3D=3D 2, #size-cells =3D=3D 1)
    arch/mips/boot/dts/brcm/bcm63268.dtsi:111.4-35: Warning (ranges_format)=
: /ubus/timer-mfd@10000080:ranges: "ranges" property has invalid length (12=
 bytes) (parent #address-cells =3D=3D 1, child #address-cells =3D=3D 2, #si=
ze-cells =3D=3D 1)
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (pci_de=
vice_reg): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (pci_de=
vice_bus_num): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (i2c_bu=
s_reg): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268-comtrend-vr-3032u.dtb: Warning (spi_bu=
s_reg): Failed prerequisite 'reg_format'
    arch/mips/boot/dts/brcm/bcm63268.dtsi:113.21-121.6: Warning (avoid_defa=
ult_addr_size): /ubus/timer-mfd@10000080/watchdog@1c: Relying on default #a=
ddress-cells value
    arch/mips/boot/dts/brcm/bcm63268.dtsi:113.21-121.6: Warning (avoid_defa=
ult_addr_size): /ubus/timer-mfd@10000080/watchdog@1c: Relying on default #s=
ize-cells value
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warni=
ng, 0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imxrt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson2k_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning=
, 0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sp7021_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

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
trizeps4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
xcep_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1911:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
