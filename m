Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C68D36396C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 04:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhDSCjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 22:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbhDSCjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 22:39:09 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957DFC06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 19:38:40 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u11so13388113pjr.0
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 19:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=brTCYXUYuoQ9a56wqAuWRfOtuboDS3m5liQ2MURuhQI=;
        b=bMEQEaXNNz0jog4qG2UNMHnwibjlYRG+dDh3/qh333VOwRjqCywN7/hyxVv+DQ5rUu
         /3xMY2pIVP5QQd188/k7BmzcC97/9FEIUCrwRujsuyjMoXrlw9UF7YBq2nOobl8NfKNV
         OzyrtS8ThPoq1T1Z2TPdOXY3SqOmPex8/hCdX8liJqBFHsO9fBeIu5JeuSBHOHOiveY+
         66zf5/O9FpULsH4WpfEOo+Yjd3G+mjvxSCepPAIsFJSRk7xm/PqTbdQ+Fc5GHKUqKoqw
         1heuWyGTgSHZHItrUxH2xPt5/dUNUlN/xQXTtDYY3BfWI4M6BqaqedbzECItZ2xE38lR
         6y0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=brTCYXUYuoQ9a56wqAuWRfOtuboDS3m5liQ2MURuhQI=;
        b=FbIcZ+JrpRMe2s/97X0FLPVOSe/x+QhYHjXgVoJVavFTCoJa/Na54o/DpGU4L/oPEi
         WE0c3ualgiku6Pj9i2AznjyFB3cUT3hCOiOAZTW2m2MIg+GVgTVyd6KeYK4WNFtp22wp
         8OV2G3BzkhMCxhBvADdZMwFJXO8NRG4I2yIGQC3282yFZp86szetX4QGZVFpoG5zm12q
         PHq1p1YfH2CNT/XU0jmQM2lb90YTYq+ZVe1EELSiShGmb9XcMaqf7RCTanrgtoKqhvdi
         ud2eib6RFfHRBOMyoqwLic3H5z+mf2Gsy6hlTZ9yuki/wz3uCev/m/Iut60UeBDS3VXC
         qO4A==
X-Gm-Message-State: AOAM532BoEYHmlL7cpM8tp0MzojhLLFxur/Wgk1SMXubX6kjDaaB9ShP
        UruSyYhVoqpiQvNdqtYoxOTGo+c56Y6sPWgy
X-Google-Smtp-Source: ABdhPJyMKJkgEFySlktgSIeHlYmMHgsSeJ3LywesE/mGhK6BplAhinKgrAhsj3QJprhkkPExZFAUqw==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr22425780pjk.92.1618799919939;
        Sun, 18 Apr 2021 19:38:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m20sm9650113pfk.133.2021.04.18.19.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 19:38:39 -0700 (PDT)
Message-ID: <607ced2f.1c69fb81.2259.8d14@mx.google.com>
Date:   Sun, 18 Apr 2021 19:38:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.267-24-gfa327072beb33
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 115 runs,
 6 regressions (v4.9.267-24-gfa327072beb33)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 115 runs, 6 regressions (v4.9.267-24-gfa327=
072beb33)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.267-24-gfa327072beb33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.267-24-gfa327072beb33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa327072beb33d10504b717cfe547bcad787b5ae =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607cb76b0fa078dc64dac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607cb76b0fa078dc64dac=
6c3
        failing since 155 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607cb75cc372192007dac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607cb75cc372192007dac=
6c4
        failing since 155 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607cb765c372192007dac6d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607cb765c372192007dac=
6d6
        failing since 155 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607cb700eab1fc2b1ddac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607cb700eab1fc2b1ddac=
6cf
        failing since 155 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/607ce77c1b393f98b2dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607ce77c1b393f98b2dac=
6bd
        failing since 155 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/607cbccaa93e700e42dac6c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.267=
-24-gfa327072beb33/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607cbccaa93e700e42dac=
6c5
        failing since 151 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
