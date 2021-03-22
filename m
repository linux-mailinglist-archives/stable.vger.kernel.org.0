Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF29343D40
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCVJwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCVJvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 05:51:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F93C061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 02:51:51 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bt4so8100212pjb.5
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 02:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0sfvEt2GKwetvM6kEu7Z44QW9ybqXIY5VBPQtz/Z6IM=;
        b=LBxvtgasxS97gilPuoPlHVHiCZBbVbQt8KIfAE36Sc5EqXZhY3hjK/4GeYMzc2pcIg
         JvzMgpI+QV4tsy3rZ+kw1vl8P+0dDAEFbJfyb7rGCdNl2IBllvICzBFyw1fZ7sHNkHaO
         k9OMrJ0oNeErI01LveqMDOKZpOfc4XYmioovI52TqZ9teyjl9L7hK+naJVQsSS6rB1IY
         iYAESZY+q8+t+ec3MlSoq50L0kC8nh8GyBieis+vNSsduJZChrVVRhmkn1fCs+iou71N
         Wbx2YXDoeeSJTmKmmtuM4eA1vo+SW7TWw4IX0n4BWx24/aYvrV4RxZFVkfaRhf1HE4Yg
         Hizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0sfvEt2GKwetvM6kEu7Z44QW9ybqXIY5VBPQtz/Z6IM=;
        b=W67tpc/lvWCCMEFWNCtUybFHrCFh3t3L44dcz5Zb5RFCtThrDfsHfX8z7bEQkRxLzr
         uxMF8tmBYOfFlkQ0wRVTPZwIlYh7EBpmX5XIsKbelrmaYhPV1KEwxc227F5vszLuSa1h
         LdoMEJ93yBQucuo8YRsrBxySNV1Pkt9jaWAj6IyF+1kSju1zfqMTDfEaw6uigSVz9Wjv
         i3mw8pwdPmI0oVec3+kmNiRFmmB0V6e0a9QiNvb5TGiqTeK4xDOAsZjxbSmBCrnBcwiW
         iJIn/rBERmHPnV8jQHad/QCB3y6R5NshBkAUD5CDlmKITgdXemh5RzomUKaC7eEITRmI
         j3Rg==
X-Gm-Message-State: AOAM531x5IYv1kgAMbV7s94GdGX37LK1NY5bvWne/nlWMokR4jsE3xxV
        y+qvVZNSvMes633wudPN9gdm5LgBpvsXkw==
X-Google-Smtp-Source: ABdhPJyGaIFfuzpdUIE+DykF4U1vkmrXfgDLRABx6nOW0apsiVf4zXO3hAoqby81lSpEfeBuyOBv2Q==
X-Received: by 2002:a17:902:d512:b029:e6:d595:b0f9 with SMTP id b18-20020a170902d512b02900e6d595b0f9mr17311351plg.78.1616406709712;
        Mon, 22 Mar 2021 02:51:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f2sm13578076pfq.129.2021.03.22.02.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:51:49 -0700 (PDT)
