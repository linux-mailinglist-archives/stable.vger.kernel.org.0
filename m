Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405755B5AD1
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 15:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiILNEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 09:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiILNEr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 09:04:47 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D422163CF
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 06:04:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v4so8198569pgi.10
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 06:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=kzaxF6cXdoeZ816sCidnebu4lGz/g1b2BzIGNL634uc=;
        b=mNaP4W7Eta1LQ4XvB4N4dEhrsOTnTdPB7usPccM7c3Is05No6i1z3B6+D/2LMLw6qF
         9W/ZTOG1kyn+pHU+WVA/gMQQ2yYkQqaouQydGHdeLS/m5LeQ3lhGxJdsISD6ilG/6t3W
         jXrI3DmVk1xN8o2vMbrc/8qPMMSSy+nDtYmChYIH5VuopQxqHx//IcCbxqFVMacm8vXB
         mtEekvxII6sLqxAX+s4AJ6npA6n5oDiaOuuxfyE7vWUHG2UUanAhv9cRd/FVBGHSpSIu
         irrm13t+Z5aUEwS2KOKR3aV3Z7m9iXzS+O2Kgju9aQdcfb0rqeceFTVo61APIiygWvUM
         L4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=kzaxF6cXdoeZ816sCidnebu4lGz/g1b2BzIGNL634uc=;
        b=tNmlXna3vvoBkrMM6B7H1ajw1v6wO3v+zDwA8jpS9EjMkjFNify8P4qwSvRJJEN3Mp
         hM2m/5xxWZ7udXugPMZqRUKadqMSYTNlfacJTgfT8oBZzsOur1O3tn8iYpU/1C0qmBi+
         rhGYRN4EO5r/paqz8Vucye8oLPO2bwI+hxRxz9zpwgTxkGFyEi7rA3irgkKfJF9lklPE
         3tUIdDVpzGTX/FnnUEBT22F05mnx/O+KpGc14jkvyy1mRhQbJ04iZwZxOI+HTafwlSyW
         KHSE/gejcm7xDc3+WvpvECpH9krMQTZv/JmSZOEqiXNXahJC6L85qgFFKYUgGgKhzY3H
         eHKw==
X-Gm-Message-State: ACgBeo2yKA+Mv/B39dkD1Jy0I3bLfujSmrVYue7+YmfWeJn/b0+KCvtd
        5QLUEhiZkFsFY9M8P4eD//x51V+isnbcGStSti4=
X-Google-Smtp-Source: AA6agR6XGgjJsHSxPYaQooyORVgGpJOFji3ongDgfxz1PCmb5LE0dDVeSD+Iyr5YKxE+hEk2LiF/Vg==
X-Received: by 2002:a63:4a11:0:b0:439:1b3:9e4b with SMTP id x17-20020a634a11000000b0043901b39e4bmr4487844pga.537.1662987881889;
        Mon, 12 Sep 2022 06:04:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jb20-20020a170903259400b00177f25f8ab3sm5978695plb.89.2022.09.12.06.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 06:04:40 -0700 (PDT)
Message-ID: <631f2e68.170a0220.ef3fc.9c9c@mx.google.com>
Date:   Mon, 12 Sep 2022 06:04:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.66-115-g0b77c83157a0
Subject: stable-rc/queue/5.15 build: 180 builds: 8 failed, 172 passed,
 11977 errors, 5 warnings (v5.15.66-115-g0b77c83157a0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 build: 180 builds: 8 failed, 172 passed, 11977 errors,=
 5 warnings (v5.15.66-115-g0b77c83157a0)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.66-115-g0b77c83157a0/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.66-115-g0b77c83157a0
Git Commit: 0b77c83157a0d671793f3e5e2f7d59f750a97659
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    at91_dt_defconfig: (gcc-10) FAIL
    multi_v4t_defconfig: (gcc-10) FAIL
    multi_v5_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-10): 32 errors
    axs103_defconfig (gcc-10): 72 errors
    axs103_smp_defconfig (gcc-10): 72 errors
    haps_hs_defconfig (gcc-10): 70 errors
    haps_hs_smp_defconfig (gcc-10): 70 errors
    hsdk_defconfig (gcc-10): 72 errors
    nsimosci_hs_defconfig (gcc-10): 70 errors
    nsimosci_hs_smp_defconfig (gcc-10): 70 errors
    tinyconfig (gcc-10): 36 errors, 1 warning
    vdk_hs38_defconfig (gcc-10): 34 errors
    vdk_hs38_smp_defconfig (gcc-10): 34 errors

