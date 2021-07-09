Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366153C1D03
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 03:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhGIBdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 21:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGIBdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 21:33:13 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C52C061574
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 18:30:30 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h4so8307695pgp.5
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 18:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R84CCvFXd5NXBcS7bik2P0Nlez7H8bqvUDteCpVCHNA=;
        b=MW+beQ7keM1V5A/gJnVcg1T7Sqx7xNaTy/XqqYc99u2cydS7E2jQaZM3f1QdKuRIHu
         f8aR5SCEzr3u9v2CrT/LnEW9efkiFtOqSOfMtbA607IHv4x1Kyest/6wIgm7a9IlZ1Hf
         I+klrY//ulD1gCtVX9ZHsZ+i/ZrSMZXB9TKRpabrTTsG5erxAzOmGaVbvD5Br2njhfp1
         xsmH9u6IQsuLH5AkqtjZfZiAn1a7+eYscZBaxDRdpSX2aCRR5NqYl52S1s8auaW0E0RG
         GNBeOnD0eRZUJ6XoFbQsJ4h5XnAGhMyLEivN6EuE6TbeP6nCJCtyumfvmJD+3ZcmgtWl
         WvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R84CCvFXd5NXBcS7bik2P0Nlez7H8bqvUDteCpVCHNA=;
        b=evrS1aiiSFFkXCyeiQQ83MsTAZ4A/QNo5v97NYRj7P6hRcvyuPVWFBLXFOt2KdvCa2
         Nvp1qUv/56/cK8tGlsdYICZW6q5QGpe1h76Kg/cQgCCUb44ApABQnnkh+8gsyTnQom1e
         E1HMwbuj+GpfbG5yrE/sAnLdgILUaL7/q19pb6JGfIn3smDx0y314as7TOf6LxqvcP7K
         AqyKq8lsGc8RuKWY7QTHA7/5b1tezbtYJX/sJ3+BAFu/ZnTcqH/9EDKZqnPLOHEAf6Rw
         KzZXqYwfEIej/KXeZb/PQj0gbQ3hkLjFOqJBpnzmwv0idSjZDmIPdMQsPdHwVqhLbvWN
         4gLA==
X-Gm-Message-State: AOAM531e7cnqRcSZGOtT1B+L0ULCN6z54c/CXnc3cBnJbtPXZlQKCN9x
        M6DJeS+ADz9EPYu/MEubh7YMN8wqm8wkPPan
X-Google-Smtp-Source: ABdhPJzbA8ewE2YCWzyLjuS4b4kiVJosYkySjXDflcvOgi2uBhCB0NXW1NO7mpyqGidxNhXzL+BnPA==
X-Received: by 2002:a63:5b51:: with SMTP id l17mr34762491pgm.408.1625794229481;
        Thu, 08 Jul 2021 18:30:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a65sm4371306pfa.11.2021.07.08.18.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 18:30:29 -0700 (PDT)
Message-ID: <60e7a6b5.1c69fb81.5bc82.df30@mx.google.com>
Date:   Thu, 08 Jul 2021 18:30:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.196-30-g4fb4dad00eae
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 170 runs,
 7 regressions (v4.19.196-30-g4fb4dad00eae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 170 runs, 7 regressions (v4.19.196-30-g4fb4d=
ad00eae)

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
nel/v4.19.196-30-g4fb4dad00eae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.196-30-g4fb4dad00eae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4fb4dad00eae34931106fc50d8ecdf633a74302c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e76caf76c9bf2b81117993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e76caf76c9bf2b81117=
994
        failing since 237 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e76cb94e3a06029411798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e76cb94e3a060294117=
990
        failing since 237 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e76cbd76c9bf2b8111799b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e76cbd76c9bf2b81117=
99c
        failing since 237 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e76c5ff9a3cef2fa11799d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e76c5ff9a3cef2fa117=
99e
        failing since 237 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60e78e3cb97790c1d811796d

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.196=
-30-g4fb4dad00eae/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e78e3cb97790c1d8117981
        failing since 23 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-08T23:45:53.574536  /lava-4160873/1/../bin/lava-test-case
    2021-07-08T23:45:53.590852  <8>[   17.666577] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-08T23:45:53.591300  /lava-4160873/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e78e3cb97790c1d811799a
        failing since 23 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-08T23:45:51.131296  /lava-4160873/1/../bin/lava-test-case
    2021-07-08T23:45:51.148296  <8>[   15.224070] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e78e3cb97790c1d81179b1
        failing since 23 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-07-08T23:45:50.110859  /lava-4160873/1/../bin/lava-test-case
    2021-07-08T23:45:50.116022  <8>[   14.204572] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
