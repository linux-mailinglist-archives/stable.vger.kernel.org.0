Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7432B3B86
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 03:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgKPCvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Nov 2020 21:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgKPCvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Nov 2020 21:51:06 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B020C0613CF
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 18:51:05 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c20so12583034pfr.8
        for <stable@vger.kernel.org>; Sun, 15 Nov 2020 18:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WbqJddiO1O/k7CIdCn1XflOqPiG00o92Fd8QgMz5Nmc=;
        b=xj8hIIa9BSkWJc8B2Zr4UQt3EJHGpnRzSNpfrWlu/mwUPmf/oh/g+yD55a93GGcmz6
         DeqBJqqtTFax4RtYvNNoTudAlGzFs327RMiiXXNLoJ4C6ewRgWDBZmaCZSnCdZbsqohS
         35mFYX9E8i/zZEb53huuYmra1Ihi0W3nCMIVZ2Gf6m2UJAZ+dzzMkhdtM6SWYVp8Csv2
         mcZOFHzZV7BdkiJRj4gZ/dTc/m8B7xIB/+sZl64SvLNASn4vpfajMP/9m0qALbewCYo3
         N2FIK2rH3cX0w84B3HSHspX8fjYKki/esplxoxBAlARgWvCX7aWPYM6Y0jjpJkixHGUU
         V0tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WbqJddiO1O/k7CIdCn1XflOqPiG00o92Fd8QgMz5Nmc=;
        b=VYypUlQCONTvCKOB7EaT+F4mFuGcR8l+oyONcMYZZQhNfKDq6CAr4uLA8EQhz7HPlD
         qVMAuPVb3GZ1bUqG4+kbpCw79zaX/Hi6FsurWavqIThwv2ZKYtRN7OxezCESOh3+1QlL
         k99IbWD0oqh014BRdJMleu8R5kcWeDycqEY+bo3ZgLj17hcX8u6H1T0BK8sf8fJ1xToz
         dVvK1W7dgEUWMdjUj09HY9a/KwminUFc3HdZv/AEizI002rReDqXIIgNeVoTOuwcXr8p
         g8C06UZD/LDqltwAmUAmoKtqBa/5lhOmczMnRFNF3t1emkjEUNYvWM5y69VfS+nuDwBV
         nzaw==
X-Gm-Message-State: AOAM53141sFAP5ZcRMhYW18WMVzoW/X69I+/FCBFajrWNZGeQhKm/YJi
        dpLCglabY+286OMttRGbIvEag5nwQTEr1w==
X-Google-Smtp-Source: ABdhPJztZdwMmijdyyzm0Y59KZLTDTNiCg0QJDeCWMtJUu10Z+d0JaK9nHUttqrfaZl7jvAIX1Oehw==
X-Received: by 2002:a17:90a:2ec3:: with SMTP id h3mr13957143pjs.54.1605495064013;
        Sun, 15 Nov 2020 18:51:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm15729166pjr.50.2020.11.15.18.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 18:51:03 -0800 (PST)
Message-ID: <5fb1e917.1c69fb81.1f040.158a@mx.google.com>
Date:   Sun, 15 Nov 2020 18:51:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.206-33-g99cf73992291
X-Kernelci-Report-Type: build
Subject: stable-rc/queue/4.14 build: 19 builds: 0 failed, 19 passed,
 7 warnings (v4.14.206-33-g99cf73992291)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 build: 19 builds: 0 failed, 19 passed, 7 warnings (v4.=
14.206-33-g99cf73992291)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F4.1=
4/kernel/v4.14.206-33-g99cf73992291/

Tree: stable-rc
Branch: queue/4.14
Git Describe: v4.14.206-33-g99cf73992291
Git Commit: 99cf73992291b24d13a83fb360b7f940d411f73e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 3 unique architectures

Warnings Detected:

arm64:
    allnoconfig (gcc-8): 1 warning

arm:
    pxa168_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 1 warning

mips:
    jmr3927_defconfig (gcc-8): 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 warning


Warnings summary:

    7    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_l=
ist=E2=80=99 defined but not used [-Wunused-variable]

Section mismatches summary:

    1    WARNING: modpost: Found 1 section mismatch(es).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

Section mismatches:
    WARNING: modpost: Found 1 section mismatch(es).

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:48:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---
For more info write to <info@kernelci.org>