arm64:
    defconfig (gcc-10): 69 errors
    defconfig+arm64-chromebook (gcc-10): 73 errors

arm:
    am200epdkit_defconfig (gcc-10): 74 errors
    aspeed_g4_defconfig (gcc-10): 34 errors
    aspeed_g5_defconfig (gcc-10): 34 errors
    assabet_defconfig (gcc-10): 72 errors
    at91_dt_defconfig (gcc-10): 23 errors
    axm55xx_defconfig (gcc-10): 72 errors
    badge4_defconfig (gcc-10): 72 errors
    bcm2835_defconfig (gcc-10): 72 errors
    cerfcube_defconfig (gcc-10): 72 errors
    cm_x300_defconfig (gcc-10): 74 errors
    colibri_pxa270_defconfig (gcc-10): 74 errors
    colibri_pxa300_defconfig (gcc-10): 74 errors
    collie_defconfig (gcc-10): 34 errors
    corgi_defconfig (gcc-10): 74 errors
    davinci_all_defconfig (gcc-10): 72 errors
    dove_defconfig (gcc-10): 74 errors
    ep93xx_defconfig (gcc-10): 72 errors
    eseries_pxa_defconfig (gcc-10): 74 errors
    exynos_defconfig (gcc-10): 72 errors
    ezx_defconfig (gcc-10): 74 errors
    footbridge_defconfig (gcc-10): 72 errors
    gemini_defconfig (gcc-10): 34 errors
    h3600_defconfig (gcc-10): 72 errors
    h5000_defconfig (gcc-10): 74 errors
    hackkit_defconfig (gcc-10): 72 errors
    hisi_defconfig (gcc-10): 34 errors
    imote2_defconfig (gcc-10): 74 errors
    imx_v4_v5_defconfig (gcc-10): 72 errors
    imx_v6_v7_defconfig (gcc-10): 72 errors
    integrator_defconfig (gcc-10): 74 errors
    iop32x_defconfig (gcc-10): 72 errors
    ixp4xx_defconfig (gcc-10): 72 errors
    jornada720_defconfig (gcc-10): 72 errors
    keystone_defconfig (gcc-10): 72 errors
    lart_defconfig (gcc-10): 72 errors
    lpc18xx_defconfig (gcc-10): 34 errors
    lpc32xx_defconfig (gcc-10): 72 errors
    lpd270_defconfig (gcc-10): 74 errors
    lubbock_defconfig (gcc-10): 74 errors
    magician_defconfig (gcc-10): 74 errors
    mainstone_defconfig (gcc-10): 74 errors
    milbeaut_m10v_defconfig (gcc-10): 70 errors
    mini2440_defconfig (gcc-10): 72 errors
    mmp2_defconfig (gcc-10): 74 errors
    moxart_defconfig (gcc-10): 34 errors
    mps2_defconfig (gcc-10): 34 errors
    multi_v4t_defconfig (gcc-10): 22 errors
    multi_v5_defconfig (gcc-10): 24 errors
    multi_v7_defconfig (gcc-10): 142 errors
    mvebu_v5_defconfig (gcc-10): 76 errors
    mvebu_v7_defconfig (gcc-10): 74 errors
    mxs_defconfig (gcc-10): 72 errors
    neponset_defconfig (gcc-10): 72 errors
    netwinder_defconfig (gcc-10): 34 errors
    nhk8815_defconfig (gcc-10): 72 errors
    omap1_defconfig (gcc-10): 74 errors
    omap2plus_defconfig (gcc-10): 74 errors
    orion5x_defconfig (gcc-10): 74 errors
    oxnas_v6_defconfig (gcc-10): 72 errors
    palmz72_defconfig (gcc-10): 74 errors
    pcm027_defconfig (gcc-10): 74 errors
    pleb_defconfig (gcc-10): 72 errors
    pxa168_defconfig (gcc-10): 74 errors
    pxa255-idp_defconfig (gcc-10): 74 errors
    pxa3xx_defconfig (gcc-10): 74 errors
    pxa910_defconfig (gcc-10): 74 errors
    pxa_defconfig (gcc-10): 74 errors
    qcom_defconfig (gcc-10): 72 errors
    realview_defconfig (gcc-10): 74 errors
    rpc_defconfig (gcc-10): 17 errors
    s3c2410_defconfig (gcc-10): 72 errors
    s3c6400_defconfig (gcc-10): 70 errors
    s5pv210_defconfig (gcc-10): 72 errors
    sama5_defconfig (gcc-10): 22 errors
    sama7_defconfig (gcc-10): 72 errors
    shannon_defconfig (gcc-10): 72 errors
    shmobile_defconfig (gcc-10): 34 errors
    simpad_defconfig (gcc-10): 72 errors
    socfpga_defconfig (gcc-10): 72 errors
    spear13xx_defconfig (gcc-10): 72 errors
    spear3xx_defconfig (gcc-10): 72 errors
    spear6xx_defconfig (gcc-10): 72 errors
    spitz_defconfig (gcc-10): 74 errors
    stm32_defconfig (gcc-10): 32 errors
    sunxi_defconfig (gcc-10): 72 errors
    tct_hammer_defconfig (gcc-10): 72 errors
    tegra_defconfig (gcc-10): 72 errors
    trizeps4_defconfig (gcc-10): 74 errors
    u8500_defconfig (gcc-10): 72 errors
    versatile_defconfig (gcc-10): 74 errors
    vexpress_defconfig (gcc-10): 74 errors
    vf610m4_defconfig (gcc-10): 32 errors
    viper_defconfig (gcc-10): 74 errors
    vt8500_v6_v7_defconfig (gcc-10): 34 errors
    xcep_defconfig (gcc-10): 74 errors
    zeus_defconfig (gcc-10): 74 errors

