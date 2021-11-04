Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11F44537B
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 14:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhKDNFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 09:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhKDNFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 09:05:40 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09ABC061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 06:03:02 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id j9so5365807pgh.1
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 06:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aMJdn9+NnyHXtS2ojsN6vwTC+czE0v7QUF/nqLXcq3g=;
        b=wRLr4gUMjAju+vS0zEwa6b42fn4hkL7go21Nib+/ZSvm43ZAcQVTzrjBSAZs9PXFlg
         37i0b+iDH8aTosXciz9PnfSegOKwMIedXlyGpA9Dpj9+MszWBrEDHFkK5DiJzO/rggVA
         c4QlqPdDgP4otCeHFky/XzVnAhgbvupDtRKxwx1kdDrJTPHfww2aU/eQufBXyf5MO4WB
         fLnRpsLgtyax4NAtLY1kqxh89WeViHAEhEUAnSPSTInhTQsjqvsALfHqJgEpx/l/UTFd
         ET8+j0GAgywpUD6T8n3urv/crHseowfb4ZFBzR2gSoZZM70hHcXeJ+M74BLaj5G/yk1Z
         5LDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aMJdn9+NnyHXtS2ojsN6vwTC+czE0v7QUF/nqLXcq3g=;
        b=Bs80OHmF/99n3r1VDQ+hKMwqBz4s1Y0gI4ZvQBJp0CNoJxvq4Mi5YSqRPJtZr9iP9y
         fi4w1BUpsW3n/ISoBUivjC2gWEqbajMz9D8RpKMTsITA18jFqxRvkjzM4PdS3oXxVRhT
         6YIwIGhgn/HI6nbdpPfRfL9BRmrUKiw5Sb4gZYArXBQkh8ugjYARZUpnUhqFkXPpsSEL
         +LVLVF+E10/Yvn8xaZY7aXBSDux15LSvmRgRCtcq/nkAsON1nbTVsDyHGDakMOvnOvon
         d0fyHsAXrs9CThtdd/Zz3tf8jXQW4ipUn/pw1sSy594f4DmnT5XAL2oaK0SBw1n5DnZW
         hDEQ==
X-Gm-Message-State: AOAM531cUcd89q+2gVoiOYnVPR6uc1eAsp6x7d6Hp+RvYnyE+4Z3LfEc
        IyDBktxOQENS5UUX5e8lDlMKxKQP6lRfATpF
X-Google-Smtp-Source: ABdhPJzTeGCW0A1spz+NU4V5Tx8WGN8vlaIo8ctKprLIds5fDdUquDfh2rdCg3ZoufnRzPEQhhVkbw==
X-Received: by 2002:a63:6c44:: with SMTP id h65mr35942842pgc.423.1636030979108;
        Thu, 04 Nov 2021 06:02:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22sm4839743pfe.76.2021.11.04.06.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 06:02:58 -0700 (PDT)
Message-ID: <6183da02.1c69fb81.a09ab.07b1@mx.google.com>
Date:   Thu, 04 Nov 2021 06:02:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.77-10-gb4e5b555340f
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/5.10 build: 197 builds: 194 failed, 3 passed,
 195 errors, 196 warnings (v5.10.77-10-gb4e5b555340f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 197 builds: 194 failed, 3 passed, 195 errors, 1=
96 warnings (v5.10.77-10-gb4e5b555340f)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.77-10-gb4e5b555340f/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.77-10-gb4e5b555340f
Git Commit: b4e5b555340f75d9f4b40fd947d686521e3558b2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-10) FAIL
    axs103_defconfig: (gcc-10) FAIL
    axs103_smp_defconfig: (gcc-10) FAIL
    haps_hs_defconfig: (gcc-10) FAIL
    haps_hs_smp_defconfig: (gcc-10) FAIL
    hsdk_defconfig: (gcc-10) FAIL
    nsimosci_hs_defconfig: (gcc-10) FAIL
    nsimosci_hs_smp_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    vdk_hs38_defconfig: (gcc-10) FAIL
    vdk_hs38_smp_defconfig: (gcc-10) FAIL

arm64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

