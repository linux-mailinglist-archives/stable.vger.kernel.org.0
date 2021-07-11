Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227D03C3DF0
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 18:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhGKQay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 12:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKQax (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 12:30:53 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851A3C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 09:28:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j3so5836424plx.7
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 09:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PaV0C0MBnP/hVaacNUDGYQimWMdDnLZs8IO7drIG+yo=;
        b=tiDuZAcj88Vo1urOZsnmnA9zAteGx61mbWt+sYUr0hn36IwFABDnaU++vnw3prboye
         WLzB/TBZ//CeBsDWmUwXuhjQ4Y972mq5aguqUbS5qrjJQn86IMy/PzDEJTVjYe199GRo
         3CKeBw0/p3PbAfZzI8ThEYd8IdzUn2g21bfSqDotRMYEOnJmjhn70OjEVXHerxb+Au6j
         U8ASbAGA/2JPgGXXhxT2G1TJ0cGPgqoVdnTp7frqRQGgRHyw5PbEMq2UMli3VDthrTfC
         PA9DMsGjIBG0bFqqa/fV4TGBsP6r15fCFrLIPBt51unPIlLaMJj/2fAlnOFfvkw6zc3p
         Yvqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PaV0C0MBnP/hVaacNUDGYQimWMdDnLZs8IO7drIG+yo=;
        b=mQn1wSbBS/fdsk2RgkJaLjiiXWYV2EXZITh6hH5q6UNkR23hqKdbHVipmCTRrpuQIA
         d3l/0WbJBjEZ+fK9XKCtZj/yxuFkpNs5oybagogAp9Jaka5XWBwhZjNCTPz4HZQHB8Rt
         cEhNwjbthCaQdM44FEO6+vIE+Rbe9edS7vQB1lcVQDjbSzAGGwwcgJ5mkJ6hKTjFjTzl
         D6y0WHWkzlP+vxXV6qY6N/qKOCaLWmTR51ElD54PRtrCIYnC4OmSyc4i1WJtMUMKgx0B
         dcYfEA7Cwvt05Se+J55vAViaQgCZgYLU5a9yYgryMN3gdNLNYNX80UNz7Dz7aWpFok9l
         gKaw==
X-Gm-Message-State: AOAM533SV3QPX/4h8TQzqP3FZNDOCXPoOwcAeSUolKGAvzQ4nShpgqq6
        qDs7iTPcfYiDMOaX35wNscaIipBrEFkkGOOt
X-Google-Smtp-Source: ABdhPJwK/FEOPe0pC/tPj9FXK0OdvESLUF7YmOVj9agXTk/K6uuImcOpTTPTMsYSPY57FlWIPS1H3Q==
X-Received: by 2002:a17:902:bd81:b029:129:8eb1:c909 with SMTP id q1-20020a170902bd81b02901298eb1c909mr13627715pls.30.1626020885936;
        Sun, 11 Jul 2021 09:28:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n5sm7111576pfv.29.2021.07.11.09.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 09:28:05 -0700 (PDT)
Message-ID: <60eb1c15.1c69fb81.cba6f.4e66@mx.google.com>
Date:   Sun, 11 Jul 2021 09:28:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.197
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 172 runs, 8 regressions (v4.19.197)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 172 runs, 8 regressions (v4.19.197)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.197/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.197
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      fcfbdfe9626edd5bf00c732e093eed249ecdbfa1 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60eaeb2248a82b634111798d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eaeb2248a82b6341117=
98e
        new failure (last pass: v4.19.196) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae5459cc22d7646117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae5459cc22d7646117=
973
        failing since 234 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae5549cc22d7646117985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae5549cc22d7646117=
986
        failing since 234 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae5466e43d061d3117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae5466e43d061d3117=
973
        failing since 234 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae505ed4f08e59e117972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae505ed4f08e59e117=
973
        failing since 234 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/60eaeefc9cd69e74c611796a

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.197/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eaeefc9cd69e74c611797e
        failing since 24 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-07-11T13:15:29.879644  /lava-4175022/1/../bin/lava-test-case<8>[  =
 18.335708] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T13:15:29.880223  =

    2021-07-11T13:15:29.880586  /lava-4175022/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eaeefc9cd69e74c6117997
        failing since 24 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-07-11T13:15:27.421798  /lava-4175022/1/../bin/lava-test-case
    2021-07-11T13:15:27.427073  <8>[   15.894678] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eaeefc9cd69e74c6117998
        failing since 24 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-07-11T13:15:26.402562  /lava-4175022/1/../bin/lava-test-case
    2021-07-11T13:15:26.407851  <8>[   14.875141] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
