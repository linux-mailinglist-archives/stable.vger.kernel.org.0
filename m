Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555274F50E
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 12:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFVKFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 06:05:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55676 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFVKFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 06:05:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so8373839wmj.5
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 03:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vwxbqLnXto9e3RXCyal2HXp6WyeLZRpKVN+JTantDik=;
        b=HwDdOGEWsXjWRN4SwHbGv14Q/VfxlilG6fAFQKQFB9r5mH6bxINmn7oYGql+4WI66F
         xLrtuy7gXqcIWnLOEozvemp9SAByFU6+5CN+mFs0WCxGtGSzj8lyI4aDU6cgy/FvaYG7
         h20MxjUT0iHlvceT+3yk+t8N9o+UvFgqo5tI/QuVJBL9AjrfLsGvRqqXH9/9/JLc9VZd
         az0OQ5PTbwzfzmlpJP8ex2uWn6DR577yqSV2A8mBSUFMV4aIX8mFcE18atZN5LkBFtoD
         ZFHELo082krq6EUI7JHGnmaSqcXx6MbR2bqnZ7HkuI1znFOJ5Gvs3D2X+gWDI/i6LIfh
         MlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vwxbqLnXto9e3RXCyal2HXp6WyeLZRpKVN+JTantDik=;
        b=YPlQLsJhrTjkamnn0G03vjxfGU76zjl2Xj3cceVP3XjVmQ10Wpz7wd65jxDaU3xy85
         38tVu7fAdAOr9c/tI5ymoTa53suB1IcW7MsH0P+gfjZXve8qsL7qpH2HJ8E52yqOHd+3
         7K1yWfYWRLIc1cpQOqVmYZlIBg6KV7RdudRbTo/P9dixUORF78ft3xYL17KJfhAtBHBf
         ahhpaovokcpajSHoj9973EZbInYvtf03IKaMTMCOvZQrtMXmlJ97qcYlhQ1HmbWQ4CFT
         DhlQBLa/P8ERMFu0Akwl7uI30+bqInkBYjPdaQ3T0R/kytKH5sPfIkpb20n58UcJMC8b
         DN6w==
X-Gm-Message-State: APjAAAUm+h57fxjQqRpshWMa6Y4XPa/ywzWbUBv7x+xrWGYzGeHQEPt2
        5cZXULmjDjCpraNrmVxIEuNal3PaqD7ZFw==
X-Google-Smtp-Source: APXvYqzRnuEpxWZ7EY+TjTxT5QcpA15fRahCgFvqQvygAXcvpnM+UPjpfgJrzfwUwZPRdVAsTtLb7w==
X-Received: by 2002:a1c:6154:: with SMTP id v81mr7430116wmb.92.1561197912287;
        Sat, 22 Jun 2019 03:05:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t63sm5319906wmt.6.2019.06.22.03.05.11
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 03:05:11 -0700 (PDT)
Message-ID: <5d0dfd57.1c69fb81.1e32c.d983@mx.google.com>
Date:   Sat, 22 Jun 2019 03:05:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.129-2-g8a3dbd7a613b
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y build: 201 builds: 172 failed, 29 passed,
 341 errors, 125 warnings (v4.14.129-2-g8a3dbd7a613b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 172 failed, 29 passed, 341 errors=
, 125 warnings (v4.14.129-2-g8a3dbd7a613b)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.129-2-g8a3dbd7a613b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.129-2-g8a3dbd7a613b
Git Commit: 8a3dbd7a613b72b1c6e20f421ed67bc840535cf3
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
    netx_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    omap1_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
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
    sama5_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tango4_defconfig: (gcc-8) FAIL
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
    decstation_defconfig: (gcc-8) FAIL
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
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-8): 2 errors, 2 warnings
    axs103_smp_defconfig (gcc-8): 2 errors, 2 warnings
    haps_hs_defconfig (gcc-8): 2 errors
    haps_hs_smp_defconfig (gcc-8): 2 errors
    hsdk_defconfig (gcc-8): 2 errors, 2 warnings
    nsim_hs_defconfig (gcc-8): 2 errors
    nsim_hs_smp_defconfig (gcc-8): 2 errors
    nsimosci_hs_defconfig (gcc-8): 2 errors, 2 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 2 errors, 2 warnings
    vdk_hs38_defconfig (gcc-8): 2 errors, 3 warnings
    vdk_hs38_smp_defconfig (gcc-8): 2 errors, 3 warnings

