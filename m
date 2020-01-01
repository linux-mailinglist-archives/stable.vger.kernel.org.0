Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6CE512E04E
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 20:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgAATsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 14:48:45 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38918 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgAATsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 14:48:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so37534184wrt.6
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 11:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GvMTGL+3GAzm7MKINw358HFjejg3HDIdwDLXBHaHS/E=;
        b=1sLt+Xcu/PXoPy0FcHo6FoqWlfcLpVZqg64jVQ7euThTTKPJl2335p4uXwYA0ErzUe
         o/I9DHyPHIGrRE9a/1dmVAKuPnmlziA0VBKrTVqKr+p+Sk/mtrXGkp58QqK8nkGQW8qi
         VcMMgPHBGjMrwV4X9EeB5pgf4q3JV/3QQ9GzvszZvZFEVfQHw7CJC9t0Wg9ZmtdlP24n
         FpojnQUhSmcLBnm+g/nMS2qQ+hO4QQG8V8pvrCN1Lh1VZoKQ4L9mBXkL49FmwHLzx/g6
         ur6btAsWB0z0el50/cnxG6VxMDGIoZ40h2D+K+XIQwXmM41YzpzpozOdqpktqHAreY2Z
         Y1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GvMTGL+3GAzm7MKINw358HFjejg3HDIdwDLXBHaHS/E=;
        b=becA9BL7WD+0PymrBQ8qIwVHiKdJe2fYuZWCK/q2HQUEYzd5eNWuXuB0IA4N31C//S
         ibnb4eti1O3EQSjF3GJQwrBZFlV4NP9755huCxhemaDZR2Rd3jOaTcGHb+Irruz/zsGN
         E8IgCFz25egDBgKJ0LlL0mUb9BCzIV8iPsiFflSALnUadR0xzLBv6PGY334ZDoQtCPl9
         ObQ25ry0FKSvxkolWtZ/wOdtIKMDR7v4B20aYZfvvFLLzcp8MJhbSHEjin+Qb7+F6OLu
         8wpQu4IvI7GFgPtOP9bE5vmqFYWrcBngm7RZRuajaxZ+dh12vtxalmeMWxOyKVnnflNK
         gMEg==
X-Gm-Message-State: APjAAAWGiPbNmMNsVjHrAMINzhhsOwAGw1A9dH+9X6tYPDfvGD2jX0/X
        C3eYNn+KN0tMY2gJdKbJraKaUYcVT0UqBA==
X-Google-Smtp-Source: APXvYqz5KxjJbqpBOgGovYohQ0rfzq56EsqU2uq9+h9W8kj1zFgHfYpZK+7hc19/UvyOvsqVdJXStA==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr78764154wrm.293.1577908117161;
        Wed, 01 Jan 2020 11:48:37 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p26sm6243728wmc.24.2020.01.01.11.48.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 11:48:36 -0800 (PST)
Message-ID: <5e0cf794.1c69fb81.84269.c602@mx.google.com>
Date:   Wed, 01 Jan 2020 11:48:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.161-72-gac4e1f65c8e8
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y build: 201 builds: 177 failed, 24 passed,
 177 errors, 455 warnings (v4.14.161-72-gac4e1f65c8e8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 177 failed, 24 passed, 177 errors=
, 455 warnings (v4.14.161-72-gac4e1f65c8e8)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.161-72-gac4e1f65c8e8/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.161-72-gac4e1f65c8e8
Git Commit: ac4e1f65c8e8dbb1e7677acef9b3508aa2f8c3b1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

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
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    ebsa110_defconfig: (gcc-8) FAIL
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
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    multi_v4t_defconfig: (gcc-8) FAIL
    multi_v5_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    neponset_defconfig: (gcc-8) FAIL
    netwinder_defconfig: (gcc-8) FAIL
    netx_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    nuc910_defconfig: (gcc-8) FAIL
    nuc950_defconfig: (gcc-8) FAIL
    nuc960_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa910_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    realview_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tango4_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    i386_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
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
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    omega2p_defconfig: (gcc-8) FAIL
    pic32mzda_defconfig: (gcc-8) FAIL
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
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-8): 1 error, 2 warnings
    axs103_smp_defconfig (gcc-8): 1 error, 2 warnings
    haps_hs_defconfig (gcc-8): 1 error, 2 warnings
    haps_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    hsdk_defconfig (gcc-8): 1 error, 2 warnings
    nsim_hs_defconfig (gcc-8): 1 error, 2 warnings
    nsim_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    nsimosci_hs_defconfig (gcc-8): 1 error, 2 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_defconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_smp_defconfig (gcc-8): 1 error, 2 warnings

