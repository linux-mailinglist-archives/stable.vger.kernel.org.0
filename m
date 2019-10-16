Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387A1D962A
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 18:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405996AbfJPQAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 12:00:49 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40620 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405990AbfJPQAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 12:00:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so3346412wmj.5
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 09:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q4yS7v4/279FcTuMRnUPmwYot7rVtFYlgTu9e1WH1ck=;
        b=e9x0X2cusivt2WzWJwni0TvomkNBUIB29F1t6Gsr3PigHcCWz3Szni9WloxUNZ/JvC
         9IWsGU2JivZ4oy90a9qcEm3E55Kwd/5fZTOnx30CdPo9U98vIK84dypYA5btqjLF7U/n
         X/s9BFpbqj6v6adq537QAOGp5uoj2064gbI350S+NAxy1HpFQY69BbPrbgSaP0S26GEj
         SWRTOGE/AAuciAADibZIJmGMOCdRJ775VEw02+opxu1mN2jkdBZD9HMyaplQb+YaL9hy
         bEZQgyHo9jpH9Zj60R/hMr99Ge0IBSeVqFUko2+4UU6AEO1Qor3JbM3DhwZeXawMnA8E
         eorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q4yS7v4/279FcTuMRnUPmwYot7rVtFYlgTu9e1WH1ck=;
        b=K+UK5oHIfs0wFnvC3NCyClkQycVdGCyGZOy2HyWdO3jAUmz0cxZiD2GdFHIl2QMBVi
         WPv5Y5DGPZmPbd4yJuJ0NZuLK0C7LlDM4jma9Op11RjpxlvrBVww5bwbhgtb4DvTFD/V
         F2ZPBEjgL+P3i5fgpyA0f/TxgvjtzaeJ0MTGMq8W1/G/PW5FRLjj8ZHzOfcleTPh0nuh
         3xBE2NIdy8wY6kYisQf2mJJqk7fam+8auwh7b786lCqeEVFTI+c/tXj5wK8iLVU9srT1
         1qGM7FYTr9OGdeb7z4NsZxAbIHnR2BovWju/5Ap0/VgpWtPyXeMeReR6CG0FLR0NbfZS
         DlFw==
X-Gm-Message-State: APjAAAWdYEApCtuXEaqUGKZSzS5cThtQjpUQfnGmyamvOsgDEuD/2+AX
        EwZo/J7vaiFFSvCWwR2FobLbhNwWxwLIxQ==
X-Google-Smtp-Source: APXvYqzugXWh/Zt27lJKQlDJSyytmILlPg4ObZKyTwcluOjFlXPyFE01/QNDzOhVO5FFm4El0CMgfQ==
X-Received: by 2002:a1c:dcd6:: with SMTP id t205mr4162792wmg.10.1571241636531;
        Wed, 16 Oct 2019 09:00:36 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r140sm3230503wme.47.2019.10.16.09.00.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 09:00:35 -0700 (PDT)
Message-ID: <5da73ea3.1c69fb81.2f4b7.17d6@mx.google.com>
Date:   Wed, 16 Oct 2019 09:00:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.3.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.3.6-111-gd8fee438c028
Subject: stable-rc/linux-5.3.y build: 208 builds: 178 failed, 30 passed,
 1068 errors, 162 warnings (v5.3.6-111-gd8fee438c028)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.3.y build: 208 builds: 178 failed, 30 passed, 1068 errors=
, 162 warnings (v5.3.6-111-gd8fee438c028)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.3.y=
/kernel/v5.3.6-111-gd8fee438c028/

Tree: stable-rc
Branch: linux-5.3.y
Git Describe: v5.3.6-111-gd8fee438c028
Git Commit: d8fee438c02867cd53e85dcb6cc7d3475b222483
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
    haps_hs_defconfig: (gcc-8) FAIL
    haps_hs_smp_defconfig: (gcc-8) FAIL
    hsdk_defconfig: (gcc-8) FAIL
    nsim_hs_defconfig: (gcc-8) FAIL
    nsim_hs_smp_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL

arm64:
    defconfig: (gcc-8) FAIL