arm64:
    defconfig (gcc-8): 2 errors, 1 warning

arm:
    acs5k_defconfig (gcc-8): 2 errors, 1 warning
    acs5k_tiny_defconfig (gcc-8): 2 errors, 1 warning
    am200epdkit_defconfig (gcc-8): 2 errors
    aspeed_g4_defconfig (gcc-8): 2 errors, 1 warning
    aspeed_g5_defconfig (gcc-8): 2 errors, 1 warning
    assabet_defconfig (gcc-8): 2 errors, 1 warning
    at91_dt_defconfig (gcc-8): 2 errors
    axm55xx_defconfig (gcc-8): 2 errors, 1 warning
    badge4_defconfig (gcc-8): 2 errors, 1 warning
    bcm2835_defconfig (gcc-8): 2 errors
    cerfcube_defconfig (gcc-8): 2 errors, 1 warning
    clps711x_defconfig (gcc-8): 2 errors, 1 warning
    cm_x2xx_defconfig (gcc-8): 2 errors
    cm_x300_defconfig (gcc-8): 2 errors, 1 warning
    cns3420vb_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 2 errors, 1 warning
    colibri_pxa300_defconfig (gcc-8): 2 errors, 1 warning
    collie_defconfig (gcc-8): 2 errors, 1 warning
    corgi_defconfig (gcc-8): 2 errors, 1 warning
    davinci_all_defconfig (gcc-8): 2 errors, 1 warning
    dove_defconfig (gcc-8): 2 errors, 1 warning
    ebsa110_defconfig (gcc-8): 2 errors, 1 warning
    efm32_defconfig (gcc-8): 2 errors
    em_x270_defconfig (gcc-8): 2 errors
    ep93xx_defconfig (gcc-8): 2 errors, 1 warning
    eseries_pxa_defconfig (gcc-8): 2 errors, 1 warning
    exynos_defconfig (gcc-8): 2 errors, 1 warning
    ezx_defconfig (gcc-8): 2 errors, 1 warning
    footbridge_defconfig (gcc-8): 2 errors, 1 warning
    gemini_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 2 errors, 1 warning
    h5000_defconfig (gcc-8): 2 errors
    hackkit_defconfig (gcc-8): 2 errors, 1 warning
    hisi_defconfig (gcc-8): 2 errors, 1 warning
    imote2_defconfig (gcc-8): 2 errors, 1 warning
    imx_v4_v5_defconfig (gcc-8): 2 errors
    imx_v6_v7_defconfig (gcc-8): 2 errors, 1 warning
    integrator_defconfig (gcc-8): 2 errors, 1 warning
    iop13xx_defconfig (gcc-8): 2 errors, 1 warning
    iop32x_defconfig (gcc-8): 2 errors, 1 warning
    iop33x_defconfig (gcc-8): 2 errors, 1 warning
    ixp4xx_defconfig (gcc-8): 2 errors, 1 warning
    jornada720_defconfig (gcc-8): 2 errors, 1 warning
    keystone_defconfig (gcc-8): 2 errors, 1 warning
    ks8695_defconfig (gcc-8): 2 errors, 1 warning
    lart_defconfig (gcc-8): 2 errors, 1 warning
    lpc18xx_defconfig (gcc-8): 2 errors
    lpc32xx_defconfig (gcc-8): 2 errors
    lpd270_defconfig (gcc-8): 2 errors, 1 warning
    lubbock_defconfig (gcc-8): 2 errors, 1 warning
    magician_defconfig (gcc-8): 2 errors, 1 warning
    mainstone_defconfig (gcc-8): 2 errors, 1 warning
    mini2440_defconfig (gcc-8): 2 errors, 1 warning
    mmp2_defconfig (gcc-8): 2 errors, 1 warning
    moxart_defconfig (gcc-8): 2 errors, 1 warning
    mps2_defconfig (gcc-8): 2 errors
    multi_v4t_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 2 errors, 1 warning
    multi_v7_defconfig (gcc-8): 2 errors, 1 warning
    mv78xx0_defconfig (gcc-8): 2 errors, 1 warning
    mvebu_v5_defconfig (gcc-8): 2 errors, 1 warning
    mvebu_v7_defconfig (gcc-8): 2 errors, 1 warning
    mxs_defconfig (gcc-8): 2 errors, 1 warning
    neponset_defconfig (gcc-8): 2 errors, 1 warning
    netwinder_defconfig (gcc-8): 2 errors, 1 warning
    netx_defconfig (gcc-8): 2 errors, 1 warning
    nhk8815_defconfig (gcc-8): 2 errors, 1 warning
    nuc910_defconfig (gcc-8): 1 warning
    nuc950_defconfig (gcc-8): 1 warning
    nuc960_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 2 errors
    omap2plus_defconfig (gcc-8): 2 errors, 1 warning
    orion5x_defconfig (gcc-8): 2 errors, 1 warning
    palmz72_defconfig (gcc-8): 2 errors, 1 warning
    pcm027_defconfig (gcc-8): 2 errors, 1 warning
    pleb_defconfig (gcc-8): 2 errors
    prima2_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 2 errors, 1 warning
    pxa255-idp_defconfig (gcc-8): 2 errors, 1 warning
    pxa3xx_defconfig (gcc-8): 2 errors, 1 warning
    pxa910_defconfig (gcc-8): 2 errors, 1 warning
    pxa_defconfig (gcc-8): 2 errors, 1 warning
    qcom_defconfig (gcc-8): 2 errors, 1 warning
    raumfeld_defconfig (gcc-8): 2 errors, 1 warning
    realview_defconfig (gcc-8): 2 errors, 1 warning
    rpc_defconfig (gcc-8): 2 errors, 1 warning
    s3c2410_defconfig (gcc-8): 2 errors, 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 2 errors, 1 warning
    shannon_defconfig (gcc-8): 2 errors, 1 warning
    shmobile_defconfig (gcc-8): 2 errors
    simpad_defconfig (gcc-8): 2 errors, 1 warning
    socfpga_defconfig (gcc-8): 2 errors, 1 warning
    spear13xx_defconfig (gcc-8): 2 errors, 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    spear6xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 2 errors, 1 warning
    sunxi_defconfig (gcc-8): 2 errors, 1 warning
    tango4_defconfig (gcc-8): 2 errors, 1 warning
    tegra_defconfig (gcc-8): 2 errors, 1 warning
    trizeps4_defconfig (gcc-8): 2 errors, 1 warning
    u300_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 2 errors, 1 warning
    versatile_defconfig (gcc-8): 2 errors, 1 warning
    vexpress_defconfig (gcc-8): 2 errors, 1 warning
    viper_defconfig (gcc-8): 2 errors
    vt8500_v6_v7_defconfig (gcc-8): 2 errors, 1 warning
    xcep_defconfig (gcc-8): 2 errors
    zeus_defconfig (gcc-8): 2 errors, 1 warning
    zx_defconfig (gcc-8): 1 warning

