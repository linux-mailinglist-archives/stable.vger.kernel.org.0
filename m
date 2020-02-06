Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5DA153DCD
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 05:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgBFEL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 23:11:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39249 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFELZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 23:11:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so5314061wme.4
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 20:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fB7ae+knB7YZYBMmFDytaYUx38LChRND8af6Du8g7Ok=;
        b=o0E6r1jxeajS6Q8XhiiibRICWsUsYn9F8/ORcH5d1hPvoNp6PbLZkXCQ1r7LGuBO7u
         0wryjhs3i3BIVtlm3sX4BiZFsKFcDu1SyHWY6kQIeHIFwh1pirbsvyq7WCvN7xMdXuc9
         ciryI4g5Z7+sZkFUa2QgMP+Qkpa0zm12rnCJbuXMVBdR0xWwWw8KHb1r+GsZpFcr6S/v
         P41nvE3GBnWmTx/2jMeDgmcpoeISHCIB7tE5lzdjHlVA5qpFVv+J9j/7L1MJMtaNjBCD
         f95TTNBq5Jd1vgSz1L5fkrGhNGTBvIVEWiJte2jglaIbJMkbxXgTYB6aTgQEyu3AQwMx
         twHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fB7ae+knB7YZYBMmFDytaYUx38LChRND8af6Du8g7Ok=;
        b=eeg29ZiGpIE/u12FBF3DKc5xF8dL/+5t0B12u4RPGdaJIEOuhgjl9hYyi+wqwj+rHu
         8bCVxZwrYN3PsnGqvWqHybi79N0fJHWMNH9PVuP/DFY3P3RKTCm6bBxG7CETNz/idH1v
         js+fnAb5KDDoZge0xHTSm2IBH3X1I3KLxH8iNsZyV+ROL6IxGWdImj2DxNVb4bbyyuFV
         cYAzYoTnU+Lldo8WgTVp59ceWUJc8cSOVo4t07MqWlzWZWOoLBYgdzF9OTwIdqDKD4/D
         PwqVNKowd2NUba1rPiJqzjIKhmI6hhmMKZOHsuo3Dfsvy5dGxW+gcKZipC7CR1UgcKj9
         qkDg==
X-Gm-Message-State: APjAAAXSkFoJTQ+zPBPBYzBhLXXBtHF/RWG1FhxOScnDr8ypCW3RnjqD
        7GO8QwFO2yvTe/NnZjSzflxJJTfSk4MudA==
X-Google-Smtp-Source: APXvYqzbn5+qvihHD7E6as/p5Z4w104SITGbQGCiZr1wm7x/sfu/eW4Htkz8mKkr4bCREpTHNkXK4A==
X-Received: by 2002:a1c:a584:: with SMTP id o126mr1477928wme.163.1580962283125;
        Wed, 05 Feb 2020 20:11:23 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f1sm2425570wro.85.2020.02.05.20.11.22
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 20:11:22 -0800 (PST)
Message-ID: <5e3b91ea.1c69fb81.4fb94.a6e2@mx.google.com>
Date:   Wed, 05 Feb 2020 20:11:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.213
X-Kernelci-Report-Type: build
Subject: stable/linux-4.4.y build: 28 builds: 0 failed, 28 passed,
 2 warnings (v4.4.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y build: 28 builds: 0 failed, 28 passed, 2 warnings (v4.4.=
213)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.4.y/ke=
rnel/v4.4.213/

Tree: stable
Branch: linux-4.4.y
Git Describe: v4.4.213
Git Commit: d6ccbff9be43dbb6113a6a3f107c3d066052097e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 4 unique architectures

Warnings Detected:

arc:

arm64:

arm:
    mxs_defconfig (gcc-8): 1 warning

mips:
    ip22_defconfig (gcc-8): 1 warning


Warnings summary:

    1    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argum=
ent 5 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from integer withou=
t a cast [-Wint-conversion]
    1    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate =E2=80=98c=
onst=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

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
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: passing argument 5=
 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from integer without a c=
ast [-Wint-conversion]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate =E2=80=98const=
=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

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
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