arm:
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
    milbeaut_m10v_defconfig: (gcc-10) FAIL
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
    nhk8815_defconfig: (gcc-10) FAIL
    omap1_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    orion5x_defconfig: (gcc-10) FAIL
    oxnas_v6_defconfig: (gcc-10) FAIL
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
    ci20_defconfig: (gcc-10) FAIL
    cobalt_defconfig: (gcc-10) FAIL
    cu1000-neo_defconfig: (gcc-10) FAIL
    cu1830-neo_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    decstation_defconfig: (gcc-10) FAIL
    decstation_r4k_defconfig: (gcc-10) FAIL
    e55_defconfig: (gcc-10) FAIL
    fuloong2e_defconfig: (gcc-10) FAIL
    gcw0_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip22_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    ip32_defconfig: (gcc-10) FAIL
    jazz_defconfig: (gcc-10) FAIL
    jmr3927_defconfig: (gcc-10) FAIL
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
    mpc30x_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL
    nlm_xlp_defconfig: (gcc-10) FAIL
    nlm_xlr_defconfig: (gcc-10) FAIL
    omega2p_defconfig: (gcc-10) FAIL
    pic32mzda_defconfig: (gcc-10) FAIL
    pistachio_defconfig: (gcc-10) FAIL
    qi_lb60_defconfig: (gcc-10) FAIL
    rb532_defconfig: (gcc-10) FAIL
    rbtx49xx_defconfig: (gcc-10) FAIL
    rm200_defconfig: (gcc-10) FAIL
    rs90_defconfig: (gcc-10) FAIL
    rt305x_defconfig: (gcc-10) FAIL
    sb1250_swarm_defconfig: (gcc-10) FAIL
    tb0219_defconfig: (gcc-10) FAIL
    tb0226_defconfig: (gcc-10) FAIL
    tb0287_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    vocore2_defconfig: (gcc-10) FAIL
    workpad_defconfig: (gcc-10) FAIL
    xway_defconfig: (gcc-10) FAIL

riscv:
    allnoconfig: (gcc-10) FAIL
    defconfig: (gcc-10) FAIL
    nommu_k210_defconfig: (gcc-10) FAIL
    nommu_virt_defconfig: (gcc-10) FAIL
    rv32_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

x86_64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    x86_64_defconfig: (gcc-10) FAIL
    x86_64_defconfig+x86-chromebook: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-10): 1 error, 1 warning
    axs103_defconfig (gcc-10): 1 error, 1 warning
    axs103_smp_defconfig (gcc-10): 1 error, 1 warning
    haps_hs_defconfig (gcc-10): 1 error, 1 warning
    haps_hs_smp_defconfig (gcc-10): 1 error, 1 warning
    hsdk_defconfig (gcc-10): 1 error, 1 warning
    nsimosci_hs_defconfig (gcc-10): 1 error, 1 warning
    nsimosci_hs_smp_defconfig (gcc-10): 1 error, 1 warning
    tinyconfig (gcc-10): 1 error, 1 warning
    vdk_hs38_defconfig (gcc-10): 1 error, 1 warning
    vdk_hs38_smp_defconfig (gcc-10): 1 error, 1 warning

arm64:
    allnoconfig (gcc-10): 1 error, 1 warning
    tinyconfig (gcc-10): 1 error, 1 warning

