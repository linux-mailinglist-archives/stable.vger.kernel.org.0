Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4D26BB6CC
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbjCOO7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjCOO6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:58:37 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E209037
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:57:58 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id bj12so2822664pfb.8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678892257;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BvLJcOzXw2ZvAo/WUExlIL8tx2j0KJTtzy+ViogF2lM=;
        b=b8ICurSydkF1doFTcdi0jdGjv2STFulbdPn/PMq0eL9kfno3X+XljX/QXwdxSLfrqI
         Tfj/CfB4LBv9pfb86Dr8SSt6NjRyESJFvPl5GD/7gjIByxedlh2HzxBz9y0f8/s4m6zq
         wVuF7QjJz/dmNuqs0F9F2SmpHCbwLvEZxT812Xkh/5ke50OI1bo/Z8uLe8hX0BLc8v++
         9OKeKlNiJz87FZXdF14rXWVptheEMEOUJ5bemfgPdJvp+HbbxDDDH902AD5zCM2eBpK/
         udHuemTyX5zvwYm381NxG2xQeyOsIl64Uy4l+/rnCTBX6L+3JlPKE3ziBLZwuTjF2/11
         waaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678892257;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvLJcOzXw2ZvAo/WUExlIL8tx2j0KJTtzy+ViogF2lM=;
        b=ixzHR8fKMWBRy5FRIPsvZ+I0accIOBERxIJdeLIETRmMra3hgeyVqur4r8aZPFY/9P
         8IPWbWDav/LuzhSKOerIS/vopIGp2r85huSsCpnTAAl6gAb9ZgCvgzUXS0tPSQ5tPZG9
         W2d0WpwP1PF7QJTvfc0Dm0J4e5p1j9hOeol2zUZMuyjk7hv69oObvobqIa1HbZtaERSf
         0+3ibkyzILF5NaSfO8cke95jj/syGnH6X683z5/l37Z+Gl2cVCeJndjnwjpHEeqUsQrE
         J77gvAZ3Q++LbXHnVJzFJJEDYnjSxtil7dMwP0cRMJJ3MI+DKiFEjBU7cC2SvZeuqDbv
         SlYA==
X-Gm-Message-State: AO0yUKWrBdsH1TfEY7rafc2tjAZLRJqwmD77QB46HteKArA7Fqf0UT14
        Pm/H47g7WFljqmKETKFTjQbtHKjs//BbsXaRzT/U6Mib
X-Google-Smtp-Source: AK7set9h3pxCUAMTgKl6F9SlaLZM8QxsLmgBGEt8HUd53dw8hfrx46zIV296++5OdYCQdAsDmXSojA==
X-Received: by 2002:a62:3285:0:b0:5a8:a570:4597 with SMTP id y127-20020a623285000000b005a8a5704597mr29937483pfy.5.1678892256464;
        Wed, 15 Mar 2023 07:57:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f26-20020aa78b1a000000b005a8c92f7c27sm3613042pfd.212.2023.03.15.07.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 07:57:36 -0700 (PDT)
Message-ID: <6411dce0.a70a0220.c455c.80d0@mx.google.com>
Date:   Wed, 15 Mar 2023 07:57:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-109-g420b6d10bae3
X-Kernelci-Report-Type: build
Subject: stable-rc/linux-5.10.y build: 193 builds: 145 failed, 48 passed,
 220 errors, 15 warnings (v5.10.173-109-g420b6d10bae3)
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

stable-rc/linux-5.10.y build: 193 builds: 145 failed, 48 passed, 220 errors=
, 15 warnings (v5.10.173-109-g420b6d10bae3)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.10.=
y/kernel/v5.10.173-109-g420b6d10bae3/

Tree: stable-rc
Branch: linux-5.10.y
Git Describe: v5.10.173-109-g420b6d10bae3
Git Commit: 420b6d10bae34ef9aa0d118b31afec6107595e72
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
    allnoconfig (gcc-10): 1 error
    axs103_defconfig (gcc-10): 3 errors
    haps_hs_defconfig (gcc-10): 2 errors
    nsimosci_hs_defconfig (gcc-10): 2 errors
    tinyconfig (gcc-10): 3 errors
    vdk_hs38_defconfig (gcc-10): 2 errors

arm64:

