Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02281BCF88
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 00:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgD1WNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 18:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbgD1WNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 18:13:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20409C03C1AC
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 15:13:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d184so64054pfd.4
        for <stable@vger.kernel.org>; Tue, 28 Apr 2020 15:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2N4jzIs/Y/qNrKKRy/XXkJ95NtjTHrckK2zUT0f+YOQ=;
        b=b92Di0QMnzOASDmWNXC0W/ZmrU5LrLshW47j3QTvIPHQM8uriqtM7ODT70a6OGhbtJ
         jnvBWlOJnuR1H5tEjveHp65V2ueeIYYbK4aQ1QrwZlAkQw5WbNh0b4oFJzbddzHVNJeI
         4iZNNps6y20KPsG7kz6swfIUYW0DBLVHFUdKdDHeofyUu+F3wnYKeSYdj9+zGwxlG/ZO
         73zizsHbaKjiWeRYJlaGcQ8RY4CaKfTHDLl0qRO++hZZVV3vG/MVKunkoUz/KqMyGhk9
         d7MslGnBjh6s9ugbgs6B1cyowTfLgp0U9S++lZ/x4AkdP4hU8JQvDZTEH4WZ8j/Z5RGs
         1y+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2N4jzIs/Y/qNrKKRy/XXkJ95NtjTHrckK2zUT0f+YOQ=;
        b=siN3DUcTwuYuhGQDZVy5OQ/Db+7uvOyoJdkq4J+qDqttZLwGtjYqz07aaW4qfXUIiD
         ToeN78gRz+/V7m6NLH/clgM5bfhVmTSJL6pvN1F/+CpvYyHi4kFgfKBP5F7kj1xTQ8Cs
         Xc9+nsoeawcyXpRJ8a7k0Iw1iToaQxwm0bOVbEOLP/57a2p6ZlatYdMMRlwkM8UTQIxa
         pVD0n+WQ33gsRU+zAMQfVFTRYasiWW4qb3g/5v14+JFU0qakUFMzdmZcPM97ar+E59qy
         FsRilWd1L8B+UeexfuKuGB4TPJcAIr61Nlyos8gbzPT0p1dOV8E6ah4YmG3gTz+f3q77
         VBIQ==
X-Gm-Message-State: AGi0PubYMkp/opSxXtyHPzbf4tqWGaWtNJo8D9eOQbA6OizzkB4cA+cy
        pb9Kbt+LaV4vqPLCtx4VdLdUyamPNhM=
X-Google-Smtp-Source: APiQypL5fvs71TigK7Gqku8qvivAj6tqbNvXdxx4oZmKOqRtz0JYGSIDFGqM26Oxe5FisqWkXK7skA==
X-Received: by 2002:a63:5952:: with SMTP id j18mr29683300pgm.272.1588112007355;
        Tue, 28 Apr 2020 15:13:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 82sm15812972pfv.214.2020.04.28.15.13.25
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 15:13:25 -0700 (PDT)
Message-ID: <5ea8aa85.1c69fb81.31cbb.d682@mx.google.com>
Date:   Tue, 28 Apr 2020 15:13:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-3.16.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v3.16.83
X-Kernelci-Report-Type: build
Subject: stable/linux-3.16.y build: 186 builds: 13 failed, 173 passed,
 11 errors, 3939 warnings (v3.16.83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-3.16.y build: 186 builds: 13 failed, 173 passed, 11 errors, 39=
39 warnings (v3.16.83)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-3.16.y/k=
ernel/v3.16.83/

Tree: stable
Branch: linux-3.16.y
Git Describe: v3.16.83
Git Commit: 92f17c867833bbfdaced034629afb8e30a19e882
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-8) FAIL
    fpga_defconfig: (gcc-8) FAIL
    fpga_noramfs_defconfig: (gcc-8) FAIL

arm:
    kzm9g_defconfig: (gcc-8) FAIL

mips:
    cavium_octeon_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
    malta_kvm_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sead3_defconfig: (gcc-8) FAIL
    sead3micro_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 2 errors, 235 warnings
    fpga_defconfig (gcc-8): 3 warnings
    fpga_noramfs_defconfig (gcc-8): 2 errors, 8 warnings

arm64:
    allnoconfig (gcc-8): 2 warnings

