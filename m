Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F0A392CC0
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 13:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbhE0Lca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 07:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhE0Lca (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 07:32:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451AEC061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 04:30:57 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so2161141pjb.2
        for <stable@vger.kernel.org>; Thu, 27 May 2021 04:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sHRW5yUBxhDDOhTrrrfAmGzddiuTgtSOrgGI4ynGmNY=;
        b=qitx7RrXLEAV7hI09LMU9+cHS996e7M0aHe2TL+VRVJtSuXONmU2W3UYmcs9UDPd5I
         4eGyzSIe3bRMTC5DG6kXZkOW+zJIDKpagvEE8/6YG6st5jstW8wnKnyaSIN/L9IZXAbc
         vibZ1mLIQr+lsC8YlxeIwCbIGSJLeAV04AVXkDsC+UQdnWIqtYyLpDP0vX8gmwGZuSip
         sYH/4Vpq10kTCIoRXmjcIFIGTr4koOFlMu6o+hB6UJrkKnlIEfebvMjKIYQJ2Du5dSu2
         o3kYo6k2D1SPUeK+2C40Vxf3dehsaFx5CeRAWLqbhEoWVhdTbLrMXuk4nzPnMxWrF8f2
         ZlBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sHRW5yUBxhDDOhTrrrfAmGzddiuTgtSOrgGI4ynGmNY=;
        b=oUWWWiE+anuRKY09G+Q4AeEY5BWucIMNJFdSyGlcYyMPv90IQuhRNqmno6S/v55yOI
         qSJwrbYiHWYv8pgjnG1EMqxSVx526BMycl5s0REGAE7qVhFFu5p3Hd5YX9GphoMm+JQp
         Rz46lKZeTyKYAUlNOJd0OgyMdSK3DHRJZUfKn9hopl64bbyiDQFjRtItH5Mc1pC/vXy9
         Yp7e3qA3kewN74JwWM4wPKb+fOkQFKbzecGBauwec530YxPEN3RZVQq0r7Kp+EvEKPW0
         2y6INdIV4oSnhSmm8bghP1F2oHXgUhTBNO1U+w+X4xFTTumrN114EKyP5rh6a0qoIBmW
         25Ug==
X-Gm-Message-State: AOAM5323jNgD3I5lRNFseDUj3JYUxskTiYdDE3jkj126csYWlaLWpPZM
        LVDeG+ddeUVs+8L53+ElWQYcz1ZYi0tT/Q==
X-Google-Smtp-Source: ABdhPJyg/Efh4IuDlhLYUdC51oXtz3oUMTZCEuQLe28u1a8becEn2UuFO0di+1dzqM6sVOqQv+i1pQ==
X-Received: by 2002:a17:90b:d98:: with SMTP id bg24mr8602303pjb.112.1622115056536;
        Thu, 27 May 2021 04:30:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b12sm1813488pgs.52.2021.05.27.04.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 04:30:56 -0700 (PDT)
Message-ID: <60af82f0.1c69fb81.565d8.621a@mx.google.com>
Date:   Thu, 27 May 2021 04:30:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.122-4-g2e864e6a084c
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/5.4 build: 29 builds: 0 failed, 29 passed,
 17 warnings (v5.4.122-4-g2e864e6a084c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 build: 29 builds: 0 failed, 29 passed, 17 warnings (v5.=
4.122-4-g2e864e6a084c)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.4=
/kernel/v5.4.122-4-g2e864e6a084c/

Tree: stable-rc
Branch: queue/5.4
Git Describe: v5.4.122-4-g2e864e6a084c
Git Commit: 2e864e6a084ca46fb25d5fa336b1ea759dd9c167
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

Warnings Detected:

arc:
    haps_hs_smp_defconfig (gcc-8): 2 warnings
    nsim_hs_smp_defconfig (gcc-8): 2 warnings

arm64:
    defconfig (gcc-8): 2 warnings

arm:
    dove_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    h5000_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    omap1_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning

mips:


Warnings summary:

    11   WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL
    4    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [=
-Wcpp]
    2    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer=
 to integer of different size [-Wpointer-to-int-cast]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

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
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section mi=
smatches

Warnings:
    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to i=
nteger of different size [-Wpointer-to-int-cast]
    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to i=
nteger of different size [-Wpointer-to-int-cast]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
    <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---
For more info write to <info@kernelci.org>
