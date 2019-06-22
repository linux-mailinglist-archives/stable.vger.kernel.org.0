Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024634F52C
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 12:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfFVKSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 06:18:44 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:51212 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFVKSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 06:18:44 -0400
Received: by mail-wm1-f50.google.com with SMTP id 207so8418725wma.1
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 03:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nN7ME6i2/kx2kvNl6DJBdPLObREUy8U+HK2w32evkNA=;
        b=JUSYInaMdqey2ZwBy75e7bOja9fVxYn57qldhe1ALt8dKqa5TPIszadFcLH2x3mJho
         JIM0fBs3kgez8+ktvexb2qWJTWcvCS/+saVO2p3kSWlRkKH5j1dHQSZo6qecmFHH2dd2
         U10mW9zBbD7+4+0jbZpJqGjVtr5VIdl61AmhuWqnEAGgDcJgiVl1pBtJRt17SS7Q1VFn
         0DLean5q/9J5klTnEK+tgU9dQfLJX3GtGmFERY20ooO9CI/cmWFmRykzhHfeXaNcDZZE
         3aa7NTVkUflgksJBxRFmzOqxB54vX/JyJiE1KUny2c0zTQ7e7RAXRErdATAufuLgBt6d
         P2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nN7ME6i2/kx2kvNl6DJBdPLObREUy8U+HK2w32evkNA=;
        b=sAej+r4s2fyrUS+B7QVpCL/QzJhjBtzlQXwv1bRC9cnZRbjFzgDCSYNc1dc0Ihv4wz
         y6zoTC7yb5YXGPbCGkHieZqjE1tVnMETSNBPY9DsUmb+Tacs2HYMknLj/6sDBGeSTdN6
         5+SnhAMBMYI+feskhqEucILwsS9+CiaOLTCzVm4C77KAdea4+7MctEsIwPsBQ1sLewwT
         9yQsoDa9AEpC89oAfyNlRnRoheTp81ZbBiy7mg2376/d96AYuXB8g7eDwJP6EoJI7hoZ
         lNeGE3t2uvndk1GdRTAv6CpIZS+HVBMZJk/1xEh4vfSuBtIsAqkKivpkoWEYImY9ZFXp
         mgPw==
X-Gm-Message-State: APjAAAVHOtDILZCA6PfORyd+thIcZvDBm9Sc/qxJdlTG5yCcrLGieVVP
        gGPLsodEgunFw0eaVUSlFzj5OKljFC3iFg==
X-Google-Smtp-Source: APXvYqz4YMInqi7piyFmlAUlabxI2ClbifcgUAqaz8yxBV+9ReljNM+i/iykmLEroJ9wPw2zAXOAIg==
X-Received: by 2002:a1c:e356:: with SMTP id a83mr7947524wmh.38.1561198713910;
        Sat, 22 Jun 2019 03:18:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j189sm7641334wmb.48.2019.06.22.03.18.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 03:18:33 -0700 (PDT)
Message-ID: <5d0e0079.1c69fb81.d5b72.aac1@mx.google.com>
Date:   Sat, 22 Jun 2019 03:18:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.4.183-2-g7a2e13b64534
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y build: 190 builds: 162 failed, 28 passed,
 337 errors, 3005 warnings (v4.4.183-2-g7a2e13b64534)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 162 failed, 28 passed, 337 errors,=
 3005 warnings (v4.4.183-2-g7a2e13b64534)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.183-2-g7a2e13b64534/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.183-2-g7a2e13b64534
Git Commit: 7a2e13b64534b5cbd4e5fb29fc1dbb8a5514d81d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
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
    assabet_defconfig: (gcc-8) FAIL
    at91_dt_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    bcm_defconfig: (gcc-8) FAIL
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
    qcom_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    realview-smp_defconfig: (gcc-8) FAIL
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
    ar7_defconfig: (gcc-8) FAIL
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
    loongson3_defconfig: (gcc-8) FAIL
    ls1b_defconfig: (gcc-8) FAIL
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
    pistachio_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    sead3_defconfig: (gcc-8) FAIL
    sead3micro_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 679 warnings
    axs103_defconfig (gcc-8): 3 warnings
    axs103_smp_defconfig (gcc-8): 3 warnings
    nsim_hs_defconfig (gcc-8): 3 warnings
    nsim_hs_smp_defconfig (gcc-8): 3 warnings
    nsimosci_hs_defconfig (gcc-8): 3 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 3 warnings
    tinyconfig (gcc-8): 683 warnings
    vdk_hs38_defconfig (gcc-8): 2 errors, 19 warnings
    vdk_hs38_smp_defconfig (gcc-8): 2 errors, 20 warnings

