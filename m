Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4FD5FE9E1
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 09:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJNHzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 03:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJNHzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 03:55:15 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4855048E95
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 00:55:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d10so4210445pfh.6
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 00:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pCtit9bnOClfBmHp3BB3vS3HxFkQsJ02HGg39+Wx/Pw=;
        b=UxIh3rGQyg/+ywuTgA91LzEkEIrklKbav3u03/akj12p42QKQ5M1KPSTPHXE20ZuCs
         dX0heiJlCSbscd5q3j0w3srV2ayL2oSRLQde/KYD+WxzGlJxdk+tAlZmGvh9sx8dSQ6T
         tCsY6eJRJEXgOU8k55QbQoke+HY+5j5haDWCU56V4px0mwwKoUyC5k+I376y4qI18kbH
         Hebhgt9ufVXZDgDFieap1OFyWcF3josXAHnTkTinRAKzdP6y6WY92yBYMqHgpX6HGbmD
         gHiMqX7Mjq84PywmVvlbwCrpexiFLS2QCiB//EHwabftRo9mw6zAKeHQE+zXpmr40kSe
         ihdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pCtit9bnOClfBmHp3BB3vS3HxFkQsJ02HGg39+Wx/Pw=;
        b=wn2SeFCOEg9M3LK5NiFs8duG2egt5bvSBmxThKEXPvdwRM4TTJASBuhdaM1MxCGCCI
         mSOpOHdYQ0yAzwYpvZsCFAI5uQPMant1T28+EWzq+kV/jY7OfPSVN06xrEvWKT/qPZYm
         Auo/f9KFIwGK+594wVrddFtj+gmhXlP3uG7PV7OK+z/UbofpUIgX/XFa/KX8W0dpHiou
         FhcgdOv0/XbeX1e8xMTw7RGgxf4qSzlTFS8/qJzc1/80MYDhyLjh6N0Hx32a0aSOFdsG
         TLfpZsk4h1rVoP8b+1jvk7B/Q3oFPVax8AWZOndsqgo6pbt575PSWaFxD6qrDWex6h3g
         z84g==
X-Gm-Message-State: ACrzQf0QaoTNlHkNDCEVhzFEWV8TnvtRB3e0pGofb1XhfjyEQGY84XDA
        c27BUZ+i8d9ENV1y+6QN6HGksjFLyCI3MdHSngQ=
X-Google-Smtp-Source: AMsMyM4uu4g04GETRyLC90vl3f4vE5jA9LpEKfw/txL8y6Gitj/RQjZz82igr3C/2FdmG7oUfbuY5A==
X-Received: by 2002:a05:6a00:1a44:b0:52a:ecd5:bbef with SMTP id h4-20020a056a001a4400b0052aecd5bbefmr3815736pfv.28.1665734103658;
        Fri, 14 Oct 2022 00:55:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e24-20020a656798000000b00454f8a8cc24sm871990pgr.12.2022.10.14.00.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:55:02 -0700 (PDT)
Message-ID: <634915d6.650a0220.49401.1dfd@mx.google.com>
Date:   Fri, 14 Oct 2022 00:55:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.295-44-g2107c2352c1b7
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/4.14 build: 202 builds: 202 failed, 0 passed,
 201 errors, 12 warnings (v4.14.295-44-g2107c2352c1b7)
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

stable-rc/queue/4.14 build: 202 builds: 202 failed, 0 passed, 201 errors, 1=
2 warnings (v4.14.295-44-g2107c2352c1b7)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.295-44-g2107c2352c1b7/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.295-44-g2107c2352c1b7
Git Commit: 2107c2352c1b7e6f19806b4d367759f66e9bf528
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-10) FAIL
    axs103_defconfig: (gcc-10) FAIL
    axs103_smp_defconfig: (gcc-10) FAIL
    haps_hs_defconfig: (gcc-10) FAIL
    haps_hs_smp_defconfig: (gcc-10) FAIL
    hsdk_defconfig: (gcc-10) FAIL
    nsim_hs_defconfig: (gcc-10) FAIL
    nsim_hs_smp_defconfig: (gcc-10) FAIL
    nsimosci_hs_defconfig: (gcc-10) FAIL
    nsimosci_hs_smp_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    vdk_hs38_defconfig: (gcc-10) FAIL
    vdk_hs38_smp_defconfig: (gcc-10) FAIL