i386:
    allnoconfig (gcc-10): 31 errors
    i386_defconfig (gcc-10): 73 errors
    tinyconfig (gcc-10): 35 errors

mips:
    32r2el_defconfig (gcc-10): 87 errors, 1 warning
    ar7_defconfig (gcc-10): 79 errors
    ath25_defconfig (gcc-10): 79 errors
    ath79_defconfig (gcc-10): 77 errors
    bcm47xx_defconfig (gcc-10): 79 errors
    bcm63xx_defconfig (gcc-10): 38 errors
    bigsur_defconfig (gcc-10): 87 errors
    bmips_be_defconfig (gcc-10): 37 errors
    bmips_stb_defconfig (gcc-10): 37 errors
    capcella_defconfig (gcc-10): 81 errors
    cavium_octeon_defconfig (gcc-10): 85 errors
    ci20_defconfig (gcc-10): 77 errors
    cobalt_defconfig (gcc-10): 81 errors
    cu1000-neo_defconfig (gcc-10): 77 errors
    cu1830-neo_defconfig (gcc-10): 77 errors
    db1xxx_defconfig (gcc-10): 38 errors
    decstation_64_defconfig (gcc-10): 80 errors
    decstation_defconfig (gcc-10): 79 errors
    decstation_r4k_defconfig (gcc-10): 79 errors
    e55_defconfig (gcc-10): 77 errors
    fuloong2e_defconfig (gcc-10): 85 errors
    gcw0_defconfig (gcc-10): 79 errors
    gpr_defconfig (gcc-10): 81 errors
    ip22_defconfig (gcc-10): 81 errors
    ip32_defconfig (gcc-10): 87 errors
    jazz_defconfig (gcc-10): 81 errors
    jmr3927_defconfig (gcc-10): 38 errors
    lemote2f_defconfig (gcc-10): 85 errors, 1 warning
    loongson1b_defconfig (gcc-10): 77 errors
    loongson1c_defconfig (gcc-10): 77 errors
    loongson2k_defconfig (gcc-10): 85 errors, 1 warning
    loongson3_defconfig (gcc-10): 85 errors
    malta_defconfig (gcc-10): 79 errors
    malta_kvm_defconfig (gcc-10): 79 errors
    malta_qemu_32r6_defconfig (gcc-10): 81 errors
    maltaaprp_defconfig (gcc-10): 79 errors
    maltasmvp_defconfig (gcc-10): 81 errors
    maltasmvp_eva_defconfig (gcc-10): 81 errors
    maltaup_defconfig (gcc-10): 79 errors
    maltaup_xpa_defconfig (gcc-10): 79 errors
    mpc30x_defconfig (gcc-10): 81 errors
    mtx1_defconfig (gcc-10): 81 errors
    nlm_xlp_defconfig (gcc-10): 85 errors
    nlm_xlr_defconfig (gcc-10): 81 errors
    omega2p_defconfig (gcc-10): 36 errors
    pic32mzda_defconfig (gcc-10): 75 errors
    qi_lb60_defconfig (gcc-10): 79 errors
    rb532_defconfig (gcc-10): 81 errors
    rbtx49xx_defconfig (gcc-10): 81 errors
    rm200_defconfig (gcc-10): 83 errors, 1 warning
    rs90_defconfig (gcc-10): 37 errors
    rt305x_defconfig (gcc-10): 77 errors
    sb1250_swarm_defconfig (gcc-10): 87 errors
    tb0219_defconfig (gcc-10): 81 errors
    tb0226_defconfig (gcc-10): 81 errors
    tb0287_defconfig (gcc-10): 81 errors
    vocore2_defconfig (gcc-10): 36 errors
    workpad_defconfig (gcc-10): 79 errors

