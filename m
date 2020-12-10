Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E032D667B
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 20:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgLJTak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 14:30:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390311AbgLJTah (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 14:30:37 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92978C0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 11:29:57 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id g18so5187413pgk.1
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 11:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=96F7qRDgQv1rsnN8sdxA8rDTmlpEgbBrIsOp1GTyZYc=;
        b=wwwld6D1bm/WrPxGh3Ff9k5OKstC53IrdrD6EjhQ1Eu77ymPNwCo1+BeZNSAqs6eyB
         PGpqTxXnZKB4rjEcoSRvZFEWrtHb3u1N/YaK3pskBkSKCEjXbPKKu5Dx1uXlZ61ytZKF
         Pf7r9ZvHAdl9rWsB2PUbq3bocBtCCZysG5RCuFtUySjyPpSB2BSYByC/F8sefeqn/FrS
         IKXsHllvXrtUpRtK3XgpKpZCoib5KG7wCKyClqrggTzgly2766NP9XDvVr84kaJGIBoB
         Tm5sq963sTDykwM4O8Y68Z/oohiXjQ6iANM2gXKQTELwCas1QVcBAZNJxDbT6fmJ9ngW
         oU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=96F7qRDgQv1rsnN8sdxA8rDTmlpEgbBrIsOp1GTyZYc=;
        b=mGLBPdwrugLi6ttCABu52QxQZbTO+i4QZmjDFPBsc1sRq/h0XwtmlKmVvnfsju6Omu
         zmSNESj4+peH6m3M+9t+lZTqgIAWzsjt7v3WCmEhuY+ov4ms++MpNd+b+EqrEZ7S02RI
         uFH3MgTQFd7QqCnT/AhhBwHJHPbQq+2RK5KFnajSNtW2zONtg8FD4XeuPqVPergV9EFD
         g0QE/K8zv5tRFgg90Z9j/uFrjt6ZuYEZ/qttaItgos91wdYYE/J0wP+e68dahJtd5Jor
         BY9a0aUCvwNaMtIWDdHL8833xLKD7x+/C8ibnlfrghzBPGI3wSYwP1bt8puaNcEYVbHg
         5YXQ==
X-Gm-Message-State: AOAM5305Hiflp2ec0JuPWHYKluyDsUV8N5yOhUFRvxSmV51cAOxYZjG3
        LzTJww9UcMpTO4S0uM7yIyKki/wj5Bh0XA==
X-Google-Smtp-Source: ABdhPJzBosvRsXOusUIkeagAnGuXxDkN0Ijs7qONjJUrDjDd6zQlT7PJEOlbc6zSqBwZ26lu2Jibiw==
X-Received: by 2002:a63:5114:: with SMTP id f20mr5442886pgb.5.1607628596665;
        Thu, 10 Dec 2020 11:29:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k2sm7441852pgi.47.2020.12.10.11.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 11:29:55 -0800 (PST)
Message-ID: <5fd27733.1c69fb81.f6f70.dd5e@mx.google.com>
Date:   Thu, 10 Dec 2020 11:29:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.162-40-ga556f48a1f86
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 159 runs,
 7 regressions (v4.19.162-40-ga556f48a1f86)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 159 runs, 7 regressions (v4.19.162-40-ga55=
6f48a1f86)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
bcm2837-rpi-3-b            | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.162-40-ga556f48a1f86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.162-40-ga556f48a1f86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a556f48a1f8643fdb3badffeeef8a86dfe7e872f =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
bcm2837-rpi-3-b            | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23d80df683152f8c94cf0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fd23d80df683152=
f8c94cf3
        new failure (last pass: v4.19.162-25-g9ce3572039658)
        1 lines

    2020-12-10 15:22:04.792000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-12-10 15:22:04.792000+00:00  (user:khilman) is already connected
    2020-12-10 15:22:20.147000+00:00  =00
    2020-12-10 15:22:20.148000+00:00  =

    2020-12-10 15:22:20.148000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-12-10 15:22:20.148000+00:00  =

    2020-12-10 15:22:20.148000+00:00  DRAM:  948 MiB
    2020-12-10 15:22:20.162000+00:00  RPI 3 Model B (0xa02082)
    2020-12-10 15:22:20.250000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-12-10 15:22:20.282000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (363 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23d86022f49e978c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23d86022f49e978c94=
cc9
        new failure (last pass: v4.19.162-25-g9ce3572039658) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2404a14d58f156fc94cb9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd2404a14d58f1=
56fc94cbe
        failing since 29 days (last pass: v4.19.155-42-g97cf958a4cd1, first=
 fail: v4.19.157)
        2 lines =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23d569f02e88140c94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23d569f02e88140c94=
cbd
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23d4d6b3675c8bdc94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23d4d6b3675c8bdc94=
ceb
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23d496b3675c8bdc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23d496b3675c8bdc94=
cc6
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd23cf90c9858694cc94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
62-40-ga556f48a1f86/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd23cf90c9858694cc94=
ce2
        failing since 22 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
