Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8368165560
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 03:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBTC6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 21:58:38 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34052 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgBTC6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 21:58:37 -0500
Received: by mail-pg1-f194.google.com with SMTP id j4so1171028pgi.1
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 18:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kPwGL5DzR+qGpZyohmfcyx4rjYvp1wA1LDuKNgWGQ/o=;
        b=fdop3Eh7UqSbTRXNNrk1LWBlPfOXZphHBp2jtVyrHfwoMr4Zsw0EcqX+9RVeWO9dNd
         eQYpRRHYif8akAXbTvx9RNlLoChLv09E/eF1L+2gQ5/w6+wrfctdyPXy+6MCa9Nl9L4U
         xKaK+49jj2l7ZsKJuQgvwo3mPxKJEjGveFaGgmlRCA4uXFJfzD1mSu1l/xlNgdL/QE8t
         NhR1P08ZsNd1zzC6XkytM8pHtLo2Uhrnu3Htf4ySG9/RxItayVJTWcGlewha+BRIF+vd
         UGsquk93gmfwfZjTS2QQlJ1bSoX1ntBPS+FzJYgVhZnf3qM1yr2/XMyunCbiPIvTOAj9
         wsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kPwGL5DzR+qGpZyohmfcyx4rjYvp1wA1LDuKNgWGQ/o=;
        b=FlvVVyDjpuNd4oysx7PQ2Pcb6LP/vpTnkmErb8fUtRr2F3hct08ruuoOwMgHMERVvG
         RlHi6kZR3wiupBiF5Hv5gNlYRwcaz3dRlHTeAvhR8DqN8pUZfNWUt0YVFa1q9zGVB+R2
         sLlJRwMRo3c5gcM0QwnXtIf/9pLSLGrbMQCc+Zt9mUhCBhCgB698xg9fync2TerLxsJ2
         vnOTTR+2TW/6yOcWEmGAiamq33m3aKOegGls77/i4VanRCuHrWNgSDmf0A2HQYzaYHnb
         F3GPYO7RzybQy/qpWnnlOqdSP3EG5W7nfVqFLTUavHZ9vB6W24qQzL80dqzB+9zhrbt/
         8EbA==
X-Gm-Message-State: APjAAAW/vfbUEVZoAe36I2MapZ7e+do6Ibo1f4EW1XsBjG3C+IjQnFmC
        CZLlUAb5Z7wfMvSAHf8ElXRBw7R0osw=
X-Google-Smtp-Source: APXvYqzgJjYzcWGAoyZ842OAuxRUsJRwyC3YPq/g1122+NfA/vyEKBP5ZCBUryEs0IIr8FWJdbRqDA==
X-Received: by 2002:a63:d207:: with SMTP id a7mr31145186pgg.225.1582167516449;
        Wed, 19 Feb 2020 18:58:36 -0800 (PST)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i64sm1086756pgc.51.2020.02.19.18.58.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 18:58:35 -0800 (PST)
Message-ID: <5e4df5db.1c69fb81.baa2b.4917@mx.google.com>
Date:   Wed, 19 Feb 2020 18:58:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.105
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y build: 15 builds: 0 failed, 15 passed,
 2 warnings (v4.19.105)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y build: 15 builds: 0 failed, 15 passed, 2 warnings (v=
4.19.105)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.105/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.105
Git Commit: 4fccc2503536a564a4ba31a1d50439854201659f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 4 unique architectures

Warnings Detected:

arc:

arm64:

arm:
    multi_v7_defconfig (gcc-8): 2 warnings

mips:


Warnings summary:

    1    drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c:159:5: warning: =E2=80=
=98is_double=E2=80=99 may be used uninitialized in this function [-Wmaybe-u=
ninitialized]
    1    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_propert=
y): /wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 =
or bad phandle (referred from clocks[0])

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c:159:5: warning: =E2=80=98is=
_double=E2=80=99 may be used uninitialized in this function [-Wmaybe-uninit=
ialized]
    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_property): /=
wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 or ba=
d phandle (referred from clocks[0])

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

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
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---
For more info write to <info@kernelci.org>
