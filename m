Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2CB6BBDD8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 21:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCOUUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 16:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCOUUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 16:20:00 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB3D32CED
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 13:19:55 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t83so1418287pgb.11
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 13:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678911595;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/WUkjgYpmkAUJ0wPaLSMq+jyVSnxiP4+pGYNYKi+L4g=;
        b=YGe2LTz4SBLu1VaRo3o81YKRZT+mCBJ1XRyEitNcaNyBMNXPaR9QyTS9lN4afHQ3Vh
         TBXGE3nQ7A+nzCvaIe9Wz1dtTwhqoxqHQ+ZMcpMi80Bc2JXyBQj/CvhQIAD7iQWPuLHU
         YoEheGAiUAmsUMLDX2O1AHfTysI2Ew3b7zPeS8KSGeAIDJrUgMozu8LnIEtwoaWdVAJl
         KqPi49c26c43KYVShQ1ltoHN8V+Y84lndtjmTurjFhoLL3XI55s0WRd3Wmgb6o+w/Iz2
         o3k5kqCCLwspyy3rc9jZFXurwXWypo7rtjgMgGLmkZ8Y9eeL0FcDihMLoJCDrfpjZIv4
         jFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678911595;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WUkjgYpmkAUJ0wPaLSMq+jyVSnxiP4+pGYNYKi+L4g=;
        b=cHbX/UJ1Y3Xlyg5uhMSOS6+ikWAjuWSpt6zBmLi8JqRxafykYw8u7wSjvpGoKhoHLM
         +aE3xR2Di3YIpucxXTVAM0j2P1Dwh4R5TQAxR9pB6q1P0WFaBG1SIhcypoqjchA42TUw
         U3VMPrj0voDH+Z3GxeGYqdPvmTwfL19o4DshAZOznaEnejrpcBouRq7F0IaPABniD8Si
         vV6IsjPOdUwf0i5KOsAGqZR+iY6yP1wM/79oG1zE7rtWBXzJ/x7nRtH3zpv058caIKZj
         sfQA3x15yCzot/j6s2TimPIUPtYHKtloGamUNMljFyCfflsIITAgadhQK9P5vLmRcjGl
         uDtQ==
X-Gm-Message-State: AO0yUKWQilwpAeMIkQm8dNvNO+DBZ/JMD60rMTwvyZLD0PawHTnSzfdw
        Z/wbVWENMFzxAj/k7AH9ZCzKXg6D2XbcH1XdH402pdFL
X-Google-Smtp-Source: AK7set+fCKSGOY/PqKZg3Wl7xsc8lyLz+/1LhTaMuVzcLbu6FW17Nosf3RNpYBJ0BrqDrQYHx6gDPA==
X-Received: by 2002:a62:1a83:0:b0:625:e77b:433e with SMTP id a125-20020a621a83000000b00625e77b433emr109346pfa.24.1678911593640;
        Wed, 15 Mar 2023 13:19:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s11-20020aa7828b000000b005ded5d2d571sm3911779pfm.185.2023.03.15.13.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 13:19:53 -0700 (PDT)
Message-ID: <64122869.a70a0220.127c.8c9b@mx.google.com>
Date:   Wed, 15 Mar 2023 13:19:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-107-g16db2cbd9bc8
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/5.10 build: 193 builds: 145 failed, 48 passed,
 224 errors, 15 warnings (v5.10.173-107-g16db2cbd9bc8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 193 builds: 145 failed, 48 passed, 224 errors, =
15 warnings (v5.10.173-107-g16db2cbd9bc8)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.173-107-g16db2cbd9bc8/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.173-107-g16db2cbd9bc8
Git Commit: 16db2cbd9bc8535fe0e95e9b439e9844d73bf8ee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-10) FAIL
    axs103_defconfig: (gcc-10) FAIL
    haps_hs_defconfig: (gcc-10) FAIL
    nsimosci_hs_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    vdk_hs38_defconfig: (gcc-10) FAIL

