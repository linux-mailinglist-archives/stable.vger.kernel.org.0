Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64241187D9
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 11:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbfEIJfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 05:35:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51892 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfEIJfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 05:35:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id o189so2365503wmb.1
        for <stable@vger.kernel.org>; Thu, 09 May 2019 02:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2GGK7qUobrnPrOOzm2ZYqh2MTmQWHp0KQst7VSuGzyA=;
        b=QVLHZ3HGTbvPiYR+HervZF9U1tSRzJ8lnulOhdNqO9N8sFvQd/rUL/Hl3x1Gx0shjK
         YrZ9cK+e2xQ7sMdszVJZDa57zd5qg9KxhRd1iea1tJD9GTGQ9JpgXI9Jx3mAB7hRdjIe
         rVO4TwYBVpFj2s2FIP8b2txVqJP9nYqYQQUFKy6eDu0tvXxbpmAwFpiQSR+vrJrDStDM
         BQGxMgnkfiqBxNHWrbWUzXZnTbWPxXzfZhsjAJLmCkdIdw6Gth96JCVTtTdRT9llbNPF
         5Zf9mvhUXDmTwZDeiaBcdIwPnBEKS0NH7yEP3dVfUnPrC0V2NXX1Bh+mqLCGt/oMDRgi
         ifZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2GGK7qUobrnPrOOzm2ZYqh2MTmQWHp0KQst7VSuGzyA=;
        b=aa3s9dIKn/0932fUibJ2y548qTHoJ8QpHjxyaSCZ7N+gsxKE9VUzmFcdpo7u3quNu2
         3utg5nQHkUg0bfvuNnXd/8jgX44u2NBW7xWGOISjVIiTCJCmfJNtE0oy8RP/dfGby/Ew
         7A9DUBQC/pUnh6s0gY6KUTOj6vHwX8Nc3iiskkFA0cioOfyxVCprlwzDxahXyGc0UWJc
         a4vQepBHJSz0VBfAyuQae81iqa+T3Fcu09tzfvHv+5clCYVN6xfjuHsLS5rKsTZaX5OO
         xOQ5uTlxe8yaX++S7wKDvmwgyhQ2aN26yTrd/82hLGahuAEKW21T7KcQCwIXk1YD6l30
         bl9Q==
X-Gm-Message-State: APjAAAVMwVg5i82elav2/KnEXY9b8ODe0D8SLvS6uAM4mn5zSJ7vHII7
        wQL16AH/DtOeH0plEe8i9wVkRV3CaEwUxQ==
X-Google-Smtp-Source: APXvYqzo0Yn0qUcJnTaUtd+gX5Qe4XVv9PTwNd9gNXy4UI7iZuJX1xyIG3Uu+1EQtlwcsAuj4YpxsA==
X-Received: by 2002:a1c:7f8e:: with SMTP id a136mr1715013wmd.36.1557394496306;
        Thu, 09 May 2019 02:34:56 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s22sm2277132wmh.45.2019.05.09.02.34.54
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 02:34:54 -0700 (PDT)
Message-ID: <5cd3f43e.1c69fb81.ccf61.a621@mx.google.com>
Date:   Thu, 09 May 2019 02:34:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.174
Subject: stable-rc/linux-4.9.y build: 196 builds: 9 failed, 187 passed,
 5 errors, 2979 warnings (v4.9.174)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 196 builds: 9 failed, 187 passed, 5 errors, 29=
79 warnings (v4.9.174)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.174/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.174
Git Commit: d79b8577dfb7d02cada8c6671d39d10c09af891b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

mips:    mips-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0

    32r2el_defconfig: FAIL
    bigsur_defconfig: FAIL
    decstation_defconfig: FAIL
    ip27_defconfig: FAIL
    ip28_defconfig: FAIL
    jmr3927_defconfig: FAIL
    malta_kvm_guest_defconfig: FAIL
    nlm_xlr_defconfig: FAIL
    sb1250_swarm_defconfig: FAIL

Errors and Warnings Detected:

arc:    arc-linux-gcc (ARC HS GNU/Linux glibc toolchain 2018.09-rc1) 8.2.1 =
20180814

    allnoconfig: 4 warnings
    axs103_defconfig: 16 warnings
    axs103_smp_defconfig: 17 warnings
    nsim_hs_defconfig: 3 warnings
    nsim_hs_smp_defconfig: 4 warnings
    nsimosci_hs_defconfig: 6 warnings
    nsimosci_hs_smp_defconfig: 7 warnings
    tinyconfig: 5 warnings
    vdk_hs38_defconfig: 17 warnings
    vdk_hs38_smp_defconfig: 18 warnings
    zebu_hs_defconfig: 3 warnings
    zebu_hs_smp_defconfig: 4 warnings