arm:
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
    am200epdkit_defconfig: (gcc-8) FAIL
    aspeed_g4_defconfig: (gcc-8) FAIL
    aspeed_g5_defconfig: (gcc-8) FAIL
    assabet_defconfig: (gcc-8) FAIL
    at91_dt_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    cerfcube_defconfig: (gcc-8) FAIL
    clps711x_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    ebsa110_defconfig: (gcc-8) FAIL
    efm32_defconfig: (gcc-8) FAIL
    em_x270_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    exynos_defconfig: (gcc-8) FAIL
    ezx_defconfig: (gcc-8) FAIL
    footbridge_defconfig: (gcc-8) FAIL
    gemini_defconfig: (gcc-8) FAIL
    h3600_defconfig: (gcc-8) FAIL
    h5000_defconfig: (gcc-8) FAIL
    hackkit_defconfig: (gcc-8) FAIL
    hisi_defconfig: (gcc-8) FAIL
    imote2_defconfig: (gcc-8) FAIL
    imx_v4_v5_defconfig: (gcc-8) FAIL
    imx_v6_v7_defconfig: (gcc-8) FAIL
    integrator_defconfig: (gcc-8) FAIL
    iop13xx_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    iop33x_defconfig: (gcc-8) FAIL
    ixp4xx_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    ks8695_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc18xx_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    mps2_defconfig: (gcc-8) FAIL
    multi_v5_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    neponset_defconfig: (gcc-8) FAIL
    netwinder_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    omap1_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    oxnas_v6_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa910_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
    realview_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tango4_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    xcep_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL

i386:
    i386_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
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
    decstation_64_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    decstation_r4k_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gcw0_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
    lasat_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
    loongson1b_defconfig: (gcc-8) FAIL
    loongson1c_defconfig: (gcc-8) FAIL
    loongson3_defconfig: (gcc-8) FAIL
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
    omega2p_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    vocore2_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

riscv:
    defconfig: (gcc-8) FAIL
    rv32_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 warning
    axs103_defconfig (gcc-8): 6 errors, 1 warning
    axs103_smp_defconfig (gcc-8): 6 errors, 1 warning
    haps_hs_defconfig (gcc-8): 6 errors, 1 warning
    haps_hs_smp_defconfig (gcc-8): 6 errors, 1 warning
    hsdk_defconfig (gcc-8): 6 errors, 1 warning
    nsim_hs_defconfig (gcc-8): 6 errors, 1 warning
    nsim_hs_smp_defconfig (gcc-8): 6 errors, 1 warning
    nsimosci_hs_defconfig (gcc-8): 6 errors, 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 6 errors, 1 warning
    tinyconfig (gcc-8): 1 warning
    vdk_hs38_defconfig (gcc-8): 6 errors, 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 6 errors, 1 warning

arm64:
    defconfig (gcc-8): 6 errors, 3 warnings

