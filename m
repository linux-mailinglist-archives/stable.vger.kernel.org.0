Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1175D153F4B
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgBFHdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:33:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54058 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgBFHdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:33:13 -0500
Received: by mail-wm1-f65.google.com with SMTP id s10so5095862wmh.3
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 23:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VnBPK+SLfHH8eDl7gmshPbQB7OIIw/p8TrO5wxlnMds=;
        b=VNdDlym6cW7ch6OUbQY9I7q8l251hUo8Gwv/zc2MmQLmol7qlRq5UyiIWz/lragdrK
         F9O+W1qUkmQD//eXdn5qXGi3gQ06AXM1zAsjitekt2gMY0ENmnWnSM3l4q5Y9u3DOy4/
         yEZsQmRADGoV1nwJrgz4uL3NLTWkffWz8hLKSrlye90smiu2bY6hNlRqfeC6JLASnvFN
         B21tpKoGF39i5ObHL+Hcs2nyfhS1iyD2K0NZYC7YF/wOJsvAa1c+5aWK6lSbqb+QpsU8
         PFZV2dQzZ5WvfJ7laklwNVVc41ytAwX1ynNBQpyERn8tMQUsQXu9whw5tzM8N/L1f8e/
         aWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VnBPK+SLfHH8eDl7gmshPbQB7OIIw/p8TrO5wxlnMds=;
        b=WHYvWSlEgdt73/PcrOJh8pv745k3+Y3aEbygmf/Yey5y9bmHt1jdw84/ONgWBUtDUd
         /YCQrO9OnkuV9FDJocPeiaVwzPm6il+IOIm6TqcgLgG2tFUxYsqFy9L9WJ2h8ffXrXga
         K8NM7Q76uV7cgnhwNCnMofZu6toZ9F9OLufEv4HYDPiTtWSfN91V01L0uIzgZcW/r8CA
         KaSmvlar+KUS/++LD+5Zvuriy+4hSayIMfZFARYVJmsJZ2rW+WIhLhPF1EuK3IUMZG8t
         QJe5ZPgIo0mlbe0W8pykGcCA1T7bo71vWmSCzs6q85C7SaZwEQ02OkoQoJTjaEeRR/TF
         hDwQ==
X-Gm-Message-State: APjAAAVs5k9IZqNVcZC6VMHNCsqbLZ+7equE+j5g00hO9JkVNF6BT1s0
        3lr0qC75Bvom1tpEjcX7u+7UqDVayVKJJA==
X-Google-Smtp-Source: APXvYqxWYZwW+olKdOpJWafKQgXjATE+oLc6dX5NphHjXBX+9tPeX+4UVfwXqhCLFcJbtwUq/krjWw==
X-Received: by 2002:a1c:e108:: with SMTP id y8mr2595308wmg.147.1580974389198;
        Wed, 05 Feb 2020 23:33:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i11sm3015106wrs.10.2020.02.05.23.33.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 23:33:08 -0800 (PST)
Message-ID: <5e3bc134.1c69fb81.b3bec.ccc2@mx.google.com>
Date:   Wed, 05 Feb 2020 23:33:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.170
X-Kernelci-Report-Type: build
Subject: stable/linux-4.14.y build: 27 builds: 0 failed, 27 passed,
 17 warnings (v4.14.170)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y build: 27 builds: 0 failed, 27 passed, 17 warnings (v4.=
14.170)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.170/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.170
Git Commit: e0f8b8a65a473a8baa439cf865a694bbeb83fe90
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 4 unique architectures

Warnings Detected:

arc:

arm64:
    defconfig (gcc-8): 1 warning

arm:
    acs5k_tiny_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 2 warnings
    mxs_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    pxa_defconfig (gcc-8): 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning

mips:
    malta_qemu_32r6_defconfig (gcc-8): 1 warning


Warnings summary:

    15   fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
    1    {standard input}:29: Warning: macro instruction expanded into mult=
iple instructions
    1    drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c:146:5: warning: =E2=80=
=98is_double=E2=80=99 may be used uninitialized in this function [-Wmaybe-u=
ninitialized]

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
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    {standard input}:29: Warning: macro instruction expanded into multiple =
instructions

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]
    drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c:146:5: warning: =E2=80=98is=
_double=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninit=
ialized]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may be us=
ed uninitialized in this function [-Wmaybe-uninitialized]

---
For more info write to <info@kernelci.org>