arm64:
    defconfig: (gcc-10) FAIL
    defconfig+arm64-chromebook: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

arm:
    acs5k_defconfig: (gcc-10) FAIL
    acs5k_tiny_defconfig: (gcc-10) FAIL
    allnoconfig: (gcc-10) FAIL
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
    cm_x2xx_defconfig: (gcc-10) FAIL
    cm_x300_defconfig: (gcc-10) FAIL
    cns3420vb_defconfig: (gcc-10) FAIL
    colibri_pxa270_defconfig: (gcc-10) FAIL
    colibri_pxa300_defconfig: (gcc-10) FAIL
    collie_defconfig: (gcc-10) FAIL
    corgi_defconfig: (gcc-10) FAIL
    davinci_all_defconfig: (gcc-10) FAIL
    dove_defconfig: (gcc-10) FAIL
    ebsa110_defconfig: (gcc-10) FAIL
    efm32_defconfig: (gcc-10) FAIL
    em_x270_defconfig: (gcc-10) FAIL
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
    imote2_defconfig: (gcc-10) FAIL
    imx_v4_v5_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    integrator_defconfig: (gcc-10) FAIL
    iop13xx_defconfig: (gcc-10) FAIL
    iop32x_defconfig: (gcc-10) FAIL
    iop33x_defconfig: (gcc-10) FAIL
    ixp4xx_defconfig: (gcc-10) FAIL
    jornada720_defconfig: (gcc-10) FAIL
    keystone_defconfig: (gcc-10) FAIL
    ks8695_defconfig: (gcc-10) FAIL
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
    multi_v4t_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    multi_v7_defconfig: (gcc-10) FAIL
    mv78xx0_defconfig: (gcc-10) FAIL
    mvebu_v5_defconfig: (gcc-10) FAIL
    mvebu_v7_defconfig: (gcc-10) FAIL
    mxs_defconfig: (gcc-10) FAIL
    neponset_defconfig: (gcc-10) FAIL
    netwinder_defconfig: (gcc-10) FAIL
    netx_defconfig: (gcc-10) FAIL
    nhk8815_defconfig: (gcc-10) FAIL
    nuc910_defconfig: (gcc-10) FAIL
    nuc950_defconfig: (gcc-10) FAIL
    nuc960_defconfig: (gcc-10) FAIL
    omap1_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    orion5x_defconfig: (gcc-10) FAIL
    palmz72_defconfig: (gcc-10) FAIL
    pcm027_defconfig: (gcc-10) FAIL
    pleb_defconfig: (gcc-10) FAIL
    prima2_defconfig: (gcc-10) FAIL
    pxa168_defconfig: (gcc-10) FAIL
    pxa255-idp_defconfig: (gcc-10) FAIL
    pxa3xx_defconfig: (gcc-10) FAIL
    pxa910_defconfig: (gcc-10) FAIL
    pxa_defconfig: (gcc-10) FAIL
    qcom_defconfig: (gcc-10) FAIL
    raumfeld_defconfig: (gcc-10) FAIL
    realview_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    s3c2410_defconfig: (gcc-10) FAIL
    s3c6400_defconfig: (gcc-10) FAIL
    s5pv210_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    shannon_defconfig: (gcc-10) FAIL
    shmobile_defconfig: (gcc-10) FAIL
    simpad_defconfig: (gcc-10) FAIL
    socfpga_defconfig: (gcc-10) FAIL
    spear13xx_defconfig: (gcc-10) FAIL
    spear3xx_defconfig: (gcc-10) FAIL
    spear6xx_defconfig: (gcc-10) FAIL
    spitz_defconfig: (gcc-10) FAIL
    stm32_defconfig: (gcc-10) FAIL
    sunxi_defconfig: (gcc-10) FAIL
    tango4_defconfig: (gcc-10) FAIL
    tct_hammer_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    trizeps4_defconfig: (gcc-10) FAIL
    u300_defconfig: (gcc-10) FAIL
    u8500_defconfig: (gcc-10) FAIL
    versatile_defconfig: (gcc-10) FAIL
    vexpress_defconfig: (gcc-10) FAIL
    vf610m4_defconfig: (gcc-10) FAIL
    viper_defconfig: (gcc-10) FAIL
    vt8500_v6_v7_defconfig: (gcc-10) FAIL
    xcep_defconfig: (gcc-10) FAIL
    zeus_defconfig: (gcc-10) FAIL
    zx_defconfig: (gcc-10) FAIL

