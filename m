Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A27405CAA
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 20:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbhIISLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 14:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243623AbhIISLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 14:11:41 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37559C061575
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 11:10:30 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q3so1608536plx.4
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 11:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xs7td6MjvShGLQzBArIHApl7bmAVLowzhyHjFvc8Pxw=;
        b=a1LsHiDwj5n5Ds1AsdhlFq2UShvgFFf33H9xv8Greus62hAgW3cZDpsHRWvc9o9Jin
         PBCyxOMIZnN2KGpSbA+hq+JdNQsQPDjB41vXPU12idHNWpbHEVNuimIg3diVyEIEd1qH
         xHpzPkli3i3kS8r/uT448eVV1mwGkp02fEwdlI9OD8TP7d1tUIp5IjZx2LFKCkRAmffl
         MOUKz5FEWUNLBuxcqR/tVdGmLlVsMpF8P45CbmTB0ccI2m+8ehK8T2YFg+7NzBY09oJN
         Ls2afUqO/854G1tvuI1i2K1m6bfYfJ9E3cfQGs5sAupMkswMWT8WDaDctGeS5w3sMnZK
         2/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xs7td6MjvShGLQzBArIHApl7bmAVLowzhyHjFvc8Pxw=;
        b=ex7DOHBG6U3LjrXiAYenOv5bteJIaLXXn39ebjtLKfH1GHo+qnk3nNYHTWyjOJTowu
         sFR7QB8X8VargWlyH2M37sUfbrX9tM9z3e2zGJdZ3gokIyfYXjRzeBl640oYVLqp6Brg
         5e5lAa/YmGQ1OBOYtArj+bKIo0D770x6OILsEnAyzx/5ZXl5UuV4kSAN7D3ndYeTtIYk
         5Ev8BxsuLQwfOqckANXqOanX7G62x9fSY2TomiG/OpgrgRGgutO/dGzcsftIiQR+3aCO
         +n0tcS4H8H+fa4PgOVCNqLXk0A65+vW0WeIpzBGCvSW+qPn1Slq32/ft98yiQche1Ikm
         xr/A==
X-Gm-Message-State: AOAM533w+YKU/IInCstNiDxUHmI/NaCZowdjLB9V0uNJo6ioJSZGgTOU
        BQrZt40pczWj7pRM4fwnBNfgQ1my01eHIdBN
X-Google-Smtp-Source: ABdhPJyxXVG761f+sn4K4pcbyI+YOxeU1cdfxuy2J8zigo82nWQ+XX/7RaVjQMLF8oLr5pkbBTjHsg==
X-Received: by 2002:a17:90a:e60c:: with SMTP id j12mr5035184pjy.60.1631211029394;
        Thu, 09 Sep 2021 11:10:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mi18sm3123537pjb.15.2021.09.09.11.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 11:10:29 -0700 (PDT)
Message-ID: <613a4e15.1c69fb81.dae1.800d@mx.google.com>
Date:   Thu, 09 Sep 2021 11:10:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-4-g1551ad39a829
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 214 runs,
 4 regressions (v5.14.2-4-g1551ad39a829)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 214 runs, 4 regressions (v5.14.2-4-g1551ad39=
a829)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-4-g1551ad39a829/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-4-g1551ad39a829
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1551ad39a8298aa3618bb3567105715d5d2bdaa8 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/613a1c0acc4b9b7a29d5966d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1c0acc4b9b7a29d59=
66e
        new failure (last pass: v5.14.2-4-gdaa4b4126de9) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/613a1d4d221ecc5dc8d59702

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1d4d221ecc5dc8d59=
703
        failing since 0 day (last pass: v5.14.2-3-gbf9435541571, first fail=
: v5.14.2-3-g5e3461135fe5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613a1e0cec97349469d596e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1e0cec97349469d59=
6e5
        new failure (last pass: v5.14.2-4-gdaa4b4126de9) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613a1cee646e672ed2d5967a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-g1551ad39a829/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1cee646e672ed2d59=
67b
        failing since 1 day (last pass: v5.14.1-14-gc097b4308d82, first fai=
l: v5.14.1-17-g77d60f40b9ee) =

 =20