arm:
    acs5k_defconfig (gcc-8): 7 warnings
    acs5k_tiny_defconfig (gcc-8): 6 warnings
    allnoconfig (gcc-8): 4 warnings
    am200epdkit_defconfig (gcc-8): 12 warnings
    ape6evm_defconfig (gcc-8): 29 warnings
    armadillo800eva_defconfig (gcc-8): 5 warnings
    assabet_defconfig (gcc-8): 9 warnings
    at91_dt_defconfig (gcc-8): 6 warnings
    at91rm9200_defconfig (gcc-8): 15 warnings
    at91sam9260_9g20_defconfig (gcc-8): 13 warnings
    at91sam9261_9g10_defconfig (gcc-8): 14 warnings
    at91sam9263_defconfig (gcc-8): 12 warnings
    at91sam9g45_defconfig (gcc-8): 5 warnings
    at91sam9rl_defconfig (gcc-8): 8 warnings
    at91x40_defconfig (gcc-8): 4 warnings
    axm55xx_defconfig (gcc-8): 19 warnings
    badge4_defconfig (gcc-8): 17 warnings
    bcm2835_defconfig (gcc-8): 5 warnings
    bcm_defconfig (gcc-8): 14 warnings
    bockw_defconfig (gcc-8): 9 warnings
    cerfcube_defconfig (gcc-8): 6 warnings
    clps711x_defconfig (gcc-8): 10 warnings
    cm_x2xx_defconfig (gcc-8): 14 warnings
    cm_x300_defconfig (gcc-8): 16 warnings
    cns3420vb_defconfig (gcc-8): 8 warnings
    colibri_pxa270_defconfig (gcc-8): 19 warnings
    colibri_pxa300_defconfig (gcc-8): 14 warnings
    collie_defconfig (gcc-8): 5 warnings
    corgi_defconfig (gcc-8): 20 warnings
    davinci_all_defconfig (gcc-8): 13 warnings
    dove_defconfig (gcc-8): 17 warnings
    ebsa110_defconfig (gcc-8): 7 warnings
    efm32_defconfig (gcc-8): 3 warnings
    em_x270_defconfig (gcc-8): 15 warnings
    ep93xx_defconfig (gcc-8): 8 warnings
    eseries_pxa_defconfig (gcc-8): 17 warnings
    exynos_defconfig (gcc-8): 18 warnings
    ezx_defconfig (gcc-8): 17 warnings
    footbridge_defconfig (gcc-8): 10 warnings
    genmai_defconfig (gcc-8): 3 warnings
    h3600_defconfig (gcc-8): 10 warnings
    h5000_defconfig (gcc-8): 12 warnings
    hackkit_defconfig (gcc-8): 6 warnings
    hi3xxx_defconfig (gcc-8): 13 warnings
    imote2_defconfig (gcc-8): 15 warnings
    imx_v4_v5_defconfig (gcc-8): 32 warnings
    imx_v6_v7_defconfig (gcc-8): 26 warnings
    integrator_defconfig (gcc-8): 8 warnings
    iop13xx_defconfig (gcc-8): 13 warnings
    iop32x_defconfig (gcc-8): 13 warnings
    iop33x_defconfig (gcc-8): 8 warnings
    ixp4xx_defconfig (gcc-8): 8 warnings
    jornada720_defconfig (gcc-8): 10 warnings
    keystone_defconfig (gcc-8): 36 warnings
    kirkwood_defconfig (gcc-8): 17 warnings
    koelsch_defconfig (gcc-8): 4 warnings
    ks8695_defconfig (gcc-8): 7 warnings
    kzm9g_defconfig (gcc-8): 1 error, 9 warnings
    lager_defconfig (gcc-8): 4 warnings
    lart_defconfig (gcc-8): 11 warnings
    lpc32xx_defconfig (gcc-8): 6 warnings
    lpd270_defconfig (gcc-8): 6 warnings
    lubbock_defconfig (gcc-8): 7 warnings
    mackerel_defconfig (gcc-8): 16 warnings
    magician_defconfig (gcc-8): 19 warnings
    mainstone_defconfig (gcc-8): 6 warnings
    marzen_defconfig (gcc-8): 10 warnings
    mini2440_defconfig (gcc-8): 17 warnings
    mmp2_defconfig (gcc-8): 9 warnings
    moxart_defconfig (gcc-8): 7 warnings
    msm_defconfig (gcc-8): 35 warnings
    multi_v5_defconfig (gcc-8): 19 warnings
    multi_v7_defconfig (gcc-8): 25 warnings
    mv78xx0_defconfig (gcc-8): 34 warnings
    mvebu_v5_defconfig (gcc-8): 18 warnings
    mvebu_v7_defconfig (gcc-8): 17 warnings
    mxs_defconfig (gcc-8): 36 warnings
    neponset_defconfig (gcc-8): 8 warnings
    netwinder_defconfig (gcc-8): 5 warnings
    netx_defconfig (gcc-8): 12 warnings
    nhk8815_defconfig (gcc-8): 17 warnings
    nuc910_defconfig (gcc-8): 6 warnings
    nuc950_defconfig (gcc-8): 6 warnings
    nuc960_defconfig (gcc-8): 6 warnings
    omap1_defconfig (gcc-8): 17 warnings
    omap2plus_defconfig (gcc-8): 36 warnings
    orion5x_defconfig (gcc-8): 16 warnings
    palmz72_defconfig (gcc-8): 6 warnings
    pcm027_defconfig (gcc-8): 8 warnings
    pleb_defconfig (gcc-8): 6 warnings
    prima2_defconfig (gcc-8): 9 warnings
    pxa168_defconfig (gcc-8): 6 warnings
    pxa255-idp_defconfig (gcc-8): 6 warnings
    pxa3xx_defconfig (gcc-8): 6 warnings
    pxa910_defconfig (gcc-8): 6 warnings
    qcom_defconfig (gcc-8): 36 warnings
    raumfeld_defconfig (gcc-8): 15 warnings
    realview-smp_defconfig (gcc-8): 6 warnings
    realview_defconfig (gcc-8): 6 warnings
    rpc_defconfig (gcc-8): 9 warnings
    s3c2410_defconfig (gcc-8): 21 warnings
    s3c6400_defconfig (gcc-8): 6 warnings
    s5p64x0_defconfig (gcc-8): 7 warnings
    s5pc100_defconfig (gcc-8): 5 warnings
    s5pv210_defconfig (gcc-8): 7 warnings
    sama5_defconfig (gcc-8): 20 warnings
    shannon_defconfig (gcc-8): 6 warnings
    shmobile_defconfig (gcc-8): 5 warnings
    simpad_defconfig (gcc-8): 16 warnings
    socfpga_defconfig (gcc-8): 29 warnings
    spear13xx_defconfig (gcc-8): 9 warnings
    spear3xx_defconfig (gcc-8): 7 warnings
    spear6xx_defconfig (gcc-8): 7 warnings
    spitz_defconfig (gcc-8): 20 warnings
    sunxi_defconfig (gcc-8): 11 warnings
    tct_hammer_defconfig (gcc-8): 7 warnings
    tegra_defconfig (gcc-8): 23 warnings
    trizeps4_defconfig (gcc-8): 20 warnings
    u300_defconfig (gcc-8): 7 warnings
    u8500_defconfig (gcc-8): 19 warnings
    versatile_defconfig (gcc-8): 6 warnings
    vexpress_defconfig (gcc-8): 12 warnings
    viper_defconfig (gcc-8): 14 warnings
    vt8500_v6_v7_defconfig (gcc-8): 12 warnings
    xcep_defconfig (gcc-8): 6 warnings
    zeus_defconfig (gcc-8): 15 warnings

i386:
    allnoconfig (gcc-8): 3 warnings
    i386_defconfig (gcc-8): 5 warnings

