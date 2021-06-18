Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80323AD367
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 22:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhFRUKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 16:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRUKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 16:10:33 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7309AC061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 13:08:23 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e33so8712985pgm.3
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 13:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iflyHQQBq2CeiZ7f1/tGb7GirOaLFiUwfXRhTX/b/d8=;
        b=n4DwGTJLU9BVd0OoyA+yym5aDZt8qfFKmLosZZ3pEqDyFYN3CluSoc7ShMDpKT2rdt
         DBZNNsL/MOFEwHb/5hs4ZNBdVG5raJ63RaOwYxD4FeQcgu98wucXVEMojCtMjDzbaWeq
         ecx+o/+iJ1FjTEwt2f65Wj4xKKXoVn4CotWDYVF1fWYXGauVSBUN4v2tNJWbIjMSnAIJ
         6ObOHjHvZLheyIdEaXJ8/zGb+MWbgsyCuvVacH+cKylG81Wz1kR+pR6oTL4wt57d6G8Q
         MO69zK6b4Nl0+ABJaNHkklS9mFadaqRP4cv6wypWsQxyiRVMVcgbzlSU1LhJ5tOB2a4N
         EOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iflyHQQBq2CeiZ7f1/tGb7GirOaLFiUwfXRhTX/b/d8=;
        b=D6uZtgVQmPZjZnbXIIilduhdAwac7BFW+aK0GgJeF0Kp8aMHd5sAGgQa06fRehyzvA
         1BGMXdFyVbI5BcM9rPElMAPwpyBCqwj1EhVIHTFO8mWXvFNgQZxH0RDCuJWqRSlBQ1lC
         SB2zAQs+I6qgTWdHg+5jsR3Z2DtEnVDfPfuHw6QmICyaqa3yKItdMs+WnelvfIMB96Mw
         jPmWJ4qB7/hZHI5X2ybTjeDaFqrCCv2S5kWkf7L4ZMw7s+OHBU5xeHinv2TUrHYzggKY
         Ymnshz8bYJ6iFqwQebE8n1F4HqTByf9c93E551S117+oNdp0q3RtdedfUhVixqIXebJO
         KHGw==
X-Gm-Message-State: AOAM530v1PPES5s3gmmv69xMkzQWi8HWSl+Uf9UK8DsnOnU3WNk3j1EB
        lBCkd4dTY7OnyezKhEVN9x0YLA0Xp3M1Rv86
X-Google-Smtp-Source: ABdhPJy3JNUnL5OcKsVJ0a+DuBD4PM0EUsD7A7Oamd6YYKOBC27nVTTC+l7j60BLnSgsTX97qn7Ipw==
X-Received: by 2002:aa7:9491:0:b029:2ed:2787:be36 with SMTP id z17-20020aa794910000b02902ed2787be36mr6750885pfk.43.1624046902881;
        Fri, 18 Jun 2021 13:08:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y66sm8968769pfb.91.2021.06.18.13.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 13:08:22 -0700 (PDT)
Message-ID: <60ccfd36.1c69fb81.6735a.87ff@mx.google.com>
Date:   Fri, 18 Jun 2021 13:08:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 127 runs, 7 regressions (v4.19.195)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 127 runs, 7 regressions (v4.19.195)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.195/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.195
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb575cd5d7f60241d016fdd13a9e86d962093c9b =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccc78f74caa8b9c241329c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60ccc78f74caa8b9=
c241329f
        new failure (last pass: v4.19.194-68-g3c1f7bd17074)
        2 lines

    2021-06-18T16:19:01.527062  / # =

    2021-06-18T16:19:01.538272  =

    2021-06-18T16:19:01.641140  / # #
    2021-06-18T16:19:01.650164  #
    2021-06-18T16:19:02.908771  / # export SHELL=3D/bin/sh
    2021-06-18T16:19:02.919238  export SHEL[   57.445520] hwmon hwmon1: Und=
ervoltage detected!
    2021-06-18T16:19:02.919444  L=3D/bin/sh
    2021-06-18T16:19:04.540156  / # . /lava-462940/environment
    2021-06-18T16:19:04.550674  . /lava-462940/environment
    2021-06-18T16:19:07.499881  / # /lava-462940/bin/lava-test-runner /lava=
-462940/0 =

    ... (11 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccc3a1ffd2373778413283

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccc3a1ffd2373778413=
284
        failing since 212 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cccbdc092acf55d841327c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cccbdc092acf55d8413=
27d
        failing since 212 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccc39cffd237377841327d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccc39cffd2373778413=
27e
        failing since 212 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ccd7cfe388b219e8413279

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ccd7cfe388b219e8413295
        failing since 3 days (last pass: v4.19.194, first fail: v4.19.194-6=
8-g3c1f7bd17074)

    2021-06-18T17:28:39.606950  /lava-4053078/1/../bin/lava-test-case
    2021-06-18T17:28:39.612348  <8>[   14.709083] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ccd7cfe388b219e8413296
        failing since 3 days (last pass: v4.19.194, first fail: v4.19.194-6=
8-g3c1f7bd17074)

    2021-06-18T17:28:40.643823  /lava-4053078/1/../bin/lava-test-case<8>[  =
 15.728410] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-18T17:28:40.644268  =

    2021-06-18T17:28:40.644551  /lava-4053078/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ccd7cfe388b219e84132af
        failing since 3 days (last pass: v4.19.194, first fail: v4.19.194-6=
8-g3c1f7bd17074)

    2021-06-18T17:28:43.067350  /lava-4053078/1/../bin/lava-test-case
    2021-06-18T17:28:43.084379  <8>[   18.169672] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-18T17:28:43.084640  /lava-4053078/1/../bin/lava-test-case   =

 =20
