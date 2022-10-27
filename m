Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720B560EED8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 05:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiJ0D4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 23:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234443AbiJ0D4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 23:56:23 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08579923E8
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 20:56:21 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q71so70961pgq.8
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 20:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aXwfWuTzQqppVeZ7rWSZbpRfjp5oa7SeJISk2g2ZJZQ=;
        b=elvgCxfVzgx1UkeMvwYbNjopR36BoRVkAvCYo1m2mPz0EJoIzAZQKvHvXWB4Fnom31
         5o/wNQLSPTLQ8S0H4U5zxtuW+wkYZJuOBJoT0JAsZUTokHSrWwFyunPmxfLQI7mSWhCD
         HNGXj+tdNoTFJTQXMxMXxI2BXnoXwIcL0aGHRfB0sXPfUqlNhQJA8AMeHgU3GpngbegI
         /awoOz5jS7Rp6wOn1R6qQ9viRM4UWVZHoBVlxuy9AWV1FwByUu7r7RpyAo2iCAHv36Yc
         kD5DCEP3Y/tZsX2kSGZtcKHl7HWC4LRiZ9DWZmdE7BU4xpjgvQMBtRxY9NEB+mhkLhse
         UOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aXwfWuTzQqppVeZ7rWSZbpRfjp5oa7SeJISk2g2ZJZQ=;
        b=F2M8SsmJEyIIYHeWABmqj9ZcdknBjJqhjourltJ5Jb9AhTg2SMFsU1eMFMICNcFe53
         nAm3gVyYE9Qdm1KCABnoUnMUfgNK05gtYJUt1AuMv+ehKJzakq/57wsTxUyHSdaT1YLy
         LL3cJEtGDG25qBeqZp3DFVmG6eXi2yiSix/u5LCFM/vlY1l+y7EI8cCQkbmQHpcakytR
         GEE/0r7rH1rsRif7D4ecqpT54XtBErgkHyIMetAZNldA4ta28VfeNM1KOfhVuQNRvy6V
         nIDJkFkYIrSzjHy6XN9grCkGXXSXlYrTrjWSjN4KsO/psxc1VNvkvLZgEO4xEgVNMGkj
         Yt+w==
X-Gm-Message-State: ACrzQf26FMhkYxBgISbGJgjvKwHXL2D4DBq6BhclSZCJw9ElV2und/yE
        UecY/zx08NR5n+AokdomCLqwqLnMpX073Hla
X-Google-Smtp-Source: AMsMyM68NAImZSWHaSBxUBAsxgLeQk/wpzl4mnf4cW5V8vTMdxX3g174cdO7cN1/ftaELqH3nVeHng==
X-Received: by 2002:a05:6a00:1483:b0:56b:ab8e:f44a with SMTP id v3-20020a056a00148300b0056bab8ef44amr22356422pfu.85.1666842978854;
        Wed, 26 Oct 2022 20:56:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y123-20020a623281000000b0056bf24f0837sm156021pfy.166.2022.10.26.20.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 20:56:18 -0700 (PDT)
Message-ID: <635a0162.620a0220.209fc.0650@mx.google.com>
Date:   Wed, 26 Oct 2022 20:56:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.10.150-97-g0394aed6bd4db
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 build: 185 builds: 3 failed, 182 passed,
 12187 errors, 9 warnings (v5.10.150-97-g0394aed6bd4db)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 185 builds: 3 failed, 182 passed, 12187 errors,=
 9 warnings (v5.10.150-97-g0394aed6bd4db)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.150-97-g0394aed6bd4db/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.150-97-g0394aed6bd4db
Git Commit: 0394aed6bd4db64c94e5c235796a37a160fbdb8c
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
    allnoconfig (gcc-10): 36 errors
    axs103_defconfig (gcc-10): 70 errors
    axs103_smp_defconfig (gcc-10): 70 errors
    haps_hs_defconfig (gcc-10): 68 errors
    haps_hs_smp_defconfig (gcc-10): 68 errors
    hsdk_defconfig (gcc-10): 70 errors
    nsimosci_hs_defconfig (gcc-10): 68 errors
    nsimosci_hs_smp_defconfig (gcc-10): 68 errors
    tinyconfig (gcc-10): 36 errors
    vdk_hs38_defconfig (gcc-10): 33 errors
    vdk_hs38_smp_defconfig (gcc-10): 33 errors

arm64:
    defconfig (gcc-10): 65 errors
    defconfig+arm64-chromebook (gcc-10): 69 errors

