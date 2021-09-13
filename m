Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD304088D1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 12:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbhIMKOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 06:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238241AbhIMKOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 06:14:48 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FB6C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 03:13:32 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k24so8980926pgh.8
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 03:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ONggBwweYaiR1X7Mvrh0+peUm4HdwMOpW2CIeZKamQ4=;
        b=cqe/IIY6aCclXgPiihC60mfM0JqExpcUAf4bA7zd9ffCPosbC7V2jctwqV0jGrA6vo
         Ip7P06pha129pZOrNYkFgGDVMqBAS2aZdotAXkE4lf6D2QE8W+9jsbSEbV52/REGuoIH
         V8ZwlVh22WFYt8HC8sums+YKiZQkX9uEGSxkf+ED/zqG6Py++igkX+b8d54e0zVE+eqA
         +9Eb2JHhXYYfIbVc+Z9kX7EIGBzDS6OWmXXP+bpPWWUShbM2n6eN83OJg0bNY996t4po
         IFLseRC/suXmypmHbzE2LBKCixffqHGe3MOs61J1qz6S131PkPrwpwJW0Lommi9CW2Ic
         /CzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ONggBwweYaiR1X7Mvrh0+peUm4HdwMOpW2CIeZKamQ4=;
        b=t7OO/OtQz8tziQqpVX7EiFUs3tk1XuxkrBlji8BXNEAwOZqA10xizmjS0gFTCm7Tjp
         viJqkpjZ9EiPSSrRzH3I9ilOycqwiTZ+oHifTtKgESgcNJB0V76/qpijJbQ0+o1xXb+c
         1dXXxAB7fZyXGBTDp+mc3s/rx3yzFvpXQNvqT1SCc8e7APQTAqJpvKj2WNEPeuRRvvTL
         sq42SeKnhPhXWPBvnNj19ZEwisjIpZzUnGh5+8u3HA24UcuxmEpPMBIOth6Qc7aiOHKP
         mW87FlKeNk7sFwBYi3B9c5A3SHvqvnp07g49isyF7qc72Hh+EaESwOu5coI8XtyTPE57
         /9Ng==
X-Gm-Message-State: AOAM530eIbJ9N1Spm6PO0afG/Sez3YfGpqG/JaIzoU/HnOAgQBEJpxwf
        KNg6RxFChZbqkm6HrjyJsNwnUQwOkp3Jep8f
X-Google-Smtp-Source: ABdhPJwOmCALfuPiu2nFuk6Dd++zy8YhrHqPQnLd2KH0EgOXcy13V1asgQtT5xKAc4ZHQjE/n0Ts6A==
X-Received: by 2002:a63:5413:: with SMTP id i19mr10496311pgb.297.1631528012078;
        Mon, 13 Sep 2021 03:13:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h16sm607830pjt.30.2021.09.13.03.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 03:13:31 -0700 (PDT)
Message-ID: <613f244b.1c69fb81.7cc07.1189@mx.google.com>
Date:   Mon, 13 Sep 2021 03:13:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-106-gd5a3197936bf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 6 regressions (v4.19.206-106-gd5a3197936bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 6 regressions (v4.19.206-106-gd5a3=
197936bf)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-106-gd5a3197936bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-106-gd5a3197936bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5a3197936bf72d8bc5fb7c9383cbdbdcdda2531 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613ef049ffffc368f8d5966d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ef049ffffc368f8d59=
66e
        failing since 303 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613ef04ee6ee123c73d59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613ef04ee6ee123c73d59=
675
        failing since 303 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f1c6d6aeba13e1d99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f1c6d6aeba13e1d99a=
2db
        failing since 303 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/613f1ec19387c2e04d99a2da

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-106-gd5a3197936bf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f1ec19387c2e04d99a2ee
        failing since 90 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-13T10:10:33.541023  /lava-4507805/1/../bin/lava-test-case<8>[  =
 17.569297] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-13T10:10:33.541527  =

    2021-09-13T10:10:33.541878  /lava-4507805/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f1ec19387c2e04d99a307
        failing since 90 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-13T10:10:31.083496  /lava-4507805/1/../bin/lava-test-case
    2021-09-13T10:10:31.083967  <8>[   15.128224] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f1ec19387c2e04d99a308
        failing since 90 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-09-13T10:10:30.062535  /lava-4507805/1/../bin/lava-test-case
    2021-09-13T10:10:30.067507  <8>[   14.108903] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