mips:
    allnoconfig (gcc-8): 28 warnings
    ar7_defconfig (gcc-8): 29 warnings
    ath79_defconfig (gcc-8): 31 warnings
    bcm47xx_defconfig (gcc-8): 43 warnings
    bcm63xx_defconfig (gcc-8): 28 warnings
    bigsur_defconfig (gcc-8): 86 warnings
    capcella_defconfig (gcc-8): 29 warnings
    cavium_octeon_defconfig (gcc-8): 50 warnings
    cobalt_defconfig (gcc-8): 29 warnings
    db1xxx_defconfig (gcc-8): 29 warnings
    decstation_defconfig (gcc-8): 29 warnings
    e55_defconfig (gcc-8): 29 warnings
    fuloong2e_defconfig (gcc-8): 59 warnings
    gpr_defconfig (gcc-8): 29 warnings
    ip22_defconfig (gcc-8): 30 warnings
    ip27_defconfig (gcc-8): 73 warnings
    ip28_defconfig (gcc-8): 51 warnings
    ip32_defconfig (gcc-8): 59 warnings
    jazz_defconfig (gcc-8): 29 warnings
    jmr3927_defconfig (gcc-8): 28 warnings
    lasat_defconfig (gcc-8): 28 warnings
    lemote2f_defconfig (gcc-8): 1 error, 4 warnings
    loongson3_defconfig (gcc-8): 329 warnings
    ls1b_defconfig (gcc-8): 29 warnings
    malta_defconfig (gcc-8): 31 warnings
    malta_kvm_defconfig (gcc-8): 2 errors, 4 warnings
    malta_kvm_guest_defconfig (gcc-8): 31 warnings
    maltaaprp_defconfig (gcc-8): 31 warnings
    maltasmvp_defconfig (gcc-8): 34 warnings
    maltasmvp_eva_defconfig (gcc-8): 34 warnings
    maltaup_defconfig (gcc-8): 31 warnings
    markeins_defconfig (gcc-8): 29 warnings
    mips_paravirt_defconfig (gcc-8): 50 warnings
    mpc30x_defconfig (gcc-8): 29 warnings
    msp71xx_defconfig (gcc-8): 31 warnings
    mtx1_defconfig (gcc-8): 35 warnings
    nlm_xlp_defconfig (gcc-8): 77 warnings
    nlm_xlr_defconfig (gcc-8): 1 error, 2 warnings
    pnx8335_stb225_defconfig (gcc-8): 31 warnings
    qi_lb60_defconfig (gcc-8): 30 warnings
    rb532_defconfig (gcc-8): 29 warnings
    rbtx49xx_defconfig (gcc-8): 30 warnings
    rm200_defconfig (gcc-8): 29 warnings
    rt305x_defconfig (gcc-8): 31 warnings
    sb1250_swarm_defconfig (gcc-8): 48 warnings
    sead3_defconfig (gcc-8): 31 warnings
    sead3micro_defconfig (gcc-8): 2 errors, 2 warnings
    tb0219_defconfig (gcc-8): 29 warnings
    tb0226_defconfig (gcc-8): 29 warnings
    tb0287_defconfig (gcc-8): 29 warnings
    workpad_defconfig (gcc-8): 29 warnings
    xway_defconfig (gcc-8): 31 warnings

x86_64:
    allnoconfig (gcc-8): 2 warnings
    x86_64_defconfig (gcc-8): 63 warnings

Errors summary:

    4    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint=
 in =E2=80=98asm=E2=80=99
    2    include/linux/kern_levels.h:4:18: error: format =E2=80=98%lx=E2=80=
=99 expects argument of type =E2=80=98long unsigned int=E2=80=99, but argum=
ent 4 has type =E2=80=98u64=E2=80=99 {aka =E2=80=98long long unsigned int=
=E2=80=99} [-Werror=3Dformat=3D]
    1    arch/mips/loongson/common/cs5536/cs5536_ohci.c:141:25: error: bitw=
ise comparison always evaluates to false [-Werror=3Dtautological-compare]
    1    arch/mips/kernel/genex.S:234: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another=
 ISA mode
    1    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise co=
mparison always evaluates to false [-Werror=3Dtautological-compare]
    1    arch/arm/mach-shmobile/board-kzm9g.c:734:13: error: initializer el=
ement is not computable at load time

Warnings summary:

    1008  arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 =
on a boolean expression [-Wbool-operation]
    413  <stdin>:1238:2: warning: #warning syscall seccomp not implemented =
[-Wcpp]
    288  arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 o=
n a boolean expression [-Wbool-operation]
    128  fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 i=
n =E2=80=98strncpy=E2=80=99 call is the same expression as the source; did =
you mean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    123  arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    118  lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    115  fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 outpu=
t truncated before terminating nul copying as many bytes from a string as i=
ts length [-Wstringop-truncation]
    113  cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    104  net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified b=
ound depends on the length of the source argument [-Wstringop-overflow=3D]
    66   drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=
=99 output truncated copying between 0 and 16 bytes from a string of length=
 16 [-Wstringop-truncation]
    66   drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=
=99 specified bound depends on the length of the source argument [-Wstringo=
p-overflow=3D]
    54   include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98=
struct sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=
=E2=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t=
 aligned to 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98=
struct sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t =
aligned to 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98=
struct sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=
=99 offset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98=
struct sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=
=80=99 offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t =
aligned to 8 [-Wpacked-not-aligned]
    54   include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98=
struct sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    49   crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 speci=
fied bound 64 equals destination size [-Wstringop-truncation]
    49   crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    49   crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    49   crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 spec=
ified bound 64 equals destination size [-Wstringop-truncation]
    49   crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 spec=
ified bound 64 equals destination size [-Wstringop-truncation]
    46   drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 o=
f =E2=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-no=
t-aligned]
    34   net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 spe=
cified bound 2 equals source length [-Wstringop-overflow=3D]
    30   fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 32 equals destination size [-Wstringop-truncation]
    30   fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 32 equals destination size [-Wstringop-truncation]
    28   fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 out=
put truncated before terminating nul copying as many bytes from a string as=
 its length [-Wstringop-truncation]
    22   net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat=
_group_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    20   include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    20   include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    14   net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output =
may be truncated copying 21 bytes from a string of length 64 [-Wstringop-tr=
uncation]
    14   net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output=
 may be truncated copying 21 bytes from a string of length 64 [-Wstringop-t=
runcation]
    14   net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 speci=
fied bound 16 equals destination size [-Wstringop-truncation]
    14   net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=
=99 output may be truncated copying 127 bytes from a string of length 127 [=
-Wstringop-truncation]
    14   include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (=
void *) / sizeof (void)=E2=80=99 does not compute the number of array eleme=
nts [-Wsizeof-pointer-div]
    14   drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alig=
nment 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-ali=
gned]
    12   net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=
=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    11   net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat=
_group_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    11   net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 =
in =E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 =
[-Wpacked-not-aligned]
    11   net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset =
132 in =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t align=
ed to 8 [-Wpacked-not-aligned]
    11   net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4=
 in =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned =
to 8 [-Wpacked-not-aligned]
    11   net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat=
_group_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    11   net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 =
in =E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    11   fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output ma=
y be truncated copying between 0 and 31 bytes from a string of length 253 [=
-Wstringop-truncation]
    6    drivers/video/hdmi.c:163:2: warning: =E2=80=98strncpy=E2=80=99 spe=
cified bound 16 equals destination size [-Wstringop-truncation]
    6    drivers/video/hdmi.c:162:2: warning: =E2=80=98strncpy=E2=80=99 spe=