arm64:
    defconfig (gcc-8): 2 errors
    tinyconfig (gcc-8): 1 warning

arm:
    acs5k_defconfig (gcc-8): 2 errors
    acs5k_tiny_defconfig (gcc-8): 2 errors
    am200epdkit_defconfig (gcc-8): 2 errors
    assabet_defconfig (gcc-8): 2 errors
    at91_dt_defconfig (gcc-8): 2 errors
    axm55xx_defconfig (gcc-8): 2 errors
    badge4_defconfig (gcc-8): 2 errors
    bcm2835_defconfig (gcc-8): 2 errors
    bcm_defconfig (gcc-8): 2 errors
    cerfcube_defconfig (gcc-8): 2 errors
    clps711x_defconfig (gcc-8): 2 errors, 1 warning
    cm_x2xx_defconfig (gcc-8): 2 errors
    cm_x300_defconfig (gcc-8): 2 errors
    colibri_pxa270_defconfig (gcc-8): 2 errors
    colibri_pxa300_defconfig (gcc-8): 2 errors
    collie_defconfig (gcc-8): 2 errors
    corgi_defconfig (gcc-8): 2 errors
    davinci_all_defconfig (gcc-8): 2 errors, 1 warning
    dove_defconfig (gcc-8): 2 errors
    ebsa110_defconfig (gcc-8): 2 errors
    efm32_defconfig (gcc-8): 2 errors
    em_x270_defconfig (gcc-8): 2 errors
    ep93xx_defconfig (gcc-8): 2 errors
    eseries_pxa_defconfig (gcc-8): 2 errors
    exynos_defconfig (gcc-8): 2 errors
    ezx_defconfig (gcc-8): 2 errors
    footbridge_defconfig (gcc-8): 2 errors
    h3600_defconfig (gcc-8): 2 errors
    h5000_defconfig (gcc-8): 2 errors
    hackkit_defconfig (gcc-8): 2 errors
    hisi_defconfig (gcc-8): 2 errors
    imote2_defconfig (gcc-8): 2 errors
    imx_v4_v5_defconfig (gcc-8): 2 errors
    imx_v6_v7_defconfig (gcc-8): 2 errors
    integrator_defconfig (gcc-8): 2 errors
    iop13xx_defconfig (gcc-8): 2 errors
    iop32x_defconfig (gcc-8): 2 errors
    iop33x_defconfig (gcc-8): 2 errors
    ixp4xx_defconfig (gcc-8): 2 errors
    jornada720_defconfig (gcc-8): 2 errors
    keystone_defconfig (gcc-8): 2 errors
    ks8695_defconfig (gcc-8): 2 errors
    lart_defconfig (gcc-8): 2 errors
    lpc18xx_defconfig (gcc-8): 2 errors
    lpc32xx_defconfig (gcc-8): 2 errors, 1 warning
    lpd270_defconfig (gcc-8): 2 errors
    lubbock_defconfig (gcc-8): 2 errors
    magician_defconfig (gcc-8): 2 errors
    mainstone_defconfig (gcc-8): 2 errors
    mini2440_defconfig (gcc-8): 2 errors
    mmp2_defconfig (gcc-8): 2 errors
    moxart_defconfig (gcc-8): 2 errors
    multi_v5_defconfig (gcc-8): 2 errors
    multi_v7_defconfig (gcc-8): 2 errors, 1 warning
    mv78xx0_defconfig (gcc-8): 2 errors
    mvebu_v5_defconfig (gcc-8): 2 errors
    mvebu_v7_defconfig (gcc-8): 2 errors
    mxs_defconfig (gcc-8): 2 errors, 1 warning
    neponset_defconfig (gcc-8): 2 errors
    netwinder_defconfig (gcc-8): 2 errors
    netx_defconfig (gcc-8): 2 errors
    nhk8815_defconfig (gcc-8): 2 errors
    omap1_defconfig (gcc-8): 2 errors
    omap2plus_defconfig (gcc-8): 2 errors, 1 warning
    orion5x_defconfig (gcc-8): 2 errors
    palmz72_defconfig (gcc-8): 2 errors
    pcm027_defconfig (gcc-8): 2 errors
    pleb_defconfig (gcc-8): 2 errors
    pxa168_defconfig (gcc-8): 2 errors
    pxa255-idp_defconfig (gcc-8): 2 errors
    pxa3xx_defconfig (gcc-8): 2 errors
    pxa910_defconfig (gcc-8): 2 errors
    qcom_defconfig (gcc-8): 2 errors
    raumfeld_defconfig (gcc-8): 2 errors
    realview-smp_defconfig (gcc-8): 2 errors
    realview_defconfig (gcc-8): 2 errors
    rpc_defconfig (gcc-8): 2 errors
    s3c2410_defconfig (gcc-8): 2 errors
    sama5_defconfig (gcc-8): 2 errors
    shannon_defconfig (gcc-8): 2 errors
    shmobile_defconfig (gcc-8): 2 errors
    simpad_defconfig (gcc-8): 2 errors
    socfpga_defconfig (gcc-8): 2 errors
    spear13xx_defconfig (gcc-8): 2 errors
    spitz_defconfig (gcc-8): 2 errors
    sunxi_defconfig (gcc-8): 2 errors
    tegra_defconfig (gcc-8): 2 errors
    trizeps4_defconfig (gcc-8): 2 errors
    u8500_defconfig (gcc-8): 2 errors
    versatile_defconfig (gcc-8): 2 errors
    vexpress_defconfig (gcc-8): 2 errors
    viper_defconfig (gcc-8): 2 errors
    vt8500_v6_v7_defconfig (gcc-8): 2 errors
    xcep_defconfig (gcc-8): 2 errors
    zeus_defconfig (gcc-8): 2 errors

