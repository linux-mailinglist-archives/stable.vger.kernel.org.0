Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B813B041A
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 14:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhFVMUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 08:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhFVMUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 08:20:39 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DABC061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 05:18:22 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m2so16909854pgk.7
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 05:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CvNiqEsywsqtZhiKgLC0wpgV8Q/veuZVJd1BVCo2Sck=;
        b=l+3A9TR8MbCOygbToSGtT3d73ShXrvoE4zlyJwz+VBzmnfVqb2d72x6Zqknb9JuOUr
         Eg06wXlijkFto5+lDHrAQH4d49rPN0LTy0ID52w/qqMk3Yo2nJ4qXAEfaUyADUNfyeFi
         xcfZLoYgpAOPTsf3RJ1EP8jMvwH0R/x1ODIqeIkW05z6512aOhAK0SgKNVHgIInm3t1i
         F0FYhUVhjifo02UmqX8kQJC+Hq1SdsUqQ47BN7oFulwvkyuFxzBnk86jD+0xikZejoT8
         N81sXmeB/iUWArDJWJj8AM1YvQh5Ev1k6h9x7xv7tgOXWTJaqFH5cjVVbUKuo73jrO8C
         y4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CvNiqEsywsqtZhiKgLC0wpgV8Q/veuZVJd1BVCo2Sck=;
        b=kGhj9LjlsqD1NQlir05tqFXO1okTTAVGCuUDunQGguzaAvny/Ffnm5JzLA0/8FobWV
         byH6f1tB5tKkzZx8WqdhpXRXbKPtzPBVnaWpwYAhQgqqIOi5mBBDJ7tO5PTGuA0wfCJ6
         7PJhlnpNger1Hm/PBg2Br7Bgd92ZM1sSjyGsKgfhBO3Mtco1+jKKa/ogZGEcl2ErXeIw
         5SU+PNl8mqP5bxlr5XQQJWxE7XOg/FiLLo8Ls/2KZubVVbLbpzKAdh5EcckOUv9ZByhr
         4j5bZ+S1SEYgmTVkvg5BJeC2Jven2y/wbh/FctlUda4Ff3PcjS3BOcVAyf5UcgCFzq08
         Snmg==
X-Gm-Message-State: AOAM53362Ue9opELvwOKDOwIQ99fhXv/o2539Lc6IQ04cfqTKcrUpQ0Z
        K7h7zhuLQl3TasSsr0H6++Q0wCTdLDlYDg==
X-Google-Smtp-Source: ABdhPJzpURgApeWQX7FdMs8GPPOOhgqexV7GTjr/wvXd9XnzHeYSWBPL5ovO98+GsUlNebZEwGALNw==
X-Received: by 2002:aa7:96bb:0:b029:2fa:f102:468c with SMTP id g27-20020aa796bb0000b02902faf102468cmr3315560pfk.25.1624364301637;
        Tue, 22 Jun 2021 05:18:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3sm2519774pjz.49.2021.06.22.05.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 05:18:21 -0700 (PDT)
Message-ID: <60d1d50d.1c69fb81.4b962.668b@mx.google.com>
Date:   Tue, 22 Jun 2021 05:18:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-81-g2b8c719fdf7f
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 158 runs,
 8 regressions (v4.19.195-81-g2b8c719fdf7f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 158 runs, 8 regressions (v4.19.195-81-g2b8c7=
19fdf7f)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.195-81-g2b8c719fdf7f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-81-g2b8c719fdf7f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b8c719fdf7ff5689c99f1746c3a5ba51a0da8c4 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d1a0a21c8af3539b413293

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d1a0a21c8af3539b413=
294
        failing since 220 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d1a2bf07b5858e64413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d1a2bf07b5858e64413=
26a
        failing since 220 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d1a191f6dcfb37e0413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d1a191f6dcfb37e0413=
268
        failing since 220 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d1a3e2c39260e689413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d1a3e2c39260e689413=
286
        failing since 220 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d19f6a14a77d962e413275

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d19f6a14a77d962e413=
276
        failing since 220 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60d1b6f777331dd046413279

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-81-g2b8c719fdf7f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d1b6f777331dd046413295
        failing since 7 days (last pass: v4.19.194-28-g6098ecdead2c, first =
fail: v4.19.194-67-g1b5dea188d94)

    2021-06-22T10:09:52.353051  /lava-4071484/1/../bin/lava-test-case
    2021-06-22T10:09:52.358330  <8>[   15.174449] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d1b6f777331dd046413296
        failing since 7 days (last pass: v4.19.194-28-g6098ecdead2c, first =
fail: v4.19.194-67-g1b5dea188d94)

    2021-06-22T10:09:53.372752  /lava-4071484/1/../bin/lava-test-case
    2021-06-22T10:09:53.389421  <8>[   16.193806] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d1b6f877331dd0464132af
        failing since 7 days (last pass: v4.19.194-28-g6098ecdead2c, first =
fail: v4.19.194-67-g1b5dea188d94)

    2021-06-22T10:09:55.814838  /lava-4071484/1/../bin/lava-test-case
    2021-06-22T10:09:55.831494  <8>[   18.636015] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