Message-ID: <605868b5.1c69fb81.6aab4.060a@mx.google.com>
Date:   Mon, 22 Mar 2021 02:51:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.25-122-g41ea6b8505eb9
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 build: 196 builds: 3 failed, 193 passed, 2 errors,
 14 warnings (v5.10.25-122-g41ea6b8505eb9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 196 builds: 3 failed, 193 passed, 2 errors, 14 =
warnings (v5.10.25-122-g41ea6b8505eb9)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.25-122-g41ea6b8505eb9/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.25-122-g41ea6b8505eb9
Git Commit: 41ea6b8505eb9e737811fa01ca05def894d3d2ff
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    realview_defconfig: (gcc-8) FAIL

mips:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:

arm64:

arm:
    omap1_defconfig (gcc-8): 1 warning
    realview_defconfig (gcc-8): 2 errors, 1 warning

i386:

mips:
    decstation_64_defconfig (gcc-8): 1 warning
    decstation_defconfig (gcc-8): 1 warning
    decstation_r4k_defconfig (gcc-8): 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 1 warning
    rm200_defconfig (gcc-8): 1 warning

riscv:
    rv32_defconfig (gcc-8): 6 warnings

x86_64:
    tinyconfig (gcc-8): 1 warning

Errors summary:

    1    kernel/rcu/tree.c:683:2: error: invalid initializer
    1    kernel/rcu/tree.c:683:2: error: implicit declaration of function =
=E2=80=98IRQ_WORK_INIT=E2=80=99; did you mean =E2=80=98IRQMASK_I_BIT=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    3    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    {standard input}:39: Warning: macro instruction expanded into mult=
iple instructions
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    cc1: some warnings being treated as errors
    1    arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: =E2=80=98am=
s_delta_camera_power=E2=80=99 defined but not used [-Wunused-function]
    1    .config:1172:warning: override: UNWINDER_GUESS changes choice state

Section mismatches summary:

    7    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    2    WARNING: modpost: vmlinux.o(.text+0xae2c): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    2    WARNING: modpost: vmlinux.o(.text+0xae1c): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    2    WARNING: modpost: vmlinux.o(.text+0xaba4): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    2    WARNING: modpost: vmlinux.o(.text+0x94e4): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    2    WARNING: modpost: vmlinux.o(.text+0x8970): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    2    FATAL: modpost: Section mismatches detected.
    1    WARNING: modpost: vmlinux.o(.text+0xeba0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xe594): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xe4a4): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xdd40): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xd000): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xcdd0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xccc0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xc8b4): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xc134): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xbce0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xbb24): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xba30): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xb72c): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xb5c0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xb330): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xb218): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xb1a8): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xb0ec): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xae30): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xad94): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xab08): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xaaa0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xaa68): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa850): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa7c0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa750): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa600): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa494): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa3f0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa364): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0xa258): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x9ee0): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x9794): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x9744): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x9734): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x9508): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x9358): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x8f18): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x8e90): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x8d18): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x8c24): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x8c1c): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x8a14): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x71d8): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x6b64): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x1df10): Section mismatch in re=
ference from the function reserve_exception_space() to the function .memini=
t.text:memblock_reserve()
    1    WARNING: modpost: vmlinux.o(.text+0x10560): Section mismatch in re=
ference from the function reserve_exception_space() to the function .memini=
t.text:memblock_reserve()

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
    WARNING: modpost: vmlinux.o(.text+0xaba4): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()
    WARNING: modpost: vmlinux.o(.text+0xaba4): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section m=
ismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x71d8): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa364): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8c24): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8f18): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8a14): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xab08): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb218): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa258): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa494): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x1df10): Section mismatch in referen=
ce from the function reserve_exception_space() to the function .meminit.tex=
t:memblock_reserve()

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8c1c): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x9744): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
cu1000-neo_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8970): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8970): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xeba0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xaa68): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xad94): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:708:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa600): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xbce0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa3f0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xe594): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
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
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa850): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xccc0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcdd0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb5c0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb72c): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xaaa0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x10560): Section mismatch in referen=
ce from the function reserve_exception_space() to the function .meminit.tex=
t:memblock_reserve()

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x9794): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x9734): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xdd40): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xae2c): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc134): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa7c0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    {standard input}:39: Warning: macro instruction expanded into multiple =
instructions

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x9ee0): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xae1c): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xae30): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xbb24): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xae1c): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xae2c): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xe4a4): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xd000): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc8b4): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nommu_virt_defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
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
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: =E2=80=98ams_del=
ta_camera_power=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x94e4): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8d18): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb0ec): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x9508): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x8e90): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb330): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/rcu/tree.c:683:2: error: implicit declaration of function =E2=80=
=98IRQ_WORK_INIT=E2=80=99; did you mean =E2=80=98IRQMASK_I_BIT=E2=80=99? [-=
Werror=3Dimplicit-function-declaration]
    kernel/rcu/tree.c:683:2: error: invalid initializer

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xa750): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x9358): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 6 warnings, 0 secti=
on mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

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
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb1a8): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1172:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 section mi=
smatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x6b64): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()
    FATAL: modpost: Section mismatches detected.

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

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
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

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
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0x94e4): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xba30): Section mismatch in referenc=
e from the function reserve_exception_space() to the function .meminit.text=
:memblock_reserve()

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