i386:
    i386_defconfig (gcc-8): 2 errors

mips:
    allnoconfig (gcc-8): 49 warnings
    ar7_defconfig (gcc-8): 2 errors, 49 warnings
    ath79_defconfig (gcc-8): 2 errors, 49 warnings
    bcm47xx_defconfig (gcc-8): 2 errors
    bcm63xx_defconfig (gcc-8): 2 errors, 49 warnings
    bigsur_defconfig (gcc-8): 16 errors, 5 warnings
    bmips_be_defconfig (gcc-8): 2 errors
    bmips_stb_defconfig (gcc-8): 2 errors
    capcella_defconfig (gcc-8): 2 errors
    cavium_octeon_defconfig (gcc-8): 2 errors
    ci20_defconfig (gcc-8): 2 errors, 49 warnings
    cobalt_defconfig (gcc-8): 2 errors
    db1xxx_defconfig (gcc-8): 2 errors
    decstation_defconfig (gcc-8): 1 error
    e55_defconfig (gcc-8): 49 warnings
    fuloong2e_defconfig (gcc-8): 2 errors
    gpr_defconfig (gcc-8): 2 errors, 49 warnings
    ip22_defconfig (gcc-8): 2 errors
    ip27_defconfig (gcc-8): 2 errors
    ip28_defconfig (gcc-8): 2 errors
    ip32_defconfig (gcc-8): 2 errors, 49 warnings
    jazz_defconfig (gcc-8): 2 errors, 49 warnings
    jmr3927_defconfig (gcc-8): 1 error
    lasat_defconfig (gcc-8): 2 errors, 49 warnings
    lemote2f_defconfig (gcc-8): 2 errors, 49 warnings
    loongson3_defconfig (gcc-8): 2 errors
    ls1b_defconfig (gcc-8): 2 errors, 49 warnings
    malta_defconfig (gcc-8): 2 errors, 49 warnings
    malta_kvm_defconfig (gcc-8): 2 errors
    malta_kvm_guest_defconfig (gcc-8): 2 errors
    malta_qemu_32r6_defconfig (gcc-8): 2 errors
    maltaaprp_defconfig (gcc-8): 2 errors
    maltasmvp_defconfig (gcc-8): 2 errors
    maltasmvp_eva_defconfig (gcc-8): 2 errors, 49 warnings
    maltaup_defconfig (gcc-8): 2 errors, 49 warnings
    maltaup_xpa_defconfig (gcc-8): 2 errors
    markeins_defconfig (gcc-8): 2 errors, 49 warnings
    mips_paravirt_defconfig (gcc-8): 2 errors, 49 warnings
    mpc30x_defconfig (gcc-8): 2 errors
    msp71xx_defconfig (gcc-8): 2 errors, 49 warnings
    mtx1_defconfig (gcc-8): 2 errors, 49 warnings
    nlm_xlp_defconfig (gcc-8): 2 errors, 49 warnings
    nlm_xlr_defconfig (gcc-8): 1 error, 1 warning
    pistachio_defconfig (gcc-8): 2 errors, 49 warnings
    pnx8335_stb225_defconfig (gcc-8): 2 errors
    qi_lb60_defconfig (gcc-8): 2 errors, 49 warnings
    rb532_defconfig (gcc-8): 2 errors, 49 warnings
    rbtx49xx_defconfig (gcc-8): 2 errors, 49 warnings
    rm200_defconfig (gcc-8): 2 errors, 49 warnings
    rt305x_defconfig (gcc-8): 2 errors
    sb1250_swarm_defconfig (gcc-8): 16 errors, 5 warnings
    sead3_defconfig (gcc-8): 2 errors, 49 warnings
    sead3micro_defconfig (gcc-8): 2 errors
    tb0219_defconfig (gcc-8): 2 errors
    tb0226_defconfig (gcc-8): 2 errors, 49 warnings
    tb0287_defconfig (gcc-8): 2 errors, 49 warnings
    tinyconfig (gcc-8): 49 warnings
    workpad_defconfig (gcc-8): 2 errors, 49 warnings
    xilfpga_defconfig (gcc-8): 49 warnings
    xway_defconfig (gcc-8): 2 errors, 49 warnings