arm:
    allnoconfig: (gcc-10) FAIL
    am200epdkit_defconfig: (gcc-10) FAIL
    aspeed_g4_defconfig: (gcc-10) FAIL
    assabet_defconfig: (gcc-10) FAIL
    at91_dt_defconfig: (gcc-10) FAIL
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
    ezx_defconfig: (gcc-10) FAIL
    footbridge_defconfig: (gcc-10) FAIL
    gemini_defconfig: (gcc-10) FAIL
    h3600_defconfig: (gcc-10) FAIL
    h5000_defconfig: (gcc-10) FAIL
    hackkit_defconfig: (gcc-10) FAIL
    imote2_defconfig: (gcc-10) FAIL
    imx_v4_v5_defconfig: (gcc-10) FAIL
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
    multi_v4t_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    mv78xx0_defconfig: (gcc-10) FAIL
    mvebu_v5_defconfig: (gcc-10) FAIL
    mxs_defconfig: (gcc-10) FAIL
    neponset_defconfig: (gcc-10) FAIL
    netwinder_defconfig: (gcc-10) FAIL
    nhk8815_defconfig: (gcc-10) FAIL
    omap1_defconfig: (gcc-10) FAIL
    orion5x_defconfig: (gcc-10) FAIL
    palmz72_defconfig: (gcc-10) FAIL
    pcm027_defconfig: (gcc-10) FAIL
    pleb_defconfig: (gcc-10) FAIL
    pxa168_defconfig: (gcc-10) FAIL
    pxa255-idp_defconfig: (gcc-10) FAIL
    pxa3xx_defconfig: (gcc-10) FAIL
    pxa910_defconfig: (gcc-10) FAIL
    pxa_defconfig: (gcc-10) FAIL
    s3c2410_defconfig: (gcc-10) FAIL
    s3c6400_defconfig: (gcc-10) FAIL
    s5pv210_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    shannon_defconfig: (gcc-10) FAIL
    simpad_defconfig: (gcc-10) FAIL
    spear3xx_defconfig: (gcc-10) FAIL
    spear6xx_defconfig: (gcc-10) FAIL
    spitz_defconfig: (gcc-10) FAIL
    stm32_defconfig: (gcc-10) FAIL
    tct_hammer_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    trizeps4_defconfig: (gcc-10) FAIL
    u300_defconfig: (gcc-10) FAIL
    versatile_defconfig: (gcc-10) FAIL
    vf610m4_defconfig: (gcc-10) FAIL
    viper_defconfig: (gcc-10) FAIL
    vt8500_v6_v7_defconfig: (gcc-10) FAIL
    xcep_defconfig: (gcc-10) FAIL
    zeus_defconfig: (gcc-10) FAIL

i386:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

mips:
    allnoconfig: (gcc-10) FAIL
    ar7_defconfig: (gcc-10) FAIL
    ath25_defconfig: (gcc-10) FAIL
    ath79_defconfig: (gcc-10) FAIL
    bcm47xx_defconfig: (gcc-10) FAIL
    bcm63xx_defconfig: (gcc-10) FAIL
    bigsur_defconfig: (gcc-10) FAIL
    capcella_defconfig: (gcc-10) FAIL
    ci20_defconfig: (gcc-10) FAIL
    cobalt_defconfig: (gcc-10) FAIL
    cu1000-neo_defconfig: (gcc-10) FAIL
    cu1830-neo_defconfig: (gcc-10) FAIL
    db1xxx_defconfig: (gcc-10) FAIL
    decstation_64_defconfig: (gcc-10) FAIL
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
    malta_kvm_guest_defconfig: (gcc-10) FAIL
    malta_qemu_32r6_defconfig: (gcc-10) FAIL
    mpc30x_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL
    nlm_xlp_defconfig: (gcc-10) FAIL
    nlm_xlr_defconfig: (gcc-10) FAIL
    omega2p_defconfig: (gcc-10) FAIL
    pic32mzda_defconfig: (gcc-10) FAIL
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

riscv:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

x86_64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-10): 4 errors
    axs103_defconfig (gcc-10): 1 error
    haps_hs_defconfig (gcc-10): 1 error
    nsimosci_hs_defconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 2 errors
    vdk_hs38_defconfig (gcc-10): 1 error

arm64:

