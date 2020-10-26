Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126AD2992A0
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 17:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786136AbgJZQkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 12:40:05 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42065 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503104AbgJZQkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 12:40:05 -0400
Received: by mail-pl1-f194.google.com with SMTP id t22so4987450plr.9
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 09:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QjtJs76NQdEK/NRj1A4LARiLaln+FFIB3p04GnzeE2I=;
        b=iG+Rs8qXApc709a4oim6v1E4cFHiQajNin0TsMflHmbcOzzQHvpp+fHa+uFQ8eaYnn
         HwhSNfIT7Vex5R3WEaDXtgiRxSFmpxJ7J8tJOgc3R1XPx0l0W+NXP0uReAk1VM6NbJ+Z
         uG01eF1OkcMWVqGoikeSrC+Mc74GZ5peqX1xPkHB3Pii3WNc2zTSgFQs1z81E/NCMux9
         /u5VbP6v9FyoHzlHr57Y++laIAXumKHG/03+cwsT9+k1G/8zpNcprzlCHkMckprrKQbs
         OOWioxRcXEDk9a2iEXN4kNY0BWmUfZ44cRzFsRmCoB6OdLW6h+Fx/k/Tcfb2vJaj2bXZ
         maIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QjtJs76NQdEK/NRj1A4LARiLaln+FFIB3p04GnzeE2I=;
        b=gqjb5RX3Ww7QhNIWjvAS/Gv702f+7HLIbxrhLgGAfR9n0/GmsBpp7jhLgQVkEtC+Q+
         R9OIKhi7ATwuUkN7JXzjtvMGY4OcvW7JJSCNTpJGcLYflMZPu6veaikJYD+upXCuAbH7
         Xysagl314cpH7OxVVJKU//Zp7nPxYtw3CzhH0HEeznh8o2JbbdwwOaW0ZBby+fdaDKYb
         JviZjrQNURclLfywHVw9HlUFgD//ofKBSP7d5wlWbPh5AqoJuCNBE8gpHoelUvlWFO8F
         X5CpTuB01M/0FaCxOPYdLfg2NLnOpMoS/u5weBq0+Fs5BAruzTa6pa+CUAf/AuWoxjPR
         MdKQ==
X-Gm-Message-State: AOAM531mgmFlL0z+G6INTNuoTwonokwxvMvZ8NOTx3JyJXy9IXxZbnMe
        0yiLxf8SUNft+eNxHaRX5R5SH8ZtgkXJeg==
X-Google-Smtp-Source: ABdhPJx3sKo4v7RQicGIZACAPdleuAYrW+XETTDzNqbof+W7A9LRXF4nRAavbVCZWQwtwg+0dSTrdg==
X-Received: by 2002:a17:90b:309:: with SMTP id ay9mr17300166pjb.39.1603730400920;
        Mon, 26 Oct 2020 09:40:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f8sm11647873pga.78.2020.10.26.09.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 09:40:00 -0700 (PDT)
