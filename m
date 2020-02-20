Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3660165541
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 03:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBTCuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 21:50:18 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40480 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgBTCuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 21:50:17 -0500
Received: by mail-pg1-f194.google.com with SMTP id z7so1148566pgk.7
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 18:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sb+0GEmA4ZD8lTonVeP3FxEJuBCo9r4JZccXZKdvpIQ=;
        b=W3rgCpf39F3xDH7qNAT3uyulRvpzuN4LEvwP8Xd2FowEgdAJTezTYHGr/c/z2iPBet
         2hMPpvgWyDg+fF14t/w+7cAuSu5FhHj7nS1FSBmcHsSd7dI9HEsW88aI35Jp1mPZOibG
         vXQ3nz4pg2LdHHaSFzBQzu5MsQq5/VeQN1PJSJOU11VNKTT4gALlIYVJ3wtLMRqyprBH
         22qYKPiwPHMZT5St0wU14xOmFRT+D2h/24PvMvvMD4TaUVfce8JbNfOzHTImJNn7QnOs
         l0yuGEq4ZhHKKOxdapBsUHG1nszmbAUcS5UkN0j9SY2Lkb1r/lPjQDRjcgh4JwGw5ea1
         UkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sb+0GEmA4ZD8lTonVeP3FxEJuBCo9r4JZccXZKdvpIQ=;
        b=ScUSmX2V7NzFJJ+rgnSNBdtKaDxs+SovrsLQjYZE9rJn5+OXSj08O3OyOEL0tgmvuo
         7M8SDhBgPioZ0cDBFDsCE90vo2nHpnar1F9/Z4bGSjAkkV2LGgQUZH/qg1mCB0FmqI3a
         /QTPVXlsKTWDJsQ8VSb9EwJMwk4IF8fPAF/LJIjh2eU/KuY+XkcmDrgVsEHjqE9FKwnT
         j9RyAwc30gBCYhZvIxEIlxE05+Yw7asGvOHG5/EvVS67SMRpO7gv6nJf8Je1cLuJabbT
         G70evV0hhkg+2Fvrdlweu2CmYgt/ZNy+RE4p5c+WIoBWz7AIrKd92inJKxODqEA24WNh
         UXrg==
X-Gm-Message-State: APjAAAXRoh3SZAuiRJvL7lAUH31vknOCzt6Rdsa4W9QE49bPm/4Gbkp5
        HpFXxMXebiRt6lhAaGTEpRsQRqO0EcM=
X-Google-Smtp-Source: APXvYqzQM/TQjQfUpevtnPdUWpjO79F6Lp92fjsCXTUlUZecNDxwk/xCuGNKlXKzI97b0PVhmgYP2g==
X-Received: by 2002:a63:4823:: with SMTP id v35mr30116662pga.177.1582167015950;
        Wed, 19 Feb 2020 18:50:15 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21sm1077720pgo.63.2020.02.19.18.50.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 18:50:15 -0800 (PST)
Message-ID: <5e4df3e7.1c69fb81.b9f9d.471f@mx.google.com>
Date:   Wed, 19 Feb 2020 18:50:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.21-7-gba7360881c6c
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y build: 23 builds: 0 failed, 23 passed,
 21 warnings (v5.4.21-7-gba7360881c6c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y build: 23 builds: 0 failed, 23 passed, 21 warnings (v=
5.4.21-7-gba7360881c6c)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.21-7-gba7360881c6c/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.21-7-gba7360881c6c
Git Commit: ba7360881c6c6d9272de721a0d923c59c1a23a43
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

Warnings Detected:

arm64:
    defconfig (gcc-8): 12 warnings

arm:
    colibri_pxa300_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    h5000_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    viper_defconfig (gcc-8): 1 warning

mips:


Warnings summary:

    8    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL
    2    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_=
format): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address=
-cells =3D=3D 2, #size-cells =3D=3D 2)
    1    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_=
min_dma_period=E2=80=99 defined but not used [-Wunused-function]
    1    arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning (reg_form=
at): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cel=
ls =3D=3D 2, #size-cells =3D=3D 2)
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (spi_bus_=
reg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (pci_devi=
ce_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (i2c_bus_=
reg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_r=
eg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (pci_devic=
e_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_r=
eg): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_re=
g): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (pci_device=
_bus_num): Failed prerequisite 'reg_format'
    1    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_re=
g): Failed prerequisite 'reg_format'

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

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
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 12 warnings, 0 section m=
ismatches

Warnings:
    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_forma=
t): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cell=
s =3D=3D 2, #size-cells =3D=3D 2)
    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (pci_device_bus_=
num): Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (i2c_bus_reg): F=
ailed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2.dtb: Warning (spi_bus_reg): F=
ailed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433.dtsi:254.3-29: Warning (reg_forma=
t): /gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cell=
s =3D=3D 2, #size-cells =3D=3D 2)
    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (pci_device_bus=
_num): Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (i2c_bus_reg): =
Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos5433-tm2e.dtb: Warning (spi_bus_reg): =
Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos7.dtsi:83.3-29: Warning (reg_format): =
/gpu@14ac0000:reg: property has invalid length (8 bytes) (#address-cells =
=3D=3D 2, #size-cells =3D=3D 2)
    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (pci_device_bu=
s_num): Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (i2c_bus_reg):=
 Failed prerequisite 'reg_format'
    arch/arm64/boot/dts/exynos/exynos7-espresso.dtb: Warning (spi_bus_reg):=
 Failed prerequisite 'reg_format'

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    WARNING: "return_address" [vmlinux] is a static EXPORT_SYMBOL_GPL

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