arm:
    acs5k_defconfig (gcc-8): 6 errors
    acs5k_tiny_defconfig (gcc-8): 6 errors
    am200epdkit_defconfig (gcc-8): 6 errors
    aspeed_g4_defconfig (gcc-8): 6 errors
    aspeed_g5_defconfig (gcc-8): 6 errors
    assabet_defconfig (gcc-8): 6 errors
    at91_dt_defconfig (gcc-8): 6 errors, 4 warnings
    axm55xx_defconfig (gcc-8): 6 errors
    badge4_defconfig (gcc-8): 6 errors
    bcm2835_defconfig (gcc-8): 6 errors
    cerfcube_defconfig (gcc-8): 6 errors
    clps711x_defconfig (gcc-8): 6 errors
    cm_x2xx_defconfig (gcc-8): 6 errors
    cm_x300_defconfig (gcc-8): 6 errors
    colibri_pxa270_defconfig (gcc-8): 6 errors
    colibri_pxa300_defconfig (gcc-8): 6 errors
    collie_defconfig (gcc-8): 6 errors
    corgi_defconfig (gcc-8): 6 errors
    davinci_all_defconfig (gcc-8): 6 errors
    dove_defconfig (gcc-8): 6 errors
    ebsa110_defconfig (gcc-8): 6 errors
    efm32_defconfig (gcc-8): 6 errors
    em_x270_defconfig (gcc-8): 6 errors
    ep93xx_defconfig (gcc-8): 6 errors
    eseries_pxa_defconfig (gcc-8): 6 errors
    exynos_defconfig (gcc-8): 6 errors
    ezx_defconfig (gcc-8): 6 errors
    footbridge_defconfig (gcc-8): 6 errors
    gemini_defconfig (gcc-8): 6 errors
    h3600_defconfig (gcc-8): 6 errors
    h5000_defconfig (gcc-8): 6 errors
    hackkit_defconfig (gcc-8): 6 errors
    hisi_defconfig (gcc-8): 6 errors
    imote2_defconfig (gcc-8): 6 errors
    imx_v4_v5_defconfig (gcc-8): 6 errors, 1 warning
    imx_v6_v7_defconfig (gcc-8): 6 errors
    integrator_defconfig (gcc-8): 6 errors
    iop13xx_defconfig (gcc-8): 6 errors
    iop32x_defconfig (gcc-8): 6 errors
    iop33x_defconfig (gcc-8): 6 errors
    ixp4xx_defconfig (gcc-8): 6 errors
    jornada720_defconfig (gcc-8): 6 errors
    keystone_defconfig (gcc-8): 6 errors
    ks8695_defconfig (gcc-8): 6 errors
    lart_defconfig (gcc-8): 6 errors
    lpc18xx_defconfig (gcc-8): 6 errors
    lpc32xx_defconfig (gcc-8): 6 errors
    lpd270_defconfig (gcc-8): 6 errors
    lubbock_defconfig (gcc-8): 6 errors
    magician_defconfig (gcc-8): 6 errors
    mainstone_defconfig (gcc-8): 6 errors
    mini2440_defconfig (gcc-8): 6 errors, 2 warnings
    mmp2_defconfig (gcc-8): 6 errors
    moxart_defconfig (gcc-8): 6 errors
    mps2_defconfig (gcc-8): 6 errors
    multi_v5_defconfig (gcc-8): 6 errors, 3 warnings
    multi_v7_defconfig (gcc-8): 6 errors, 16 warnings
    mv78xx0_defconfig (gcc-8): 6 errors
    mvebu_v5_defconfig (gcc-8): 6 errors
    mvebu_v7_defconfig (gcc-8): 6 errors
    mxs_defconfig (gcc-8): 6 errors
    neponset_defconfig (gcc-8): 6 errors
    netwinder_defconfig (gcc-8): 6 errors
    nhk8815_defconfig (gcc-8): 6 errors
    omap1_defconfig (gcc-8): 6 errors
    omap2plus_defconfig (gcc-8): 6 errors, 1 warning
    orion5x_defconfig (gcc-8): 6 errors
    oxnas_v6_defconfig (gcc-8): 6 errors
    palmz72_defconfig (gcc-8): 6 errors
    pcm027_defconfig (gcc-8): 6 errors
    pleb_defconfig (gcc-8): 6 errors
    pxa168_defconfig (gcc-8): 6 errors
    pxa255-idp_defconfig (gcc-8): 6 errors
    pxa3xx_defconfig (gcc-8): 6 errors
    pxa910_defconfig (gcc-8): 6 errors
    pxa_defconfig (gcc-8): 6 errors
    qcom_defconfig (gcc-8): 6 errors, 2 warnings
    realview_defconfig (gcc-8): 6 errors
    rpc_defconfig (gcc-8): 6 errors
    s3c2410_defconfig (gcc-8): 6 errors
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 6 errors, 1 warning
    sama5_defconfig (gcc-8): 6 errors, 4 warnings
    shannon_defconfig (gcc-8): 6 errors
    shmobile_defconfig (gcc-8): 6 errors, 2 warnings
    simpad_defconfig (gcc-8): 6 errors
    socfpga_defconfig (gcc-8): 6 errors
    spear13xx_defconfig (gcc-8): 6 errors
    spitz_defconfig (gcc-8): 6 errors
    sunxi_defconfig (gcc-8): 6 errors
    tango4_defconfig (gcc-8): 6 errors
    tct_hammer_defconfig (gcc-8): 6 errors, 2 warnings
    tegra_defconfig (gcc-8): 6 errors
    trizeps4_defconfig (gcc-8): 6 errors
    u8500_defconfig (gcc-8): 6 errors, 6 warnings
    versatile_defconfig (gcc-8): 6 errors
    vexpress_defconfig (gcc-8): 6 errors
    viper_defconfig (gcc-8): 6 errors
    vt8500_v6_v7_defconfig (gcc-8): 6 errors
    xcep_defconfig (gcc-8): 6 errors
    zeus_defconfig (gcc-8): 6 errors

i386:
    i386_defconfig (gcc-8): 6 errors