arm:
    allnoconfig (gcc-10): 1 error
    am200epdkit_defconfig (gcc-10): 1 error
    aspeed_g4_defconfig (gcc-10): 1 error
    assabet_defconfig (gcc-10): 2 errors
    at91_dt_defconfig (gcc-10): 4 errors
    badge4_defconfig (gcc-10): 1 error
    bcm2835_defconfig (gcc-10): 1 error
    cerfcube_defconfig (gcc-10): 1 error
    clps711x_defconfig (gcc-10): 1 error
    cm_x300_defconfig (gcc-10): 1 error
    cns3420vb_defconfig (gcc-10): 2 errors
    colibri_pxa270_defconfig (gcc-10): 1 error
    colibri_pxa300_defconfig (gcc-10): 2 errors
    collie_defconfig (gcc-10): 1 error
    corgi_defconfig (gcc-10): 2 errors
    davinci_all_defconfig (gcc-10): 1 error
    dove_defconfig (gcc-10): 2 errors
    ebsa110_defconfig (gcc-10): 1 error
    efm32_defconfig (gcc-10): 1 error
    ep93xx_defconfig (gcc-10): 1 error
    eseries_pxa_defconfig (gcc-10): 1 error
    ezx_defconfig (gcc-10): 2 errors
    footbridge_defconfig (gcc-10): 1 error
    gemini_defconfig (gcc-10): 1 error
    h3600_defconfig (gcc-10): 1 error
    h5000_defconfig (gcc-10): 1 error
    hackkit_defconfig (gcc-10): 3 errors
    imote2_defconfig (gcc-10): 3 errors
    imx_v4_v5_defconfig (gcc-10): 1 error
    integrator_defconfig (gcc-10): 2 errors
    iop32x_defconfig (gcc-10): 1 error
    ixp4xx_defconfig (gcc-10): 2 errors
    jornada720_defconfig (gcc-10): 1 error
    keystone_defconfig (gcc-10): 1 error, 2 warnings
    lart_defconfig (gcc-10): 1 error
    lpc18xx_defconfig (gcc-10): 3 errors
    lpc32xx_defconfig (gcc-10): 1 error
    lpd270_defconfig (gcc-10): 2 errors
    lubbock_defconfig (gcc-10): 1 error
    magician_defconfig (gcc-10): 2 errors
    mainstone_defconfig (gcc-10): 1 error
    mini2440_defconfig (gcc-10): 1 error
    mmp2_defconfig (gcc-10): 1 error
    moxart_defconfig (gcc-10): 1 error
    mps2_defconfig (gcc-10): 3 errors
    multi_v4t_defconfig (gcc-10): 2 errors
    multi_v5_defconfig (gcc-10): 2 errors
    mv78xx0_defconfig (gcc-10): 1 error
    mvebu_v5_defconfig (gcc-10): 2 errors
    mxs_defconfig (gcc-10): 1 error
    neponset_defconfig (gcc-10): 2 errors
    netwinder_defconfig (gcc-10): 1 error
    nhk8815_defconfig (gcc-10): 1 error
    omap1_defconfig (gcc-10): 1 error
    orion5x_defconfig (gcc-10): 1 error
    palmz72_defconfig (gcc-10): 3 errors
    pcm027_defconfig (gcc-10): 1 error
    pleb_defconfig (gcc-10): 1 error
    pxa168_defconfig (gcc-10): 2 errors
    pxa255-idp_defconfig (gcc-10): 2 errors
    pxa3xx_defconfig (gcc-10): 1 error
    pxa910_defconfig (gcc-10): 1 error
    pxa_defconfig (gcc-10): 1 error
    s3c2410_defconfig (gcc-10): 1 error
    s3c6400_defconfig (gcc-10): 3 errors
    s5pv210_defconfig (gcc-10): 1 error
    sama5_defconfig (gcc-10): 1 error
    shannon_defconfig (gcc-10): 2 errors
    simpad_defconfig (gcc-10): 2 errors
    spear3xx_defconfig (gcc-10): 1 error
    spear6xx_defconfig (gcc-10): 1 error
    spitz_defconfig (gcc-10): 1 error
    stm32_defconfig (gcc-10): 1 error
    tct_hammer_defconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 3 errors
    trizeps4_defconfig (gcc-10): 2 errors
    u300_defconfig (gcc-10): 2 errors
    versatile_defconfig (gcc-10): 3 errors
    vf610m4_defconfig (gcc-10): 1 error
    viper_defconfig (gcc-10): 1 error
    vt8500_v6_v7_defconfig (gcc-10): 3 errors
    xcep_defconfig (gcc-10): 1 error
    zeus_defconfig (gcc-10): 1 error

i386:
    allnoconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 1 error