arm:
    am200epdkit_defconfig (gcc-10): 72 errors
    aspeed_g4_defconfig (gcc-10): 33 errors
    aspeed_g5_defconfig (gcc-10): 33 errors
    assabet_defconfig (gcc-10): 70 errors
    at91_dt_defconfig (gcc-10): 70 errors
    axm55xx_defconfig (gcc-10): 70 errors
    badge4_defconfig (gcc-10): 74 errors
    bcm2835_defconfig (gcc-10): 72 errors
    cerfcube_defconfig (gcc-10): 70 errors
    cm_x300_defconfig (gcc-10): 72 errors
    colibri_pxa270_defconfig (gcc-10): 72 errors
    colibri_pxa300_defconfig (gcc-10): 72 errors
    collie_defconfig (gcc-10): 33 errors
    corgi_defconfig (gcc-10): 74 errors
    davinci_all_defconfig (gcc-10): 70 errors
    dove_defconfig (gcc-10): 72 errors
    ebsa110_defconfig (gcc-10): 70 errors
    efm32_defconfig (gcc-10): 36 errors
    ep93xx_defconfig (gcc-10): 74 errors
    eseries_pxa_defconfig (gcc-10): 72 errors
    exynos_defconfig (gcc-10): 70 errors
    ezx_defconfig (gcc-10): 72 errors
    footbridge_defconfig (gcc-10): 70 errors
    gemini_defconfig (gcc-10): 33 errors
    h3600_defconfig (gcc-10): 70 errors
    h5000_defconfig (gcc-10): 72 errors
    hackkit_defconfig (gcc-10): 70 errors
    hisi_defconfig (gcc-10): 33 errors
    imote2_defconfig (gcc-10): 72 errors
    imx_v4_v5_defconfig (gcc-10): 72 errors
    imx_v6_v7_defconfig (gcc-10): 70 errors
    integrator_defconfig (gcc-10): 72 errors
    iop32x_defconfig (gcc-10): 70 errors
    ixp4xx_defconfig (gcc-10): 70 errors
    jornada720_defconfig (gcc-10): 70 errors
    keystone_defconfig (gcc-10): 72 errors
    lart_defconfig (gcc-10): 70 errors
    lpc18xx_defconfig (gcc-10): 37 errors
    lpc32xx_defconfig (gcc-10): 74 errors
    lpd270_defconfig (gcc-10): 72 errors
    lubbock_defconfig (gcc-10): 72 errors
    magician_defconfig (gcc-10): 72 errors
    mainstone_defconfig (gcc-10): 72 errors
    milbeaut_m10v_defconfig (gcc-10): 70 errors
    mini2440_defconfig (gcc-10): 70 errors
    mmp2_defconfig (gcc-10): 72 errors
    moxart_defconfig (gcc-10): 37 errors
    mps2_defconfig (gcc-10): 37 errors
    multi_v4t_defconfig (gcc-10): 38 errors
    multi_v5_defconfig (gcc-10): 86 errors
    multi_v7_defconfig (gcc-10): 140 errors
    mvebu_v5_defconfig (gcc-10): 76 errors
    mvebu_v7_defconfig (gcc-10): 72 errors
    mxs_defconfig (gcc-10): 70 errors
    neponset_defconfig (gcc-10): 70 errors
    netwinder_defconfig (gcc-10): 33 errors
    nhk8815_defconfig (gcc-10): 70 errors
    omap1_defconfig (gcc-10): 74 errors
    omap2plus_defconfig (gcc-10): 74 errors
    orion5x_defconfig (gcc-10): 74 errors
    oxnas_v6_defconfig (gcc-10): 70 errors
    palmz72_defconfig (gcc-10): 72 errors
    pcm027_defconfig (gcc-10): 72 errors
    pleb_defconfig (gcc-10): 70 errors
    prima2_defconfig (gcc-10): 70 errors
    pxa168_defconfig (gcc-10): 72 errors
    pxa255-idp_defconfig (gcc-10): 72 errors
    pxa3xx_defconfig (gcc-10): 72 errors
    pxa910_defconfig (gcc-10): 72 errors
    pxa_defconfig (gcc-10): 74 errors
    qcom_defconfig (gcc-10): 72 errors
    realview_defconfig (gcc-10): 72 errors
    rpc_defconfig (gcc-10): 16 errors
    s3c2410_defconfig (gcc-10): 70 errors
    s3c6400_defconfig (gcc-10): 70 errors
    s5pv210_defconfig (gcc-10): 70 errors
    sama5_defconfig (gcc-10): 70 errors
    shannon_defconfig (gcc-10): 70 errors
    shmobile_defconfig (gcc-10): 33 errors
    simpad_defconfig (gcc-10): 70 errors
    socfpga_defconfig (gcc-10): 72 errors
    spear13xx_defconfig (gcc-10): 70 errors
    spear3xx_defconfig (gcc-10): 70 errors
    spear6xx_defconfig (gcc-10): 70 errors
    spitz_defconfig (gcc-10): 74 errors
    stm32_defconfig (gcc-10): 36 errors
    sunxi_defconfig (gcc-10): 70 errors
    tango4_defconfig (gcc-10): 70 errors
    tct_hammer_defconfig (gcc-10): 70 errors
    tegra_defconfig (gcc-10): 70 errors
    trizeps4_defconfig (gcc-10): 72 errors
    u300_defconfig (gcc-10): 70 errors
    u8500_defconfig (gcc-10): 70 errors
    versatile_defconfig (gcc-10): 72 errors
    vexpress_defconfig (gcc-10): 74 errors
    vf610m4_defconfig (gcc-10): 32 errors
    viper_defconfig (gcc-10): 72 errors
    vt8500_v6_v7_defconfig (gcc-10): 33 errors
    xcep_defconfig (gcc-10): 76 errors
    zeus_defconfig (gcc-10): 72 errors
    zx_defconfig (gcc-10): 33 errors