arm64:    aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0

    defconfig: 1 warning
    tinyconfig: 1 warning

arm:    arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0

    multi_v7_defconfig: 2 warnings
    omap2plus_defconfig: 1 warning
    sunxi_defconfig: 1 warning

mips:    mips-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0

    allnoconfig: 52 warnings
    ar7_defconfig: 52 warnings
    ath25_defconfig: 52 warnings
    ath79_defconfig: 52 warnings
    bcm47xx_defconfig: 52 warnings
    bcm63xx_defconfig: 52 warnings
    bigsur_defconfig: 1 error, 56 warnings
    bmips_be_defconfig: 52 warnings
    bmips_stb_defconfig: 52 warnings
    capcella_defconfig: 52 warnings
    cavium_octeon_defconfig: 52 warnings
    ci20_defconfig: 52 warnings
    cobalt_defconfig: 52 warnings
    db1xxx_defconfig: 52 warnings
    decstation_defconfig: 1 error
    e55_defconfig: 52 warnings
    fuloong2e_defconfig: 52 warnings
    gpr_defconfig: 52 warnings
    ip22_defconfig: 52 warnings
    ip32_defconfig: 52 warnings
    jazz_defconfig: 52 warnings
    jmr3927_defconfig: 1 error
    lasat_defconfig: 52 warnings
    lemote2f_defconfig: 52 warnings
    loongson1b_defconfig: 52 warnings
    loongson1c_defconfig: 52 warnings
    loongson3_defconfig: 52 warnings
    malta_defconfig: 52 warnings
    malta_kvm_defconfig: 52 warnings
    malta_qemu_32r6_defconfig: 52 warnings
    maltaaprp_defconfig: 52 warnings
    maltasmvp_defconfig: 52 warnings
    maltasmvp_eva_defconfig: 52 warnings
    maltaup_defconfig: 52 warnings
    maltaup_xpa_defconfig: 52 warnings
    markeins_defconfig: 52 warnings
    mips_paravirt_defconfig: 52 warnings
    mpc30x_defconfig: 52 warnings
    msp71xx_defconfig: 52 warnings
    mtx1_defconfig: 52 warnings
    nlm_xlp_defconfig: 52 warnings
    nlm_xlr_defconfig: 1 error, 1 warning
    pic32mzda_defconfig: 52 warnings
    pistachio_defconfig: 52 warnings
    pnx8335_stb225_defconfig: 52 warnings
    qi_lb60_defconfig: 52 warnings
    rb532_defconfig: 52 warnings
    rbtx49xx_defconfig: 52 warnings
    rm200_defconfig: 52 warnings
    rt305x_defconfig: 52 warnings
    sb1250_swarm_defconfig: 1 error, 56 warnings
    tb0219_defconfig: 52 warnings
    tb0226_defconfig: 52 warnings
    tb0287_defconfig: 52 warnings
    tinyconfig: 52 warnings
    workpad_defconfig: 52 warnings
    xilfpga_defconfig: 52 warnings
    xway_defconfig: 52 warnings

Errors summary:

    1    cc1: error: '-march=3Dr3900' requires '-mfp32'
    1    cc1: error: '-march=3Dr3000' requires '-mfp32'
    1    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise co=
mparison always evaluates to false [-Werror=3Dtautological-compare]
    1    (.text+0x1bf10): undefined reference to `iommu_is_span_boundary'
    1    (.text+0x1bbc0): undefined reference to `iommu_is_span_boundary'

Warnings summary:

    2530  arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean exp=
ression [-Wbool-operation]
    330  arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expr=
ession [-Wbool-operation]
    36   fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-voi=
d function [-Wreturn-type]
    12   kernel/sched/core.c:3294:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    12   arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is n=
ot used [-Wunused-value]
    10   net/core/ethtool.c:300:1: warning: control reaches end of non-void=
 function [-Wreturn-type]
    10   include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches en=
d of non-void function [-Wreturn-type]
    8    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOT=
LB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (C=
AVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NL=
M_XLR_BOARD)
    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    6    fs/posix_acl.c:34:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    5    lib/cpumask.c:211:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    4    block/cfq-iosched.c:3840:1: warning: control reaches end of non-vo=