cified bound 8 equals destination size [-Wstringop-truncation]
    6    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3598:2: warn=
ing: =E2=80=98strncpy=E2=80=99 output truncated before terminating nul copy=
ing 3 bytes from a string of the same length [-Wstringop-truncation]
    5    {standard input}:1462: Warning: the `msa' extension requires 64-bi=
t FPRs
    5    drivers/net/irda/irtty-sir.c:405:3: warning: =E2=80=98strncpy=E2=
=80=99 output may be truncated copying 5 bytes from a string of length 15 [=
-Wstringop-truncation]
    4    fs/cifs/cifsencrypt.c:309:3: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 16 equals destination size [-Wstringop-truncation]
    4    drivers/video/fbdev/mx3fb.c:748:2: warning: =E2=80=98strncpy=E2=80=
=99 output truncated before terminating nul copying 8 bytes from a string o=
f the same length [-Wstringop-truncation]
    4    drivers/misc/eeprom/at25.c:311:2: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 10 equals destination size [-Wstringop-truncation]
    3    sound/pci/au88x0/au88x0_core.c:2303:58: warning: =E2=80=98src[0]=
=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    3    sound/pci/au88x0/au88x0_core.c:2302:59: warning: =E2=80=98mix[0]=
=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    3    drivers/scsi/scsi_tgt_if.c:192:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 16 equals destination size [-Wstringop-truncation]
    3    drivers/net/wireless/hostap/hostap_ioctl.c:3614:3: warning: =E2=80=
=98strncpy=E2=80=99 specified bound 16 equals destination size [-Wstringop-=
truncation]
    3    cc1: all warnings being treated as errors
    2    {standard input}:1715: Warning: the `msa' extension requires 64-bi=
t FPRs
    2    {standard input}:1498: Warning: the `msa' extension requires 64-bi=
t FPRs
    2    mm/mmap.c:650:2: warning: =E2=80=98prev=E2=80=99 may be used unini=
tialized in this function [-Wmaybe-uninitialized]
    2    mm/memory.c:581:7: warning: assignment to =E2=80=98pgtable_t=E2=80=
=99 {aka =E2=80=98long unsigned int=E2=80=99} from =E2=80=98void *=E2=80=99=
 makes integer from pointer without a cast [-Wint-conversion]
    2    include/linux/rbtree.h:85:11: warning: =E2=80=98rb_link=E2=80=99 m=
ay be used uninitialized in this function [-Wmaybe-uninitialized]
    2    include/linux/rbtree.h:82:28: warning: =E2=80=98rb_parent=E2=80=99=
 may be used uninitialized in this function [-Wmaybe-uninitialized]
    2    include/linux/kernel.h:716:17: warning: comparison of distinct poi=
nter types lacks a cast
    2    fs/xfs/xfs_xattr.c:159:2: warning: =E2=80=98strncpy=E2=80=99 outpu=
t may be truncated copying between 5 and 9 bytes from a string of length 9 =
[-Wstringop-truncation]
    2    drivers/net/wireless/prism54/isl_ioctl.c:284:2: warning: =E2=80=98=
strncpy=E2=80=99 output may be truncated copying 16 bytes from a string of =
length 28 [-Wstringop-truncation]
    2    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argum=
ent 5 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from integer withou=
t a cast [-Wint-conversion]
    2    drivers/mfd/db8500-prcmu.c:2721:2: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 20 equals destination size [-Wstringop-truncation]
    2    arch/x86/kernel/rtc.c:173:29: warning: duplicate =E2=80=98const=E2=
=80=99 declaration specifier [-Wduplicate-decl-specifier]
    2    arch/x86/kernel/head_32.S:672: Warning: ignoring fill value in sec=
tion `.bss..page_aligned'
    2    arch/x86/kernel/head_32.S:670: Warning: ignoring fill value in sec=
tion `.bss..page_aligned'
    2    arch/x86/kernel/head_32.S:665: Warning: ignoring fill value in sec=
tion `.bss..page_aligned'
    2    arch/mips/kernel/cps-vec.S:384: Warning: tried to set unrecognized=
 symbol: MIPS_ISA_LEVEL_RAW
    2    arch/mips/kernel/cps-vec.S:352: Warning: tried to set unrecognized=
 symbol: MIPS_ISA_LEVEL_RAW
    2    arch/mips/kernel/cps-vec.S:232: Warning: tried to set unrecognized=
 symbol: MIPS_ISA_LEVEL_RAW
    1    {standard input}:900: Warning: the `msa' extension requires 64-bit=
 FPRs
    1    {standard input}:2119: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1953: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1923: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1882: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1822: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1821: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1697: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1668: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1664: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1655: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1525: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1485: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1431: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1424: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1395: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1359: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    {standard input}:1257: Warning: the `msa' extension requires 64-bi=
t FPRs
    1    net/caif/cfctrl.c:261:3: warning: =E2=80=98strncpy=E2=80=99 output=
 may be truncated copying 15 bytes from a string of length 15 [-Wstringop-t=
runcation]
    1    kernel/debug/kdb/kdb_support.c:132:4: warning: =E2=80=98memcpy=E2=
=80=99 accessing 396 bytes at offsets 0 and 4 overlaps 392 bytes at offset =
4 [-Wrestrict]
    1    drivers/video/fbdev/matrox/matroxfb_Ti3026.c:375:2: warning: =E2=
=80=98memcpy=E2=80=99 forming offset [22, 80] is out of the bounds [0, 21] =
of object =E2=80=98MGADACbpp32=E2=80=99 with type =E2=80=98const unsigned c=
har[21]=E2=80=99 [-Warray-bounds]
    1    drivers/scsi/pmcraid.h:1059:1: warning: alignment 1 of =E2=80=98st=
ruct pmcraid_passthrough_ioctl_buffer=E2=80=99 is less than 4 [-Wpacked-not=
-aligned]
    1    drivers/scsi/pmcraid.h:1059:1: warning: alignment 1 of =E2=80=98st=
ruct pmcraid_passthrough_ioctl_buffer=E2=80=99 is less than 32 [-Wpacked-no=
t-aligned]
    1    drivers/scsi/pmcraid.h:1056:24: warning: =E2=80=98ioarcb=E2=80=99 =
offset 16 in =E2=80=98struct pmcraid_passthrough_ioctl_buffer=E2=80=99 isn=
=E2=80=99t aligned to 32 [-Wpacked-not-aligned]
    1    drivers/net/wireless/rtlwifi/rtl8192cu/hw.c:1363:22: warning: bitw=
