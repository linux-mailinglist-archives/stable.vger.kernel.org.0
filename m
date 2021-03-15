Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB6833AA98
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 05:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhCOEzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 00:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhCOEzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 00:55:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2F1C061574
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 21:55:12 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so13682134pjc.2
        for <stable@vger.kernel.org>; Sun, 14 Mar 2021 21:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZNBG8SXcMJ0bDoXO4wfzDeOH5iDHEpgG5HfBe06RED0=;
        b=RtgvHTOgvTrsdsJ4uQgaMF896GytXCuxXtthJ2wDZFU5fjgRDdVOKnKpCl5PhoeSYZ
         Pp0639Dc40Rlp0kWU1f7G7J6CFz4sacrVlAhNylEFTUk8uBQPxr3Mv3fJcCjAEfbKFP0
         E4AXusQKQHASHaYEOrDTKE1a/5/czyQ5nim5Dbmjijajg7eZQfDp2EH8E1/VRgFbRIgZ
         8DgTJdOmd7lj1N6ePHxhBVMLfBPKpjdvOcDHl/TsZH4sp/0nOFH0lEJgBQk7k3HMvNBz
         ahflpI9uov0wyymTtTCIT5WspgKjGOw55XnFmIlgvOlD236UmNoIZIJz3aHINvRWyrna
         9A3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZNBG8SXcMJ0bDoXO4wfzDeOH5iDHEpgG5HfBe06RED0=;
        b=Th5c+yquQ6WB4DEE9hZtV5JMdGoE9lRVHFciOoA8t6eUuvFy3Z+lZxGvNfr1JrlTI1
         S8KPlaYVJ64z062bNhx5cvfr5kNODV0PRIfM1tIN/5NQm/oAA3Nj2Z1Ba5hdW9Vjqotg
         4r88ENsv/FMp2aQyGtrxfekdNVZXS2ZobTyku3wC0u5pSQOg2kfUx3ELrsJJNHlTNJhf
         6okR6ZUWR4rN0kfyLyrRi0rw56OdEaWrNIKltXFAl8sDrQZHzzq2O2govgVcE1xjN5Jy
         R1CoBgQjig5/Yp7R9ELsPx88x02ytbf7OJ4Ey+SOsowUMdz0NmxiIxgDCm5MBZsd6UCb
         7sCQ==
X-Gm-Message-State: AOAM533YqcIE07fIER+YrcnCyTf7USRxjWCeOdxySGmOaiiSYMe4V/F9
        vL2NYh99TnSueywqs7pqgT2ryln+yRNAMA==
X-Google-Smtp-Source: ABdhPJzL1cNrUshzA8iT1OWDZUY72i2uYoOPhqEDc9X7EWOJ33DKbhWKS+3O7Q5v1BqLHfjIX+jJqQ==
X-Received: by 2002:a17:902:a607:b029:e4:c03e:3a9f with SMTP id u7-20020a170902a607b02900e4c03e3a9fmr9830680plq.14.1615784111381;
        Sun, 14 Mar 2021 21:55:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w18sm8887211pjh.19.2021.03.14.21.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 21:55:11 -0700 (PDT)
Message-ID: <604ee8af.1c69fb81.62ff8.6916@mx.google.com>
Date:   Sun, 14 Mar 2021 21:55:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-262-g1eb3b9211edf9
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 build: 194 builds: 2 failed, 192 passed,
 13 warnings (v5.10.23-262-g1eb3b9211edf9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 build: 194 builds: 2 failed, 192 passed, 13 warnings (=
v5.10.23-262-g1eb3b9211edf9)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.23-262-g1eb3b9211edf9/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.23-262-g1eb3b9211edf9
Git Commit: 1eb3b9211edf92da9a511123fb2c5cd3ceca9ee2
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

mips:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

Warnings Detected:

arc:

arm64:

arm:
    omap1_defconfig (gcc-8): 1 warning

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
    1    arch/arm/mach-omap1/board-ams-delta.c:462:12: warning: =E2=80=98am=
s_delta_camera_power=E2=80=99 defined but not used [-Wunused-function]
    1    .config:1171:warning: override: UNWINDER_GUESS changes choice state

Section mismatches summary:

    7    WARNING: modpost: vmlinux.o(.text+0xc374): Section mismatch in ref=
erence from the function reserve_exception_space() to the function .meminit=
.text:memblock_reserve()
    2    WARNING: modpost: vmlinux.o(.text+0xae2c): Section mismatch in ref=
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
    1    WARNING: modpost: vmlinux.o(.text+0xae1c): Section mismatch in ref=
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
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

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
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1171:warning: override: UNWINDER_GUESS changes choice state

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
