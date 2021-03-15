Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E1F33BF38
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 16:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhCOO66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242038AbhCOO6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 10:58:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6C1C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 07:58:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso12281592pjb.4
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 07:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WO9TPjsTlbKeFB+2R6ndRGFUD+Re5HgFdOsORYuAbs0=;
        b=TudOXKc49TcXVmEFVUjtdz4oFXOFlIapCawk8neWOtguysXJUSiMntZZ7JsCN9LEj9
         TCNNlaeU8OWkttjBHiRJyPo3jD8eaD+Qv2HUjN5ntFJ64/1uKrnb0BnD5m1dcWTeDP8i
         ZTdwxkclTse7fzduenUoB0g8IGsLkHIlCkEqYWjpRQw23luwa/EpQNKrDBf12SjiXonv
         UFBkRvD5sQ8b6k6Zn8KPWdZwzYvezgbdFiHqFG0uzTdYM50nZMwXZmoSgMIMcMgbK/Ut
         KAa6fc/hg9OUE4KKoOGrCLXGNP/n6Ry1GCULqXKsOH9FcgeuCXyRMIvqO70zEMPB4Lq5
         b/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WO9TPjsTlbKeFB+2R6ndRGFUD+Re5HgFdOsORYuAbs0=;
        b=p5SirxqW9CmoKNbbdA6kRnu19KR0W/7Z1geDbG4HqpJeX6E+HJGKsaQI2xRz/3Sj4E
         L0+yUHMyQSXEhuX6s3cwuXVH3EqYqIPVxZGz+vMD4j3F1W0+NSeoUZEO3FEcrpfEQ8FT
         JGKdO4X7b+q/Rfj19znwUjGbCOm4EJIDi97koyDXPyewSq3e7Cby57Hibn3MyAETP4ZT
         2n+8bXNelw+4x97GhcvIbVwzqsf2lvJcvHD/fmEypNjL8ALYvA3lQTL0G9Lgxf5+xUuu
         wBWe2E9+jatv3pgisiKRXFOOmD8BEE7pN8JI+7Bf6tcpnteCi7aY43gOsiUBiRt3vuDO
         ODsw==
X-Gm-Message-State: AOAM533GCxrnYWvdapOZ5g4MMfvCqV/shcNqgMwR3K05dTbreP69LwQm
        Wta7IseopoLQuLrtRFFAq/QtzOzSMyo1SA==
X-Google-Smtp-Source: ABdhPJzO/UslKYxPs/pxc4eGL81APcQ7ESWW22N5KUcKYcwTKxWJpIi4ZowZBgubYcK47Hr57CvrGg==
X-Received: by 2002:a17:902:e8d2:b029:e3:c3e5:98ae with SMTP id v18-20020a170902e8d2b02900e3c3e598aemr12016733plg.78.1615820289331;
        Mon, 15 Mar 2021 07:58:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t18sm7860526pgg.33.2021.03.15.07.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:58:08 -0700 (PDT)
