Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6383AA18C
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 18:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFPQmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 12:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhFPQmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 12:42:15 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF239C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 09:40:08 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g24so2047616pji.4
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 09:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BtNQ3R20KZ6E/WCE79Q2wEeCH4uhEcDnhz5YmwPIt+k=;
        b=WCQkwmtzyijARuN/J0ODHQ/7QybIBZuYAxht0jrEsoMFKG5C/2CTzEz1ewNabTqIRi
         Rl2zenvt/s/A5MfIGLlfG+hylOV+Eu2sYpv77fbT+UA0xW/zBlsvsn8/kU0m9VLBbmhL
         JrWhYA0SEaqVwd6FDd/CKzNqR5grgKzNfq4fF2bLmgTuhd4wPye4DlK5Cwz+eGQYXDmt
         kOaV0jSw+blaTZXA3fd48TeoSM+0RJ/tcdOr6Jn2NpbZGQIT58WGEUJfAVpdY3bf/lnr
         mv9w7x1Ph/RNxprJmSpQsoFINVtt3cg7hJQvcX0eBQCAuUqgFIXW+QYBk+qgGrZesDEv
         0exA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BtNQ3R20KZ6E/WCE79Q2wEeCH4uhEcDnhz5YmwPIt+k=;
        b=nB9WcnywjQzQ5UDFJT/ZDGz6GHn6fwAlCpZ5A/PEpixNRXK/UbRrir77wWixFIlTME
         BNoXvqv9nnzITyurf592KGScBYkwKFhBbqgZkXl5/U/C8oDkSdwrRwBrkK9bLkPToLvd
         mB2IEU1wifaM2+Qn4RJRbLb05mr+TUrSAblMRg7YvK56Dytgo7QoChcXWAxjTIfJVn7V
         7Dy8ZjCjxdyc/jxHco8Gp3q+JxnDsIjlCxX8+E/Y96JuzH5s5tyuNsKCByq109/rufLa
         uzEeL8JNsx2nhx7s8ppuWLCqOjTO53zAdKVOE5+9+UXWJTSbQVUBr6yvFnYzCMMaisFg
         82oA==
X-Gm-Message-State: AOAM531uTsouwais3JUFalFOhEgYZktAlW451aiLW+5LmlKwSoEBPoV5
        b3BwvWvWF731TCvxCvIb/IbM2LhaseImjG3T
X-Google-Smtp-Source: ABdhPJwqNw/bmLg89u7WbrTSWJJAMM0C40KpFO8tAqslakTNjdzE5ijcRqAgtBCJDIH9aEPGNRJD2w==
X-Received: by 2002:a17:90a:6984:: with SMTP id s4mr653674pjj.27.1623861608022;
        Wed, 16 Jun 2021 09:40:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oc10sm2521246pjb.44.2021.06.16.09.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 09:40:07 -0700 (PDT)
Message-ID: <60ca2967.1c69fb81.2fbed.6aac@mx.google.com>
Date:   Wed, 16 Jun 2021 09:40:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.194-67-g98b7a3170403
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 7 regressions (v4.19.194-67-g98b7a3170403)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 7 regressions (v4.19.194-67-g98b7a=
3170403)

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
nel/v4.19.194-67-g98b7a3170403/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.194-67-g98b7a3170403
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98b7a31704035cc42e733defe8af9946377fc067 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9f0bb89bfb2768041329d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9f0bb89bfb27680413=
29e
        failing since 214 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9f2b4f25f96498a4132da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9f2b4f25f96498a413=
2db
        failing since 214 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9fa6d27513b3468413284

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9fa6d27513b3468413=
285
        failing since 214 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca178ae4a3dd7835413281

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca178ae4a3dd7835413=
282
        failing since 214 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ca22ba7670cfc90f41328d

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-67-g98b7a3170403/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca22ba7670cfc90f4132a9
        failing since 1 day (last pass: v4.19.194-28-g6098ecdead2c, first f=
ail: v4.19.194-67-g1b5dea188d94)

    2021-06-16T16:11:30.815683  /lava-4036490/1/../bin/lava-test-case
    2021-06-16T16:11:30.826787  <8>[   16.162555] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca22ba7670cfc90f4132aa
        failing since 1 day (last pass: v4.19.194-28-g6098ecdead2c, first f=
ail: v4.19.194-67-g1b5dea188d94)

    2021-06-16T16:11:31.843735  /lava-4036490/1/../bin/lava-test-case
    2021-06-16T16:11:31.848870  <8>[   17.181949] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca22ba7670cfc90f4132c3
        failing since 1 day (last pass: v4.19.194-28-g6098ecdead2c, first f=
ail: v4.19.194-67-g1b5dea188d94)

    2021-06-16T16:11:34.285960  /lava-4036490/1/../bin/lava-test-case<8>[  =
 19.622197] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-16T16:11:34.286503     =

 =20