i386:
    allnoconfig: (gcc-10) FAIL
    i386_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

mips:
    32r2el_defconfig: (gcc-10) FAIL
    allnoconfig: (gcc-10) FAIL
    ar7_defconfig: (gcc-10) FAIL
    ath25_defconfig: (gcc-10) FAIL
    ath79_defconfig: (gcc-10) FAIL
    bcm47xx_defconfig: (gcc-10) FAIL
    bcm63xx_defconfig: (gcc-10) FAIL
    bigsur_defconfig: (gcc-10) FAIL
    bmips_be_defconfig: (gcc-10) FAIL
    bmips_stb_defconfig: (gcc-10) FAIL
    capcella_defconfig: (gcc-10) FAIL
    cavium_octeon_defconfig: (gcc-10) FAIL
    ci20_defconfig: (gcc-10) FAIL
    cobalt_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    decstation_defconfig: (gcc-10) FAIL
    e55_defconfig: (gcc-10) FAIL
    fuloong2e_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip22_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    ip32_defconfig: (gcc-10) FAIL
    jazz_defconfig: (gcc-10) FAIL
    jmr3927_defconfig: (gcc-10) FAIL
    lasat_defconfig: (gcc-10) FAIL
    lemote2f_defconfig: (gcc-10) FAIL
    loongson1b_defconfig: (gcc-10) FAIL
    loongson1c_defconfig: (gcc-10) FAIL
    loongson3_defconfig: (gcc-10) FAIL
    malta_defconfig: (gcc-10) FAIL
    malta_kvm_defconfig: (gcc-10) FAIL
    malta_kvm_guest_defconfig: (gcc-10) FAIL
    malta_qemu_32r6_defconfig: (gcc-10) FAIL
    maltaaprp_defconfig: (gcc-10) FAIL
    maltasmvp_defconfig: (gcc-10) FAIL
    maltasmvp_eva_defconfig: (gcc-10) FAIL
    maltaup_defconfig: (gcc-10) FAIL
    maltaup_xpa_defconfig: (gcc-10) FAIL
    markeins_defconfig: (gcc-10) FAIL
    mips_paravirt_defconfig: (gcc-10) FAIL
    mpc30x_defconfig: (gcc-10) FAIL
    msp71xx_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL
    nlm_xlp_defconfig: (gcc-10) FAIL
    nlm_xlr_defconfig: (gcc-10) FAIL
    omega2p_defconfig: (gcc-10) FAIL
    pic32mzda_defconfig: (gcc-10) FAIL
    pistachio_defconfig: (gcc-10) FAIL
    pnx8335_stb225_defconfig: (gcc-10) FAIL
    qi_lb60_defconfig: (gcc-10) FAIL
    rb532_defconfig: (gcc-10) FAIL
    rbtx49xx_defconfig: (gcc-10) FAIL
    rm200_defconfig: (gcc-10) FAIL
    rt305x_defconfig: (gcc-10) FAIL
    sb1250_swarm_defconfig: (gcc-10) FAIL
    tb0219_defconfig: (gcc-10) FAIL
    tb0226_defconfig: (gcc-10) FAIL
    tb0287_defconfig: (gcc-10) FAIL
    vocore2_defconfig: (gcc-10) FAIL
    workpad_defconfig: (gcc-10) FAIL
    xilfpga_defconfig: (gcc-10) FAIL
    xway_defconfig: (gcc-10) FAIL