ise comparison always evaluates to false [-Wtautological-compare]
    1    drivers/net/wireless/rtl818x/rtl8187/leds.c:149:2: warning: =E2=80=
=98strncpy=E2=80=99 specified bound 22 equals destination size [-Wstringop-=
truncation]
    1    drivers/net/wireless/mwl8k.c:805:1: warning: alignment 1 of =E2=80=
=98struct mwl8k_dma_data=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    1    drivers/gpu/drm/i915/intel_tv.c:1422:3: warning: =E2=80=98strncpy=
=E2=80=99 specified bound 32 equals destination size [-Wstringop-truncation]
    1    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 o=
f =E2=80=98struct regcache_rbtree_node=E2=80=99 is less than 8 [-Wpacked-no=
t-aligned]
    1    cc1: warning: switch -mcpu=3Dcortex-a9 conflicts with -march=3Darm=
v7-a switch
    1    arch/x86/power/hibernate_64.c:129:2: warning: =E2=80=98memcpy=E2=
=80=99 forming offset [2, 4096] is out of the bounds [0, 1] of object =E2=
=80=98core_restore_code=E2=80=99 with type =E2=80=98char=E2=80=99 [-Warray-=
bounds]
    1    arch/x86/kernel/apic/apic.c:138:13: warning: =E2=80=98nox2apic=E2=