i386:
    i386_defconfig (gcc-8): 2 errors, 1 warning

mips:
    32r2el_defconfig (gcc-8): 2 errors
    ar7_defconfig (gcc-8): 2 errors
    ath25_defconfig (gcc-8): 2 errors
    ath79_defconfig (gcc-8): 2 errors
    bcm47xx_defconfig (gcc-8): 2 errors
    bcm63xx_defconfig (gcc-8): 2 errors
    bigsur_defconfig (gcc-8): 2 errors, 4 warnings
    bmips_be_defconfig (gcc-8): 2 errors
    bmips_stb_defconfig (gcc-8): 2 errors
    capcella_defconfig (gcc-8): 2 errors
    cavium_octeon_defconfig (gcc-8): 2 errors
    ci20_defconfig (gcc-8): 2 errors
    cobalt_defconfig (gcc-8): 2 errors
    db1xxx_defconfig (gcc-8): 2 errors
    decstation_defconfig (gcc-8): 1 error
    fuloong2e_defconfig (gcc-8): 2 errors
    gpr_defconfig (gcc-8): 2 errors
    ip22_defconfig (gcc-8): 2 errors
    ip27_defconfig (gcc-8): 2 errors
    ip28_defconfig (gcc-8): 2 errors
    ip32_defconfig (gcc-8): 2 errors
    jazz_defconfig (gcc-8): 2 errors
    jmr3927_defconfig (gcc-8): 1 error
    lasat_defconfig (gcc-8): 2 errors
    lemote2f_defconfig (gcc-8): 2 errors
    loongson1b_defconfig (gcc-8): 2 errors
    loongson1c_defconfig (gcc-8): 2 errors
    loongson3_defconfig (gcc-8): 2 errors
    malta_defconfig (gcc-8): 2 errors
    malta_kvm_defconfig (gcc-8): 2 errors
    malta_kvm_guest_defconfig (gcc-8): 2 errors
    malta_qemu_32r6_defconfig (gcc-8): 2 errors, 1 warning
    maltaaprp_defconfig (gcc-8): 2 errors
    maltasmvp_defconfig (gcc-8): 2 errors
    maltasmvp_eva_defconfig (gcc-8): 2 errors
    maltaup_defconfig (gcc-8): 2 errors
    maltaup_xpa_defconfig (gcc-8): 2 errors
    markeins_defconfig (gcc-8): 2 errors
    mips_paravirt_defconfig (gcc-8): 2 errors
    mpc30x_defconfig (gcc-8): 2 errors
    msp71xx_defconfig (gcc-8): 2 errors
    mtx1_defconfig (gcc-8): 2 errors
    nlm_xlp_defconfig (gcc-8): 2 errors
    nlm_xlr_defconfig (gcc-8): 1 error, 1 warning
    omega2p_defconfig (gcc-8): 2 errors
    pistachio_defconfig (gcc-8): 2 errors
    pnx8335_stb225_defconfig (gcc-8): 2 errors
    qi_lb60_defconfig (gcc-8): 2 errors
    rb532_defconfig (gcc-8): 2 errors
    rbtx49xx_defconfig (gcc-8): 2 errors
    rm200_defconfig (gcc-8): 2 errors
    rt305x_defconfig (gcc-8): 2 errors
    sb1250_swarm_defconfig (gcc-8): 2 errors, 4 warnings
    tb0219_defconfig (gcc-8): 2 errors
    tb0226_defconfig (gcc-8): 2 errors
    tb0287_defconfig (gcc-8): 2 errors
    vocore2_defconfig (gcc-8): 2 errors
    workpad_defconfig (gcc-8): 2 errors
    xilfpga_defconfig (gcc-8): 2 errors
    xway_defconfig (gcc-8): 2 errors

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 2 errors, 1 warning