x86_64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    x86_64_defconfig: (gcc-10) FAIL
    x86_64_defconfig+x86-chromebook: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-10): 1 error
    axs103_defconfig (gcc-10): 1 error
    axs103_smp_defconfig (gcc-10): 1 error
    haps_hs_defconfig (gcc-10): 1 error
    haps_hs_smp_defconfig (gcc-10): 1 error
    hsdk_defconfig (gcc-10): 1 error
    nsim_hs_defconfig (gcc-10): 1 error
    nsim_hs_smp_defconfig (gcc-10): 1 error
    nsimosci_hs_defconfig (gcc-10): 1 error
    nsimosci_hs_smp_defconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 1 error
    vdk_hs38_defconfig (gcc-10): 1 error
    vdk_hs38_smp_defconfig (gcc-10): 1 error

arm64:
    defconfig (gcc-10): 1 error
    defconfig+arm64-chromebook (gcc-10): 1 error
    tinyconfig (gcc-10): 1 error

arm:
    acs5k_defconfig (gcc-10): 1 error
    acs5k_tiny_defconfig (gcc-10): 1 error
    allnoconfig (gcc-10): 1 error
    am200epdkit_defconfig (gcc-10): 1 error
    aspeed_g4_defconfig (gcc-10): 1 error
    aspeed_g5_defconfig (gcc-10): 1 error
    assabet_defconfig (gcc-10): 1 error
    at91_dt_defconfig (gcc-10): 1 error
    axm55xx_defconfig (gcc-10): 1 error
    badge4_defconfig (gcc-10): 1 error
    bcm2835_defconfig (gcc-10): 1 error
    cerfcube_defconfig (gcc-10): 1 error
    clps711x_defconfig (gcc-10): 1 error
    cm_x2xx_defconfig (gcc-10): 1 error
    cm_x300_defconfig (gcc-10): 1 error
    cns3420vb_defconfig (gcc-10): 1 error
    colibri_pxa270_defconfig (gcc-10): 1 error
    colibri_pxa300_defconfig (gcc-10): 1 error
    collie_defconfig (gcc-10): 1 error
    corgi_defconfig (gcc-10): 1 error
    davinci_all_defconfig (gcc-10): 1 error
    dove_defconfig (gcc-10): 1 error
    ebsa110_defconfig (gcc-10): 1 error
    efm32_defconfig (gcc-10): 1 error
    em_x270_defconfig (gcc-10): 1 error
    ep93xx_defconfig (gcc-10): 1 error
    eseries_pxa_defconfig (gcc-10): 1 error
    exynos_defconfig (gcc-10): 1 error
    ezx_defconfig (gcc-10): 1 error
    footbridge_defconfig (gcc-10): 1 error
    gemini_defconfig (gcc-10): 1 error
    h3600_defconfig (gcc-10): 1 error
    h5000_defconfig (gcc-10): 1 error
    hackkit_defconfig (gcc-10): 1 error
    hisi_defconfig (gcc-10): 1 error
    imote2_defconfig (gcc-10): 1 error
    imx_v4_v5_defconfig (gcc-10): 1 error
    imx_v6_v7_defconfig (gcc-10): 1 error
    integrator_defconfig (gcc-10): 1 error
    iop13xx_defconfig (gcc-10): 1 error
    iop32x_defconfig (gcc-10): 1 error
    iop33x_defconfig (gcc-10): 1 error
    ixp4xx_defconfig (gcc-10): 1 error
    jornada720_defconfig (gcc-10): 1 error
    keystone_defconfig (gcc-10): 1 error
    ks8695_defconfig (gcc-10): 1 error
    lart_defconfig (gcc-10): 1 error
    lpc18xx_defconfig (gcc-10): 1 error
    lpc32xx_defconfig (gcc-10): 1 error
    lpd270_defconfig (gcc-10): 1 error
    lubbock_defconfig (gcc-10): 1 error
    magician_defconfig (gcc-10): 1 error
    mainstone_defconfig (gcc-10): 1 error
    mini2440_defconfig (gcc-10): 1 error
    mmp2_defconfig (gcc-10): 1 error
    moxart_defconfig (gcc-10): 1 error
    mps2_defconfig (gcc-10): 1 error
    multi_v4t_defconfig (gcc-10): 1 error
    multi_v5_defconfig (gcc-10): 1 error
    multi_v7_defconfig (gcc-10): 1 error
    mv78xx0_defconfig (gcc-10): 1 error
    mvebu_v5_defconfig (gcc-10): 1 error
    mvebu_v7_defconfig (gcc-10): 1 error
    mxs_defconfig (gcc-10): 1 error
    neponset_defconfig (gcc-10): 1 error
    netwinder_defconfig (gcc-10): 1 error
    netx_defconfig (gcc-10): 1 error
    nhk8815_defconfig (gcc-10): 1 error
    nuc910_defconfig (gcc-10): 1 error
    nuc950_defconfig (gcc-10): 1 error
    nuc960_defconfig (gcc-10): 1 error
    omap1_defconfig (gcc-10): 1 error
    omap2plus_defconfig (gcc-10): 1 error
    orion5x_defconfig (gcc-10): 1 error
    palmz72_defconfig (gcc-10): 1 error
    pcm027_defconfig (gcc-10): 1 error
    pleb_defconfig (gcc-10): 1 error
    prima2_defconfig (gcc-10): 1 error
    pxa168_defconfig (gcc-10): 1 error
    pxa255-idp_defconfig (gcc-10): 1 error
    pxa3xx_defconfig (gcc-10): 1 error
    pxa910_defconfig (gcc-10): 1 error
    pxa_defconfig (gcc-10): 1 error
    qcom_defconfig (gcc-10): 1 error
    raumfeld_defconfig (gcc-10): 1 error
    realview_defconfig (gcc-10): 1 error
    rpc_defconfig (gcc-10): 2 errors
    s3c2410_defconfig (gcc-10): 1 error
    s3c6400_defconfig (gcc-10): 1 error
    s5pv210_defconfig (gcc-10): 1 error
    sama5_defconfig (gcc-10): 1 error
    shannon_defconfig (gcc-10): 1 error
    shmobile_defconfig (gcc-10): 1 error
    simpad_defconfig (gcc-10): 1 error
    socfpga_defconfig (gcc-10): 1 error
    spear13xx_defconfig (gcc-10): 1 error
    spear3xx_defconfig (gcc-10): 1 error
    spear6xx_defconfig (gcc-10): 1 error
    spitz_defconfig (gcc-10): 1 error
    stm32_defconfig (gcc-10): 1 error
    sunxi_defconfig (gcc-10): 1 error
    tango4_defconfig (gcc-10): 1 error
    tct_hammer_defconfig (gcc-10): 1 error
    tegra_defconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 1 error
    trizeps4_defconfig (gcc-10): 1 error
    u300_defconfig (gcc-10): 1 error
    u8500_defconfig (gcc-10): 1 error
    versatile_defconfig (gcc-10): 1 error
    vexpress_defconfig (gcc-10): 1 error
    vf610m4_defconfig (gcc-10): 1 error
    viper_defconfig (gcc-10): 1 error
    vt8500_v6_v7_defconfig (gcc-10): 1 error
    xcep_defconfig (gcc-10): 1 error
    zeus_defconfig (gcc-10): 1 error
    zx_defconfig (gcc-10): 1 error