id function [-Wreturn-type]
    3    drivers/clk/sunxi/clk-sun8i-bus-gates.c:85:27: warning: 'clk_paren=
t' may be used uninitialized in this function [-Wmaybe-uninitialized]
    2    drivers/mfd/omap-usb-tll.c:90:53: warning: overflow in conversion =
from 'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070=
' to '22' [-Woverflow]
    2    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined =
but not used [-Wunused-function]
    1    cc1: all warnings being treated as errors
    1    arch/arm64/kernel/vdso.c:127:6: warning: 'memcmp' reading 4 bytes =
from a region of size 1 [-Wstringop-overflow=3D]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sect=
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
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mi=
smatches

Warnings:
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 section =
mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 16 warnings, 0 sect=
ion mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    block/cfq-iosched.c:3840:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 =
section mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    block/cfq-iosched.c:3840:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]
    lib/cpumask.c:211:1: warning: control reaches end of non-void function =
[-Wreturn-type]

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
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 56 warnings, 0 sect=
ion mismatches

Errors:
    (.text+0x1bf10): undefined reference to `iommu_is_span_boundary'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    cc1: error: '-march=3Dr3000' requires '-mfp32'

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    drivers/clk/sunxi/clk-sun8i-bus-gates.c:85:27: warning: 'clk_parent' ma=
y be used uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sectio=
n mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

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
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    cc1: error: '-march=3Dr3900' requires '-mfp32'

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
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0=
 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0=
 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnin=
gs, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, =
0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings=
, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    drivers/clk/sunxi/clk-sun8i-bus-gates.c:85:27: warning: 'clk_parent' ma=
y be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/mfd/omap-usb-tll.c:90:53: warning: overflow in conversion from =
'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070' to =
'22' [-Woverflow]

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
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 secti=
on mismatches

Errors:
    arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise compari=
son always evaluates to false [-Werror=3Dtautological-compare]

Warnings:
    cc1: all warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 =
section mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    lib/cpumask.c:211:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 =
section mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 7 warnings=
, 0 section mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    lib/cpumask.c:211:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

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
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    drivers/mfd/omap-usb-tll.c:90:53: warning: overflow in conversion from =
'int' to 'u8' {aka 'unsigned char'} changes value from 'i * 256 + 2070' to =
'22' [-Woverflow]

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 =
section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warning=
s, 0 section mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sect=
ion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 56 warnings, =
0 section mismatches

Errors:
    (.text+0x1bbc0): undefined reference to `iommu_is_span_boundary'

Warnings:
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XE=
N && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM=
_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR=
_BOARD)
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

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
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    drivers/clk/sunxi/clk-sun8i-bus-gates.c:85:27: warning: 'clk_parent' ma=
y be used uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 sec=
tion mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    arch/arm64/kernel/vdso.c:127:6: warning: 'memcmp' reading 4 bytes from =
a region of size 1 [-Wstringop-overflow=3D]

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 section m=
ismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 5 warnings, 0 section mis=
matches

Warnings:
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 17 warnings, 0 se=
ction mismatches

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    block/cfq-iosched.c:3840:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 18 warnings, =
0 section mismatches

Warnings:
    arch/arc/kernel/unwind.c:188:14: warning: 'unw_hdr_alloc' defined but n=
ot used [-Wunused-function]
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    fs/ext4/ext4_jbd2.h:430:1: warning: control reaches end of non-void fun=
ction [-Wreturn-type]
    block/cfq-iosched.c:3840:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    arch/arc/include/asm/cmpxchg.h:95:29: warning: value computed is not us=
ed [-Wunused-value]
    fs/posix_acl.c:34:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]
    lib/cpumask.c:211:1: warning: control reaches end of non-void function =
[-Wreturn-type]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 se=
ction mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 52 warnings, 0 secti=
on mismatches

Warnings:
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:831:36: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]
    arch/mips/math-emu/cp1emu.c:836:14: warning: '~' on a boolean expressio=
n [-Wbool-operation]

---------------------------------------------------------------------------=
-----
zebu_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sect=
ion mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 =
section mismatches

Warnings:
    kernel/sched/core.c:3294:1: warning: control reaches end of non-void fu=
nction [-Wreturn-type]
    net/core/ethtool.c:300:1: warning: control reaches end of non-void func=
tion [-Wreturn-type]
    lib/cpumask.c:211:1: warning: control reaches end of non-void function =
[-Wreturn-type]
    include/linux/sunrpc/svc_xprt.h:178:1: warning: control reaches end of =
non-void function [-Wreturn-type]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
