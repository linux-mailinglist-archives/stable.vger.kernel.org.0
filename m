Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA375EE1DD
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfKDOHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 09:07:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53274 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbfKDOHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 09:07:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id x4so5666714wmi.3
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 06:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N552tYk8zFNj/JTtYrlrl00VZArPsS7o6Axz295bioI=;
        b=S3kQFB+qG/SDxDqXtQFzRKxP9Nzi5X5WNpsb0kjdraINWzaxdMxmgEbxVjfAPSyyCP
         CumjhLDRXjch5yVwzLsZOiyV8MIGRlF0wY6mlAxp2haidtvgZasKVAOyPGKowDy0dECJ
         wUMG3ialWveKXLl5kPJ36TOpf5hXnMZqdH41kXuJ3DIHYkp7m9g9vsT2R5DuTe5otFFa
         Yp8d5sbfuGZgIRM5n/E/N7fqitpMH1EGRNZUi+IRaI4opfgWYT1/rDFVxFCiwuDOm1lm
         26feOmLC2/1JFeYXzDyrwy2muvXAZ7LZJNTASpFlR8Mf/cxXnyx8x2Br2KYiUUw23zoG
         5ipg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N552tYk8zFNj/JTtYrlrl00VZArPsS7o6Axz295bioI=;
        b=dsdcsk8HJncxi2WahOf6nhavgnhBCxEkSUYnEE3z+V0u8pztn+O8mYRez0GicBsZ13
         5vJTvA5GiX4tJTE5iJZwcceOPY9vdLrHeGeSZqY1aQMDU4lG8wfw3l53XRixt8Gqn0hT
         WrTeCRygFJ8ls7cA6E15ULIJbDpPBYJCX+AL6n+0nYH8BLXT4XIQfSxIX4ulHGoPVeAp
         gFeQfvgiKXovvglrfsOdulGstEcqyuBi297RWB3vG0CrWZGttEmWEwIAWI2a1bksDHck
         e1lfCyMjWFf7cU0/QyBnSgLmAJLSEbjjrnE+93qWvOXHnJGgEDLqi1GxYt/ExEDdeobZ
         k2vQ==
X-Gm-Message-State: APjAAAWL8wQHgVURP6QfKnkYJvRVz9X0G1uwM8aXwd+Kprh2npMcfrM9
        csVTjq/mvJsWcZxgO5FxMertmAni7z99gg==
X-Google-Smtp-Source: APXvYqx2dehhJjPLRgu5WVQlIG5HwRM8D/n30WvgIjY9GYbE4PGuO8duA8tzTiAB4hfGRPtZtmhvbw==
X-Received: by 2002:a1c:7704:: with SMTP id t4mr21298767wmi.4.1572876446965;
        Mon, 04 Nov 2019 06:07:26 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t29sm33473675wrb.53.2019.11.04.06.07.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 06:07:26 -0800 (PST)