Message-ID: <5f96fbe0.1c69fb81.4c945.7c7d@mx.google.com>
Date:   Mon, 26 Oct 2020 09:40:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-260-g497626ce1ea7
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 build: 203 builds: 1 failed, 202 passed,
 158 warnings (v4.19.152-260-g497626ce1ea7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 build: 203 builds: 1 failed, 202 passed, 158 warnings =
(v4.19.152-260-g497626ce1ea7)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
9/kernel/v4.19.152-260-g497626ce1ea7/

Tree: stable-rc
Branch: queue/4.19
Git Describe: v4.19.152-260-g497626ce1ea7
Git Commit: 497626ce1ea7abd214af170237e48397fcc48d80
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failure Detected:

arm:
    rpc_defconfig: (gcc-8) FAIL

Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 warning
    axs103_defconfig (gcc-8): 1 warning
    axs103_smp_defconfig (gcc-8): 1 warning
    haps_hs_defconfig (gcc-8): 3 warnings
    haps_hs_smp_defconfig (gcc-8): 3 warnings
    hsdk_defconfig (gcc-8): 1 warning
    nsim_hs_defconfig (gcc-8): 3 warnings
    nsim_hs_smp_defconfig (gcc-8): 3 warnings
    nsimosci_hs_defconfig (gcc-8): 3 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 3 warnings
    tinyconfig (gcc-8): 1 warning
    vdk_hs38_defconfig (gcc-8): 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 1 warning

arm64:
    allnoconfig (gcc-8): 1 warning
    defconfig (gcc-8): 2 warnings
    tinyconfig (gcc-8): 1 warning

arm:
    allnoconfig (gcc-8): 1 warning
    am200epdkit_defconfig (gcc-8): 1 warning
    aspeed_g4_defconfig (gcc-8): 2 warnings
    aspeed_g5_defconfig (gcc-8): 2 warnings
    at91_dt_defconfig (gcc-8): 2 warnings
    clps711x_defconfig (gcc-8): 3 warnings
    cm_x2xx_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    efm32_defconfig (gcc-8): 3 warnings
    eseries_pxa_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 2 warnings
    h3600_defconfig (gcc-8): 2 warnings
    h5000_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 2 warnings
    integrator_defconfig (gcc-8): 1 warning
    lpc18xx_defconfig (gcc-8): 2 warnings
    lpc32xx_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 2 warnings
    multi_v4t_defconfig (gcc-8): 3 warnings
    multi_v7_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 2 warnings
    palmz72_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    prima2_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa255-idp_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    raumfeld_defconfig (gcc-8): 3 warnings
    s3c2410_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 2 warnings
    spitz_defconfig (gcc-8): 1 warning
    stm32_defconfig (gcc-8): 3 warnings
    sunxi_defconfig (gcc-8): 1 warning
    tango4_defconfig (gcc-8): 1 warning
    tct_hammer_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning
    u300_defconfig (gcc-8): 2 warnings
    vexpress_defconfig (gcc-8): 2 warnings
    viper_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning

i386:

mips:
    allnoconfig (gcc-8): 1 warning
    ar7_defconfig (gcc-8): 2 warnings
    bigsur_defconfig (gcc-8): 2 warnings
    cavium_octeon_defconfig (gcc-8): 2 warnings
    db1xxx_defconfig (gcc-8): 1 warning
    fuloong2e_defconfig (gcc-8): 2 warnings
    gcw0_defconfig (gcc-8): 1 warning
    ip27_defconfig (gcc-8): 2 warnings
    ip28_defconfig (gcc-8): 2 warnings
    ip32_defconfig (gcc-8): 2 warnings
    jmr3927_defconfig (gcc-8): 1 warning
    lemote2f_defconfig (gcc-8): 3 warnings
    loongson1b_defconfig (gcc-8): 2 warnings
    loongson1c_defconfig (gcc-8): 2 warnings
    loongson3_defconfig (gcc-8): 4 warnings
    malta_defconfig (gcc-8): 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 2 warnings
    maltaaprp_defconfig (gcc-8): 1 warning
    maltasmvp_defconfig (gcc-8): 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 warning
    maltaup_defconfig (gcc-8): 1 warning
    maltaup_xpa_defconfig (gcc-8): 1 warning
    mips_paravirt_defconfig (gcc-8): 2 warnings
    nlm_xlp_defconfig (gcc-8): 3 warnings
    pic32mzda_defconfig (gcc-8): 1 warning
    rb532_defconfig (gcc-8): 2 warnings
    sb1250_swarm_defconfig (gcc-8): 2 warnings
    tinyconfig (gcc-8): 1 warning

riscv:
    allnoconfig (gcc-8): 1 warning
    defconfig (gcc-8): 3 warnings
    tinyconfig (gcc-8): 1 warning

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 2 warnings


Warnings summary:

    68   /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_l=
ist=E2=80=99 defined but not used [-Wunused-variable]
    41   /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =
=E2=80=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned=
 int=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=
=80=98long unsigned int=E2=80=99} [-Wformat=3D]
    27   /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =
=E2=80=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned=
 int=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 =
[-Wformat=3D]
    14   /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =
=E2=80=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned=
 int=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=
=80=98long unsigned int=E2=80=99} [-Wformat=3D]
    3    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame siz=
e of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]
    2    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_propert=
y): /wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 =
or bad phandle (referred from clocks[0])
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    .config:1010:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings,=
 0 section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section mi=
smatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section mi=
smatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 se=
ction mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame size of =
1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame size of =
1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warning=
s, 0 section mismatches

Warnings:
    {standard input}:131: Warning: macro instruction expanded into multiple=
 instructions
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings,=
 0 section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 se=
ction mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_property): /=
wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 or ba=
d phandle (referred from clocks[0])

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame size of =
1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings=
, 0 section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 secti=
on mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, =
0 section mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_property): /=
wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 or ba=
d phandle (referred from clocks[0])

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1010:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98long unsigned int=E2=80=99 [-Wf=
ormat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 se=
ction mismatches

Warnings:
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 4 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]
    /scratch/linux/include/linux/kern_levels.h:5:18: warning: format =E2=80=
=98%llu=E2=80=99 expects argument of type =E2=80=98long long unsigned int=
=E2=80=99, but argument 5 has type =E2=80=98sector_t=E2=80=99 {aka =E2=80=
=98long unsigned int=E2=80=99} [-Wformat=3D]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