riscv:
    defconfig (gcc-10): 73 errors
    nommu_k210_defconfig (gcc-10): 31 errors
    nommu_k210_sdcard_defconfig (gcc-10): 31 errors
    rv32_defconfig (gcc-10): 73 errors

x86_64:
    allnoconfig (gcc-10): 32 errors
    tinyconfig (gcc-10): 36 errors
    x86_64_defconfig (gcc-10): 75 errors
    x86_64_defconfig+x86-chromebook (gcc-10): 79 errors

Errors summary:

    11907  /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    4    arch/arm/mach-at91/pm.c:385:19: error: =E2=80=98DDR3PHY_ZQ0SRO_PUO=
DT_OFF=E2=80=99 undeclared (first use in this function)
    4    arch/arm/mach-at91/pm.c:381:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDO=
DT_OFF=E2=80=99 undeclared (first use in this function)
    4    arch/arm/mach-at91/pm.c:377:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PUO=
_OFF=E2=80=99 undeclared (first use in this function)
    4    arch/arm/mach-at91/pm.c:373:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDO=
_OFF=E2=80=99 undeclared (first use in this function)
    4    arch/arm/mach-at91/pm.c:370:38: error: =E2=80=98DDR3PHY_ZQ0SR0=E2=
=80=99 undeclared (first use in this function)
    3    /bin/sh: 1:   SYSHDR  arch/mips/include/generated/uapi/asm/unistd_=
n32.h
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99
    2    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/irq_work.h
    2    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/poll.h
    2    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/msgbuf.h
    2    /bin/sh: 1:   UPD     include/generated/utsrelease.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/x86/include/generated/uapi/asm/termbits.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/riscv/include/generated/uapi/asm/swab.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/mips/include/generated/asm/simd.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/mips/include/generated/asm/emergency-restart.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/uapi/asm/kvm_para.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/asm/msi.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/asm/exec.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arc/include/generated/asm/local.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  UPD    =
 include/generated/compile.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSHDR =
 arch/arm/include/generated/uapi/asm/unistd-oabi.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC =
 arch/mips/boot/tools/relocs_32.o
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC     =
 init/noinitramfs.o
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC     =
 init/do_mounts_initrd.o
    1    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/qspinlock.h
    1    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/kvm_para.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/early_ioremap=
