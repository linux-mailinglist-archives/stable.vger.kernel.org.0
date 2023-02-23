Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C034A6A07DE
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 12:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjBWL6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 06:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBWL6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 06:58:45 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A541C320
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:58:40 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id cb13so5860577pfb.5
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gJNTfrQoFFqz51C8/SL9LZRfY9o/KUySZK8UDiGrtbU=;
        b=1hRTpM4Msv8EwbHzh2G1x7LiqVtij3oM/D1iwjs8qyqXNVw6T4WFhgZmBNPhck5YiD
         YD8HPsTsMbnMtjOaK3cvSnCDT6xPwGqi/ovL6Nl14FLIJKPDmP8gnbmPRB7vf6FCXw2Y
         xMb7ovLlGfMD32ctZzEk/mEHM7e3ii8eVgORu2+25HueykEOg/NVFXEZOlxnh7C1C7fS
         jLKKwdVAbfIz2R1k8jcK5Ix/yuPBWzdYw1noJ6A/R0+0ECjryD9FgXLeVSdQjeJN5V20
         C0o+fqOEfceq3LTQk2v8rXYi/SEllFKoKWC24kil6kIuBVGXRBRxuR7vms89VarUpk86
         lwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gJNTfrQoFFqz51C8/SL9LZRfY9o/KUySZK8UDiGrtbU=;
        b=bIHbYO9xPwJK9BUlGpsD79YtMgxxt+CAxl9i3Prb1d8q2XlEi827l+0xW226Qqzp4E
         bGS2h8h3zXz55oq94lIGeX45jlJIwjzeYhprgy8yzbw7Eeco0VYJF291YWymVhNAgcLu
         MCdvEYOL/nyAdh1ZC5VLqxLHr7+aflCKnREPp1wSrZti3ZnR477J9niv+1oRGkZ1iqex
         EgU+BbXGLvV66wKvMV+u2/ztsfxsIi3E9tfqRgCHnrGYhYFsx93YM7qaA7NzOhqqJT0n
         eoOyK309+WrRbD/o0HtBPQCGnnahQg24HbUgymDzyKHd1lP2dz18Dj39f9lXJu+1Qzm1
         0cMQ==
X-Gm-Message-State: AO0yUKWa8lglDyIgHrLa53iKVYzCO+4CJhQiwKapkZbPVE6NXrGa3C5G
        dnfHQ+VFmwAzGY3mxwEz1s/vdnDY3yQ5Ag6Z/67tSw==
X-Google-Smtp-Source: AK7set9G2jx3cT+vFBwVYIK+dy/3zR6dsoKWEsDeKNNwVNGkxHU3w/fn87SnK7YWhmMN9+wfcYgFvg==
X-Received: by 2002:a62:7bce:0:b0:5ce:ef1b:a80 with SMTP id w197-20020a627bce000000b005ceef1b0a80mr6525605pfc.32.1677153518748;
        Thu, 23 Feb 2023 03:58:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f23-20020a637557000000b004e8f7f23c4bsm5037206pgn.76.2023.02.23.03.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 03:58:38 -0800 (PST)
Message-ID: <63f754ee.630a0220.5f583.92a7@mx.google.com>
Date:   Thu, 23 Feb 2023 03:58:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.95-30-gccb2246d6916
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/5.15 build: 181 builds: 163 failed, 18 passed,
 161 errors, 163 warnings (v5.15.95-30-gccb2246d6916)
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

stable-rc/queue/5.15 build: 181 builds: 163 failed, 18 passed, 161 errors, =
163 warnings (v5.15.95-30-gccb2246d6916)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.95-30-gccb2246d6916/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.95-30-gccb2246d6916
Git Commit: ccb2246d691692270ee637cf4b9480192120ac7c
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
    capcella_defconfig: (gcc-10) FAIL
    cavium_octeon_defconfig: (gcc-10) FAIL
    ci20_defconfig: (gcc-10) FAIL
    cobalt_defconfig: (gcc-10) FAIL
    cu1000-neo_defconfig: (gcc-10) FAIL
    cu1830-neo_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    decstation_64_defconfig: (gcc-10) FAIL
    decstation_defconfig: (gcc-10) FAIL
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
    mpc30x_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL
    nlm_xlp_defconfig: (gcc-10) FAIL
    nlm_xlr_defconfig: (gcc-10) FAIL
    omega2p_defconfig: (gcc-10) FAIL
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
    vocore2_defconfig: (gcc-10) FAIL
    workpad_defconfig: (gcc-10) FAIL
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
    tinyconfig (gcc-10): 1 warning
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
    bmips_be_defconfig (gcc-10): 1 error, 1 warning
    bmips_stb_defconfig (gcc-10): 1 error, 1 warning
    capcella_defconfig (gcc-10): 1 error, 1 warning
    cavium_octeon_defconfig (gcc-10): 1 error, 1 warning
    ci20_defconfig (gcc-10): 1 error, 1 warning
    cobalt_defconfig (gcc-10): 1 error, 1 warning
    cu1000-neo_defconfig (gcc-10): 1 error, 1 warning
    cu1830-neo_defconfig (gcc-10): 1 error, 1 warning
    db1xxx_defconfig (gcc-10): 1 error, 1 warning
    decstation_64_defconfig (gcc-10): 1 error, 1 warning
    decstation_defconfig (gcc-10): 1 error, 1 warning
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
    mpc30x_defconfig (gcc-10): 1 error, 1 warning
    mtx1_defconfig (gcc-10): 1 error, 1 warning
    nlm_xlp_defconfig (gcc-10): 1 error, 1 warning
    nlm_xlr_defconfig (gcc-10): 1 error, 1 warning
    omega2p_defconfig (gcc-10): 1 error, 1 warning
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
    vocore2_defconfig (gcc-10): 1 error, 1 warning
    workpad_defconfig (gcc-10): 1 error, 1 warning
    xway_defconfig (gcc-10): 1 error, 1 warning

riscv:
    defconfig (gcc-10): 1 error, 1 warning
    rv32_defconfig (gcc-10): 1 error, 1 warning

x86_64:

Errors summary:

    153  kernel/bpf/core.c:1651:3: error: implicit declaration of function =
=E2=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]
    9    kernel/bpf/core.c:1651:3: error: implicit declaration of function =
'barrier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    162  cc1: some warnings being treated as errors
    1    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_devic=
e_reg): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expec=
ted "0,0"
    1    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' i=
s unknown, fallback to ''

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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mis=
matches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 FAIL, 1 error, 1 warni=
ng, 0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson2k_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning=
, 0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, =
0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning,=
 0 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section m=
ismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0=
 section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

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
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function 'barr=
ier_nospec' [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 =
section mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
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
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section=
 mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    kernel/bpf/core.c:1651:3: error: implicit declaration of function =E2=
=80=98barrier_nospec=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
