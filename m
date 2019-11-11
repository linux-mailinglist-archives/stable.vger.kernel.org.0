Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E67F78ED
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 17:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfKKQhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 11:37:31 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42876 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfKKQha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 11:37:30 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so15324628wrf.9
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 08:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AeIOPQiS2GjkEspQvFWewOmpG6y4GbmwoDoL/GttFhI=;
        b=khj6/J7Jt993Vn+W4gjHyFsQ4623CUTUclobyc84O+7pl1F5O2WlSYRjJ541MOiI5d
         Mmv4bjNNt5/DMsFRojDrLYtAoqJPWwR73eUt9nzZz7QA/KSNQs8mYnMz6OBVYY2sfnUh
         C8ijD9WcsTmbDoiTnoWvRj81rtO46Gyk1NTrPNu7WC9kmW3H02C+mrE8WP13UmKge5AF
         peoNXOZld9GnQxkkAhPHl1hMPF2wvC9RwwBVA/bYTL1dN/EKrFXUfO/KQWI5tn7ChB3B
         UdPp+tVAAOaY6YgwW4toD8EhsmkcMd5DnPCrYSlydj72+fUWEZP191IzcVeHbwDX0aI1
         Y/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AeIOPQiS2GjkEspQvFWewOmpG6y4GbmwoDoL/GttFhI=;
        b=KKHz4P1i/VJncPlvE0MTAaeRg0VqOsXvTXZyjb6rKBIl6XitGhcAcISRHAztTMUCt7
         mmWjO3OCmqSXyshHv8M6qKj+zGcpNToXXLkHSs+bt9e8Irrgs58CIvxwUZz1igw4rx93
         +ssU9iK7h3EgOuQ4eiBWbpPYzCE8hZ5g3LzRV/4bF/+pYrVAk9LivJDi/fAHHXMWcrqM
         YHugoF1Uq6cVlnvt4RBeq3+qeVbMS3wv1gozlBMmd+mtMkOehNNbRjUHgGEhykC5zs6S
         QupSDgj9wi3jqodKh8BXvv1DUd7fo776Ysc1XvN82gL/f9TyOVJuIOuGFP65krhZp3vV
         gETA==
X-Gm-Message-State: APjAAAWCpcqzIe9Xbo17U+RZ0xW1Nh0jNPBODL0vfyjGFGYpJ3UHq5XA
        4IwmAVRK52U7to+54uuMnT6pdF3KThAZlg==
X-Google-Smtp-Source: APXvYqxGEfQyn7weUIUWs2daoKZ+Kwi5Haz1VsPEuKokEQSE0wGoaMbcBqW0hLZktygf7RZfCCRHng==
X-Received: by 2002:a5d:52c8:: with SMTP id r8mr21293911wrv.347.1573490240510;
        Mon, 11 Nov 2019 08:37:20 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b3sm18803506wmh.17.2019.11.11.08.37.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 08:37:19 -0800 (PST)
Message-ID: <5dc98e3f.1c69fb81.29693.8bc6@mx.google.com>
Date:   Mon, 11 Nov 2019 08:37:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.153-68-g0d12dcf336c6
Subject: stable-rc/linux-4.14.y build: 201 builds: 11 failed, 190 passed,
 104 warnings (v4.14.153-68-g0d12dcf336c6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 11 failed, 190 passed, 104 warnin=
gs (v4.14.153-68-g0d12dcf336c6)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.153-68-g0d12dcf336c6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.153-68-g0d12dcf336c6
Git Commit: 0d12dcf336c606a37cf2ad4319bc59f69eb6c255
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    tinyconfig: (gcc-8) FAIL

arm64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

i386:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

mips:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

x86_64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

Warnings Detected:

arc:

arm64:
    allnoconfig (gcc-8): 2 warnings
    defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 2 warnings

arm:
    acs5k_defconfig (gcc-8): 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 warning
    aspeed_g4_defconfig (gcc-8): 1 warning
    aspeed_g5_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 warning
    badge4_defconfig (gcc-8): 1 warning
    cerfcube_defconfig (gcc-8): 1 warning
    clps711x_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    cns3420vb_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    collie_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 warning
    ebsa110_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    footbridge_defconfig (gcc-8): 1 warning
    gemini_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    hackkit_defconfig (gcc-8): 1 warning
    hisi_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    iop13xx_defconfig (gcc-8): 1 warning
    iop32x_defconfig (gcc-8): 1 warning
    iop33x_defconfig (gcc-8): 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    jornada720_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    ks8695_defconfig (gcc-8): 1 warning
    lart_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 1 warning
    multi_v4t_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    netx_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    nuc910_defconfig (gcc-8): 1 warning
    nuc950_defconfig (gcc-8): 1 warning
    nuc960_defconfig (gcc-8): 1 warning
    omap2plus_defconfig (gcc-8): 1 warning
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
    raumfeld_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 1 warning
    rpc_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    simpad_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    spear6xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tango4_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u300_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning
    zx_defconfig (gcc-8): 1 warning

i386:
    i386_defconfig (gcc-8): 1 warning

mips:
    malta_qemu_32r6_defconfig (gcc-8): 1 warning

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 warning


Warnings summary:

    98   fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
    2    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs'=
 defined but not used [-Wunused-function]
    2    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defi=
ned but not used [-Wunused-function]
    1    {standard input}:29: Warning: macro instruction expanded into mult=
iple instructions
    1    .config:1024:warning: override: UNWINDER_GUESS changes choice state

Section mismatches summary:

    189  WARNING: modpost: Found 1 section mismatch(es).
    11   FATAL: modpost: Section mismatches detected.
    1    WARNING: vmlinux.o(.text+0x9539c): Section mismatch in reference f=
rom the function __rmqueue() to the function .meminit.text:zone_pcp_update()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs' defi=
ned but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defined b=
ut not used [-Wunused-function]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section mi=
smatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section m=
ismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section m=
ismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

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

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

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
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    {standard input}:29: Warning: macro instruction expanded into multiple =
instructions

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

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

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: vmlinux.o(.text+0x9539c): Section mismatch in reference from t=
he function __rmqueue() to the function .meminit.text:zone_pcp_update()

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section mi=
smatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    arch/arm64/kernel/cpufeature.c:940:13: warning: 'cpu_copy_el2regs' defi=
ned but not used [-Wunused-function]
    arch/arm64/kernel/cpufeature.c:802:13: warning: 'runs_at_el2' defined b=
ut not used [-Wunused-function]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 FAIL, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1024:warning: override: UNWINDER_GUESS changes choice state

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section mis=
matches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section mi=
smatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section mis=
matches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

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

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: 'last_vma' may be used uninitialized=
 in this function [-Wmaybe-uninitialized]

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---
For more info write to <info@kernelci.org>
