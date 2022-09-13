Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978275B782C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiIMRi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiIMRie (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:38:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9022E760D8
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:29:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so16148548pja.5
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=ZlYT6gwVOe4Rm4wc7ERNH5EL3oz3Wcwme4R+kBDv6Gg=;
        b=OOpOwc+O3rFvW7QzPY245ZEj01dBX4c1GRkEIw0PoJFg1BTmHVBj6T8XNPJdBEQyC1
         FCyjmDoVZzRt9Zvkr2Te1pG5nGmZDnn/8rAOsqRlSFWzRC1Ysh3qZ0e9swhZeza4ydy2
         ycc8y+lk8v2+WL9V2JFBrxu62mhGh2t2CEr1UXarCQOEEqhuXHBbpznkR4gHMUg5uzgh
         3+HrdxkrNK6AEr3glSH+e+HtgcCm6qTU8okH+P+DGSYeQwbeBLSlk5NIhrDA2e0b6/kj
         jCcl6muTDC56JWQh3aa+6KLSYK3WpwSkdbqhOuZcDJmmRyDqQpN8+ddlRd0OOTY0Ztbj
         nDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=ZlYT6gwVOe4Rm4wc7ERNH5EL3oz3Wcwme4R+kBDv6Gg=;
        b=LhYNITnre9QTlzIJ+0v9Lw9OzvXiS0dg3g1+FD14SR0RwPHaZNbK/kGjxMDdoKiu0o
         a2B0noV4MxNMxkd/g27YJBea0aFpqnO25TLJJRiNtKjlnrS2/vaIeRmmbZ0sRnBH57oO
         rMv1vxfoarbgH2DcQTb/pHS3Kngt0FToOIPo4TK6dUK170+/bLNxETwdgEmFMRl110ms
         75Hw8ozFpRkwMLw79BduPT/Mg2b1BGuLGPFxTIzwts9FTh122Fz/plR04WPdUJzNqqYk
         B/xuX9MPuERQjaIWzWQO27CFuxf46uqz6Mlw33A7E7yZLZIny+uj4E9l2C/aoAlaQle9
         1+Pg==
X-Gm-Message-State: ACrzQf1qhUFL0M3xO78Z2FRsRJEcxZ510R9VM+A9pDQ/zouJfgd2yiM/
        6fvjhsIcM4nshc0tEByQnIMlXRYc8+ybMFMMmHs=
X-Google-Smtp-Source: AMsMyM6PSmcTtZw8WiRHc7deFq8c1jQjLA5SEIYq2sza5mWlPwcR81tfMjCEi7jkLbJd+MrqYgBYOQ==
X-Received: by 2002:a17:90a:13c8:b0:200:17ca:f183 with SMTP id s8-20020a17090a13c800b0020017caf183mr131258pjf.104.1663086585727;
        Tue, 13 Sep 2022 09:29:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r2-20020aa79882000000b00536aa488062sm8086988pfl.163.2022.09.13.09.29.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 09:29:44 -0700 (PDT)
Message-ID: <6320aff8.a70a0220.90428.cebe@mx.google.com>
Date:   Tue, 13 Sep 2022 09:29:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.66-121-gb3f0d61067d1e
Subject: stable-rc/queue/5.15 build: 180 builds: 4 failed, 176 passed,
 12154 errors, 5 warnings (v5.15.66-121-gb3f0d61067d1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 build: 180 builds: 4 failed, 176 passed, 12154 errors,=
 5 warnings (v5.15.66-121-gb3f0d61067d1e)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.66-121-gb3f0d61067d1e/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.66-121-gb3f0d61067d1e
Git Commit: b3f0d61067d1eb1fd43964666efb988a46c0f7ce
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

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
    at91_dt_defconfig (gcc-10): 72 errors
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
    multi_v4t_defconfig (gcc-10): 38 errors
    multi_v5_defconfig (gcc-10): 86 errors
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
    sama5_defconfig (gcc-10): 72 errors
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

    12104  /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    3    /bin/sh: 1:   SYSHDR  arch/mips/include/generated/uapi/asm/unistd_=
n32.h
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99
    2    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/uapi/asm/kvm_para.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/asm/parport.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arm/include/generated/asm/msi.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arc/include/generated/asm/module.lds.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP   =
 arch/arc/include/generated/asm/compat.h
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  HOSTCC =
 scripts/dtc/fstree.o
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC     =
 net/core/netpoll.o
    1    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC     =
 init/do_mounts.o
    1    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/user.h
    1    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/percpu.h
    1    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/kvm_para.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/termios.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/socket.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/sembuf.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/resource=
.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/bitsperl=
ong.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/parport.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/extable.h
    1    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/compat.h
    1    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/types.h
    1    /bin/sh: 1:   UPD     include/generated/utsrelease.h
    1    /bin/sh: 1:   UPD     include/generated/compile.h
    1    /bin/sh: 1:   SYSNR   arch/mips/include/generated/asm/unistd_nr_o3=
2.h
    1    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-o=
abi.h
    1    /bin/sh: 1:   HOSTCC  scripts/dtc/dtc.o
    1    /bin/sh: 1:   HOSTCC  arch/x86/tools/relocs_64.o
    1    /bin/sh: 1:   HOSTCC  arch/mips/boot/tools/relocs_32.o
    1    /bin/sh: 1:   CHK     include/generated/compile.h
    1    /bin/sh: 1:   CC      fs/kernfs/file.o
    1    /bin/sh: 1:   CC      crypto/asymmetric_keys/pkcs7_parser.o
    1    /bin/sh: 1:   CC      arch/arm/kernel/irq.o
    1    /bin/sh: 1:   AR      drivers/pwm/built-in.a

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
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/percpu.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 31 errors, 0 warnings, 0 section=
 mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   HOSTCC  arch/x86/tools/relocs_64.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 se=
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
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/kvm_para.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/socket.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   CC      crypto/asymmetric_keys/pkcs7_parser.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   WRAP    arch/mips/include/generated/asm/user.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   UPD     include/generated/compile.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/compat.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   SYSNR   arch/mips/include/generated/asm/unistd_nr_o32.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   HOSTCC  arch/mips/boot/tools/relocs_32.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC      init=
/do_mounts.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  CC      net/=
core/netpoll.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/termios.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 142 errors, 0 warnings, 0 =
section mismatches

Errors:
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/sembuf.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/resource.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arc/include/generated/asm/compat.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arc/include/generated/asm/module.lds.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   CC      fs/kernfs/file.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   AR      drivers/pwm/built-in.a
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/parport.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 72 errors, 0 warnings, 0 sect=
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/asm/extable.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   CC      arch/arm/kernel/irq.o
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1:   SYSHDR  arch/arm/include/generated/uapi/asm/unistd-oabi.h
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
    /bin/sh: 1:   WRAP    arch/arm/include/generated/uapi/asm/bitsperlong.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied  WRAP    arch=
/arm/include/generated/asm/parport.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1:   WRAP    arch/arc/include/generated/uapi/asm/types.h
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
    /bin/sh: 1: ../scripts/pahole-flags.sh: Permission denied
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