Errors summary:

    169  net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first=
 use in this function); did you mean 'msg_queue'?
    169  net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' un=
declared (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?
    1    cc1: error: '-march=3Dr3900' requires '-mfp32'
    1    cc1: error: '-march=3Dr3000' requires '-mfp32'
    1    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise co=
mparison always evaluates to false [-Werror=3Dtautological-compare]

Warnings summary:

    98   fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
    14   arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is n=
ot used [-Wunused-value]
    8    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOT=
LB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (C=
AVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NL=
M_XLR_BOARD)
    2    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined =
but not used [-Wunused-function]
    1    {standard input}:29: Warning: macro instruction expanded into mult=
iple instructions
    1    cc1: all warnings being treated as errors
    1    .config:1023:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

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
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 4 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    cc1: error: '-march=3Dr3000' requires '-mfp32'

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    cc1: error: '-march=3Dr3900' requires '-mfp32'

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warning=
s, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    {standard input}:29: Warning: macro instruction expanded into multiple =
instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise compari=
son always evaluates to false [-Werror=3Dtautological-compare]

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings=
, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings=
, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 4 warnings, =
0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

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
    .config:1023:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 3 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 3 warnings, 0=
 section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1278:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'msg_queue'?
    net/ipv4/tcp_output.c:1278:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
