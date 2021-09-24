Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADC9417BD0
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 21:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344765AbhIXTbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 15:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344442AbhIXTbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 15:31:00 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FA7C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 12:29:26 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gj8-20020a17090b108800b0019e8deab37bso1908614pjb.5
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 12:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jIDkXpaBQPfAIQL9kdJaNUVzKQlfooUNauKfcp6GOKY=;
        b=PelXNthAsE98cLzC2qOWzSjCPSYDsTvZa+IaMgTLAgZr6eg8ItNI3FZJKZ2xyg9bTh
         PhKw2e+mAcUoj1DzmT8k79C5JD35hLFtCtQTNKJRMTaNe8u0ADVUM9a0a23QKZusFxrf
         56kSN/A4r526yjbl86LGLK3RqkWT219dVVbzSlzMzbg57zR55oY3wqnqHKyZaVUR09Kn
         pefBkW6qdmJr12yHxGK6cpKS4qQzy07pcTe2BEG6tKCEdcTNz4Y5VEjPSjcCMTqkovm6
         jZl1/Y4Fmr779XVJhylykayH24ZN5W2Vci4QSxRd2IOI5qoFOr3QUEpeIaLPLFk1qyZt
         X6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jIDkXpaBQPfAIQL9kdJaNUVzKQlfooUNauKfcp6GOKY=;
        b=qyiTjHv707Ui8mH0LaMTPbex0dxys2qxW8LIorx3//+YwaDbD90e6G5YcE/BqcnRV1
         qozWSoQbUFX14y1WIFQ4giL/850/yE2c413pGdukQvPfdEkVljKh6RkylU13uewrS48W
         elZ1+CVn3q8+wh3ylcU0WSNn2Ou61XB/83hKE6SJrKzx6l6RKcUQW+qnkY4+1MwD13nC
         yH1JmubNGGXqBCs7EEWmrycDly+SZMVIVxdCelfFzacHLQ1hm1lOLTR22yoxxp7xTE3O
         yBH1LvSvTTSSdVN5eDF5UsWMcNGqOUaW1xYeRniC2LzeL0F77AC7I0M3kKjlDU2Fu0FB
         7XaA==
X-Gm-Message-State: AOAM533AkcfmPXW2bDLoCQvyYXbrjQX6922eSNL5eOrV3jhe8VfuyT0o
        gv4loZGRtC9Y2co/fQyKbaH9VwGSH3LoT8WP
X-Google-Smtp-Source: ABdhPJyQFYQl27LO1ylT/mZGj8k/3RoKKFB/gvzwED4YF3rRQTt2p8jgGwqcTQ0SOFjupUIp4FTECg==
X-Received: by 2002:a17:903:120e:b0:138:d732:3b01 with SMTP id l14-20020a170903120e00b00138d7323b01mr10439052plh.21.1632511766165;
        Fri, 24 Sep 2021 12:29:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14sm10390116pgn.85.2021.09.24.12.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 12:29:25 -0700 (PDT)
Message-ID: <614e2715.1c69fb81.ccb99.f5fd@mx.google.com>
Date:   Fri, 24 Sep 2021 12:29:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-34-g2bda4af134d0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 84 runs,
 6 regressions (v4.19.207-34-g2bda4af134d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 84 runs, 6 regressions (v4.19.207-34-g2bda4a=
f134d0)

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

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.207-34-g2bda4af134d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.207-34-g2bda4af134d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2bda4af134d0539b1c849462c596b25bfadf417d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614df0e043702b56da99a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614df0e043702b56da99a=
2e2
        failing since 314 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614df0f152a6111ccb99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614df0f152a6111ccb99a=
2e0
        failing since 314 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614df0e143702b56da99a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614df0e143702b56da99a=
2e6
        failing since 314 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/614e0efc15460a205e99a2f9

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-34-g2bda4af134d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e0efc15460a205e99a30d
        failing since 101 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-24T17:46:25.831784  /lava-4579739/1/../bin/lava-test-case
    2021-09-24T17:46:25.849076  <8>[   18.463786] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-24T17:46:25.849295  /lava-4579739/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e0efc15460a205e99a326
        failing since 101 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-24T17:46:23.389030  /lava-4579739/1/../bin/lava-test-case
    2021-09-24T17:46:23.394223  <8>[   16.022208] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e0efc15460a205e99a327
        failing since 101 days (last pass: v4.19.194-28-g6098ecdead2c, firs=
t fail: v4.19.194-67-g1b5dea188d94)

    2021-09-24T17:46:22.370076  /lava-4579739/1/../bin/lava-test-case
    2021-09-24T17:46:22.375222  <8>[   15.002834] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
