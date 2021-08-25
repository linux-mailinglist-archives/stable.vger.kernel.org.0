Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7280F3F6CAB
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 02:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbhHYAic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 20:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAib (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 20:38:31 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51D7C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:37:46 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c4so13288888plh.7
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Pqp4Ph+cTaJzn/zE+aV1/4XvvV6e3+Kl7ut4MKh+jko=;
        b=EzdJhlXbGc+M52Yx75RIHwM6MQFnP4qHmc6sanjfU1AGVoIwNvWygRUIvgJB2YA2+H
         iyteCQYhwSj9y6oR76JSGy6fMnpY+87AKudopZCpjpo0KeEKZxqO7mh3jPMjYvx4zBIb
         EULpkv8VNCin6aAJrYfdpJgUmA+6VOxqkRUbN969h6WA8ogrVwWNOrnDMcKGncvCtWKG
         cgNKSH1irT6q9bN+gR7qeuHRvG9wPIcwOQ45M9w3LReuWtAQZHqSEYTtqgAi0zSAVX5G
         ExDsRlwf8VT+Ga8hUf/Gwh9QWdYp2OMVNPmZhd+GWmwHlOff5ItA6HKIjUABGdlVi2Uh
         BD9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Pqp4Ph+cTaJzn/zE+aV1/4XvvV6e3+Kl7ut4MKh+jko=;
        b=Zj5fB9+Hrg0fql3g1OWF5OS8mxKaQG/RG5noV9aqCN5VaylspaKQAkj1sGlJUER2Z1
         1AFucFpuBAaOPuFRLcfwd2W6POBHSB9O0xGU60fAxs0NtRNQv9no38PKxS7YGnEfYMSr
         zMBjZHjxVdWch6eig9cw7rT468BZLoRsp8kRL7eSo6MnroTLrbnb7gucHtItgez8qr0D
         tZ+P0wt8AiNPYlgDgWuNEZbMyCwiCJ2ztEfnTVPCD4l8frEXBXm8yRatgu5rurep03rZ
         LwV+4b2a73xweiCZKTmJSSCzoapqeM2t4awGPXaTFHZFr36tTc/xzZ7sipCIdv6IS/Gp
         dL8Q==
X-Gm-Message-State: AOAM533DqtP0JjmOfu7FGaUWAWtZERcaurrFjcQRHb6/+/bxxg+g7mwM
        c/S4Y55lda/v5zBzTmw+E42l2qm8xSCptTMm
X-Google-Smtp-Source: ABdhPJwdLNNUGm+Cb4ed0J8ECOu9DqQ6Jd+TJpgesNV3lqc7+vxSqmi4rcBoH+OYSEYB51sWqyzllQ==
X-Received: by 2002:a17:90a:9292:: with SMTP id n18mr7346967pjo.120.1629851866280;
        Tue, 24 Aug 2021 17:37:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id br3sm1973948pjb.52.2021.08.24.17.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:37:46 -0700 (PDT)
Message-ID: <612590da.1c69fb81.34608.5902@mx.google.com>
Date:   Tue, 24 Aug 2021 17:37:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.204-83-gb2aca51627fb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 169 runs,
 7 regressions (v4.19.204-83-gb2aca51627fb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 169 runs, 7 regressions (v4.19.204-83-gb2aca=
51627fb)

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
nel/v4.19.204-83-gb2aca51627fb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.204-83-gb2aca51627fb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2aca51627fb1f162c21e4bf380e2e257c1743d0 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61255b6d228be6686f8e2c97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61255b6d228be6686f8e2=
c98
        failing since 284 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61255b65227aef57528e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61255b65227aef57528e2=
c83
        failing since 284 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61255b64228be6686f8e2c90

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61255b64228be6686f8e2=
c91
        failing since 284 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61255b2c03c595e3ae8e2c88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61255b2c03c595e3ae8e2=
c89
        failing since 284 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61256dccaef649f1eb8e2c77

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-83-gb2aca51627fb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61256dccaef649f1eb8e2c8b
        failing since 70 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-24T22:07:58.810779  /lava-4408311/1/../bin/lava-test-case<8>[  =
 17.370424] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-24T22:07:58.811110  =

    2021-08-24T22:07:58.811299  /lava-4408311/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61256dccaef649f1eb8e2ca4
        failing since 70 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-24T22:07:56.344582  /lava-4408311/1/../bin/lava-test-case
    2021-08-24T22:07:56.354616  <8>[   14.929180] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61256dccaef649f1eb8e2ca5
        failing since 70 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-24T22:07:55.333782  /lava-4408311/1/../bin/lava-test-case
    2021-08-24T22:07:55.339296  <8>[   13.909742] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
