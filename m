Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C7C2D068C
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 19:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgLFSuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 13:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbgLFSuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 13:50:07 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CBCC0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 10:49:27 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id w6so7526350pfu.1
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 10:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cmcHDHNq369cSmit5yi5UXaYPVM6SNxJFNZ9cfuaQe8=;
        b=CC0dktXNtXrenopaHwQd+W7bnl5CFfPhdWjl9FPlssDXiLOSM1gXFGunv/Tfp1zpxF
         KLVN9680frrikE/6ZFNC4s8UKK60sm0VE7UAl1kJAB9oPvXSKgnwTDRt99CJqaNA+h1d
         qc23Bs6ll6XPpxs+qoovbE3LIv1IemcoSeY6KYt6uILZABbnzIUvAC6TeNhjaEr68ze0
         gMLIFIyzqWCzjEbLd9CZR8jiAVwQoRAiCoQe7VvLPEzmRjx60exh9tAlqKR25b+IVjLz
         i/y+lvb36m/nVZUcNaAxH1+E+YeT7cM5L3jLxDh2rH9x800YQWk53ouInwwVQSsTh6tY
         iTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cmcHDHNq369cSmit5yi5UXaYPVM6SNxJFNZ9cfuaQe8=;
        b=e+8a55kgE5Uj1f5vTRM4QUOepwYb2nRzHlTmTWFgWW+ImWnzSeX99mZuv14yfV1nbH
         VTsxRJp75EFn1znB0E8LqywM3eCjJjdb+f0N5fU7nkBgYD+G75MovN39pbRjmlIJxZBw
         d3QWRunaTBdrc+1mV+3bJSWAILqYjlFyPnlad4Np8DwLdlFuAXYKKSroj8WsE0elFGgP
         WO8LCeQCPuNtDhdR4KLT/LHwguuqyWdunWgHyuLK1AjDXzmuAbX2584GTvrL4OosjKWG
         i0rvHAQA6yOF6JvYIkjVIFDt2PFNa1+CQxIzxrvZsRgMmK91MZQbnHgKriui31mmsmQC
         51aQ==
X-Gm-Message-State: AOAM530QcVRHHKAyDTllD5q6U+0ard70iqh0k7A/RYacvXOGvZ7meF5t
        iIJmGWfpi65utVT0uKvveOpZz/QOWSFABQ==
X-Google-Smtp-Source: ABdhPJxjnKb8wNKr1z3zoKRlYtFoBNnK5nT+Zav92iuE1qoSdzi1YTY8UWyxlyUu/0y8AVkf5Ne53Q==
X-Received: by 2002:a63:f857:: with SMTP id v23mr15758276pgj.174.1607280566691;
        Sun, 06 Dec 2020 10:49:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k4sm7907227pjo.54.2020.12.06.10.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:49:26 -0800 (PST)
Message-ID: <5fcd27b6.1c69fb81.5fc2.2993@mx.google.com>
Date:   Sun, 06 Dec 2020 10:49:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.210-21-geea918eb2691
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 155 runs,
 8 regressions (v4.14.210-21-geea918eb2691)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 155 runs, 8 regressions (v4.14.210-21-geea=
918eb2691)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =

meson-gxbb-p200       | arm64  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =

panda                 | arm    | lab-collabora | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =

qemu_x86_64           | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.210-21-geea918eb2691/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.210-21-geea918eb2691
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eea918eb2691ce5a9daaeff667dd08ea71687abf =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccefa23ae9839da0c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccefa23ae9839da0c94=
ce4
        failing since 135 days (last pass: v4.14.188-126-g5b1e982af0f8, fir=
st fail: v4.14.189) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
meson-gxbb-p200       | arm64  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccee2e68e4d9f432c94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccee2e68e4d9f432c94=
ced
        failing since 250 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
panda                 | arm    | lab-collabora | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccef872f3b6bbbb6c94dd4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fccef872f3b6bb=
bb6c94dd9
        failing since 4 days (last pass: v4.14.209-51-g07930d77d7ba, first =
fail: v4.14.210)
        2 lines =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccec6da96921ea98c94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccec6da96921ea98c94=
cbd
        failing since 22 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccec57c6c7b16b5ec94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccec57c6c7b16b5ec94=
ce1
        failing since 22 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccec69a96921ea98c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccec69a96921ea98c94=
cba
        failing since 22 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccec1aedafcab9d4c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccec1aedafcab9d4c94=
cbb
        failing since 22 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_x86_64           | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcced9a8dda0f08e7c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
10-21-geea918eb2691/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcced9a8dda0f08e7c94=
cd1
        new failure (last pass: v4.14.210-21-ga6f93b82e1d6) =

 =20