arm:
    allnoconfig (gcc-10): 1 error, 1 warning
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
    cns3420vb_defconfig (gcc-10): 1 error, 1 warning
    colibri_pxa270_defconfig (gcc-10): 1 error, 1 warning
    colibri_pxa300_defconfig (gcc-10): 1 error, 1 warning
    collie_defconfig (gcc-10): 1 error, 1 warning
    corgi_defconfig (gcc-10): 1 error, 1 warning
    davinci_all_defconfig (gcc-10): 1 error, 1 warning
    dove_defconfig (gcc-10): 1 error, 1 warning
    ebsa110_defconfig (gcc-10): 1 error, 1 warning
    efm32_defconfig (gcc-10): 1 error, 1 warning
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
    imote2_defconfig (gcc-10): 1 error, 1 warning
    imx_v4_v5_defconfig (gcc-10): 1 error, 1 warning
    imx_v6_v7_defconfig (gcc-10): 1 error, 1 warning
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
    milbeaut_m10v_defconfig (gcc-10): 1 error, 1 warning
    mini2440_defconfig (gcc-10): 1 error, 1 warning
    mmp2_defconfig (gcc-10): 1 error, 1 warning
    moxart_defconfig (gcc-10): 1 error, 1 warning
    mps2_defconfig (gcc-10): 1 error, 1 warning
    multi_v4t_defconfig (gcc-10): 1 error, 1 warning
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
    prima2_defconfig (gcc-10): 1 error, 1 warning
    pxa168_defconfig (gcc-10): 1 error, 1 warning
    pxa255-idp_defconfig (gcc-10): 1 error, 1 warning
    pxa3xx_defconfig (gcc-10): 1 error, 1 warning
    pxa910_defconfig (gcc-10): 1 error, 1 warning
    pxa_defconfig (gcc-10): 1 error, 1 warning
    qcom_defconfig (gcc-10): 1 error, 1 warning
    realview_defconfig (gcc-10): 1 error, 1 warning
    rpc_defconfig (gcc-10): 4 errors
    s3c2410_defconfig (gcc-10): 1 error, 1 warning
    s3c6400_defconfig (gcc-10): 1 error, 1 warning
    s5pv210_defconfig (gcc-10): 1 error, 1 warning
    sama5_defconfig (gcc-10): 1 error, 1 warning
    shannon_defconfig (gcc-10): 1 error, 1 warning
    shmobile_defconfig (gcc-10): 1 error, 1 warning
    simpad_defconfig (gcc-10): 1 error, 1 warning
    socfpga_defconfig (gcc-10): 1 error, 1 warning
    spear13xx_defconfig (gcc-10): 1 error, 1 warning
    spear3xx_defconfig (gcc-10): 1 error, 1 warning
    spear6xx_defconfig (gcc-10): 1 error, 1 warning
    spitz_defconfig (gcc-10): 1 error, 1 warning
    stm32_defconfig (gcc-10): 1 error, 1 warning
    sunxi_defconfig (gcc-10): 1 error, 1 warning
    tango4_defconfig (gcc-10): 1 error, 1 warning
    tct_hammer_defconfig (gcc-10): 1 error, 1 warning
    tegra_defconfig (gcc-10): 1 error, 1 warning
    tinyconfig (gcc-10): 1 error, 1 warning
    trizeps4_defconfig (gcc-10): 1 error, 1 warning
    u300_defconfig (gcc-10): 1 error, 1 warning
    u8500_defconfig (gcc-10): 1 error, 1 warning
    versatile_defconfig (gcc-10): 1 error, 1 warning
    vexpress_defconfig (gcc-10): 1 error, 1 warning
    vf610m4_defconfig (gcc-10): 1 error, 1 warning
    viper_defconfig (gcc-10): 1 error, 1 warning
    vt8500_v6_v7_defconfig (gcc-10): 1 error, 1 warning
    xcep_defconfig (gcc-10): 1 error, 1 warning
    zeus_defconfig (gcc-10): 1 error, 1 warning
    zx_defconfig (gcc-10): 1 error, 1 warning

i386:
    allnoconfig (gcc-10): 1 error, 1 warning
    i386_defconfig (gcc-10): 1 error, 1 warning
    tinyconfig (gcc-10): 1 error, 1 warning