mips:
    32r2el_defconfig (gcc-8): 6 errors, 1 warning
    allnoconfig (gcc-8): 1 warning
    ar7_defconfig (gcc-8): 6 errors, 1 warning
    ath25_defconfig (gcc-8): 6 errors, 1 warning
    ath79_defconfig (gcc-8): 6 errors, 1 warning
    bcm47xx_defconfig (gcc-8): 6 errors, 1 warning
    bcm63xx_defconfig (gcc-8): 6 errors, 1 warning
    bigsur_defconfig (gcc-8): 6 errors, 3 warnings
    bmips_be_defconfig (gcc-8): 6 errors, 1 warning
    bmips_stb_defconfig (gcc-8): 6 errors, 1 warning
    capcella_defconfig (gcc-8): 6 errors, 1 warning
    cavium_octeon_defconfig (gcc-8): 6 errors, 3 warnings
    ci20_defconfig (gcc-8): 6 errors, 2 warnings
    cobalt_defconfig (gcc-8): 6 errors, 1 warning
    db1xxx_defconfig (gcc-8): 6 errors, 1 warning
    decstation_64_defconfig (gcc-8): 6 errors, 3 warnings
    decstation_defconfig (gcc-8): 6 errors, 1 warning
    decstation_r4k_defconfig (gcc-8): 6 errors, 1 warning
    e55_defconfig (gcc-8): 2 warnings
    fuloong2e_defconfig (gcc-8): 6 errors, 3 warnings
    gcw0_defconfig (gcc-8): 6 errors, 1 warning
    gpr_defconfig (gcc-8): 6 errors, 1 warning
    ip22_defconfig (gcc-8): 6 errors, 2 warnings
    ip27_defconfig (gcc-8): 6 errors, 3 warnings
    ip28_defconfig (gcc-8): 6 errors, 4 warnings
    ip32_defconfig (gcc-8): 6 errors, 3 warnings
    jazz_defconfig (gcc-8): 6 errors, 1 warning
    jmr3927_defconfig (gcc-8): 6 errors, 1 warning
    lasat_defconfig (gcc-8): 6 errors, 1 warning
    lemote2f_defconfig (gcc-8): 6 errors, 3 warnings
    loongson1b_defconfig (gcc-8): 6 errors, 1 warning
    loongson1c_defconfig (gcc-8): 6 errors, 1 warning
    loongson3_defconfig (gcc-8): 6 errors, 3 warnings
    malta_defconfig (gcc-8): 6 errors, 1 warning
    malta_kvm_defconfig (gcc-8): 6 errors, 1 warning
    malta_kvm_guest_defconfig (gcc-8): 6 errors, 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 6 errors, 2 warnings
    maltaaprp_defconfig (gcc-8): 6 errors, 1 warning
    maltasmvp_defconfig (gcc-8): 6 errors, 1 warning
    maltasmvp_eva_defconfig (gcc-8): 6 errors, 1 warning
    maltaup_defconfig (gcc-8): 6 errors, 1 warning
    maltaup_xpa_defconfig (gcc-8): 6 errors, 1 warning
    markeins_defconfig (gcc-8): 6 errors, 1 warning
    mips_paravirt_defconfig (gcc-8): 6 errors, 3 warnings
    mpc30x_defconfig (gcc-8): 6 errors, 1 warning
    msp71xx_defconfig (gcc-8): 6 errors, 1 warning
    mtx1_defconfig (gcc-8): 6 errors, 1 warning
    nlm_xlp_defconfig (gcc-8): 6 errors, 3 warnings
    nlm_xlr_defconfig (gcc-8): 6 errors, 1 warning
    omega2p_defconfig (gcc-8): 6 errors, 1 warning
    pic32mzda_defconfig (gcc-8): 2 warnings
    pistachio_defconfig (gcc-8): 6 errors, 1 warning
    pnx8335_stb225_defconfig (gcc-8): 6 errors, 1 warning
    qi_lb60_defconfig (gcc-8): 6 errors, 3 warnings
    rb532_defconfig (gcc-8): 6 errors, 1 warning
    rbtx49xx_defconfig (gcc-8): 6 errors, 1 warning
    rm200_defconfig (gcc-8): 6 errors, 1 warning
    rt305x_defconfig (gcc-8): 6 errors, 1 warning
    sb1250_swarm_defconfig (gcc-8): 6 errors, 2 warnings
    tb0219_defconfig (gcc-8): 6 errors, 1 warning
    tb0226_defconfig (gcc-8): 6 errors, 1 warning
    tb0287_defconfig (gcc-8): 6 errors, 1 warning
    tinyconfig (gcc-8): 1 warning
    vocore2_defconfig (gcc-8): 6 errors, 1 warning
    workpad_defconfig (gcc-8): 6 errors, 1 warning
    xway_defconfig (gcc-8): 6 errors, 1 warning

