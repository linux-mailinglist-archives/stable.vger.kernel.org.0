Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D593F8E72
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 21:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243300AbhHZTHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 15:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhHZTHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 15:07:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BBDC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:07:03 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id e16so3140043pfc.6
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CBE9hd2fhMKCObyWCuiU4LY+vY4ttIeaqhVVRYDpXfA=;
        b=f80flpfq4LgzaCazwxeO8RaqwJ5BJ6+njeTg4Ut4DK81pFpQ7pROKejIzJRyio+I1h
         H97nB1U0KLsUQeCZUXPP3V6MQCQGZXeeCBztCCfgckOMCmILBBXQPcp652637vk90yGi
         /QG+QKpXazkR+DKJJLwc0dz/ZRW/rr7oMnEvXpcvRfB8j0P+MKLRuIjRGtk0BY3JuwvK
         CRNHbrSQmIexXRyjRfzJnuHV3hiJOpb19PDtE2rZTJhU+N5mVex0H3TnkW0oAm3C2JYW
         jrhhl7lZJVOIlo0twlKfDkPmeU8Eh5YiDvYeEeDsWIRt2bstXt4HAthqzrgPndfU2xXi
         /LGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CBE9hd2fhMKCObyWCuiU4LY+vY4ttIeaqhVVRYDpXfA=;
        b=o7FWEmcYxLpbzS1nuUfG/EiCXgOKWqyZ9xL2EnjOCWsOefUfTAniXsHIlVWKGOMICT
         cXXem6AeRKy9zC5vGd1LEiGHpwJDauGcFI7rr6Oynmdo8xH2Sgp13s5i7JwWmmwQ3X1L
         sagptCyyoSut6A5urlTKwpph2F8fHeJoJfGC8GMC+t2mFa7ZakAirVVcgJz0L2bGFsG5
         HriJnYgZQd/BCDljifZmCslE9rHer/5SkgkRxATcAojpnzx88c4en3AB7dTjEHiAJwxc
         p6MpIDReCm4pghxMpzWLQqWH+E00Hq1QiAdcMbmlBG9kVD0bYLztbc+BLSm/STQ5wZSN
         +iGA==
X-Gm-Message-State: AOAM531GQZWTeqTBkEOlEQRq8bqXW4F5Dvir8DtZANuwjBz6WAjj1tHZ
        GtbSZVcnR61DZuJpShINlwQ6CShVLEQRgJic
X-Google-Smtp-Source: ABdhPJwD5bsqpBPqqF0UuOThmHI9XjoG0p6x5e6jQXJZrAZhC26HVhGsGIyYv9knOlQRZo1TXNUj5w==
X-Received: by 2002:a63:1a64:: with SMTP id a36mr4589720pgm.225.1630004822422;
        Thu, 26 Aug 2021 12:07:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id br3sm8060230pjb.52.2021.08.26.12.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:07:02 -0700 (PDT)
Message-ID: <6127e656.1c69fb81.34608.4c68@mx.google.com>
Date:   Thu, 26 Aug 2021 12:07:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.204-83-g8c193742738f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 163 runs,
 7 regressions (v4.19.204-83-g8c193742738f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 163 runs, 7 regressions (v4.19.204-83-g8c193=
742738f)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.204-83-g8c193742738f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.204-83-g8c193742738f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c193742738f791f15d201714582ed740d23d79e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127b0e3db81d5e1768e2c87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b0e3db81d5e1768e2=
c88
        failing since 285 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127bc60a6bcc56cde8e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127bc60a6bcc56cde8e2=
c7e
        failing since 285 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127b5a1df2a57397c8e2c92

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b5a1df2a57397c8e2=
c93
        failing since 285 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6127b09363158cf6308e2c7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b09363158cf6308e2=
c7c
        failing since 285 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6127bc612924690c6e8e2c83

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-g8c193742738f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6127bc612924690c6e8e2c97
        failing since 72 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-26T16:07:40.318021  /lava-4418608/1/../bin/lava-test-case
    2021-08-26T16:07:40.335188  <8>[   17.723087] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-26T16:07:40.335677  /lava-4418608/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6127bc612924690c6e8e2cb0
        failing since 72 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-26T16:07:37.893870  /lava-4418608/1/../bin/lava-test-case<8>[  =
 15.281138] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-26T16:07:37.897933  =

    2021-08-26T16:07:37.898449  /lava-4418608/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6127bc612924690c6e8e2cb1
        failing since 72 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-26T16:07:36.857237  /lava-4418608/1/../bin/lava-test-case
    2021-08-26T16:07:36.862676  <8>[   14.261734] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