Message-ID: <604f7600.1c69fb81.2c6e2.2c98@mx.google.com>
Date:   Mon, 15 Mar 2021 07:58:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-284-g8f3dde972600f
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 build: 196 builds: 196 failed, 0 passed,
 196 errors, 204 warnings (v5.10.23-284-g8f3dde972600f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 196 builds: 196 failed, 0 passed, 196 errors, 2=
04 warnings (v5.10.23-284-g8f3dde972600f)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.23-284-g8f3dde972600f/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.23-284-g8f3dde972600f
Git Commit: 8f3dde972600f1d60a4f6a6b2fdb569b4b8c077d
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
    hsdk_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL

arm64:
    allnoconfig: (gcc-8) FAIL
    defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm:
    allnoconfig: (gcc-8) FAIL
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
    cm_x300_defconfig: (gcc-8) FAIL
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    ebsa110_defconfig: (gcc-8) FAIL
    efm32_defconfig: (gcc-8) FAIL
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
    iop32x_defconfig: (gcc-8) FAIL
    ixp4xx_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc18xx_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    milbeaut_m10v_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    mps2_defconfig: (gcc-8) FAIL
    multi_v4t_defconfig: (gcc-8) FAIL
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
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa910_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
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
    stm32_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tango4_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    vf610m4_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    xcep_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    allnoconfig: (gcc-8) FAIL
    i386_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    allnoconfig: (gcc-8) FAIL
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
    cu1000-neo_defconfig: (gcc-8) FAIL
    cu1830-neo_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_64_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    decstation_r4k_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gcw0_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
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
    mpc30x_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    omega2p_defconfig: (gcc-8) FAIL
    pic32mzda_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    rs90_defconfig: (gcc-8) FAIL
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
    defconfig: (gcc-8) FAIL
    nommu_k210_defconfig: (gcc-8) FAIL
    nommu_virt_defconfig: (gcc-8) FAIL
    rv32_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

x86_64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 error, 1 warning
    axs103_defconfig (gcc-8): 1 error, 1 warning
    axs103_smp_defconfig (gcc-8): 1 error, 1 warning
    haps_hs_defconfig (gcc-8): 1 error, 1 warning
    haps_hs_smp_defconfig (gcc-8): 1 error, 1 warning
    hsdk_defconfig (gcc-8): 1 error, 1 warning
    nsimosci_hs_defconfig (gcc-8): 1 error, 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    vdk_hs38_defconfig (gcc-8): 1 error, 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 1 error, 1 warning

arm64:
    allnoconfig (gcc-8): 1 error, 1 warning
    defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

arm:
    allnoconfig (gcc-8): 1 error, 1 warning
    am200epdkit_defconfig (gcc-8): 1 error, 1 warning
    aspeed_g4_defconfig (gcc-8): 1 error, 1 warning
    aspeed_g5_defconfig (gcc-8): 1 error, 1 warning
    assabet_defconfig (gcc-8): 1 error, 1 warning
    at91_dt_defconfig (gcc-8): 1 error, 1 warning
    axm55xx_defconfig (gcc-8): 1 error, 1 warning
    badge4_defconfig (gcc-8): 1 error, 1 warning
    bcm2835_defconfig (gcc-8): 1 error, 1 warning
    cerfcube_defconfig (gcc-8): 1 error, 1 warning
    clps711x_defconfig (gcc-8): 1 error, 1 warning
    cm_x300_defconfig (gcc-8): 1 error, 1 warning
    cns3420vb_defconfig (gcc-8): 1 error, 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 error, 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 error, 1 warning
    collie_defconfig (gcc-8): 1 error, 1 warning
    corgi_defconfig (gcc-8): 1 error, 1 warning
    davinci_all_defconfig (gcc-8): 1 error, 1 warning
    dove_defconfig (gcc-8): 1 error, 1 warning
    ebsa110_defconfig (gcc-8): 1 error, 1 warning
    efm32_defconfig (gcc-8): 1 error, 1 warning
    ep93xx_defconfig (gcc-8): 1 error, 1 warning
    eseries_pxa_defconfig (gcc-8): 1 error, 1 warning
    exynos_defconfig (gcc-8): 1 error, 1 warning
    ezx_defconfig (gcc-8): 1 error, 1 warning
    footbridge_defconfig (gcc-8): 1 error, 1 warning
    gemini_defconfig (gcc-8): 1 error, 1 warning
    h3600_defconfig (gcc-8): 1 error, 1 warning
    h5000_defconfig (gcc-8): 1 error, 1 warning
    hackkit_defconfig (gcc-8): 1 error, 1 warning
    hisi_defconfig (gcc-8): 1 error, 1 warning
    imote2_defconfig (gcc-8): 1 error, 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 error, 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 error, 1 warning
    integrator_defconfig (gcc-8): 1 error, 1 warning
    iop32x_defconfig (gcc-8): 1 error, 1 warning
    ixp4xx_defconfig (gcc-8): 1 error, 1 warning
    jornada720_defconfig (gcc-8): 1 error, 1 warning
    keystone_defconfig (gcc-8): 1 error, 1 warning
    lart_defconfig (gcc-8): 1 error, 1 warning
    lpc18xx_defconfig (gcc-8): 1 error, 1 warning
    lpc32xx_defconfig (gcc-8): 1 error, 1 warning
    lpd270_defconfig (gcc-8): 1 error, 1 warning
    lubbock_defconfig (gcc-8): 1 error, 1 warning
    magician_defconfig (gcc-8): 1 error, 1 warning
    mainstone_defconfig (gcc-8): 1 error, 1 warning
    milbeaut_m10v_defconfig (gcc-8): 1 error, 1 warning
    mini2440_defconfig (gcc-8): 1 error, 1 warning
    mmp2_defconfig (gcc-8): 1 error, 1 warning
    moxart_defconfig (gcc-8): 1 error, 1 warning
    mps2_defconfig (gcc-8): 1 error, 1 warning
    multi_v4t_defconfig (gcc-8): 1 error, 1 warning
    multi_v5_defconfig (gcc-8): 1 error, 1 warning
    multi_v7_defconfig (gcc-8): 1 error, 1 warning
    mv78xx0_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v5_defconfig (gcc-8): 1 error, 1 warning
    mvebu_v7_defconfig (gcc-8): 1 error, 1 warning
    mxs_defconfig (gcc-8): 1 error, 1 warning
    neponset_defconfig (gcc-8): 1 error, 1 warning
    netwinder_defconfig (gcc-8): 1 error, 1 warning
    nhk8815_defconfig (gcc-8): 1 error, 1 warning
    omap1_defconfig (gcc-8): 1 error, 2 warnings
    omap2plus_defconfig (gcc-8): 1 error, 1 warning
    orion5x_defconfig (gcc-8): 1 error, 1 warning
    oxnas_v6_defconfig (gcc-8): 1 error, 1 warning
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
    rpc_defconfig (gcc-8): 1 error, 1 warning
    s3c2410_defconfig (gcc-8): 1 error, 1 warning
    s3c6400_defconfig (gcc-8): 1 error, 1 warning
    s5pv210_defconfig (gcc-8): 1 error, 1 warning
    sama5_defconfig (gcc-8): 1 error, 1 warning
    shannon_defconfig (gcc-8): 1 error, 1 warning
    shmobile_defconfig (gcc-8): 1 error, 1 warning
    simpad_defconfig (gcc-8): 1 error, 1 warning
    socfpga_defconfig (gcc-8): 1 error, 1 warning
    spear13xx_defconfig (gcc-8): 1 error, 1 warning
    spear3xx_defconfig (gcc-8): 1 error, 1 warning
    spear6xx_defconfig (gcc-8): 1 error, 1 warning
    spitz_defconfig (gcc-8): 1 error, 1 warning
    stm32_defconfig (gcc-8): 1 error, 1 warning
    sunxi_defconfig (gcc-8): 1 error, 1 warning
    tango4_defconfig (gcc-8): 1 error, 1 warning
    tct_hammer_defconfig (gcc-8): 1 error, 1 warning
    tegra_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    trizeps4_defconfig (gcc-8): 1 error, 1 warning
    u300_defconfig (gcc-8): 1 error, 1 warning
    u8500_defconfig (gcc-8): 1 error, 1 warning
    versatile_defconfig (gcc-8): 1 error, 1 warning
    vexpress_defconfig (gcc-8): 1 error, 1 warning
    vf610m4_defconfig (gcc-8): 1 error, 1 warning
    viper_defconfig (gcc-8): 1 error, 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 error, 1 warning
    xcep_defconfig (gcc-8): 1 error, 1 warning
    zeus_defconfig (gcc-8): 1 error, 1 warning
    zx_defconfig (gcc-8): 1 error, 1 warning

i386:
    allnoconfig (gcc-8): 1 error, 1 warning
    i386_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning

mips:
    32r2el_defconfig (gcc-8): 1 error, 1 warning
    allnoconfig (gcc-8): 1 error, 1 warning
    ar7_defconfig (gcc-8): 1 error, 1 warning
    ath25_defconfig (gcc-8): 1 error, 1 warning
    ath79_defconfig (gcc-8): 1 error, 1 warning
    bcm47xx_defconfig (gcc-8): 1 error, 1 warning
    bcm63xx_defconfig (gcc-8): 1 error, 1 warning
    bigsur_defconfig (gcc-8): 1 error, 1 warning
    bmips_be_defconfig (gcc-8): 1 error, 1 warning
    bmips_stb_defconfig (gcc-8): 1 error, 1 warning
    capcella_defconfig (gcc-8): 1 error, 1 warning
    cavium_octeon_defconfig (gcc-8): 1 error, 1 warning
    ci20_defconfig (gcc-8): 1 error, 1 warning
    cobalt_defconfig (gcc-8): 1 error, 1 warning
    cu1000-neo_defconfig (gcc-8): 1 error, 1 warning
    cu1830-neo_defconfig (gcc-8): 1 error, 1 warning
    db1xxx_defconfig (gcc-8): 1 error, 1 warning
    decstation_64_defconfig (gcc-8): 1 error, 2 warnings
    decstation_defconfig (gcc-8): 1 error, 2 warnings
    decstation_r4k_defconfig (gcc-8): 1 error, 2 warnings
    e55_defconfig (gcc-8): 1 error, 1 warning
    fuloong2e_defconfig (gcc-8): 1 error, 1 warning
    gcw0_defconfig (gcc-8): 1 error, 1 warning
    gpr_defconfig (gcc-8): 1 error, 1 warning
    ip22_defconfig (gcc-8): 1 error, 1 warning
    ip27_defconfig (gcc-8): 1 error, 1 warning
    ip28_defconfig (gcc-8): 1 error, 1 warning
    ip32_defconfig (gcc-8): 1 error, 1 warning
    jazz_defconfig (gcc-8): 1 error, 1 warning
    jmr3927_defconfig (gcc-8): 1 error, 1 warning
    lemote2f_defconfig (gcc-8): 1 error, 1 warning
    loongson1b_defconfig (gcc-8): 1 error, 1 warning
    loongson1c_defconfig (gcc-8): 1 error, 1 warning
    loongson3_defconfig (gcc-8): 1 error, 1 warning
    malta_defconfig (gcc-8): 1 error, 1 warning
    malta_kvm_defconfig (gcc-8): 1 error, 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 error, 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 1 error, 1 warning
    maltaaprp_defconfig (gcc-8): 1 error, 1 warning
    maltasmvp_defconfig (gcc-8): 1 error, 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 error, 1 warning
    maltaup_defconfig (gcc-8): 1 error, 1 warning
    maltaup_xpa_defconfig (gcc-8): 1 error, 1 warning
    mpc30x_defconfig (gcc-8): 1 error, 1 warning
    mtx1_defconfig (gcc-8): 1 error, 1 warning
    nlm_xlp_defconfig (gcc-8): 1 error, 1 warning
    nlm_xlr_defconfig (gcc-8): 1 error, 1 warning
    omega2p_defconfig (gcc-8): 1 error, 1 warning
    pic32mzda_defconfig (gcc-8): 1 error, 1 warning
    pistachio_defconfig (gcc-8): 1 error, 1 warning
    qi_lb60_defconfig (gcc-8): 1 error, 1 warning
    rb532_defconfig (gcc-8): 1 error, 1 warning
    rbtx49xx_defconfig (gcc-8): 1 error, 1 warning
    rm200_defconfig (gcc-8): 1 error, 1 warning
    rs90_defconfig (gcc-8): 1 error, 1 warning
    rt305x_defconfig (gcc-8): 1 error, 1 warning
    sb1250_swarm_defconfig (gcc-8): 1 error, 1 warning
    tb0219_defconfig (gcc-8): 1 error, 1 warning
    tb0226_defconfig (gcc-8): 1 error, 1 warning
    tb0287_defconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 1 warning
    vocore2_defconfig (gcc-8): 1 error, 1 warning
    workpad_defconfig (gcc-8): 1 error, 1 warning
    xway_defconfig (gcc-8): 1 error, 1 warning

riscv:
    allnoconfig (gcc-8): 1 error, 1 warning
    defconfig (gcc-8): 1 error, 1 warning
    nommu_k210_defconfig (gcc-8): 1 error, 1 warning
    nommu_virt_defconfig (gcc-8): 1 error, 1 warning
    rv32_defconfig (gcc-8): 1 error, 4 warnings
    tinyconfig (gcc-8): 1 error, 1 warning

x86_64:
    allnoconfig (gcc-8): 1 error, 1 warning
    tinyconfig (gcc-8): 1 error, 2 warnings
    x86_64_defconfig (gcc-8): 1 error, 1 warning

Errors summary:

    196  mm/page_alloc.c:3275:2: error: implicit declaration of function =
=E2=80=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    196  cc1: some warnings being treated as errors
    3    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    1    arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: =E2=80=98am=
s_delta_camera_power=E2=80=99 defined but not used [-Wunused-function]
    1    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    1    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    1    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    .config:1171:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings,=
 0 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nommu_virt_defconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: =E2=80=98ams_del=
ta_camera_power=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 4 warnings, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mism=
atches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section misma=
tches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    .config:1171:warning: override: UNWINDER_GUESS changes choice state
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section misma=
tches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    mm/page_alloc.c:3275:2: error: implicit declaration of function =E2=80=
=98split_page_memcg=E2=80=99; did you mean =E2=80=98split_page_owner=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