arm:
    allnoconfig (gcc-10): 2 errors
    am200epdkit_defconfig (gcc-10): 1 error
    aspeed_g4_defconfig (gcc-10): 2 errors
    assabet_defconfig (gcc-10): 1 error
    at91_dt_defconfig (gcc-10): 1 error
    badge4_defconfig (gcc-10): 1 error
    bcm2835_defconfig (gcc-10): 2 errors
    cerfcube_defconfig (gcc-10): 2 errors
    clps711x_defconfig (gcc-10): 3 errors
    cm_x300_defconfig (gcc-10): 2 errors
    cns3420vb_defconfig (gcc-10): 2 errors
    colibri_pxa270_defconfig (gcc-10): 1 error
    colibri_pxa300_defconfig (gcc-10): 3 errors
    collie_defconfig (gcc-10): 3 errors
    corgi_defconfig (gcc-10): 3 errors
    davinci_all_defconfig (gcc-10): 2 errors
    dove_defconfig (gcc-10): 1 error
    ebsa110_defconfig (gcc-10): 2 errors
    efm32_defconfig (gcc-10): 2 errors
    ep93xx_defconfig (gcc-10): 1 error
    eseries_pxa_defconfig (gcc-10): 2 errors
    ezx_defconfig (gcc-10): 1 error
    footbridge_defconfig (gcc-10): 2 errors
    gemini_defconfig (gcc-10): 2 errors
    h3600_defconfig (gcc-10): 2 errors
    h5000_defconfig (gcc-10): 1 error
    hackkit_defconfig (gcc-10): 1 error
    imote2_defconfig (gcc-10): 2 errors
    imx_v4_v5_defconfig (gcc-10): 1 error
    integrator_defconfig (gcc-10): 2 errors
    iop32x_defconfig (gcc-10): 1 error
    ixp4xx_defconfig (gcc-10): 1 error
    jornada720_defconfig (gcc-10): 1 error
    keystone_defconfig (gcc-10): 1 error, 2 warnings
    lart_defconfig (gcc-10): 1 error
    lpc18xx_defconfig (gcc-10): 1 error
    lpc32xx_defconfig (gcc-10): 1 error
    lpd270_defconfig (gcc-10): 1 error
    lubbock_defconfig (gcc-10): 1 error
    magician_defconfig (gcc-10): 1 error
    mainstone_defconfig (gcc-10): 1 error
    mini2440_defconfig (gcc-10): 3 errors
    mmp2_defconfig (gcc-10): 1 error
    moxart_defconfig (gcc-10): 2 errors
    mps2_defconfig (gcc-10): 1 error
    multi_v4t_defconfig (gcc-10): 4 errors
    multi_v5_defconfig (gcc-10): 1 error
    mv78xx0_defconfig (gcc-10): 2 errors
    mvebu_v5_defconfig (gcc-10): 1 error
    mxs_defconfig (gcc-10): 2 errors
    neponset_defconfig (gcc-10): 1 error
    netwinder_defconfig (gcc-10): 2 errors
    nhk8815_defconfig (gcc-10): 2 errors
    omap1_defconfig (gcc-10): 2 errors
    orion5x_defconfig (gcc-10): 1 error
    palmz72_defconfig (gcc-10): 2 errors
    pcm027_defconfig (gcc-10): 2 errors
    pleb_defconfig (gcc-10): 1 error
    pxa168_defconfig (gcc-10): 2 errors
    pxa255-idp_defconfig (gcc-10): 2 errors
    pxa3xx_defconfig (gcc-10): 1 error
    pxa910_defconfig (gcc-10): 1 error
    pxa_defconfig (gcc-10): 2 errors
    s3c2410_defconfig (gcc-10): 3 errors
    s3c6400_defconfig (gcc-10): 1 error
    s5pv210_defconfig (gcc-10): 2 errors
    sama5_defconfig (gcc-10): 1 error
    shannon_defconfig (gcc-10): 1 error
    simpad_defconfig (gcc-10): 1 error
    spear3xx_defconfig (gcc-10): 1 error
    spear6xx_defconfig (gcc-10): 2 errors
    spitz_defconfig (gcc-10): 1 error
    stm32_defconfig (gcc-10): 2 errors
    tct_hammer_defconfig (gcc-10): 3 errors
    tinyconfig (gcc-10): 1 error
    trizeps4_defconfig (gcc-10): 1 error
    u300_defconfig (gcc-10): 1 error
    versatile_defconfig (gcc-10): 1 error
    vf610m4_defconfig (gcc-10): 2 errors
    viper_defconfig (gcc-10): 1 error
    vt8500_v6_v7_defconfig (gcc-10): 1 error
    xcep_defconfig (gcc-10): 2 errors
    zeus_defconfig (gcc-10): 1 error

i386:
    allnoconfig (gcc-10): 1 error
    tinyconfig (gcc-10): 1 error