riscv:
    defconfig (gcc-8): 6 errors
    rv32_defconfig (gcc-8): 6 errors, 3 warnings

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 6 errors

Errors summary:

    178  include/linux/kernel.h:47:52: error: invalid use of undefined type=
 'struct workqueue_struct'
    178  include/linux/kernel.h:47:52: error: dereferencing pointer to inco=
mplete type 'struct workqueue_struct'
    178  include/linux/compiler.h:357:67: error: invalid use of undefined t=
ype 'struct workqueue_struct'
    178  include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' wi=
dth not an integer constant
    178  fs/io_uring.c:2572:31: error: invalid use of undefined type 'struc=
t workqueue_struct'
    178  fs/io_uring.c:2571:18: error: invalid use of undefined type 'struc=
t workqueue_struct'

Warnings summary:

    105  <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    4    drivers/mmc/host/atmel-mci.c:2426:40: warning: this statement may =
fall through [-Wimplicit-fallthrough=3D]
    4    drivers/mmc/host/atmel-mci.c:2422:28: warning: this statement may =
fall through [-Wimplicit-fallthrough=3D]
    4    drivers/mmc/host/atmel-mci.c:2415:30: warning: this statement may =
fall through [-Wimplicit-fallthrough=3D]
    3    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:820:20: warning: this sta=
tement may fall through [-Wimplicit-fallthrough=3D]
    3    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:815:20: warning: this sta=
tement may fall through [-Wimplicit-fallthrough=3D]
    3    drivers/mmc/host/sdhci-s3c.c:613:19: warning: this statement may f=
all through [-Wimplicit-fallthrough=3D]
    2    drivers/watchdog/jz4740_wdt.c:165:6: warning: unused variable 'ret=
' [-Wunused-variable]
    2    drivers/video/fbdev/sh_mobile_lcdcfb.c:2086:22: warning: this stat=
ement may fall through [-Wimplicit-fallthrough=3D]
    2    drivers/video/fbdev/sh_mobile_lcdcfb.c:1596:22: warning: this stat=
ement may fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/phy/phy-ab8500-usb.c:459:9: warning: this statement ma=
y fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/phy/phy-ab8500-usb.c:440:9: warning: this statement ma=
y fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/phy/phy-ab8500-usb.c:424:9: warning: this statement ma=
y fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/phy/phy-ab8500-usb.c:370:9: warning: this statement ma=
y fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/phy/phy-ab8500-usb.c:352:9: warning: this statement ma=
y fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/phy/phy-ab8500-usb.c:332:9: warning: this statement ma=
y fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/gadget/udc/s3c2410_udc.c:418:7: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/gadget/udc/s3c2410_udc.c:314:7: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    2    drivers/usb/gadget/udc/atmel_usba_udc.c:329:13: warning: this stat=
ement may fall through [-Wimplicit-fallthrough=3D]
    2    drivers/scsi/wd33c93.c:1856:11: warning: this statement may fall t=
hrough [-Wimplicit-fallthrough=3D]
    2    drivers/pinctrl/pinctrl-rockchip.c:2783:3: warning: this statement=
 may fall through [-Wimplicit-fallthrough=3D]
    2    drivers/dma/imx-dma.c:542:6: warning: this statement may fall thro=
ugh [-Wimplicit-fallthrough=3D]
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    drivers/video/fbdev/jz4740_fb.c:300:8: warning: this statement may=
 fall through [-Wimplicit-fallthrough=3D]
    1    drivers/cpufreq/ti-cpufreq.c:79:20: warning: this statement may fa=
ll through [-Wimplicit-fallthrough=3D]
    1    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    1    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    .config:1168:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 =