Message-ID: <5dc0309e.1c69fb81.83871.291d@mx.google.com>
Date:   Mon, 04 Nov 2019 06:07:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.151-95-g3f14236a3fe8
Subject: stable-rc/linux-4.14.y build: 201 builds: 69 failed, 132 passed,
 144 errors, 104 warnings (v4.14.151-95-g3f14236a3fe8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 69 failed, 132 passed, 144 errors=
, 104 warnings (v4.14.151-95-g3f14236a3fe8)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.151-95-g3f14236a3fe8/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.151-95-g3f14236a3fe8
Git Commit: 3f14236a3fe8cfb5c238b250eee737f9c78c402d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    hsdk_defconfig: (gcc-8) FAIL

arm64:
    defconfig: (gcc-8) FAIL

arm:
    at91_dt_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    ebsa110_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    exynos_defconfig: (gcc-8) FAIL
    ezx_defconfig: (gcc-8) FAIL
    hisi_defconfig: (gcc-8) FAIL
    imote2_defconfig: (gcc-8) FAIL
    imx_v6_v7_defconfig: (gcc-8) FAIL
    iop13xx_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    iop33x_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    multi_v5_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    netx_defconfig: (gcc-8) FAIL
    omap1_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL

i386:
    i386_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bigsur_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
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
    markeins_defconfig: (gcc-8) FAIL
    mips_paravirt_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    hsdk_defconfig (gcc-8): 2 errors

arm64:
    allnoconfig (gcc-8): 2 warnings
    defconfig (gcc-8): 2 errors, 1 warning
    tinyconfig (gcc-8): 2 warnings

arm:
    acs5k_defconfig (gcc-8): 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 warning
    aspeed_g4_defconfig (gcc-8): 1 warning
    aspeed_g5_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    at91_dt_defconfig (gcc-8): 2 errors
    axm55xx_defconfig (gcc-8): 1 warning
    badge4_defconfig (gcc-8): 1 warning
    bcm2835_defconfig (gcc-8): 2 errors
    cerfcube_defconfig (gcc-8): 1 warning
    clps711x_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    cns3420vb_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 2 errors, 1 warning
    collie_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 2 errors, 1 warning
    davinci_all_defconfig (gcc-8): 2 errors, 1 warning
    dove_defconfig (gcc-8): 1 warning
    ebsa110_defconfig (gcc-8): 2 errors, 1 warning
    ep93xx_defconfig (gcc-8): 2 errors, 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 2 errors, 1 warning
    ezx_defconfig (gcc-8): 2 errors, 1 warning
    footbridge_defconfig (gcc-8): 1 warning
    gemini_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    hackkit_defconfig (gcc-8): 1 warning
    hisi_defconfig (gcc-8): 2 errors, 1 warning
    imote2_defconfig (gcc-8): 2 errors, 1 warning
    imx_v6_v7_defconfig (gcc-8): 2 errors, 1 warning
    integrator_defconfig (gcc-8): 1 warning
    iop13xx_defconfig (gcc-8): 5 errors, 1 warning
    iop32x_defconfig (gcc-8): 2 errors, 1 warning
    iop33x_defconfig (gcc-8): 2 errors, 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    jornada720_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 2 errors, 1 warning
    ks8695_defconfig (gcc-8): 1 warning
    lart_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 2 errors
    lpd270_defconfig (gcc-8): 2 errors, 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 1 warning
    multi_v4t_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 2 errors, 1 warning
    multi_v7_defconfig (gcc-8): 2 errors, 1 warning
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 2 errors, 1 warning
    mxs_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    netx_defconfig (gcc-8): 2 errors, 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    nuc910_defconfig (gcc-8): 1 warning
    nuc950_defconfig (gcc-8): 1 warning
    nuc960_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 2 errors
    omap2plus_defconfig (gcc-8): 2 errors, 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    palmz72_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    prima2_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa255-idp_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    pxa_defconfig (gcc-8): 1 warning
    qcom_defconfig (gcc-8): 1 warning
    raumfeld_defconfig (gcc-8): 2 errors, 1 warning
    realview_defconfig (gcc-8): 1 warning
    rpc_defconfig (gcc-8): 2 errors, 1 warning
    s3c2410_defconfig (gcc-8): 2 errors, 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 2 errors, 1 warning
    shannon_defconfig (gcc-8): 1 warning
    shmobile_defconfig (gcc-8): 2 errors
    simpad_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 2 errors, 1 warning
    spear13xx_defconfig (gcc-8): 2 errors, 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    spear6xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 2 errors, 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tango4_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 2 errors, 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u300_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 2 errors, 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 2 errors, 1 warning
    zeus_defconfig (gcc-8): 1 warning
    zx_defconfig (gcc-8): 1 warning

i386:
    i386_defconfig (gcc-8): 2 errors, 1 warning

mips:
    32r2el_defconfig (gcc-8): 2 errors
    bcm47xx_defconfig (gcc-8): 2 errors
    bigsur_defconfig (gcc-8): 2 errors
    bmips_be_defconfig (gcc-8): 2 errors
    bmips_stb_defconfig (gcc-8): 2 errors
    cavium_octeon_defconfig (gcc-8): 2 errors
    db1xxx_defconfig (gcc-8): 2 errors
    decstation_defconfig (gcc-8): 2 errors
    ip22_defconfig (gcc-8): 2 errors
    ip27_defconfig (gcc-8): 5 errors
    ip32_defconfig (gcc-8): 2 errors
    jazz_defconfig (gcc-8): 2 errors
    lemote2f_defconfig (gcc-8): 2 errors
    loongson3_defconfig (gcc-8): 2 errors
    malta_defconfig (gcc-8): 2 errors
    malta_kvm_defconfig (gcc-8): 2 errors
    malta_kvm_guest_defconfig (gcc-8): 2 errors
    malta_qemu_32r6_defconfig (gcc-8): 2 errors, 1 warning
    maltaaprp_defconfig (gcc-8): 2 errors
    maltasmvp_defconfig (gcc-8): 2 errors
    maltasmvp_eva_defconfig (gcc-8): 2 errors
    maltaup_defconfig (gcc-8): 2 errors
    maltaup_xpa_defconfig (gcc-8): 2 errors
    markeins_defconfig (gcc-8): 2 errors
    mips_paravirt_defconfig (gcc-8): 2 errors
    mtx1_defconfig (gcc-8): 2 errors
    nlm_xlp_defconfig (gcc-8): 2 errors
    nlm_xlr_defconfig (gcc-8): 2 errors
    pistachio_defconfig (gcc-8): 2 errors
    rm200_defconfig (gcc-8): 2 errors

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 2 errors, 1 warning

Errors summary:

    69   net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared =
(first use in this function); did you mean 'alloc_netdev'?
    69   net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared =
(first use in this function); did you mean 'alloc_netdev'?
    2    net/ipv6/route.c:418:41: error: 'blackhole_netdev' undeclared (fir=
st use in this function); did you mean 'alloc_netdev'?
    2    net/ipv6/route.c:171:19: error: 'loopback_dev' undeclared (first u=
se in this function); did you mean 'loopback_net_ops'?
    2    net/ipv6/route.c:166:33: error: 'blackhole_netdev' undeclared (fir=
st use in this function); did you mean 'alloc_netdev'?

Warnings summary:

    98   fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
    2    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs'=
 defined but not used [-Wunused-function]
    2    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defi=
ned but not used [-Wunused-function]
    1    {standard input}:29: Warning: macro instruction expanded into mult=
iple instructions
    1    .config:1023:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs' defi=
ned but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defined b=
ut not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 5 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:166:33: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:171:19: error: 'loopback_dev' undeclared (first use in=
 this function); did you mean 'loopback_net_ops'?
    net/ipv6/route.c:418:41: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 5 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:166:33: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?
    net/ipv6/route.c:171:19: error: 'loopback_dev' undeclared (first use in=
 this function); did you mean 'loopback_net_ops'?
    net/ipv6/route.c:418:41: error: 'blackhole_netdev' undeclared (first us=
e in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warning=
s, 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    {standard input}:29: Warning: macro instruction expanded into multiple =
instructions

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0=
 section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings,=
 0 section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

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
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

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
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

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
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs' defi=
ned but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defined b=
ut not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1023:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    net/ipv6/addrconf.c:6593:22: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?
    net/ipv6/addrconf.c:6667:18: error: 'blackhole_netdev' undeclared (firs=
t use in this function); did you mean 'alloc_netdev'?

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