i386:
    allnoconfig (gcc-10): 1 error, 1 warning
    i386_defconfig (gcc-10): 1 error, 1 warning
    tinyconfig (gcc-10): 1 error, 1 warning

mips:
    32r2el_defconfig (gcc-10): 1 error
    allnoconfig (gcc-10): 1 error
    ar7_defconfig (gcc-10): 1 error
    ath25_defconfig (gcc-10): 1 error
    ath79_defconfig (gcc-10): 1 error
    bcm47xx_defconfig (gcc-10): 1 error
    bcm63xx_defconfig (gcc-10): 1 error
    bigsur_defconfig (gcc-10): 1 error
    bmips_be_defconfig (gcc-10): 1 error
    bmips_stb_defconfig (gcc-10): 1 error
    capcella_defconfig (gcc-10): 1 error
    cavium_octeon_defconfig (gcc-10): 1 error
    ci20_defconfig (gcc-10): 1 error
    cobalt_defconfig (gcc-10): 1 error
    db1xxx_defconfig (gcc-10): 1 error
    decstation_defconfig (gcc-10): 1 error
    e55_defconfig (gcc-10): 1 error
    fuloong2e_defconfig (gcc-10): 1 error
    gpr_defconfig (gcc-10): 1 error
    ip22_defconfig (gcc-10): 1 error
    ip32_defconfig (gcc-10): 1 error
    jazz_defconfig (gcc-10): 1 error
    jmr3927_defconfig (gcc-10): 1 error
    lasat_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error
    loongson1b_defconfig (gcc-10): 1 error
    loongson1c_defconfig (gcc-10): 1 error
    loongson3_defconfig (gcc-10): 1 error
    malta_defconfig (gcc-10): 1 error
    malta_kvm_defconfig (gcc-10): 1 error
    malta_kvm_guest_defconfig (gcc-10): 1 error
    malta_qemu_32r6_defconfig (gcc-10): 1 error, 1 warning
    maltaaprp_defconfig (gcc-10): 1 error
    maltasmvp_defconfig (gcc-10): 1 error
    maltasmvp_eva_defconfig (gcc-10): 1 error
    maltaup_defconfig (gcc-10): 1 error
    maltaup_xpa_defconfig (gcc-10): 1 error
    markeins_defconfig (gcc-10): 1 error
    mips_paravirt_defconfig (gcc-10): 1 error
    mpc30x_defconfig (gcc-10): 1 error
    msp71xx_defconfig (gcc-10): 1 error
    mtx1_defconfig (gcc-10): 1 error
    nlm_xlp_defconfig (gcc-10): 1 error
    nlm_xlr_defconfig (gcc-10): 1 error
    omega2p_defconfig (gcc-10): 1 error
    pic32mzda_defconfig (gcc-10): 1 error
    pistachio_defconfig (gcc-10): 1 error
    pnx8335_stb225_defconfig (gcc-10): 1 error
    qi_lb60_defconfig (gcc-10): 1 error
    rb532_defconfig (gcc-10): 1 error
    rbtx49xx_defconfig (gcc-10): 1 error
    rm200_defconfig (gcc-10): 1 error
    rt305x_defconfig (gcc-10): 1 error
    sb1250_swarm_defconfig (gcc-10): 1 error
    tb0219_defconfig (gcc-10): 1 error
    tb0226_defconfig (gcc-10): 1 error
    tb0287_defconfig (gcc-10): 1 error
    vocore2_defconfig (gcc-10): 1 error
    workpad_defconfig (gcc-10): 1 error
    xilfpga_defconfig (gcc-10): 1 error
    xway_defconfig (gcc-10): 1 error

