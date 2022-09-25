Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B245A5E90DD
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 05:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiIYDae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 23:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiIYDad (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 23:30:33 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCDC27CF9
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 20:30:29 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id v1so3442093plo.9
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 20:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=d20qLZ73TJmPU/ELpXwMU7VftmTb2GvRCLkxReaRHW4=;
        b=PrLhegYGi0DPxelZxwy9AJrOgTBWGWlfqM5uc/ASQZhPYgIu7fMZTdMYq/aq9iSAxw
         VPEBAWeV+GO8JacodZISQi3rAUZndttufGoBumeWgvP+fpZzWOAufVUqg0yj5N+JbsAv
         8lic+doNfbh3EB2RCI08X7OhP7dJSSDcHcT0WzXrl5lWT0RAnRwpxaApdjCDBc0j1WT/
         ddXWgU9og6G+GixXa+NCrzPdCaYwG4l3nYBbJrBtVFEQ091PFrM+k1LFpy4K3etttWFQ
         976+H/OcfaAhSKRjFy2diJYZySKKXqfcQHpS/DiZXIEpgDb6nRVRL0en9RJAWQMt4Eec
         M3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=d20qLZ73TJmPU/ELpXwMU7VftmTb2GvRCLkxReaRHW4=;
        b=qegmO0OGd4pbt5jlYbGGYUpqzSt7Fmf+Z0z9h+7qk/KJMIQYe1uqNPNJmW5CWlWiJK
         YIQtgEff11iB4Xx2lhIW80AFI28HoIj4nzv20xutwakK7jbOW8vQxtipJb65wAg8dL1y
         Rcbbc9RhEd4YROyyof6iFQluu9fTu1I1MAcUQS374ZU53ruHGhhfprUBXUONUISJdvvF
         MnHMXJRz7DVqP8JkAzBQgsLITU/bmh0vQZdpTP9uHTyxdYwzKBwDvq12jZyobxUDJ9aV
         rEjWTAtFHTry63yIsH7oc0U/9++kWvBd9IJ5gzGaDNgqCzSlFwmonqnWH5iaL6KwCbQD
         KviQ==
X-Gm-Message-State: ACrzQf02lQbDkc3R2UnaFhD9ug/Q6TIPMSxhPHkij5wjIYQeUfZxhC8I
        D7Rhn/ZplSdq/t08AnZtz5viE2SvfycC/4/YQeE=
X-Google-Smtp-Source: AMsMyM5ocPyedLipxKq9Ez9iRGcnNGO0b7uRIsAnaYLoS3jZ9dCgbL4Y0oaN0Fg2fn0rMFqfV9ujgA==
X-Received: by 2002:a17:90b:3852:b0:203:a68c:9a7c with SMTP id nl18-20020a17090b385200b00203a68c9a7cmr30163620pjb.119.1664076627679;
        Sat, 24 Sep 2022 20:30:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2-20020a620502000000b00537f16e25d3sm9081757pff.75.2022.09.24.20.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 20:30:27 -0700 (PDT)
Message-ID: <632fcb53.620a0220.70cfd.1c34@mx.google.com>
Date:   Sat, 24 Sep 2022 20:30:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.10.145-119-g0ed01873ed141
Subject: stable-rc/queue/5.10 build: 165 builds: 3 failed, 162 passed, 4 errors,
 154 warnings (v5.10.145-119-g0ed01873ed141)
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

stable-rc/queue/5.10 build: 165 builds: 3 failed, 162 passed, 4 errors, 154=
 warnings (v5.10.145-119-g0ed01873ed141)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.145-119-g0ed01873ed141/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.145-119-g0ed01873ed141
Git Commit: 0ed01873ed141e2095cc1e0545ab5a54a55c99a6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-10): 1 warning
    axs103_smp_defconfig (gcc-10): 1 warning
    haps_hs_defconfig (gcc-10): 1 warning
    haps_hs_smp_defconfig (gcc-10): 1 warning
    nsimosci_hs_defconfig (gcc-10): 1 warning
    nsimosci_hs_smp_defconfig (gcc-10): 1 warning
    vdk_hs38_defconfig (gcc-10): 1 warning
    vdk_hs38_smp_defconfig (gcc-10): 1 warning

arm64:
    defconfig (gcc-10): 1 warning
    defconfig+arm64-chromebook (gcc-10): 1 warning