mips:
    32r2el_defconfig (gcc-10): 1 error, 1 warning
    allnoconfig (gcc-10): 1 error, 1 warning
    ar7_defconfig (gcc-10): 1 error, 1 warning
    ath25_defconfig (gcc-10): 1 error, 1 warning
    ath79_defconfig (gcc-10): 1 error, 1 warning
    bcm47xx_defconfig (gcc-10): 1 error, 1 warning
    bcm63xx_defconfig (gcc-10): 1 error, 1 warning
    bigsur_defconfig (gcc-10): 1 error, 1 warning
    bmips_be_defconfig (gcc-10): 1 error, 1 warning
    bmips_stb_defconfig (gcc-10): 1 error, 1 warning
    capcella_defconfig (gcc-10): 1 error, 1 warning
    ci20_defconfig (gcc-10): 1 error, 1 warning
    cobalt_defconfig (gcc-10): 1 error, 1 warning
    cu1000-neo_defconfig (gcc-10): 1 error, 1 warning
    cu1830-neo_defconfig (gcc-10): 1 error, 1 warning
    db1xxx_defconfig (gcc-10): 1 error, 1 warning
    decstation_64_defconfig (gcc-10): 1 warning
    decstation_defconfig (gcc-10): 1 error, 2 warnings
    decstation_r4k_defconfig (gcc-10): 1 error, 2 warnings
    e55_defconfig (gcc-10): 1 error, 1 warning
    fuloong2e_defconfig (gcc-10): 1 error, 1 warning
    gcw0_defconfig (gcc-10): 1 error, 1 warning
    gpr_defconfig (gcc-10): 1 error, 1 warning
    ip22_defconfig (gcc-10): 1 error, 1 warning
    ip32_defconfig (gcc-10): 1 error, 1 warning
    jazz_defconfig (gcc-10): 1 error, 1 warning
    jmr3927_defconfig (gcc-10): 1 error, 1 warning
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson1b_defconfig (gcc-10): 1 error, 1 warning
    loongson1c_defconfig (gcc-10): 1 error, 1 warning
    loongson3_defconfig (gcc-10): 1 error, 1 warning
    malta_defconfig (gcc-10): 1 error, 1 warning
    malta_kvm_defconfig (gcc-10): 1 error, 1 warning
    malta_kvm_guest_defconfig (gcc-10): 1 error, 1 warning
    malta_qemu_32r6_defconfig (gcc-10): 1 error, 1 warning
    maltaaprp_defconfig (gcc-10): 1 error, 1 warning
    maltasmvp_defconfig (gcc-10): 1 error, 1 warning
    maltasmvp_eva_defconfig (gcc-10): 1 error, 1 warning
    maltaup_defconfig (gcc-10): 1 error, 1 warning
    maltaup_xpa_defconfig (gcc-10): 1 error, 1 warning
    mpc30x_defconfig (gcc-10): 1 error, 1 warning
    mtx1_defconfig (gcc-10): 1 error, 1 warning
    nlm_xlp_defconfig (gcc-10): 1 error, 1 warning
    nlm_xlr_defconfig (gcc-10): 1 error, 1 warning
    omega2p_defconfig (gcc-10): 1 error, 1 warning
    pic32mzda_defconfig (gcc-10): 1 error, 1 warning
    pistachio_defconfig (gcc-10): 1 error, 1 warning
    qi_lb60_defconfig (gcc-10): 1 error, 1 warning
    rb532_defconfig (gcc-10): 1 error, 1 warning
    rbtx49xx_defconfig (gcc-10): 1 error, 1 warning
    rm200_defconfig (gcc-10): 1 error, 1 warning
    rs90_defconfig (gcc-10): 1 error, 1 warning
    rt305x_defconfig (gcc-10): 1 error, 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 error, 1 warning
    tb0219_defconfig (gcc-10): 1 error, 1 warning
    tb0226_defconfig (gcc-10): 1 error, 1 warning
    tb0287_defconfig (gcc-10): 1 error, 1 warning
    tinyconfig (gcc-10): 1 error, 1 warning
    vocore2_defconfig (gcc-10): 1 error, 1 warning
    workpad_defconfig (gcc-10): 1 error, 1 warning
    xway_defconfig (gcc-10): 1 error, 1 warning

riscv:
    allnoconfig (gcc-10): 1 error, 1 warning
    defconfig (gcc-10): 1 error, 1 warning
    nommu_k210_defconfig (gcc-10): 1 error, 1 warning
    nommu_virt_defconfig (gcc-10): 1 error, 1 warning
    rv32_defconfig (gcc-10): 1 error, 3 warnings
    tinyconfig (gcc-10): 1 error, 1 warning

x86_64:
    allnoconfig (gcc-10): 1 error, 1 warning
    tinyconfig (gcc-10): 1 error, 1 warning
    x86_64_defconfig (gcc-10): 1 error, 1 warning
    x86_64_defconfig+x86-chromebook (gcc-10): 1 error, 1 warning

Errors summary:

    169  mm/memory.c:3929:15: error: implicit declaration of function =E2=
=80=98PageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]
    11   mm/page_alloc.c:1237:4: error: implicit declaration of function =
=E2=80=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHW=
Poison=E2=80=99? [-Werror=3Dimplicit-function-declaration]
    11   mm/memory.c:3929:15: error: implicit declaration of function 'Page=
HasHWPoisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-d=
eclaration]
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    191  cc1: some warnings being treated as errors
    3    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    1    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    1    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 =
section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings=
, 0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
ip32_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning=
, 0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning=
, 0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nommu_virt_defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
rs90_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 3 warnings, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function 'PageHasHW=
Poisoned'; did you mean 'PageHWPoison'? [-Werror=3Dimplicit-function-declar=
ation]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:1237:4: error: implicit declaration of function =E2=80=
=98ClearPageHasHWPoisoned=E2=80=99; did you mean =E2=80=98ClearPageHWPoison=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 1=
 warning, 0 section mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/memory.c:3929:15: error: implicit declaration of function =E2=80=98P=
ageHasHWPoisoned=E2=80=99; did you mean =E2=80=98PageHWPoison=E2=80=99? [-W=
error=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