i386:
    allnoconfig (gcc-10): 35 errors
    i386_defconfig (gcc-10): 73 errors
    tinyconfig (gcc-10): 35 errors

mips:
    32r2el_defconfig (gcc-10): 85 errors, 1 warning
    ar7_defconfig (gcc-10): 77 errors
    ath25_defconfig (gcc-10): 77 errors
    ath79_defconfig (gcc-10): 75 errors
    bcm47xx_defconfig (gcc-10): 77 errors
    bcm63xx_defconfig (gcc-10): 37 errors
    bigsur_defconfig (gcc-10): 84 errors
    bmips_be_defconfig (gcc-10): 36 errors
    bmips_stb_defconfig (gcc-10): 36 errors
    capcella_defconfig (gcc-10): 79 errors
    cavium_octeon_defconfig (gcc-10): 86 errors
    ci20_defconfig (gcc-10): 75 errors
    cobalt_defconfig (gcc-10): 79 errors
    cu1000-neo_defconfig (gcc-10): 35 errors
    cu1830-neo_defconfig (gcc-10): 35 errors
    db1xxx_defconfig (gcc-10): 37 errors
    decstation_64_defconfig (gcc-10): 84 errors, 1 warning
    decstation_defconfig (gcc-10): 81 errors, 1 warning
    decstation_r4k_defconfig (gcc-10): 81 errors, 1 warning
    e55_defconfig (gcc-10): 77 errors
    fuloong2e_defconfig (gcc-10): 84 errors
    gcw0_defconfig (gcc-10): 77 errors
    gpr_defconfig (gcc-10): 79 errors
    ip22_defconfig (gcc-10): 79 errors
    ip32_defconfig (gcc-10): 86 errors
    jazz_defconfig (gcc-10): 79 errors
    jmr3927_defconfig (gcc-10): 37 errors
    lemote2f_defconfig (gcc-10): 84 errors
    loongson1b_defconfig (gcc-10): 75 errors
    loongson1c_defconfig (gcc-10): 75 errors
    loongson3_defconfig (gcc-10): 82 errors
    malta_defconfig (gcc-10): 77 errors
    malta_kvm_defconfig (gcc-10): 77 errors
    malta_kvm_guest_defconfig (gcc-10): 79 errors
    malta_qemu_32r6_defconfig (gcc-10): 79 errors
    maltaaprp_defconfig (gcc-10): 77 errors
    maltasmvp_defconfig (gcc-10): 79 errors
    maltasmvp_eva_defconfig (gcc-10): 79 errors
    maltaup_defconfig (gcc-10): 77 errors
    maltaup_xpa_defconfig (gcc-10): 77 errors
    mpc30x_defconfig (gcc-10): 79 errors
    mtx1_defconfig (gcc-10): 81 errors
    nlm_xlp_defconfig (gcc-10): 82 errors
    nlm_xlr_defconfig (gcc-10): 79 errors
    omega2p_defconfig (gcc-10): 39 errors
    pic32mzda_defconfig (gcc-10): 75 errors
    pistachio_defconfig (gcc-10): 77 errors
    qi_lb60_defconfig (gcc-10): 77 errors
    rb532_defconfig (gcc-10): 79 errors
    rbtx49xx_defconfig (gcc-10): 79 errors
    rm200_defconfig (gcc-10): 81 errors, 1 warning
    rs90_defconfig (gcc-10): 37 errors
    rt305x_defconfig (gcc-10): 75 errors
    sb1250_swarm_defconfig (gcc-10): 84 errors
    tb0219_defconfig (gcc-10): 79 errors
    tb0226_defconfig (gcc-10): 79 errors
    tb0287_defconfig (gcc-10): 79 errors
    vocore2_defconfig (gcc-10): 39 errors
    workpad_defconfig (gcc-10): 77 errors