arm:
    am200epdkit_defconfig (gcc-10): 1 warning
    aspeed_g4_defconfig (gcc-10): 1 warning
    aspeed_g5_defconfig (gcc-10): 1 warning
    assabet_defconfig (gcc-10): 1 warning
    at91_dt_defconfig (gcc-10): 1 warning
    axm55xx_defconfig (gcc-10): 1 warning
    badge4_defconfig (gcc-10): 1 warning
    bcm2835_defconfig (gcc-10): 1 warning
    cerfcube_defconfig (gcc-10): 1 warning
    cm_x300_defconfig (gcc-10): 1 warning
    colibri_pxa270_defconfig (gcc-10): 1 warning
    colibri_pxa300_defconfig (gcc-10): 1 warning
    collie_defconfig (gcc-10): 1 warning
    corgi_defconfig (gcc-10): 1 warning
    davinci_all_defconfig (gcc-10): 1 warning
    dove_defconfig (gcc-10): 1 warning
    ebsa110_defconfig (gcc-10): 1 warning
    ep93xx_defconfig (gcc-10): 1 warning
    eseries_pxa_defconfig (gcc-10): 1 warning
    exynos_defconfig (gcc-10): 1 warning
    ezx_defconfig (gcc-10): 1 warning
    footbridge_defconfig (gcc-10): 1 warning
    gemini_defconfig (gcc-10): 1 warning
    h3600_defconfig (gcc-10): 1 warning
    h5000_defconfig (gcc-10): 1 warning
    hackkit_defconfig (gcc-10): 1 warning
    hisi_defconfig (gcc-10): 1 warning
    imote2_defconfig (gcc-10): 1 warning
    imx_v4_v5_defconfig (gcc-10): 1 warning
    imx_v6_v7_defconfig (gcc-10): 1 warning
    integrator_defconfig (gcc-10): 1 warning
    iop32x_defconfig (gcc-10): 1 warning
    ixp4xx_defconfig (gcc-10): 1 warning
    jornada720_defconfig (gcc-10): 1 warning
    keystone_defconfig (gcc-10): 1 warning
    lpc18xx_defconfig (gcc-10): 1 warning
    lpc32xx_defconfig (gcc-10): 1 warning
    lpd270_defconfig (gcc-10): 1 warning
    lubbock_defconfig (gcc-10): 1 warning
    magician_defconfig (gcc-10): 1 warning
    mainstone_defconfig (gcc-10): 1 warning
    mini2440_defconfig (gcc-10): 1 warning
    mmp2_defconfig (gcc-10): 1 warning
    moxart_defconfig (gcc-10): 1 warning
    mps2_defconfig (gcc-10): 1 warning
    multi_v5_defconfig (gcc-10): 1 warning
    multi_v7_defconfig (gcc-10): 1 warning
    mvebu_v5_defconfig (gcc-10): 1 warning
    mvebu_v7_defconfig (gcc-10): 1 warning
    mxs_defconfig (gcc-10): 1 warning
    neponset_defconfig (gcc-10): 1 warning
    nhk8815_defconfig (gcc-10): 1 warning
    omap1_defconfig (gcc-10): 1 warning
    orion5x_defconfig (gcc-10): 1 warning
    oxnas_v6_defconfig (gcc-10): 1 warning
    palmz72_defconfig (gcc-10): 1 warning
    pcm027_defconfig (gcc-10): 1 warning
    pleb_defconfig (gcc-10): 1 warning
    pxa168_defconfig (gcc-10): 1 warning
    pxa255-idp_defconfig (gcc-10): 1 warning
    pxa3xx_defconfig (gcc-10): 1 warning
    pxa910_defconfig (gcc-10): 1 warning
    pxa_defconfig (gcc-10): 1 warning
    qcom_defconfig (gcc-10): 1 warning
    realview_defconfig (gcc-10): 1 warning
    rpc_defconfig (gcc-10): 4 errors
    s3c2410_defconfig (gcc-10): 1 warning
    s5pv210_defconfig (gcc-10): 1 warning
    sama5_defconfig (gcc-10): 1 warning
    shannon_defconfig (gcc-10): 1 warning
    shmobile_defconfig (gcc-10): 1 warning
    simpad_defconfig (gcc-10): 1 warning
    socfpga_defconfig (gcc-10): 1 warning
    spear13xx_defconfig (gcc-10): 1 warning
    spear3xx_defconfig (gcc-10): 1 warning
    spear6xx_defconfig (gcc-10): 1 warning
    tango4_defconfig (gcc-10): 1 warning
    tct_hammer_defconfig (gcc-10): 1 warning
    tegra_defconfig (gcc-10): 1 warning
    trizeps4_defconfig (gcc-10): 1 warning
    u8500_defconfig (gcc-10): 1 warning
    versatile_defconfig (gcc-10): 1 warning
    vexpress_defconfig (gcc-10): 1 warning
    viper_defconfig (gcc-10): 1 warning
    zeus_defconfig (gcc-10): 1 warning