x86_64:
    x86_64_defconfig (gcc-8): 2 errors

Errors summary:

    150  net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first=
 use in this function); did you mean 'tcp_prequeue'?
    150  net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' un=
declared (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?
    2    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' dec=
lared inside parameter list will not be visible outside of this definition =
or declaration [-Werror]
    2    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:65:63: error: 'struct page' declared insid=
e parameter list will not be visible outside of this definition or declarat=
ion [-Werror]
    2    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' de=
clared inside parameter list will not be visible outside of this definition=
 or declaration [-Werror]
    2    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'swiotlb_free'
    2    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' d=
eclared inside parameter list will not be visible outside of this definitio=
n or declaration [-Werror]
    2    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' d=
eclared inside parameter list will not be visible outside of this definitio=
n or declaration [-Werror]
    2    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', '=
;', 'asm' or '__attribute__' before 'plat_swiotlb_setup'
    1    cc1: error: '-march=3Dr3900' requires '-mfp32'
    1    cc1: error: '-march=3Dr3000' requires '-mfp32'
    1    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise co=
mparison always evaluates to false [-Werror=3Dtautological-compare]

Warnings summary:

    1376  arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean exp=
ression [-Wbool-operation]
    707  arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    670  cc1: warning: '-mno-mpy' is deprecated
    192  arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expr=
ession [-Wbool-operation]
    18   fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-voi=
d function [-Wreturn-type]
    8    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOT=
LB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (C=
AVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NL=
M_XLR_BOARD)
    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    4    kernel/sched/core.c:3089:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    3    cc1: all warnings being treated as errors
    2    net/core/ethtool.c:260:1: warning: control reaches end of non-void=
 function [-Wreturn-type]
    2    fs/posix_acl.c:34:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    2    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion =
from 'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070=
' to '22' [-Woverflow]
    2    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches e=
nd of non-void function [-Wreturn-type]
    2    block/cfq-iosched.c:3783:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    2    arch/arc/kernel/unwind.c:186:14: warning: 'unw_hdr_alloc' defined =
but not used [-Wunused-function]
    2    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in exp=
ression of type 'int' results in '-1073741824' [-Woverflow]
    1    lib/cpumask.c:178:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    1    arch/arm64/kernel/vdso.c:118:6: warning: 'memcmp' reading 4 bytes =
from a region of size 1 [-Wstringop-overflow=3D]
    1    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' de=
claration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate 'const'=
 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate 'const'=
 declaration specifier [-Wduplicate-decl-specifier]
    1    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate=
 'const' declaration specifier [-Wduplicate-decl-specifier]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 679 warnings, 0 section =
mismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

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
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 section =
mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 s=
ection mismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 5 warnings, 0 sec=
tion mismatches

Errors:
    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:65:63: error: 'struct page' declared inside par=
ameter list will not be visible outside of this definition or declaration [=
-Werror]
    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' declared=
 inside parameter list will not be visible outside of this definition or de=
claration [-Werror]
    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', 'asm' =
or '__attribute__' before 'swiotlb_free'
    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'plat_swiotlb_setup'

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
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning: duplicate 'con=
st' declaration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    cc1: error: '-march=3Dr3000' requires '-mfp32'

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section mi=
smatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    cc1: error: '-march=3Dr3900' requires '-mfp32'

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplicate 'const' decl=
aration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warning=
s, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warning=
s, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings=
, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings=
, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion from =
'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070' to =
'22' [-Woverflow]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate 'const' declara=
tion specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings=
, 0 section mismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

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
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    drivers/mfd/omap-usb-tll.c:88:53: warning: overflow in conversion from =
'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070' to =
'22' [-Woverflow]

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 =
section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings=
, 0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 s=
ection mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section =
mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 16 errors, 5 warnings,=
 0 section mismatches

Errors:
    include/linux/swiotlb.h:45:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:49:28: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:53:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:67:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:65:63: error: 'struct page' declared inside par=
ameter list will not be visible outside of this definition or declaration [=
-Werror]
    include/linux/swiotlb.h:70:29: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:75:14: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:79:9: error: 'enum dma_data_direction' declared=
 inside parameter list will not be visible outside of this definition or de=
claration [-Werror]
    include/linux/swiotlb.h:83:13: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:87:27: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:92:26: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:96:21: error: 'enum dma_data_direction' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration [-Werror]
    include/linux/swiotlb.h:100:29: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:104:24: error: 'enum dma_data_direction' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration [-Werror]
    include/linux/swiotlb.h:113:20: error: expected '=3D', ',', ';', 'asm' =
or '__attribute__' before 'swiotlb_free'
    arch/mips/sibyte/common/dma.c:11:13: error: expected '=3D', ',', ';', '=
asm' or '__attribute__' before 'plat_swiotlb_setup'

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
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
sead3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
sead3micro_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another ISA =
mode
    arch/mips/kernel/genex.S:271: Error: branch to a symbol in another ISA =
mode

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

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
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    arch/arm64/kernel/vdso.c:118:6: warning: 'memcmp' reading 4 bytes from =
a region of size 1 [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 section m=
ismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 683 warnings, 0 section m=
ismatches

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    cc1: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 19 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arch/arc/kernel/unwind.c:186:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on of type 'int' results in '-1073741824' [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    block/cfq-iosched.c:3783:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches end of=
 non-void function [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 20 warnings, =
0 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arc-elf32-gcc: warning: '-mno-mpy' is deprecated
    arch/arc/kernel/unwind.c:186:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    kernel/sched/core.c:3089:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    block/cfq-iosched.c:3783:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    drivers/base/regmap/regmap-mmio.c:86:1: warning: control reaches end of=
 non-void function [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:411:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    net/core/ethtool.c:260:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    lib/cpumask.c:178:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    arch/arc/include/asm/elf.h:58:29: warning: integer overflow in expressi=
on of type 'int' results in '-1073741824' [-Woverflow]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 49 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 49 warnings, 0 secti=
on mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

Warnings:
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:832:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:837:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared (first use =
in this function); did you mean 'tcp_prequeue'?
    net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undecla=
red (first use in this function); did you mean 'SOCK_USE_WRITE_QUEUE'?

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