.h
    1    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/resource=
.h
    1    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/mman.h
    1    /bin/sh: 1:   SYSTBL  arch/mips/include/generated/asm/syscall_tabl=
e_o32.h
    1    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-o=
abi.h
    1    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-e=
abi.h
    1    /bin/sh: 1:   CHK     include/generated/compile.h
    1    /bin/sh: 1:   CC      init/main.o
    1    /bin/sh: 1:   AR      drivers/crypto/hisilicon/built-in.a
    1    /bin/sh: 1:   AR      arch/mips/crypto/built-in.a

Warnings summary:

    2    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes =
is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_devic=
e_reg): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expec=
ted "0,0"
    1    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' i=
s unknown, fallback to ''

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
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 87 errors, 1 warning, 0 sec=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 32 errors, 0 warnings, 0 section =
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

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 32 errors, 0 warnings, 0 secti=
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

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 31 errors, 0 warnings, 0 section=
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

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, =
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

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 secti=
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
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 =
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

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 =
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

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/poll.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
at91_dt_defconfig (arm, gcc-10) =E2=80=94 FAIL, 23 errors, 0 warnings, 0 se=
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
    arch/arm/mach-at91/pm.c:370:38: error: =E2=80=98DDR3PHY_ZQ0SR0=E2=80=99=
 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:373:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:377:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PUO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:381:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDODT_OF=
F=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:385:19: error: =E2=80=98DDR3PHY_ZQ0SRO_PUODT_OF=
F=E2=80=99 undeclared (first use in this function)

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 sec=
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
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 sec=
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

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
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
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arc/include/generated/asm/local.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
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
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 s=
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
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 38 errors, 0 warnings, 0 s=
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

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 87 errors, 0 warnings, 0 se=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0 =
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

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 37 errors, 0 warnings, 0=
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

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/irq_work.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 85 errors, 0 warning=
s, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
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
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 sect=
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
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 se=
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
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 se=
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
    /bin/sh: 1:   AR      arch/mips/crypto/built-in.a
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warning=
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

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warning=
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

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 sec=
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
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, =
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
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, =
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
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, =
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
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 38 errors, 0 warnings, 0 se=
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

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 80 errors, 0 warning=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, =
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnin=
gs, 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSTBL  arch/mips/include/generated/asm/syscall_table_o32=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 73 errors, 0 warnings, 0 section =
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 69 errors, 0 warnings, 0 section =
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC      init=
/do_mounts_initrd.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 73 errors, 0 war=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 secti=
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
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
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
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, =
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/asm/exec.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
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
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sectio=
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
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0=
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
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 85 errors, 0 warnings, 0=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 sect=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC  arch=
/mips/boot/tools/relocs_32.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 sec=
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

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 secti=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
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
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sect=
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
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, 0 se=
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
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, =
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
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 secti=
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

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 secti=
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
    /bin/sh: 1:   UPD     include/generated/utsrelease.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
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
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 =
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
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0=
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
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
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
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 sect=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/mips/include/generated/asm/emergency-restart.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 87 errors, 0 warnings, 0 sect=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
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

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Sectio=
n mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the =
function .init.text:ixp4xx_irq_init()

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 sect=
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
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/kvm_para.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   UPD     include/generated/utsrelease.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 38 errors, 0 warnings, 0 s=
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

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0=
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
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 secti=
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
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 85 errors, 1 warning, 0 s=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, =
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
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, =
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
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 85 errors, 1 warning, 0=
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
    /bin/sh: 1:   CHK     include/generated/compile.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 85 errors, 0 warnings, 0=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Sect=
