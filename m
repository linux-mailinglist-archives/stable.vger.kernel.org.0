Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8A9153DC5
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 05:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBFEAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 23:00:52 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:37243 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFEAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 23:00:52 -0500
Received: by mail-wm1-f44.google.com with SMTP id f129so5290098wmf.2
        for <stable@vger.kernel.org>; Wed, 05 Feb 2020 20:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LI5aKZyxhf5qqyZPPuycQGOpfCBZQAoCDBGJjmnVMa0=;
        b=IitmbYzYFX/BftAfZhFHeCUr9EGHfCF6cd7nf5NEBAqTM20IqGsvOHqpChyPP1TpuU
         v9Pyq8bSP4J7nS/S8uAsLYGrCvirp9AR/1x579BLo3p/UtZxggueIf2o+WuOwJafky8B
         VJUDC5XAZDFtz2L9JEuMIeQ8Qjq2hwL5jWapQOXatUaIMb90u6mhS5uKakwfNI+26Rdm
         MxYAZRUID2I+tAH2F/FWogHGgOfkBZ2x8O4MkD1kaMAt/OC1NGOXNwjMgupVvFXMyi18
         5aaD6NqnkVyEkNMrTSMJDpx2kjK1QsTA5vnVEDB9xTxXIq+AN1VLpnG07UvlzFCzXOC3
         WNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LI5aKZyxhf5qqyZPPuycQGOpfCBZQAoCDBGJjmnVMa0=;
        b=bMWEAK7dlLPeRg/bi0wbHhLLXn5foet5yWK8HuvoI0vM7FTBFUr7XHoKOYpu0I+LJt
         fCNUVCym5+wMCHM2qUMuuRoz6Rw3VV6BBYtumZ8uUMECM9XWPA5Tgbk8eF+Iy0X8o+yt
         JJ+vkHc3ncxJXDUHffe1xgZEs6+G/27+dj/2G/fZ5DjsEfNuxzFHv74aKt86+bXDvvL/
         dIxXSFxo4MID7scO3xYJuWcolNPKVgc+Cpl6IjiCx1qinTZWZ4DmZ2AGXNnxW1pYc54a
         SbNFWymT3SIF5L5RXMgbgD89ZH/epRPp3LvliGlG2aZQmFI2eZAjSda+vIOGEZ9FkoiC
         u9qg==
X-Gm-Message-State: APjAAAWFEBJ0/H8VKUY3kI0v7eZP0kjWAxCiG2NFtQgUauI33g5PbznM
        EfAUiEgSV+FBVtTdXeli4JKWlcbEH7cEag==
X-Google-Smtp-Source: APXvYqwbK8kZyAF7RolgA7TdWfu36qtfA4GWjl6c1plrPnYWWG5eEJYU+GZUMkb/CNy+L8Vu5uPqdw==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr1588218wmi.46.1580961649646;
        Wed, 05 Feb 2020 20:00:49 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h2sm2645415wrt.45.2020.02.05.20.00.48
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 20:00:49 -0800 (PST)
Message-ID: <5e3b8f71.1c69fb81.2f767.b2c4@mx.google.com>
Date:   Wed, 05 Feb 2020 20:00:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.213
X-Kernelci-Report-Type: build
Subject: stable/linux-4.9.y build: 26 builds: 0 failed, 26 passed (v4.9.213)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y build: 26 builds: 0 failed, 26 passed (v4.9.213)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.9.y/ke=
rnel/v4.9.213/

Tree: stable
Branch: linux-4.9.y
Git Describe: v4.9.213
Git Commit: 0e96b1eb0ea5e4e8cdcdde6f0c68f89dc1d08be7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 5 unique architectures

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---
For more info write to <info@kernelci.org>