=80=99 defined but not used [-Wunused-variable]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/wireless/prism54/isl_ioctl.c:284:2: warning: =E2=80=98strnc=
py=E2=80=99 output may be truncated copying 16 bytes from a string of lengt=
h 28 [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 235 warnings, 0 section =
mismatches

Errors:
    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint in =
=E2=80=98asm=E2=80=99
    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint in =
=E2=80=98asm=E2=80=99

Warnings:
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    mm/memory.c:581:7: warning: assignment to =E2=80=98pgtable_t=E2=80=99 {=
aka =E2=80=98long unsigned int=E2=80=99} from =E2=80=98void *=E2=80=99 make=
s integer from pointer without a cast [-Wint-conversion]
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    include/linux/rbtree.h:85:11: warning: =E2=80=98rb_link=E2=80=99 may be=
 used uninitialized in this function [-Wmaybe-uninitialized]
    include/linux/rbtree.h:82:28: warning: =E2=80=98rb_parent=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
    mm/mmap.c:650:2: warning: =E2=80=98prev=E2=80=99 may be used uninitiali=
zed in this function [-Wmaybe-uninitialized]
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    include/linux/kernel.h:716:17: warning: comparison of distinct pointer =
types lacks a cast
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    cc1: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mi=
smatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section m=
ismatches

Warnings:
    arch/x86/kernel/head_32.S:665: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:670: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:672: Warning: ignoring fill value in section =
`.bss..page_aligned'

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 28 warnings, 0 section =
mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, 0=
 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
ape6evm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
armadillo800eva_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings=
, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 9 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/wireless/rtlwifi/rtl8192cu/hw.c:1363:22: warning: bitwise c=
omparison always evaluates to false [-Wtautological-compare]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
at91rm9200_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 15 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
at91sam9260_9g20_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 13 warnin=
gs, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/misc/eeprom/at25.c:311:2: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 10 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
at91sam9261_9g10_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 14 warnin=
gs, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
at91sam9263_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, 0=
 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
at91sam9g45_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
at91sam9rl_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
at91x40_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 31 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1359: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:900: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 19 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/misc/eeprom/at25.c:311:2: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 10 equals destination size [-Wstringop-truncation]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    kernel/debug/kdb/kdb_support.c:132:4: warning: =E2=80=98memcpy=E2=80=99=
 accessing 396 bytes at offsets 0 and 4 overlaps 392 bytes at offset 4 [-Wr=
estrict]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 43 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    drivers/net/wireless/brcm80211/brcmsmac/d11.h:786:1: warning: alignment=
 1 of =E2=80=98struct d11txh=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 28 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 14 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 86 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
bockw_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 9 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 50 warnings=
, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 10 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    drivers/net/irda/irtty-sir.c:405:3: warning: =E2=80=98strncpy=E2=80=99 =
output may be truncated copying 5 bytes from a string of length 15 [-Wstrin=
gop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 14 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 16 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/cifs/cifsencrypt.c:309:3: warning: =E2=80=98strncpy=E2=80=99 specifi=
ed bound 16 equals destination size [-Wstringop-truncation]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 19 warnings=
, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/net/wireless/hostap/hostap_ioctl.c:3614:3: warning: =E2=80=98st=
rncpy=E2=80=99 specified bound 16 equals destination size [-Wstringop-trunc=
ation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/irda/irtty-sir.c:405:3: warning: =E2=80=98strncpy=E2=80=99 =
output may be truncated copying 5 bytes from a string of length 15 [-Wstrin=
gop-truncation]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 14 warnings=
, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 20 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 13 warnings, 0=
 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    fs/xfs/xfs_xattr.c:159:2: warning: =E2=80=98strncpy=E2=80=99 output may=
 be truncated copying between 5 and 9 bytes from a string of length 9 [-Wst=
ringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0=
 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 15 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0=
 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 18 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/cifs/cifsencrypt.c:309:3: warning: =E2=80=98strncpy=E2=80=99 specifi=
ed bound 16 equals destination size [-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    fs/xfs/xfs_xattr.c:159:2: warning: =E2=80=98strncpy=E2=80=99 output may=
 be truncated copying between 5 and 9 bytes from a string of length 9 [-Wst=
ringop-truncation]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 10 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
fpga_defconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 3 warnings, 0 section=
 mismatches

Warnings:
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated

---------------------------------------------------------------------------=
-----
fpga_noramfs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 8 warnings, 0=
 section mismatches

Errors:
    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint in =
=E2=80=98asm=E2=80=99
    arch/arc/include/asm/uaccess.h:676:2: error: impossible constraint in =
=E2=80=98asm=E2=80=99

Warnings:
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    arc-elf32-gcc: warning: =E2=80=98-mno-mpy=E2=80=99 is deprecated
    mm/memory.c:581:7: warning: assignment to =E2=80=98pgtable_t=E2=80=99 {=
aka =E2=80=98long unsigned int=E2=80=99} from =E2=80=98void *=E2=80=99 make=
s integer from pointer without a cast [-Wint-conversion]
    include/linux/rbtree.h:85:11: warning: =E2=80=98rb_link=E2=80=99 may be=
 used uninitialized in this function [-Wmaybe-uninitialized]
    include/linux/rbtree.h:82:28: warning: =E2=80=98rb_parent=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
    mm/mmap.c:650:2: warning: =E2=80=98prev=E2=80=99 may be used uninitiali=
zed in this function [-Wmaybe-uninitialized]
    include/linux/kernel.h:716:17: warning: comparison of distinct pointer =
types lacks a cast

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 59 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
genmai_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 10 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
hi3xxx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 13 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/video/hdmi.c:162:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 8 equals destination size [-Wstringop-truncation]
    drivers/video/hdmi.c:163:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 16 equals destination size [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sectio=
n mismatches

Warnings:
    arch/x86/kernel/rtc.c:173:29: warning: duplicate =E2=80=98const=E2=80=
=99 declaration specifier [-Wduplicate-decl-specifier]
    arch/x86/kernel/apic/apic.c:138:13: warning: =E2=80=98nox2apic=E2=80=99=
 defined but not used [-Wunused-variable]
    arch/x86/kernel/head_32.S:665: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:670: Warning: ignoring fill value in section =
`.bss..page_aligned'
    arch/x86/kernel/head_32.S:672: Warning: ignoring fill value in section =
`.bss..page_aligned'

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 15 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/cifs/cifsencrypt.c:309:3: warning: =E2=80=98strncpy=E2=80=99 specifi=
ed bound 16 equals destination size [-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 32 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/misc/eeprom/at25.c:311:2: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 10 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/video/fbdev/mx3fb.c:748:2: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated before terminating nul copying 8 bytes from a string of the=
 same length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 26 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/misc/eeprom/at25.c:311:2: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 10 equals destination size [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/video/hdmi.c:162:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 8 equals destination size [-Wstringop-truncation]
    drivers/video/hdmi.c:163:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 16 equals destination size [-Wstringop-truncation]
    drivers/video/fbdev/mx3fb.c:748:2: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated before terminating nul copying 8 bytes from a string of the=
 same length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3598:2: warning: =
=E2=80=98strncpy=E2=80=99 output truncated before terminating nul copying 3=
 bytes from a string of the same length [-Wstringop-truncation]
    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3598:2: warning: =
=E2=80=98strncpy=E2=80=99 output truncated before terminating nul copying 3=
 bytes from a string of the same length [-Wstringop-truncation]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/video/fbdev/matrox/matroxfb_Ti3026.c:375:2: warning: =E2=80=98m=
emcpy=E2=80=99 forming offset [22, 80] is out of the bounds [0, 21] of obje=
ct =E2=80=98MGADACbpp32=E2=80=99 with type =E2=80=98const unsigned char[21]=
=E2=80=99 [-Warray-bounds]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 13 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 13 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 30 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argument 5=
 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from integer without a c=
ast [-Wint-conversion]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 73 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 8 [-Wpacked-not-ali=
gned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    drivers/net/wireless/mwl8k.c:805:1: warning: alignment 1 of =E2=80=98st=
ruct mwl8k_dma_data=E2=80=99 is less than 2 [-Wpacked-not-aligned]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    drivers/scsi/pmcraid.h:1059:1: warning: alignment 1 of =E2=80=98struct =
pmcraid_passthrough_ioctl_buffer=E2=80=99 is less than 32 [-Wpacked-not-ali=
gned]
    drivers/scsi/pmcraid.h:1056:24: warning: =E2=80=98ioarcb=E2=80=99 offse=
t 16 in =E2=80=98struct pmcraid_passthrough_ioctl_buffer=E2=80=99 isn=E2=80=
=99t aligned to 32 [-Wpacked-not-aligned]
    drivers/scsi/pmcraid.h:1059:1: warning: alignment 1 of =E2=80=98struct =
pmcraid_passthrough_ioctl_buffer=E2=80=99 is less than 4 [-Wpacked-not-alig=
ned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 51 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argument 5=
 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from integer without a c=
ast [-Wint-conversion]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 59 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 28 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 10 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 36 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
kirkwood_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
koelsch_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/wireless/prism54/isl_ioctl.c:284:2: warning: =E2=80=98strnc=
py=E2=80=99 output may be truncated copying 16 bytes from a string of lengt=
h 28 [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
kzm9g_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 9 warnings, 0 section=
 mismatches

Errors:
    arch/arm/mach-shmobile/board-kzm9g.c:734:13: error: initializer element=
 is not computable at load time

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]

---------------------------------------------------------------------------=
-----
lager_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 11 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 28 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 4 warnings, 0 sec=
tion mismatches

Errors:
    arch/mips/loongson/common/cs5536/cs5536_ohci.c:141:25: error: bitwise c=
omparison always evaluates to false [-Werror=3Dtautological-compare]

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 329 warnings, 0=
 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
mackerel_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 16 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    include/linux/sh_intc.h:99:63: warning: division =E2=80=98sizeof (void =
*) / sizeof (void)=E2=80=99 does not compute the number of array elements [=
-Wsizeof-pointer-div]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 19 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    drivers/net/irda/irtty-sir.c:405:3: warning: =E2=80=98strncpy=E2=80=99 =
output may be truncated copying 5 bytes from a string of length 15 [-Wstrin=
gop-truncation]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 31 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1498: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1715: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 4 warnings, 0 s=
ection mismatches

Errors:
    include/linux/kern_levels.h:4:18: error: format =E2=80=98%lx=E2=80=99 e=
xpects argument of type =E2=80=98long unsigned int=E2=80=99, but argument 4=
 has type =E2=80=98u64=E2=80=99 {aka =E2=80=98long long unsigned int=E2=80=
=99} [-Werror=3Dformat=3D]
    include/linux/kern_levels.h:4:18: error: format =E2=80=98%lx=E2=80=99 e=
xpects argument of type =E2=80=98long unsigned int=E2=80=99, but argument 4=
 has type =E2=80=98u64=E2=80=99 {aka =E2=80=98long long unsigned int=E2=80=
=99} [-Werror=3Dformat=3D]

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1498: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1953: Warning: the `msa' extension requires 64-bit FPRs
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 31 warnin=
gs, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1462: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1664: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 31 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1462: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1697: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 34 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1462: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1715: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/kernel/cps-vec.S:232: Warning: tried to set unrecognized symb=
ol: MIPS_ISA_LEVEL_RAW
    arch/mips/kernel/cps-vec.S:352: Warning: tried to set unrecognized symb=
ol: MIPS_ISA_LEVEL_RAW
    arch/mips/kernel/cps-vec.S:384: Warning: tried to set unrecognized symb=
ol: MIPS_ISA_LEVEL_RAW
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 34 warnings=
, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1462: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1822: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/kernel/cps-vec.S:232: Warning: tried to set unrecognized symb=
ol: MIPS_ISA_LEVEL_RAW
    arch/mips/kernel/cps-vec.S:352: Warning: tried to set unrecognized symb=
ol: MIPS_ISA_LEVEL_RAW
    arch/mips/kernel/cps-vec.S:384: Warning: tried to set unrecognized symb=
ol: MIPS_ISA_LEVEL_RAW
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 31 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1462: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1668: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
marzen_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 10 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/video/hdmi.c:162:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 8 equals destination size [-Wstringop-truncation]
    drivers/video/hdmi.c:163:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 16 equals destination size [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    drivers/net/wireless/hostap/hostap_ioctl.c:3614:3: warning: =E2=80=98st=
rncpy=E2=80=99 specified bound 16 equals destination size [-Wstringop-trunc=
ation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 50 warnings=
, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 9 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
msm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 35 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/scsi/scsi_tgt_if.c:192:3: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 16 equals destination size [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 31 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1655: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1882: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 35 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    sound/pci/au88x0/au88x0_core.c:2302:59: warning: =E2=80=98mix[0]=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    sound/pci/au88x0/au88x0_core.c:2303:58: warning: =E2=80=98src[0]=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    sound/pci/au88x0/au88x0_core.c:2302:59: warning: =E2=80=98mix[0]=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    sound/pci/au88x0/au88x0_core.c:2303:58: warning: =E2=80=98src[0]=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    sound/pci/au88x0/au88x0_core.c:2302:59: warning: =E2=80=98mix[0]=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    sound/pci/au88x0/au88x0_core.c:2303:58: warning: =E2=80=98src[0]=E2=80=
=99 may be used uninitialized in this function [-Wmaybe-uninitialized]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 19 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/video/fbdev/mx3fb.c:748:2: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated before terminating nul copying 8 bytes from a string of the=
 same length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 25 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    cc1: warning: switch -mcpu=3Dcortex-a9 conflicts with -march=3Darmv7-a =
switch
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/mfd/db8500-prcmu.c:2721:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound 20 equals destination size [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/video/hdmi.c:162:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 8 equals destination size [-Wstringop-truncation]
    drivers/video/hdmi.c:163:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 16 equals destination size [-Wstringop-truncation]
    drivers/video/fbdev/mx3fb.c:748:2: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated before terminating nul copying 8 bytes from a string of the=
 same length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3598:2: warning: =
=E2=80=98strncpy=E2=80=99 output truncated before terminating nul copying 3=
 bytes from a string of the same length [-Wstringop-truncation]
    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3598:2: warning: =
=E2=80=98strncpy=E2=80=99 output truncated before terminating nul copying 3=
 bytes from a string of the same length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 34 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 18 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 36 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    fs/cifs/cifsencrypt.c:309:3: warning: =E2=80=98strncpy=E2=80=99 specifi=
ed bound 16 equals destination size [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 77 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise compari=
son always evaluates to false [-Werror=3Dtautological-compare]

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 36 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 16 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 8 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 31 warning=
s, 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1485: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:2119: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 9 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 36 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/scsi/scsi_tgt_if.c:192:3: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 16 equals destination size [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 30 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 15 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 30 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0=
 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 9 warnings, 0 section =
mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 31 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1431: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1257: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 21 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    drivers/scsi/scsi_tgt_if.c:192:3: warning: =E2=80=98strncpy=E2=80=99 sp=
ecified bound 16 equals destination size [-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    fs/udf/super.c:933:4: warning: =E2=80=98strncpy=E2=80=99 output may be =
truncated copying between 0 and 31 bytes from a string of length 253 [-Wstr=
ingop-truncation]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
s5p64x0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
s5pc100_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 20 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/wireless/rtl818x/rtl8187/leds.c:149:2: warning: =E2=80=98st=
rncpy=E2=80=99 specified bound 22 equals destination size [-Wstringop-trunc=
ation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 48 warnings,=
 0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
sead3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 31 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1424: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1923: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
sead3micro_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 =
section mismatches

Errors:
    arch/mips/kernel/genex.S:152: Error: branch to a symbol in another ISA =
mode
    arch/mips/kernel/genex.S:234: Error: branch to a symbol in another ISA =
mode

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1395: Warning: the `msa' extension requires 64-bit FPRs

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 16 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/irda/irtty-sir.c:405:3: warning: =E2=80=98strncpy=E2=80=99 =
output may be truncated copying 5 bytes from a string of length 15 [-Wstrin=
gop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 9 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 20 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 11 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 sec=
tion mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 s=
ection mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 23 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/video/hdmi.c:162:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 8 equals destination size [-Wstringop-truncation]
    drivers/video/hdmi.c:163:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 16 equals destination size [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3598:2: warning: =
=E2=80=98strncpy=E2=80=99 output truncated before terminating nul copying 3=
 bytes from a string of the same length [-Wstringop-truncation]
    drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3598:2: warning: =
=E2=80=98strncpy=E2=80=99 output truncated before terminating nul copying 3=
 bytes from a string of the same length [-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 20 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/net/wireless/hostap/hostap_ioctl.c:3614:3: warning: =E2=80=98st=
rncpy=E2=80=99 specified bound 16 equals destination size [-Wstringop-trunc=
ation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    drivers/net/irda/irtty-sir.c:405:3: warning: =E2=80=98strncpy=E2=80=99 =
output may be truncated copying 5 bytes from a string of length 15 [-Wstrin=
gop-truncation]
    net/bluetooth/hidp/core.c:779:2: warning: =E2=80=98strncpy=E2=80=99 out=
put may be truncated copying 127 bytes from a string of length 127 [-Wstrin=
gop-truncation]
    net/irda/irlmp.c:870:2: warning: =E2=80=98strncpy=E2=80=99 output may b=
e truncated copying 21 bytes from a string of length 64 [-Wstringop-truncat=
ion]
    net/irda/irlmp.c:1107:2: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 21 bytes from a string of length 64 [-Wstringop-trunca=
tion]
    net/irda/af_irda.c:481:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 16 equals destination size [-Wstringop-truncation]
    net/irda/ircomm/ircomm_param.c:260:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 19 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    net/caif/cfctrl.c:261:3: warning: =E2=80=98strncpy=E2=80=99 output may =
be truncated copying 15 bytes from a string of length 15 [-Wstringop-trunca=
tion]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/mfd/db8500-prcmu.c:2721:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound 20 equals destination size [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 14 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, =
0 section mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 29 warnings, 0 se=
ction mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 63 warnings, 0 s=
ection mismatches

Warnings:
    arch/x86/kernel/rtc.c:173:29: warning: duplicate =E2=80=98const=E2=80=
=99 declaration specifier [-Wduplicate-decl-specifier]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:212:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:118:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:78:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:49:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:493:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:292:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:245:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:162:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    include/trace/events/writeback.h:564:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    fs/ext4/super.c:310:2: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    fs/ext4/super.c:314:3: warning: =E2=80=98strncpy=E2=80=99 specified bou=
nd 32 equals destination size [-Wstringop-truncation]
    arch/x86/power/hibernate_64.c:129:2: warning: =E2=80=98memcpy=E2=80=99 =
forming offset [2, 4096] is out of the bounds [0, 1] of object =E2=80=98cor=
e_restore_code=E2=80=99 with type =E2=80=98char=E2=80=99 [-Warray-bounds]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    include/uapi/linux/sctp.h:239:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddr_change=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:513:1: warning: alignment 4 of =E2=80=98struc=
t sctp_setpeerprim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:512:26: warning: =E2=80=98sspp_addr=E2=80=99 =
offset 4 in =E2=80=98struct sctp_setpeerprim=E2=80=99 isn=E2=80=99t aligned=
 to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:526:1: warning: alignment 4 of =E2=80=98struc=
t sctp_prim=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:525:26: warning: =E2=80=98ssp_addr=E2=80=99 o=
ffset 4 in =E2=80=98struct sctp_prim=E2=80=99 isn=E2=80=99t aligned to 8 [-=
Wpacked-not-aligned]
    include/uapi/linux/sctp.h:573:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrparams=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:567:26: warning: =E2=80=98spp_address=E2=80=
=99 offset 4 in =E2=80=98struct sctp_paddrparams=E2=80=99 isn=E2=80=99t ali=
gned to 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:680:1: warning: alignment 4 of =E2=80=98struc=
t sctp_paddrinfo=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    include/uapi/linux/sctp.h:674:26: warning: =E2=80=98spinfo_address=E2=
=80=99 offset 4 in =E2=80=98struct sctp_paddrinfo=E2=80=99 isn=E2=80=99t al=
igned to 8 [-Wpacked-not-aligned]
    net/ipv4/ip_tunnel.c:312:3: warning: =E2=80=98strncat=E2=80=99 specifie=
d bound 2 equals source length [-Wstringop-overflow=3D]
    drivers/gpu/drm/i915/intel_tv.c:1422:3: warning: =E2=80=98strncpy=E2=80=
=99 specified bound 32 equals destination size [-Wstringop-truncation]
    net/compat.c:548:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:546:35: warning: =E2=80=98gr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_req=E2=80=99 isn=E2=80=99t aligned to 8 [-Wpac=
ked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:552:35: warning: =E2=80=98gsr_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to 8=
 [-Wpacked-not-aligned]
    net/compat.c:556:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_source_req=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:554:35: warning: =E2=80=98gsr_source=E2=80=99 offset 132 i=
n =E2=80=98struct compat_group_source_req=E2=80=99 isn=E2=80=99t aligned to=
 8 [-Wpacked-not-aligned]
    net/compat.c:566:1: warning: alignment 4 of =E2=80=98struct compat_grou=
p_filter=E2=80=99 is less than 8 [-Wpacked-not-aligned]
    net/compat.c:560:35: warning: =E2=80=98gf_group=E2=80=99 offset 4 in =
=E2=80=98struct compat_group_filter=E2=80=99 isn=E2=80=99t aligned to 8 [-W=
packed-not-aligned]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]
    drivers/video/hdmi.c:162:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 8 equals destination size [-Wstringop-truncation]
    drivers/video/hdmi.c:163:2: warning: =E2=80=98strncpy=E2=80=99 specifie=
d bound 16 equals destination size [-Wstringop-truncation]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 section=
 mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 31 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    {standard input}:1525: Warning: the `msa' extension requires 64-bit FPRs
    {standard input}:1821: Warning: the `msa' extension requires 64-bit FPRs
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:679:36: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:684:14: warning: =E2=80=98~=E2=80=99 on a b=
oolean expression [-Wbool-operation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 15 warnings, 0 sectio=
n mismatches

Warnings:
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/exec.c:1069:32: warning: argument to =E2=80=98sizeof=E2=80=99 in =E2=
=80=98strncpy=E2=80=99 call is the same expression as the source; did you m=
ean to use the size of the destination? [-Wsizeof-pointer-memaccess]
    crypto/ablkcipher.c:384:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/ablkcipher.c:466:2: warning: =E2=80=98strncpy=E2=80=99 specified=
 bound 64 equals destination size [-Wstringop-truncation]
    crypto/blkcipher.c:516:2: warning: =E2=80=98strncpy=E2=80=99 specified =
bound 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:121:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    crypto/aead.c:206:2: warning: =E2=80=98strncpy=E2=80=99 specified bound=
 64 equals destination size [-Wstringop-truncation]
    drivers/base/regmap/regcache-rbtree.c:36:1: warning: alignment 1 of =E2=
=80=98struct regcache_rbtree_node=E2=80=99 is less than 4 [-Wpacked-not-ali=
gned]
    fs/kernfs/symlink.c:91:3: warning: =E2=80=98strncpy=E2=80=99 output tru=
ncated before terminating nul copying as many bytes from a string as its le=
ngth [-Wstringop-truncation]
    net/socket.c:490:4: warning: =E2=80=98strncpy=E2=80=99 specified bound =
depends on the length of the source argument [-Wstringop-overflow=3D]
    lib/kobject.c:130:3: warning: =E2=80=98strncpy=E2=80=99 output truncate=
d before terminating nul copying as many bytes from a string as its length =
[-Wstringop-truncation]
    <stdin>:1238:2: warning: #warning syscall seccomp not implemented [-Wcp=
p]
    fs/configfs/symlink.c:67:3: warning: =E2=80=98strncpy=E2=80=99 output t=
runcated before terminating nul copying as many bytes from a string as its =
length [-Wstringop-truncation]
    drivers/scsi/scsi_devinfo.c:293:2: warning: =E2=80=98strncpy=E2=80=99 s=
pecified bound depends on the length of the source argument [-Wstringop-ove=
rflow=3D]
    drivers/scsi/scsi_devinfo.c:304:4: warning: =E2=80=98strncpy=E2=80=99 o=
utput truncated copying between 0 and 16 bytes from a string of length 16 [=
-Wstringop-truncation]

---
For more info write to <info@kernelci.org>
