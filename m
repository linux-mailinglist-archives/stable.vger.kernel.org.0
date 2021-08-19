Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5393F0FFF
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 03:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhHSB3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 21:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhHSB3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 21:29:31 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37226C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 18:28:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x16so3979145pfh.2
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 18:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4WTN9aFK7wQIlJTWJ94HtlwCvdDhoJk0+Ynmw/CQK6c=;
        b=O8LQgYYsUgc5x7BFS4DnLQuWRkRbC6StJCcq2/8iUaq6UW0WAk+3PE2FlKqat6+9ct
         NHsz3AXI9s+iyXJSfVpxG1DeR4YVFxtkSHPNgBE/ruKElpzdgYGFEy362ZLuQ4Hdr9A0
         09S24E6XHW+KJSZqpq3w6OnKjOPmRlwwh5kogt0gl6Qer468YqiNqQz4ikjUweJPw/Nm
         BG/oOAU4+Qb59DGTqoBsRSBCGobdYkWW/G3rB1GiKIMYDs1l2MkQ3vV0g7LhdjqTAqur
         U/gL4eclMBqR3eHBu+INwuLyqKjCjBKSuRP7HvXjtkeDQTin7ECrGfarHM8Ipbq/loVW
         Rmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4WTN9aFK7wQIlJTWJ94HtlwCvdDhoJk0+Ynmw/CQK6c=;
        b=SS23ihuSVV48lvohsG3SdcfvHLz1pp2QsM3FucmmjnwzOLxmafoO2GiiKhgMK0bC4b
         rDoSYWZlJ7c4E4RfzQgPkddSNtEn40UFa3SOw+1dTUWR/r55Y8dsbSwNaXJCd93Bp/n7
         zrz6q4UKqaJiEEoL12cgrf+AKKchDwUyLnSRhPTd5xWFd4TTgS0y28Te5rqEJCClC2UP
         wvaxBObv+HpGUWYW3YR6m4moALBtkob6oN9rgfqCz5WDkh1CUhPmLzq3EH0oQ8SkKLpo
         Ehr6n8F31nouhSga3spMjBASq4xg3WRGPo/YkKheMBTG+JerRY5TcuS5v9BsG13eZc4p
         1gqw==
X-Gm-Message-State: AOAM532kPSftBB2UjoO9toMysLVYLyQlW3KOlusRBDJjrmutkoG6P3mw
        jz+RcxM/oE4f6TW0fPIZoIbwzPhMw991YdZG
X-Google-Smtp-Source: ABdhPJyWnnUBS84LM6Q1nBulNGgTGx64zTtC7ZbZB6lXf8sonInPWmT9XpgMtN+f8BI9TxLbgyG66A==
X-Received: by 2002:a63:4e65:: with SMTP id o37mr11565015pgl.202.1629336535601;
        Wed, 18 Aug 2021 18:28:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z1sm1168332pfg.18.2021.08.18.18.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 18:28:55 -0700 (PDT)
Message-ID: <611db3d7.1c69fb81.aca02.5a81@mx.google.com>
Date:   Wed, 18 Aug 2021 18:28:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.244
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 96 runs, 6 regressions (v4.14.244)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 96 runs, 6 regressions (v4.14.244)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.244/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.244
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      162b95d01320370b80cb2d5724cea4ae538ac740 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611d8c18bbb19dbedab1368b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d8c18bbb19dbedab13=
68c
        failing since 277 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611d79b13e5a532fe3b1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d79b13e5a532fe3b13=
67c
        failing since 277 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611d7db7f995032742b1368f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611d7db7f995032742b13=
690
        failing since 277 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/611d84c6aae2650fd7b13661

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
44/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611d84c6aae2650fd7b13679
        failing since 64 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-08-18T22:07:17.157043  /lava-4380323/1/../bin/lava-test-case
    2021-08-18T22:07:17.174262  [   16.712220] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-18T22:07:17.174528  /lava-4380323/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611d84c6aae2650fd7b13692
        failing since 64 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-08-18T22:07:14.724943  /lava-4380323/1/../bin/lava-test-case
    2021-08-18T22:07:14.743610  [   14.280408] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-18T22:07:14.743839  /lava-4380323/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611d84c6aae2650fd7b13693
        failing since 64 days (last pass: v4.14.236, first fail: v4.14.236-=
50-g2e03cf25d5d0)

    2021-08-18T22:07:13.706014  /lava-4380323/1/../bin/lava-test-case
    2021-08-18T22:07:13.711852  [   13.261552] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
