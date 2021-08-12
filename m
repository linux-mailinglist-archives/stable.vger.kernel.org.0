Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93B63EAC53
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 23:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhHLVV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 17:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhHLVVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 17:21:25 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15812C061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 14:21:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e19so9050530pla.10
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 14:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=88Um2bjdVYNBKxstBB2JzLcoijKQ0lCWRiPJ2lCkWIw=;
        b=nzpatxckr4alKZ//pPTD5g53XbD2apEX1zqKXo77D8FXOozpQ2Q3D3kK3401DSQDkA
         +ssTeXnd7equ5TxN7KJa2IiP0XTDhEDn81Kq43oa+0eGBL+f0DRdK73P/9nl18+RNASO
         57VZcWGVqJIswi2PYD4tiftOyynPEH8zme6zovw+RCVE1Rj+sEHBSRtX8de3HGzCgY3N
         xrj934SoPx7M59h9RbdvHwfJFGz/g5EWKzfWfxbQC0+SY97quqk7wc8vh4VtzLn/1pHi
         GR+NDn0K42mw8j4cDYl+sKxGO5M4N8c3y7KtVhO5eltCoxFqhHzHO8zrcuRVITyo2vj9
         IiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=88Um2bjdVYNBKxstBB2JzLcoijKQ0lCWRiPJ2lCkWIw=;
        b=gJORgA/c1nf0zf4e8mohf6mMJpfxKpfndf/Gi1soA8qbcV8skwjy0/Y6wcS0ToIoUH
         3xVkhFa66rOQ6hh4l40ADl38Tg+d6c7vNs+GB9rKwEJjewHuZdFPfYFfjleu/W+KdEXi
         4sR/ndrbAukSIP6aA9ifZRMi9T5QPtYO6Tk7dCFXpv92UN3g6wvRxcjX+j4IYSZIKv8d
         RPB0A8gAWYQkJV17pvz36ZMZqYFAOayYQxxmbnOzuceEWCQxCuHNvZ3BqnC6vY8cjGML
         2wq0YyvFpIBC0Zl/IQEeRzmS21qHFarqakyl8sJZXOCAQ8nU5VwBcD9H/8eVGXB98QEl
         piAw==
X-Gm-Message-State: AOAM531QXY3ZtvxQXbCbDzvvxxL7UPlCrjZzI9kaZnpFIVxMxMGD/kQb
        YYhhQyfwSjgUpa6hxgX8J/+yQlOb7kz+FhjV
X-Google-Smtp-Source: ABdhPJy9mR7CuxFeOIE+e8MD65IQk4KYxhuYzQAUQZjatwuRBlrfVF/bOgVN28Nnv00YFzee5rNLGQ==
X-Received: by 2002:a63:2217:: with SMTP id i23mr5669586pgi.448.1628803259271;
        Thu, 12 Aug 2021 14:20:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r17sm5138108pgu.8.2021.08.12.14.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 14:20:59 -0700 (PDT)
Message-ID: <611590bb.1c69fb81.4a4df.ecbc@mx.google.com>
Date:   Thu, 12 Aug 2021 14:20:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.140
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 171 runs, 7 regressions (v5.4.140)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 171 runs, 7 regressions (v5.4.140)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.140/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.140
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a998faa9c4cee7dc68f3f6f82be93bbb99dda322 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61155b0ce7f7c05b8eb1367e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61155b0ce7f7c05b8eb13=
67f
        new failure (last pass: v5.4.139) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611559ee137ec2bc2eb13668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611559ee137ec2bc2eb13=
669
        failing since 266 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611559f571f5335433b13683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611559f571f5335433b13=
684
        failing since 266 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61155997fa4b5c5fcab13672

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61155997fa4b5c5fcab13=
673
        failing since 266 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3288-veyron-jaq    | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 3          =


  Details:     https://kernelci.org/test/plan/id/61155d118310a14acfb13683

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.140/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61155d118310a14acfb1369b
        failing since 57 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-12T17:40:07.921159  /lava-4354475/1/../bin/lava-test-case
    2021-08-12T17:40:07.927203  <8>[   14.194202] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61155d118310a14acfb136b1
        failing since 57 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-12T17:40:06.497405  /lava-4354475/1/../bin/lava-test-case
    2021-08-12T17:40:06.514645  <8>[   12.769608] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-12T17:40:06.514954  /lava-4354475/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61155d118310a14acfb136b2
        failing since 57 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-08-12T17:40:05.477333  /lava-4354475/1/../bin/lava-test-case
    2021-08-12T17:40:05.482909  <8>[   11.749941] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
