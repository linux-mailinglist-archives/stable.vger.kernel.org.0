Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878CE3F6C17
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 01:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhHXXMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 19:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhHXXMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 19:12:40 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A39C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 16:11:56 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 17so21248842pgp.4
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 16:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R22KTqZzLkz0uqCO5udgNKwUlgSfL3LJ39RBeal2Qsg=;
        b=Ajk80+JcwqobzeeH9yq9VtHPGntt9g3PkCgrGu6oV0jD31xdJQkeFphekx8BoxP7qR
         QGRkrmtua3ENyc3z3vjuidUO+sEuSKVLZq4pyeUbOhPDkJkKnjrUl/+3yaG2jM1ix4GU
         rFl0V6tl10bEuqCPyBMTmQoPzWcyDfZgS9Ys7RV8r/qg6cJAFkPuKSVtIgheaKXa84k1
         gGhkvLd8wgEXB8arcLMBevk1Al3HfVFrWkhQe6UNNYlMS9sMiVVz9jpZPBdpY/ZS69TN
         mDhENWw9pdWMWmnQFRcQqBHcRxr+xhjEq9AMR1ATHEFh3TtpkF9qLGrYTn6toHXC5TCd
         YR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R22KTqZzLkz0uqCO5udgNKwUlgSfL3LJ39RBeal2Qsg=;
        b=CUWKQIRJkjOhACYDDhjlyZspBgAT3XvQg0R1c3R/CW9pD8weK5/Sbb4NjNFL8tkUyv
         NCe3E0SJC85LbwrPfTiKXYQ4Vt104yR11z1fVSjD9G82SAHr7q3rrhITyYRl1I1SOZ3g
         52ud9iYeShkwVtTpXluySb5hTmNq1Qq/8ULRgiNKEpxkbSIzwyyJHL1IQISnlL7YT9Xz
         hvK2RUEioDuYAHWOCi4rc4fmu8BQPHQXNSdCbHnK959dVjkZKoi8aXXRe4tfh5wJ2m4x
         qtj2G3K/tDGVSG2pIkMpFrLdLdxmKTz0cgOCYwglaJGy2iN/3GxBsA5OZXVr5M0gFGVg
         iXpg==
X-Gm-Message-State: AOAM5300N+/Dog7T9dTBZQUf/KLTBQwkXbZLNJD/440krIcgwv6U/yHx
        UUHNKgUcmWswEm24RsC/3mNcnJmXk6w0Ehst
X-Google-Smtp-Source: ABdhPJyFjnyy+zyU3kw9l3PrxUKO/BlRpRXZ0qREumNYCL/5n9Gm7gnYHM9/OQ2BehFqpbHYe8O3Sg==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr30734819pgv.453.1629846715313;
        Tue, 24 Aug 2021 16:11:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm20148407pfu.36.2021.08.24.16.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 16:11:55 -0700 (PDT)
Message-ID: <61257cbb.1c69fb81.104cc.b596@mx.google.com>
Date:   Tue, 24 Aug 2021 16:11:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.204-84-gc1eea862e3bb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 173 runs,
 7 regressions (v4.19.204-84-gc1eea862e3bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 173 runs, 7 regressions (v4.19.204-84-gc1e=
ea862e3bb)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.204-84-gc1eea862e3bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.204-84-gc1eea862e3bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1eea862e3bb2aec599f5b1b2aaaa1ee48e709b8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61254ad860a2bc9d6d8e2cb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61254ad860a2bc9d6d8e2=
cb2
        failing since 279 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61254aee406d22e2408e2cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61254aee406d22e2408e2=
cc1
        failing since 279 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61254ad360a2bc9d6d8e2c8e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61254ad360a2bc9d6d8e2=
c8f
        failing since 279 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61254a858693df04dc8e2c91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61254a858693df04dc8e2=
c92
        failing since 279 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61255b772c592c51fd8e2c8d

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
04-84-gc1eea862e3bb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61255b772c592c51fd8e2cb9
        failing since 70 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-24T20:49:44.661255  /lava-4407619/1/../bin/lava-test-case
    2021-08-24T20:49:44.678797  <8>[   15.277432] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61255b772c592c51fd8e2cba
        failing since 70 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-24T20:49:43.643243  /lava-4407619/1/../bin/lava-test-case
    2021-08-24T20:49:43.643882  <8>[   14.258035] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61255b782c592c51fd8e2cd1
        failing since 70 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-24T20:49:47.102889  /lava-4407619/1/../bin/lava-test-case
    2021-08-24T20:49:47.120018  <8>[   17.719376] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-24T20:49:47.120563  /lava-4407619/1/../bin/lava-test-case   =

 =20