ion mismatch in reference from the variable __ksymtab_prom_init_numa_memory=
 to the function .init.text:prom_init_numa_memory()

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 se=
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

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  SYSHDR  arch=
/arm/include/generated/uapi/asm/unistd-oabi.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 se=
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
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-oabi.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 =
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
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 sec=
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
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0=
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
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warni=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0=
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
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0=
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

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warning=
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

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 s=
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
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings,=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  UPD     incl=
ude/generated/compile.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   AR      drivers/crypto/hisilicon/built-in.a
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
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
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 secti=
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

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 sec=
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

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 se=
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

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 secti=
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
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 FAIL, 22 errors, 0 warnings, 0 =
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
    arch/arm/mach-at91/pm.c:370:38: error: =E2=80=98DDR3PHY_ZQ0SR0=E2=80=99=
 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:373:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:377:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PUO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:381:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDODT_OF=
F=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:385:19: error: =E2=80=98DDR3PHY_ZQ0SRO_PUODT_OF=
F=E2=80=99 undeclared (first use in this function)

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 24 errors, 0 warnings, 0 s=
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
    arch/arm/mach-at91/pm.c:370:38: error: =E2=80=98DDR3PHY_ZQ0SR0=E2=80=99=
 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:373:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:377:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PUO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:381:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDODT_OF=
F=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:385:19: error: =E2=80=98DDR3PHY_ZQ0SRO_PUODT_OF=
F=E2=80=99 undeclared (first use in this function)

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 142 errors, 0 warnings, 0 =
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/poll.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sectio=
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
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-eabi.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 =
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

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 85 errors, 0 warnings, 0 s=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 s=
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

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 31 errors, 0 warnings,=
 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/riscv/include/generated/uapi/asm/swab.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
nommu_k210_sdcard_defconfig (riscv, gcc-10) =E2=80=94 PASS, 31 errors, 0 wa=
rnings, 0 section mismatches

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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC      init=
/noinitramfs.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnings, =
0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/msgbuf.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 70 errors, 0 warnin=
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
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 s=
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
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/irq_work.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/asm/msi.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
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
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 se=
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
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/early_ioremap.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 secti=
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
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
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
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0=
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
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
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
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sec=
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
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/uapi/asm/kvm_para.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 s=
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
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   SYSHDR  arch/mips/include/generated/uapi/asm/unistd_n32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 =
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

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 s=
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
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 83 errors, 1 warning, 0 sect=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/mips/include/generated/asm/simd.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 17 errors, 0 warnings, 0 sectio=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 77 errors, 0 warnings, 0 se=
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
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/qspinlock.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 73 errors, 0 warnings, 0 sec=
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

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 22 errors, 0 warnings, 0 sect=
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
    arch/arm/mach-at91/pm.c:370:38: error: =E2=80=98DDR3PHY_ZQ0SR0=E2=80=99=
 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:373:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:377:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PUO_OFF=
=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:381:19: error: =E2=80=98DDR3PHY_ZQ0SR0_PDODT_OF=
F=E2=80=99 undeclared (first use in this function)
    arch/arm/mach-at91/pm.c:385:19: error: =E2=80=98DDR3PHY_ZQ0SRO_PUODT_OF=
F=E2=80=99 undeclared (first use in this function)

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
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
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 87 errors, 0 warnings=
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
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 s=
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

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sec=
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
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 =
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
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
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
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 s=
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
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 32 errors, 0 warnings, 0 sect=
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

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
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
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 se=
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

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 se=
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

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 81 errors, 0 warnings, 0 se=
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

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0=
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
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
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
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 36 errors, 1 warning, 0 section mi=
smatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/mman.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 s=
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
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
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
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/msgbuf.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings,=
 0 section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/resource.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 =
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
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 sect=
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
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 36 errors, 0 warnings, 0 s=
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

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 34 errors, 0 warnings,=
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
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 79 errors, 0 warnings, 0 s=
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/x86/include/generated/uapi/asm/termbits.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 secti=
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

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 74 errors, 0 warnings, 0 secti=
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
    /bin/sh: 1:   CC      init/main.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