riscv:
    defconfig (gcc-10): 67 errors
    nommu_k210_defconfig (gcc-10): 34 errors
    rv32_defconfig (gcc-10): 67 errors, 4 warnings

x86_64:
    allnoconfig (gcc-10): 36 errors
    tinyconfig (gcc-10): 36 errors
    x86_64_defconfig (gcc-10): 75 errors
    x86_64_defconfig+x86-chromebook (gcc-10): 79 errors

Errors summary:

    12158  /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99
    2    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/param.h
    2    /bin/sh: 1:   SYSTBL  arch/mips/include/generated/asm/syscall_tabl=
e_32_o32.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/mips/include/generated/asm/percpu.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/mips/include/generated/asm/module.lds.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/uapi/asm/sockios.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/uapi/asm/sembuf.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/uapi/asm/poll.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/asm/flat.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/asm/extable.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  UPD    =
 include/config/kernel.release
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSTBL =
 arch/mips/include/generated/asm/syscall_table_32_o32.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSHDR =
 arch/mips/include/generated/uapi/asm/unistd_n32.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSHDR =
 arch/arm/include/generated/uapi/asm/unistd-common.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC =
 scripts/dtc/fstree.o
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC =
 arch/x86/tools/relocs_32.o
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC =
 arch/mips/boot/tools/relocs_64.o
    1    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/mcs_spinlock=
.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/errno.h
    1    /bin/sh: 1:   UPD     include/config/kernel.release
    1    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-c=
ommon.h
    1    /bin/sh: 1:   HOSTCC  scripts/dtc/dtc.o
    1    /bin/sh: 1:   CC [M]  arch/arm/crypto/aes-neonbs-glue.o
    1    /bin/sh: 1:   CC      arch/mips/kernel/elf.o

Warnings summary:

    3    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved sy=
mbol check will be entirely skipped.

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
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 85 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved symbol =
check will be entirely skipped.

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 35 errors, 0 warnings, 0 section=
 mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 section =
mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/uapi/asm/poll.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/mips/include/generated/asm/module.lds.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/mcs_spinlock.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 75 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   CC      arch/mips/kernel/elf.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/errno.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 84 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 86 errors, 0 warning=
s, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 75 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warning=
s, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warning=
s, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   UPD     include/config/kernel.release
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 35 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 35 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 84 errors, 1 warning=
, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 1 warning, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 1 warnin=
g, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    kernel/rcu/tasks.h:710:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 67 errors, 0 warnings, 0 section =
mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 65 errors, 0 warnings, 0 section =
mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 69 errors, 0 war=
nings, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/param.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 84 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 68 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC  scri=
pts/dtc/fstree.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 68 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 73 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/param.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/asm/flat.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/uapi/asm/sembuf.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC  arch=
/mips/boot/tools/relocs_64.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 86 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Sectio=
n mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the =
function .init.text:ixp4xx_irq_init()

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-common=
.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 84 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 75 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 75 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 82 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Sect=
ion mismatch in reference from the variable __ksymtab_prom_init_numa_memory=
 to the function .init.text:prom_init_numa_memory()

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/mips/include/generated/asm/percpu.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warni=
ngs, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warni=
ngs, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSTBL  arch/mips/include/generated/asm/syscall_table_32_=
o32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSTBL  arch/mips/include/generated/asm/syscall_table_32_=
o32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  UPD     incl=
ude/config/kernel.release
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warning=
s, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings,=
 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings=
, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSHDR  arch=
/mips/include/generated/uapi/asm/unistd_n32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 38 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 86 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 140 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   CC [M]  arch/arm/crypto/aes-neonbs-glue.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 76 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/asm/extable.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 82 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings,=
 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 68 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 68 errors, 0 warnin=
gs, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 39 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSHDR  arch=
/arm/include/generated/uapi/asm/unistd-common.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 75 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/uapi/asm/sockios.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 16 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSTBL  arch=
/mips/include/generated/asm/syscall_table_32_o32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 75 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 67 errors, 4 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 84 errors, 0 warnings=
, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0=
 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 section m=
ismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 35 errors, 0 warnings, 0 section =
mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC  arch=
/x86/tools/relocs_32.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings,=
 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   HOSTCC  scripts/dtc/dtc.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 32 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 39 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings,=
 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 75 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 79 errors,=
 0 warnings, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 76 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 33 errors, 0 warnings, 0 section=
 mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---
For more info write to <info@kernelci.org>