arm64:
    allnoconfig (gcc-8): 2 warnings
    defconfig (gcc-8): 1 error, 3 warnings
    tinyconfig (gcc-8): 2 warnings

arm:
    acs5k_defconfig (gcc-8): 1 error, 3 warnings
    acs5k_tiny_defconfig (gcc-8): 1 error, 3 warnings
    aspeed_g4_defconfig (gcc-8): 1 error, 3 warnings
    aspeed_g5_defconfig (gcc-8): 1 error, 3 warnings
    assabet_defconfig (gcc-8): 1 error, 3 warnings
    at91_dt_defconfig (gcc-8): 1 error, 2 warnings
    axm55xx_defconfig (gcc-8): 1 error, 3 warnings
    badge4_defconfig (gcc-8): 1 error, 3 warnings
    bcm2835_defconfig (gcc-8): 1 error, 2 warnings
    cerfcube_defconfig (gcc-8): 1 error, 3 warnings
    clps711x_defconfig (gcc-8): 1 error, 3 warnings
    cm_x2xx_defconfig (gcc-8): 1 error, 2 warnings
    cm_x300_defconfig (gcc-8): 1 error, 3 warnings
    cns3420vb_defconfig (gcc-8): 1 error, 3 warnings
    colibri_pxa270_defconfig (gcc-8): 1 error, 3 warnings
    colibri_pxa300_defconfig (gcc-8): 1 error, 3 warnings
    collie_defconfig (gcc-8): 1 error, 3 warnings
    corgi_defconfig (gcc-8): 1 error, 3 warnings
    davinci_all_defconfig (gcc-8): 1 error, 3 warnings
    dove_defconfig (gcc-8): 1 error, 3 warnings
    ebsa110_defconfig (gcc-8): 1 error, 3 warnings
    em_x270_defconfig (gcc-8): 1 error, 2 warnings
    ep93xx_defconfig (gcc-8): 1 error, 3 warnings
    eseries_pxa_defconfig (gcc-8): 1 error, 3 warnings
    exynos_defconfig (gcc-8): 1 error, 3 warnings
    ezx_defconfig (gcc-8): 1 error, 3 warnings
    footbridge_defconfig (gcc-8): 1 error, 3 warnings
    gemini_defconfig (gcc-8): 1 error, 3 warnings
    h3600_defconfig (gcc-8): 1 error, 3 warnings
    h5000_defconfig (gcc-8): 1 error, 2 warnings
    hackkit_defconfig (gcc-8): 1 error, 3 warnings
    hisi_defconfig (gcc-8): 1 error, 3 warnings
    imote2_defconfig (gcc-8): 1 error, 3 warnings
    imx_v4_v5_defconfig (gcc-8): 1 error, 2 warnings
    imx_v6_v7_defconfig (gcc-8): 1 error, 3 warnings
    integrator_defconfig (gcc-8): 1 error, 3 warnings
    iop13xx_defconfig (gcc-8): 1 error, 3 warnings
    iop32x_defconfig (gcc-8): 1 error, 3 warnings
    iop33x_defconfig (gcc-8): 1 error, 3 warnings
    ixp4xx_defconfig (gcc-8): 1 error, 3 warnings
    jornada720_defconfig (gcc-8): 1 error, 3 warnings
    keystone_defconfig (gcc-8): 1 error, 3 warnings
    ks8695_defconfig (gcc-8): 1 error, 3 warnings
    lart_defconfig (gcc-8): 1 error, 3 warnings
    lpc32xx_defconfig (gcc-8): 1 error, 2 warnings
    lpd270_defconfig (gcc-8): 1 error, 3 warnings
    lubbock_defconfig (gcc-8): 1 error, 3 warnings
    magician_defconfig (gcc-8): 1 error, 3 warnings
    mainstone_defconfig (gcc-8): 1 error, 3 warnings
    mini2440_defconfig (gcc-8): 1 error, 3 warnings
    mmp2_defconfig (gcc-8): 1 error, 3 warnings
    moxart_defconfig (gcc-8): 1 error, 3 warnings
    multi_v4t_defconfig (gcc-8): 1 error, 3 warnings
    multi_v5_defconfig (gcc-8): 1 error, 3 warnings
    multi_v7_defconfig (gcc-8): 1 error, 3 warnings
    mv78xx0_defconfig (gcc-8): 1 error, 3 warnings
    mvebu_v5_defconfig (gcc-8): 1 error, 3 warnings
    mvebu_v7_defconfig (gcc-8): 1 error, 3 warnings
    mxs_defconfig (gcc-8): 1 error, 3 warnings
    neponset_defconfig (gcc-8): 1 error, 3 warnings
    netwinder_defconfig (gcc-8): 1 error, 3 warnings
    netx_defconfig (gcc-8): 1 error, 3 warnings
    nhk8815_defconfig (gcc-8): 1 error, 3 warnings
    nuc910_defconfig (gcc-8): 1 error, 3 warnings
    nuc950_defconfig (gcc-8): 1 error, 3 warnings
    nuc960_defconfig (gcc-8): 1 error, 3 warnings
    omap2plus_defconfig (gcc-8): 1 error, 2 warnings
    orion5x_defconfig (gcc-8): 1 error, 3 warnings
    palmz72_defconfig (gcc-8): 1 error, 3 warnings
    pcm027_defconfig (gcc-8): 1 error, 3 warnings
    prima2_defconfig (gcc-8): 1 error, 3 warnings
    pxa168_defconfig (gcc-8): 1 error, 3 warnings
    pxa255-idp_defconfig (gcc-8): 1 error, 3 warnings
    pxa3xx_defconfig (gcc-8): 1 error, 3 warnings
    pxa910_defconfig (gcc-8): 1 error, 3 warnings
    pxa_defconfig (gcc-8): 1 error, 3 warnings
    qcom_defconfig (gcc-8): 1 error, 3 warnings
    raumfeld_defconfig (gcc-8): 1 error, 3 warnings
    realview_defconfig (gcc-8): 1 error, 3 warnings
    rpc_defconfig (gcc-8): 1 error, 3 warnings
    s3c2410_defconfig (gcc-8): 1 error, 2 warnings
    s3c6400_defconfig (gcc-8): 1 error, 3 warnings
    s5pv210_defconfig (gcc-8): 1 error, 3 warnings
    sama5_defconfig (gcc-8): 1 error, 3 warnings
    shannon_defconfig (gcc-8): 1 error, 3 warnings
    shmobile_defconfig (gcc-8): 1 error, 2 warnings
    simpad_defconfig (gcc-8): 1 error, 3 warnings
    socfpga_defconfig (gcc-8): 1 error, 3 warnings
    spear13xx_defconfig (gcc-8): 1 error, 3 warnings
    spear3xx_defconfig (gcc-8): 1 error, 3 warnings
    spear6xx_defconfig (gcc-8): 1 error, 3 warnings
    spitz_defconfig (gcc-8): 1 error, 3 warnings
    sunxi_defconfig (gcc-8): 1 error, 3 warnings
    tango4_defconfig (gcc-8): 1 error, 3 warnings
    tegra_defconfig (gcc-8): 1 error, 3 warnings
    trizeps4_defconfig (gcc-8): 1 error, 3 warnings
    u300_defconfig (gcc-8): 1 error, 3 warnings
    u8500_defconfig (gcc-8): 1 error, 3 warnings
    versatile_defconfig (gcc-8): 1 error, 3 warnings
    vexpress_defconfig (gcc-8): 1 error, 3 warnings
    vt8500_v6_v7_defconfig (gcc-8): 1 error, 3 warnings
    zeus_defconfig (gcc-8): 1 error, 3 warnings
    zx_defconfig (gcc-8): 1 error, 3 warnings