mips:
    32r2el_defconfig (gcc-10): 1 warning
    allnoconfig (gcc-10): 2 errors
    ar7_defconfig (gcc-10): 1 error
    ath25_defconfig (gcc-10): 1 error
    ath79_defconfig (gcc-10): 2 errors
    bcm47xx_defconfig (gcc-10): 1 error
    bcm63xx_defconfig (gcc-10): 2 errors
    bigsur_defconfig (gcc-10): 1 error, 2 warnings
    capcella_defconfig (gcc-10): 1 error
    ci20_defconfig (gcc-10): 1 error
    cobalt_defconfig (gcc-10): 1 error
    cu1000-neo_defconfig (gcc-10): 1 error
    cu1830-neo_defconfig (gcc-10): 1 error
    db1xxx_defconfig (gcc-10): 3 errors
    decstation_64_defconfig (gcc-10): 1 error
    decstation_defconfig (gcc-10): 1 error
    decstation_r4k_defconfig (gcc-10): 1 error
    e55_defconfig (gcc-10): 2 errors
    fuloong2e_defconfig (gcc-10): 2 errors
    gcw0_defconfig (gcc-10): 1 error
    gpr_defconfig (gcc-10): 1 error
    ip22_defconfig (gcc-10): 2 errors
    ip32_defconfig (gcc-10): 2 errors
    jazz_defconfig (gcc-10): 1 error
    jmr3927_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error
    loongson1b_defconfig (gcc-10): 1 error
    loongson1c_defconfig (gcc-10): 1 error
    malta_kvm_guest_defconfig (gcc-10): 1 error
    malta_qemu_32r6_defconfig (gcc-10): 2 errors
    mpc30x_defconfig (gcc-10): 2 errors
    mtx1_defconfig (gcc-10): 1 error
    nlm_xlp_defconfig (gcc-10): 1 error, 2 warnings
    nlm_xlr_defconfig (gcc-10): 1 error, 2 warnings
    omega2p_defconfig (gcc-10): 3 errors
    pic32mzda_defconfig (gcc-10): 2 errors
    qi_lb60_defconfig (gcc-10): 1 error
    rb532_defconfig (gcc-10): 2 errors
    rbtx49xx_defconfig (gcc-10): 1 error
    rm200_defconfig (gcc-10): 2 errors
    rs90_defconfig (gcc-10): 2 errors
    rt305x_defconfig (gcc-10): 2 errors
    sb1250_swarm_defconfig (gcc-10): 1 error, 2 warnings
    tb0219_defconfig (gcc-10): 1 error
    tb0226_defconfig (gcc-10): 1 error
    tb0287_defconfig (gcc-10): 2 errors
    tinyconfig (gcc-10): 1 error
    vocore2_defconfig (gcc-10): 1 error
    workpad_defconfig (gcc-10): 1 error

riscv:
    allnoconfig (gcc-10): 1 error
    rv32_defconfig (gcc-10): 4 warnings
    tinyconfig (gcc-10): 3 errors

x86_64:
    allnoconfig (gcc-10): 2 errors
    tinyconfig (gcc-10): 1 error

Errors summary:

    203  kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 h=
as no member named =E2=80=98cpu_capacity_inverted=E2=80=99
    13   kernel/sched/sched.h:2560:20: error: 'struct rq' has no member nam=
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
allnoconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section m=
ismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
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
allnoconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section =
mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

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
ar7_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
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
ath79_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
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
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
capcella_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 se=
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
cm_x300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings=
, 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sect=
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
corgi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 secti=
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
davinci_all_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sec=
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
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
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
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
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
ebsa110_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
gcw0_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
h3600_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
hackkit_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
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
imote2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
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
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
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
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
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
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
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
lpd270_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
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
magician_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
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
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnin=
gs, 0 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
mini2440_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 se=
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
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
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
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 s=
ection mismatches

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
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 se=
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
palmz72_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
s3c2410_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sec=
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
s3c6400_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
shannon_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
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
spear6xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
stm32_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
tb0219_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 =
section mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mis=
matches

Errors:
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
tinyconfig (arc, gcc-10) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section mi=
smatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
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
trizeps4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'
    kernel/sched/sched.h:2560:20: error: 'struct rq' has no member named 'c=
pu_capacity_inverted'

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
vocore2_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0=
 section mismatches

Errors:
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
xcep_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    kernel/sched/sched.h:2560:20: error: =E2=80=98struct rq=E2=80=99 has no=
 member named =E2=80=98cpu_capacity_inverted=E2=80=99
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