i386:
    i386_defconfig (gcc-10): 1 warning

mips:
    ar7_defconfig (gcc-10): 1 warning
    ath25_defconfig (gcc-10): 1 warning
    ath79_defconfig (gcc-10): 1 warning
    bcm47xx_defconfig (gcc-10): 1 warning
    bcm63xx_defconfig (gcc-10): 1 warning
    bigsur_defconfig (gcc-10): 1 warning
    bmips_be_defconfig (gcc-10): 1 warning
    capcella_defconfig (gcc-10): 1 warning
    cavium_octeon_defconfig (gcc-10): 1 warning
    ci20_defconfig (gcc-10): 1 warning
    cobalt_defconfig (gcc-10): 1 warning
    cu1000-neo_defconfig (gcc-10): 1 warning
    cu1830-neo_defconfig (gcc-10): 1 warning
    db1xxx_defconfig (gcc-10): 1 warning
    decstation_64_defconfig (gcc-10): 2 warnings
    decstation_defconfig (gcc-10): 2 warnings
    decstation_r4k_defconfig (gcc-10): 2 warnings
    fuloong2e_defconfig (gcc-10): 1 warning
    gcw0_defconfig (gcc-10): 1 warning
    ip22_defconfig (gcc-10): 1 warning
    jmr3927_defconfig (gcc-10): 1 warning
    loongson1b_defconfig (gcc-10): 1 warning
    loongson1c_defconfig (gcc-10): 1 warning
    loongson3_defconfig (gcc-10): 1 warning
    malta_defconfig (gcc-10): 1 warning
    malta_kvm_defconfig (gcc-10): 1 warning
    malta_kvm_guest_defconfig (gcc-10): 1 warning
    malta_qemu_32r6_defconfig (gcc-10): 1 warning
    maltaaprp_defconfig (gcc-10): 1 warning
    maltasmvp_defconfig (gcc-10): 1 warning
    maltasmvp_eva_defconfig (gcc-10): 1 warning
    maltaup_defconfig (gcc-10): 1 warning
    maltaup_xpa_defconfig (gcc-10): 1 warning
    mpc30x_defconfig (gcc-10): 1 warning
    mtx1_defconfig (gcc-10): 1 warning
    nlm_xlp_defconfig (gcc-10): 1 warning
    nlm_xlr_defconfig (gcc-10): 1 warning
    omega2p_defconfig (gcc-10): 1 warning
    qi_lb60_defconfig (gcc-10): 1 warning
    rb532_defconfig (gcc-10): 1 warning
    rm200_defconfig (gcc-10): 2 warnings
    rt305x_defconfig (gcc-10): 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 warning
    tb0219_defconfig (gcc-10): 1 warning
    tb0226_defconfig (gcc-10): 1 warning
    vocore2_defconfig (gcc-10): 1 warning
    workpad_defconfig (gcc-10): 1 warning

riscv:
    defconfig (gcc-10): 1 warning
    rv32_defconfig (gcc-10): 5 warnings

x86_64:
    x86_64_defconfig (gcc-10): 1 warning
    x86_64_defconfig+x86-chromebook (gcc-10): 1 warning

Errors summary:

    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    138  net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=
=80=99 [-Wunused-variable]
    8    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-=
variable]
    3    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): S=
ection mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to=
 the function .init.text:ixp4xx_irq_init()
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
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings=
, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warning=
s, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 1 warn=
ing, 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

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
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Sectio=
n mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the =
function .init.text:ixp4xx_irq_init()

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Sect=
ion mismatch in reference from the variable __ksymtab_prom_init_numa_memory=
 to the function .init.text:prom_init_numa_memory()

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warnin=
g, 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warnin=
g, 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

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
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable 'i' [-Wunused-varia=
ble]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
1 warning, 0 section mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/core/dev_ioctl.c:41:6: warning: unused variable =E2=80=98i=E2=80=99=
 [-Wunused-variable]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