i386:
    i386_defconfig (gcc-8): 1 error, 3 warnings

mips:
    32r2el_defconfig (gcc-8): 1 error, 2 warnings
    ar7_defconfig (gcc-8): 1 error, 2 warnings
    ath25_defconfig (gcc-8): 1 error, 2 warnings
    ath79_defconfig (gcc-8): 1 error, 2 warnings
    bcm47xx_defconfig (gcc-8): 1 error, 2 warnings
    bigsur_defconfig (gcc-8): 1 error, 2 warnings
    bmips_be_defconfig (gcc-8): 1 error, 2 warnings
    bmips_stb_defconfig (gcc-8): 1 error, 2 warnings
    capcella_defconfig (gcc-8): 1 error, 2 warnings
    cavium_octeon_defconfig (gcc-8): 1 error, 2 warnings
    ci20_defconfig (gcc-8): 1 error, 2 warnings
    cobalt_defconfig (gcc-8): 1 error, 2 warnings
    db1xxx_defconfig (gcc-8): 1 error, 2 warnings
    decstation_defconfig (gcc-8): 1 error, 2 warnings
    e55_defconfig (gcc-8): 1 error, 2 warnings
    fuloong2e_defconfig (gcc-8): 1 error, 2 warnings
    gpr_defconfig (gcc-8): 1 error, 2 warnings
    ip22_defconfig (gcc-8): 1 error, 2 warnings
    ip27_defconfig (gcc-8): 1 error, 2 warnings
    ip28_defconfig (gcc-8): 1 error, 2 warnings
    ip32_defconfig (gcc-8): 1 error, 2 warnings
    jazz_defconfig (gcc-8): 1 error, 2 warnings
    jmr3927_defconfig (gcc-8): 1 error, 2 warnings
    lasat_defconfig (gcc-8): 1 error, 2 warnings
    lemote2f_defconfig (gcc-8): 1 error, 2 warnings
    loongson1b_defconfig (gcc-8): 1 error, 2 warnings
    loongson1c_defconfig (gcc-8): 1 error, 2 warnings
    loongson3_defconfig (gcc-8): 1 error, 2 warnings
    malta_defconfig (gcc-8): 1 error, 2 warnings
    malta_kvm_defconfig (gcc-8): 1 error, 2 warnings
    malta_kvm_guest_defconfig (gcc-8): 1 error, 2 warnings
    malta_qemu_32r6_defconfig (gcc-8): 1 error, 2 warnings
    maltaaprp_defconfig (gcc-8): 1 error, 2 warnings
    maltasmvp_defconfig (gcc-8): 1 error, 2 warnings
    maltasmvp_eva_defconfig (gcc-8): 1 error, 2 warnings
    maltaup_defconfig (gcc-8): 1 error, 2 warnings
    maltaup_xpa_defconfig (gcc-8): 1 error, 2 warnings
    markeins_defconfig (gcc-8): 1 error, 2 warnings
    mips_paravirt_defconfig (gcc-8): 1 error, 2 warnings
    mpc30x_defconfig (gcc-8): 1 error, 2 warnings
    mtx1_defconfig (gcc-8): 1 error, 2 warnings
    nlm_xlp_defconfig (gcc-8): 1 error, 2 warnings
    nlm_xlr_defconfig (gcc-8): 1 error, 2 warnings
    omega2p_defconfig (gcc-8): 1 error, 2 warnings
    pic32mzda_defconfig (gcc-8): 1 error, 2 warnings
    pistachio_defconfig (gcc-8): 1 error, 2 warnings
    pnx8335_stb225_defconfig (gcc-8): 1 error, 2 warnings
    qi_lb60_defconfig (gcc-8): 1 error, 2 warnings
    rb532_defconfig (gcc-8): 1 error, 2 warnings
    rbtx49xx_defconfig (gcc-8): 1 error, 2 warnings
    rm200_defconfig (gcc-8): 1 error, 2 warnings
    rt305x_defconfig (gcc-8): 1 error, 2 warnings
    sb1250_swarm_defconfig (gcc-8): 1 error, 2 warnings
    tb0219_defconfig (gcc-8): 1 error, 2 warnings
    tb0226_defconfig (gcc-8): 1 error, 2 warnings
    tb0287_defconfig (gcc-8): 1 error, 2 warnings
    vocore2_defconfig (gcc-8): 1 error, 2 warnings
    workpad_defconfig (gcc-8): 1 error, 2 warnings
    xilfpga_defconfig (gcc-8): 1 error, 2 warnings
    xway_defconfig (gcc-8): 1 error, 2 warnings

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 error, 3 warnings

Errors summary:

    177  mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=
=98maybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declarati=
on]

Warnings summary:

    177  mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=
=E2=80=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a c=
ast [-Wint-conversion]
    177  cc1: some warnings being treated as errors
    96   fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
    2    arch/arm64/kernel/cpufeature.c:940:13: warning: =E2=80=98cpu_copy_=
el2regs=E2=80=99 defined but not used [-Wunused-function]
    2    arch/arm64/kernel/cpufeature.c:802:13: warning: =E2=80=98runs_at_e=
l2=E2=80=99 defined but not used [-Wunused-function]
    1    .config:1027:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: =E2=80=98cpu_copy_el2re=
gs=E2=80=99 defined but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: =E2=80=98runs_at_el2=E2=
=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section mis=
matches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings=
, 0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings=
, 0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 =
section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings,=
 0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings,=
 0 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0=
 section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: =E2=80=98cpu_copy_el2re=
gs=E2=80=99 defined but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: =E2=80=98runs_at_el2=E2=
=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1027:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 =
section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 =
section mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 3 warnings, 0 section mi=
smatches

Errors:
    mm/shmem.c:1977:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1977:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
