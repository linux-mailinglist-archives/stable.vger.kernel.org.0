Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E6E3F0EA2
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 01:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhHRXc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 19:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbhHRXc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 19:32:27 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3906C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 16:31:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso10081302pjb.2
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 16:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hJbhiFbph43loijj2kyB+9Z8S2B/KBfP662PXVZ0iHI=;
        b=bFa4GlHO5Aftbg+D2jvrWNRS88l2XSG2m5EA7wsxRKQQzbiGUDIOAaKUhoUFrq3wrN
         EqkNihBCSDc9uUYtJXf3XmpAy4NtBOnVwg0jlfIAIX8i3WVQztZGc89f090lMmdjubP+
         n5O5Q48mxO5wsGCCRjYSDSBfHLQbZs/WugC06wXY33Ncl94gsVwGpoUr7dKALMSmGDwf
         yyX3aLOpZeGII1lACs+/Ac/h/pGfXxJk3jeKL8Je5m+iZZu6ZcuAhGrYmt4bB+J5Bp1t
         py7nHeLZIqFNcLyu/EYF4RbUVfceheEj7H3DDu3oKOig4xcADte41rJohaGtM8MyN3IK
         ja4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hJbhiFbph43loijj2kyB+9Z8S2B/KBfP662PXVZ0iHI=;
        b=gV3lyHPocZ8VZ/7Md+ZBdwvOrkw4KP7AQSSUsHfVzLRgU/cU7Xn7yx/+GTTQeLuPKm
         raJY6Cg85eIRLzVDX4f9MtzpJsrIl797ufFhbYXVONMTf0PIVHD0J6bPzJ/5ljRqidMM
         BqBb4SQAI2oI+j8RXpRAeRdimzqf+SDzTKx5VCMHY/JbJBSvvy0h3CPPWBMgMFOjLU3H
         8IOyvru6Pyw/vhXKryai4lre144bNcV3VXJ2/MgKDA07f5Pd1AUzRqHyvToYNE/x5Owm
         P/FCOmEmOXPlwpqe3zDi3zP6qVuUw9ysLH6Gn/qQ3927CLcSP1RRcj+Q4NfHrFh26wIA
         PHdA==
X-Gm-Message-State: AOAM5312mqDqcizlXeXniANqCRl51p8LBjBKAIzduXlVPC2kijkSY4MV
        pCdeS4Vk3FPJTgUJJCzsWOZ2Z0Ff0Nm5wczW
X-Google-Smtp-Source: ABdhPJx7PNIztU90ShbrpPwzM/IrGw0rHPHbkx53GENBgdZ83nGgdJvcFF8w3z2ksN5gCGZUCEantg==
X-Received: by 2002:a17:90a:db09:: with SMTP id g9mr11679943pjv.205.1629329511330;
        Wed, 18 Aug 2021 16:31:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r18sm1009769pgk.54.2021.08.18.16.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 16:31:51 -0700 (PDT)
Message-ID: <611d9867.1c69fb81.12fd1.4f56@mx.google.com>
Date:   Wed, 18 Aug 2021 16:31:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.142
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 153 runs, 7 regressions (v5.4.142)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 153 runs, 7 regressions (v5.4.142)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.142/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.142
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c15b830f7c1cafd34035a46485716933f66ab753 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/611d646e9f9c04ee03b136a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d646e9f9c04ee03b13=
6a9
        failing since 6 days (last pass: v5.4.139, first fail: v5.4.140) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/611d7e053a8f59eb92b13674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d7e053a8f59eb92b13=
675
        failing since 272 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/611d649c63bc25def2b13683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d649c63bc25def2b13=
684
        failing since 272 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/611d6f782dab9ccc31b136e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d6f782dab9ccc31b13=
6e7
        failing since 272 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/611d68383d34a6e30db1367e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.142/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611d68383d34a6e30db13696
        failing since 63 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-18T20:06:00.042712  /lava-4379459/1/../bin/lava-test-case<8>[  =
 15.458531] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-18T20:06:00.043091  =

    2021-08-18T20:06:00.043303  /lava-4379459/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611d68383d34a6e30db136ae
        failing since 63 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-18T20:05:58.600485  /lava-4379459/1/../bin/lava-test-case
    2021-08-18T20:05:58.617610  <8>[   14.033740] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-18T20:05:58.617875  /lava-4379459/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611d68383d34a6e30db136af
        failing since 63 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-18T20:05:57.587249  /lava-4379459/1/../bin/lava-test-case<8>[  =
 13.014483] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-18T20:05:57.587717     =

 =20