mips:
    32r2el_defconfig (gcc-10): 1 warning
    allnoconfig (gcc-10): 2 errors
    ar7_defconfig (gcc-10): 2 errors
    ath25_defconfig (gcc-10): 1 error
    ath79_defconfig (gcc-10): 1 error
    bcm47xx_defconfig (gcc-10): 3 errors
    bcm63xx_defconfig (gcc-10): 1 error
    bigsur_defconfig (gcc-10): 1 error, 2 warnings
    capcella_defconfig (gcc-10): 3 errors
    ci20_defconfig (gcc-10): 3 errors
    cobalt_defconfig (gcc-10): 1 error
    cu1000-neo_defconfig (gcc-10): 1 error
    cu1830-neo_defconfig (gcc-10): 1 error
    db1xxx_defconfig (gcc-10): 2 errors
    decstation_64_defconfig (gcc-10): 1 error
    decstation_defconfig (gcc-10): 2 errors
    decstation_r4k_defconfig (gcc-10): 1 error
    e55_defconfig (gcc-10): 2 errors
    fuloong2e_defconfig (gcc-10): 2 errors
    gcw0_defconfig (gcc-10): 3 errors
    gpr_defconfig (gcc-10): 1 error
    ip22_defconfig (gcc-10): 2 errors
    ip32_defconfig (gcc-10): 2 errors
    jazz_defconfig (gcc-10): 2 errors
    jmr3927_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 3 errors
    loongson1b_defconfig (gcc-10): 2 errors
    loongson1c_defconfig (gcc-10): 1 error
    malta_kvm_guest_defconfig (gcc-10): 1 error
    malta_qemu_32r6_defconfig (gcc-10): 1 error
    mpc30x_defconfig (gcc-10): 1 error
    mtx1_defconfig (gcc-10): 1 error
    nlm_xlp_defconfig (gcc-10): 1 error, 2 warnings
    nlm_xlr_defconfig (gcc-10): 1 error, 2 warnings
    omega2p_defconfig (gcc-10): 2 errors
    pic32mzda_defconfig (gcc-10): 2 errors
    qi_lb60_defconfig (gcc-10): 1 error
    rb532_defconfig (gcc-10): 2 errors
    rbtx49xx_defconfig (gcc-10): 2 errors
    rm200_defconfig (gcc-10): 1 error
    rs90_defconfig (gcc-10): 2 errors
    rt305x_defconfig (gcc-10): 2 errors
    sb1250_swarm_defconfig (gcc-10): 1 error, 2 warnings
    tb0219_defconfig (gcc-10): 2 errors
    tb0226_defconfig (gcc-10): 2 errors
    tb0287_defconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 2 errors
    vocore2_defconfig (gcc-10): 2 errors
    workpad_defconfig (gcc-10): 1 error

riscv:
    allnoconfig (gcc-10): 3 errors
    rv32_defconfig (gcc-10): 4 warnings
    tinyconfig (gcc-10): 3 errors

x86_64:
    allnoconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 3 errors

Errors summary:

    209  kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 h=
as no member named =E2=80=98cpu_capacity_inverted=E2=80=99
    10   kernel/sched/sched.h:2560:20: error: 'struct rq' has no member nam=
ed 'cpu_capacity_inverted'
    5    drivers/pci/pci-driver.c:1297:2: error: implicit declaration of fu=
nction =E2=80=98pci_restore_standard_config=E2=80=99 [-Werror=3Dimplicit-fu=
nction-declaration]

Warnings summary:

    5    drivers/pci/pci-driver.c:536:13: warning: =E2=80=98pci_pm_default_=
resume_early=E2=80=99 defined but not used [-Wunused-function]
    5    cc1: some warnings being treated as errors
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved sy=
mbol check will be entirely skipped.

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0):=
 Section mismatch in reference from the variable __ksymtab_prom_init_numa_m=
emory to the function .init.text:prom_init_numa_memory()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved symbol =
check will be entirely skipped.

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section =
mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 section m=
ismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    drivers/pci/pci-driver.c:1297:2: error: implicit declaration of functio=
n =E2=80=98pci_restore_standard_config=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    drivers/pci/pci-driver.c:536:13: warning: =E2=80=98pci_pm_default_resum=
e_early=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings=
, 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warn=
ings, 0 section mismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

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
ip32_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    drivers/pci/pci-driver.c:1297:2: error: implicit declaration of functio=
n =E2=80=98pci_restore_standard_config=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    drivers/pci/pci-driver.c:536:13: warning: =E2=80=98pci_pm_default_resum=
e_early=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Sect=
ion mismatch in reference from the variable __ksymtab_prom_init_numa_memory=
 to the function .init.text:prom_init_numa_memory()

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warning=
s, 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warning=
s, 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    drivers/pci/pci-driver.c:1297:2: error: implicit declaration of functio=
n =E2=80=98pci_restore_standard_config=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    drivers/pci/pci-driver.c:536:13: warning: =E2=80=98pci_pm_default_resum=
e_early=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    drivers/pci/pci-driver.c:1297:2: error: implicit declaration of functio=
n =E2=80=98pci_restore_standard_config=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    drivers/pci/pci-driver.c:536:13: warning: =E2=80=98pci_pm_default_resum=
e_early=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    drivers/pci/pci-driver.c:1297:2: error: implicit declaration of functio=
n =E2=80=98pci_restore_standard_config=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]

Warnings:
    drivers/pci/pci-driver.c:536:13: warning: =E2=80=98pci_pm_default_resum=
e_early=E2=80=99 defined but not used [-Wunused-function]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section m=
ismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section mi=
smatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section mi=
smatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section =
mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, =
0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

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
xcep_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
