Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1953373E18
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 17:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhEEPGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 11:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhEEPGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 11:06:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E84C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 08:05:25 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k3-20020a17090ad083b0290155b934a295so989590pju.2
        for <stable@vger.kernel.org>; Wed, 05 May 2021 08:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IAlVKsTYZz5OJ3dPa36WpFHF8n3v9V0hUziOIzH1yPY=;
        b=buFwC5GlSKSeutxDPUPYc6OJjIqoMgRA0cA71EKkYxG0zIyzehQ0tZ8Lzj9gATKy3G
         kzFITx5p84kdO6DKySHUDXLZKTOLIGM21btUrLCEBD6+k/5pH/pQYSWcqc4evRqMxNfy
         324w7FqcI0NM8AEgFI3VMpJRfGBZEuu+73QpV6Na/J4sHsc0FVS5egBKuAfNMng670mU
         qmX2cNDO4rBqOtixKqyLLX4pI/wWCC2SwGpDfKm9NIqFI00Kxq2c2ecYY2dtJkjXQ0W/
         YxPekX3dCPR9g0EVyJtUqHya+euoWA+rjbb/WbOm79geQrmydel+OvYUbQ2JGyHbnBUi
         eg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IAlVKsTYZz5OJ3dPa36WpFHF8n3v9V0hUziOIzH1yPY=;
        b=XSVJ5zN0vlPbvV+Bibm2lgOrJB2CxdH1PozKFMlPDSSU+UmeZH23xgdPqPQpAlQcqH
         0xAbx+jDs9aAAoHAwxbeGLUT2C2s2qNbva90aVjQSDgGuttTxL5VIzpI9s9rJEho0EMP
         9cvUZ8Rf0LUPfzQH/t9Lx7Pvl/P4M+wrIDxdSm/ZscvPOwwVtiuEbD8z00wfYUtw7NAN
         jwI4NLUTxBVMMlNTkG76+ASO2AKP2YAJv3q2rF5JuTThDJ5UpvMilWlHaNG7roW54K3m
         te0oiD8JG8FzFgY9oSJFS8mvig3T2IFbalPDI4Fpx0NltZsKMnVLWhDbNCHnDM6jlSDN
         4wKA==
X-Gm-Message-State: AOAM530VxG+Sj1s8f2SuSivJooRqNxO5f4i+95MGQcE67zPOkMLCJDVd
        /itEhB5BjHUGoth22TCpSBOuqVZgGELuYEAK
X-Google-Smtp-Source: ABdhPJz8/peJN9jdwcX7GrDMVh2Ovd4WzILpKJCF7HcIesyYcMQ7mpbT9wwVkeqfCLK5gmWMHyHgjw==
X-Received: by 2002:a17:902:c106:b029:ee:a12b:c097 with SMTP id 6-20020a170902c106b02900eea12bc097mr28679033pli.27.1620227124429;
        Wed, 05 May 2021 08:05:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm7900598pgs.62.2021.05.05.08.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 08:05:24 -0700 (PDT)
Message-ID: <6092b434.1c69fb81.65b35.0152@mx.google.com>
Date:   Wed, 05 May 2021 08:05:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-16-g5beeece77f26b
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 65 runs,
 5 regressions (v4.14.232-16-g5beeece77f26b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 65 runs, 5 regressions (v4.14.232-16-g5beeec=
e77f26b)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beaglebone-black     | arm   | lab-cip      | gcc-8    | omap2plus_defconfi=
g | 1          =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-16-g5beeece77f26b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-16-g5beeece77f26b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5beeece77f26bf29b2211bfaf71db9ccf4af52e9 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beaglebone-black     | arm   | lab-cip      | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609286273ae20445366f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebon=
e-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebon=
e-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609286273ae20445366f5=
469
        new failure (last pass: v4.14.232-12-g29a7f2233e906) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6092844313487cc7526f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092844313487cc7526f5=
46b
        failing since 65 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092814f2e753aad556f546b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092814f2e753aad556f5=
46c
        failing since 172 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092813fa3c656aa7f6f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092813fa3c656aa7f6f5=
469
        failing since 172 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6092812814a4adec976f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g5beeece77f26b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092812814a4adec976f5=
46b
        failing since 172 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