x86_64:
    allnoconfig (gcc-10): 1 error, 2 warnings
    tinyconfig (gcc-10): 1 error, 2 warnings
    x86_64_defconfig (gcc-10): 1 error, 2 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 1 error, 2 warnings

Errors summary:

    186  drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 =
undeclared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=
=E2=80=99?
    13   drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (firs=
t use in this function); did you mean 'IOCB_NOWAIT'?
    1    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3
    1    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    4    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic s=
uffix given and no register operands; using default for `sysret'
    4    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h=
' differs from latest kernel version at 'arch/x86/include/asm/insn.h'
    3    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic su=
ffix given and no register operands; using default for `btr'
    1    {standard input}:30: Warning: macro instruction expanded into mult=
iple instructions

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 0 warni=
ngs, 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

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
ip32_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warning=
s, 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning=
, 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    {standard input}:30: Warning: macro instruction expanded into multiple =
instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mis=
matches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mis=
matches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: 'IOCB_NOIO' undeclared (first use=
 in this function); did you mean 'IOCB_NOWAIT'?

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 2=
 warnings, 0 section mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    drivers/char/random.c:1298:41: error: =E2=80=98IOCB_NOIO=E2=80=99 undec=
lared (first use in this function); did you mean =E2=80=98IOCB_NOWAIT=E2=80=
=99?

---
For more info write to <info@kernelci.org>