section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 section =
mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 4 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/mmc/host/atmel-mci.c:2415:30: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2422:28: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2426:40: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/usb/gadget/udc/atmel_usba_udc.c:329:13: warning: this statement=
 may fall through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    drivers/watchdog/jz4740_wdt.c:165:6: warning: unused variable 'ret' [-W=
unused-variable]

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 =
section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section mi=
smatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 section mi=
smatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:815:20: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:820:20: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    drivers/pinctrl/pinctrl-rockchip.c:2783:3: warning: this statement may =
fall through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 =
section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section =
mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 section =
mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 section =
mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/dma/imx-dma.c:542:6: warning: this statement may fall through [=
-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    drivers/scsi/wd33c93.c:1856:11: warning: this statement may fall throug=
h [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 4 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    drivers/scsi/wd33c93.c:1856:11: warning: this statement may fall throug=
h [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning=
, 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warning=
s, 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    {standard input}:131: Warning: macro instruction expanded into multiple=
 instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, =
0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 =
section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/usb/gadget/udc/s3c2410_udc.c:314:7: warning: this statement may=
 fall through [-Wimplicit-fallthrough=3D]
    drivers/usb/gadget/udc/s3c2410_udc.c:418:7: warning: this statement may=
 fall through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/mmc/host/atmel-mci.c:2415:30: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2422:28: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2426:40: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 16 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/dma/imx-dma.c:542:6: warning: this statement may fall through [=
-Wimplicit-fallthrough=3D]
    drivers/mmc/host/sdhci-s3c.c:613:19: warning: this statement may fall t=
hrough [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2415:30: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2422:28: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2426:40: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:815:20: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:820:20: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    drivers/pinctrl/pinctrl-rockchip.c:2783:3: warning: this statement may =
fall through [-Wimplicit-fallthrough=3D]
    drivers/video/fbdev/sh_mobile_lcdcfb.c:2086:22: warning: this statement=
 may fall through [-Wimplicit-fallthrough=3D]
    drivers/video/fbdev/sh_mobile_lcdcfb.c:1596:22: warning: this statement=
 may fall through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:424:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:440:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:459:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:332:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:352:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:370:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section =
mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

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
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/cpufreq/ti-cpufreq.c:79:20: warning: this statement may fall th=
rough [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning,=
 0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section =
mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:815:20: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]
    drivers/pinctrl/qcom/pinctrl-spmi-gpio.c:820:20: warning: this statemen=
t may fall through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    drivers/watchdog/jz4740_wdt.c:165:6: warning: unused variable 'ret' [-W=
unused-variable]
    drivers/video/fbdev/jz4740_fb.c:300:8: warning: this statement may fall=
 through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section =
mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-8) =E2=80=94 FAIL, 6 errors, 3 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/mmc/host/sdhci-s3c.c:613:19: warning: this statement may fall t=
hrough [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/mmc/host/sdhci-s3c.c:613:19: warning: this statement may fall t=
hrough [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 4 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/mmc/host/atmel-mci.c:2415:30: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2422:28: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/mmc/host/atmel-mci.c:2426:40: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]
    drivers/usb/gadget/udc/atmel_usba_udc.c:329:13: warning: this statement=
 may fall through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warnings, =
0 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/video/fbdev/sh_mobile_lcdcfb.c:2086:22: warning: this statement=
 may fall through [-Wimplicit-fallthrough=3D]
    drivers/video/fbdev/sh_mobile_lcdcfb.c:1596:22: warning: this statement=
 may fall through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

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
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 2 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/usb/gadget/udc/s3c2410_udc.c:314:7: warning: this statement may=
 fall through [-Wimplicit-fallthrough=3D]
    drivers/usb/gadget/udc/s3c2410_udc.c:418:7: warning: this statement may=
 fall through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

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
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1168:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 6 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    drivers/usb/phy/phy-ab8500-usb.c:424:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:440:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:459:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:332:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:352:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]
    drivers/usb/phy/phy-ab8500-usb.c:370:9: warning: this statement may fal=
l through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 =
section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0=
 section mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 6 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 section=
 mismatches

Errors:
    include/linux/kernel.h:47:52: error: invalid use of undefined type 'str=
uct workqueue_struct'
    include/linux/kernel.h:47:52: error: dereferencing pointer to incomplet=
e type 'struct workqueue_struct'
    include/linux/compiler.h:357:67: error: invalid use of undefined type '=
struct workqueue_struct'
    include/linux/build_bug.h:16:45: error: bit-field '<anonymous>' width n=
ot an integer constant
    fs/io_uring.c:2571:18: error: invalid use of undefined type 'struct wor=
kqueue_struct'
    fs/io_uring.c:2572:31: error: invalid use of undefined type 'struct wor=
kqueue_struct'

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
