Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6A73C683C
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 03:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhGMBwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 21:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhGMBwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 21:52:46 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375CAC0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:49:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b12so18088408pfv.6
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 18:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HdbfnheTem+wMRYwOWO4rkrjyR864DGYdyG4tFftjqQ=;
        b=iEmjZodf/W7FH5VkBcpHe1xDG/Wm5ZWItOJkJRMfeqi7ktgu8oGaaB0Qh2xiYAFPsp
         KKfTYiWGa1qxlXIJdqmi/WuSKmGDroQpDk0/ntiOA66AjpChX+1fkfzOV/B1qgwbH6ET
         Cio3cQC3w9R54NI1FIERwUqy2QkYsQe89C1/i447lhC1wPk6sv5rcw0npZA+cnWs/F+Z
         I2Gu+v8wFEkdjzEWWrywT/X+RqhF/aQMDKUdGqh75x4HhAUvCJfET6RPvISsDzKDRsu3
         cWGB+KyIGsBoNrV/cYd1hJhviDAQANjmCZHgSG6xW9/F/zyzDmMdc5mfh2Q46cyHTbn1
         2sIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HdbfnheTem+wMRYwOWO4rkrjyR864DGYdyG4tFftjqQ=;
        b=HAXe7Jug9a4r/OeAuyJUqhFNzWHbNyoF9CbkuIKSaoMbMjSUplji675Wm9n8CNjCpk
         RupAPdz42yTVWoCvjXA0LUJeTsxK7j/800dMZIhc+YiBD4tgUfYFpflyAh5xgRxNO9dn
         QU5BAJw0r4rpTFDw7bFnjlgB2XdbL35FVpw/jiJFvIP5CoLNJjvYmuMk0uzkNulzDC6h
         0CNdhPGBl42H0k4UdA2Kbd8KA0FWDoI1Fsh4C6rZGXWUYfhg8WWPpRcwLCWOQKp79W/8
         effw3OfCdq1+QztyyK1vBq/Bh2w1zFDi6+fKY6jIO7tb/b/XfBwNxcl4iVywDw6eI3xG
         +ZpA==
X-Gm-Message-State: AOAM533gdJsPds7SOYy42yOiQW4UJ/n6mvDLmxcy7fjrsIKHl0hVzGzI
        +QVLlxayzVjpoKALeZGWZYFpzQkQw1EzJ8Ff
X-Google-Smtp-Source: ABdhPJz1+ZLaM1Ozbrp48nm+KldZ/Z7FwBXsCmw9QAO6pcavr+iwRttkopLwSO2MnO5fMaNfZpl+Xg==
X-Received: by 2002:aa7:8806:0:b029:32a:8632:e35e with SMTP id c6-20020aa788060000b029032a8632e35emr2180913pfo.10.1626140995533;
        Mon, 12 Jul 2021 18:49:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t11sm15550874pgm.36.2021.07.12.18.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 18:49:55 -0700 (PDT)
Message-ID: <60ecf143.1c69fb81.f6aca.05fa@mx.google.com>
Date:   Mon, 12 Jul 2021 18:49:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16-705-gfd3222df4dfe5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 198 runs,
 8 regressions (v5.12.16-705-gfd3222df4dfe5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 198 runs, 8 regressions (v5.12.16-705-gfd3=
222df4dfe5)

Regressions Summary
-------------------

platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defconfig=
             | 1          =

hip07-d05          | arm64  | lab-collabora   | gcc-8    | defconfig       =
             | 1          =

imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig          | 1          =

imx8mp-evk         | arm64  | lab-nxp         | gcc-8    | defconfig       =
             | 1          =

rk3288-veyron-jaq  | arm    | lab-collabora   | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.16-705-gfd3222df4dfe5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.16-705-gfd3222df4dfe5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd3222df4dfe575b8d1fd1aef320a441f3833513 =



Test Regressions
---------------- =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecbcb552f98d8c1a11797f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecbcb552f98d8c1a117=
980
        failing since 1 day (last pass: v5.12.15, first fail: v5.12.16) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
d2500cc            | x86_64 | lab-clabbe      | gcc-8    | x86_64_defconfig=
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecbe0a39d8cea7e81179cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecbe0a39d8cea7e8117=
9ce
        failing since 1 day (last pass: v5.12.16, first fail: v5.12.16-702-=
gd61ecea7819e8) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
hip07-d05          | arm64  | lab-collabora   | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60ececffc2bcc09f6e117974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ececffc2bcc09f6e117=
975
        failing since 11 days (last pass: v5.12.13-11-g6645d6f022e7, first =
fail: v5.12.14) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecc0d63c3cc5fef0117974

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline=
-imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecc0d63c3cc5fef0117=
975
        new failure (last pass: v5.12.16-702-gd61ecea7819e8) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
imx8mp-evk         | arm64  | lab-nxp         | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60ecc25e6fb09e838711797d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecc25e6fb09e8387117=
97e
        failing since 4 days (last pass: v5.12.14, first fail: v5.12.15) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
rk3288-veyron-jaq  | arm    | lab-collabora   | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60ece7d68ae8c5a2e7117984

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-705-gfd3222df4dfe5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ece7d68ae8c5a2e711799c
        failing since 28 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-13T01:09:30.470484  /lava-4186876/1/../bin/lava-test-case
    2021-07-13T01:09:30.475571  <8>[   13.721933] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ece7d78ae8c5a2e71179b4
        failing since 28 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-13T01:09:29.042037  /lava-4186876/1/../bin/lava-test-case
    2021-07-13T01:09:29.060011  <8>[   12.293697] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-13T01:09:29.060241  /lava-4186876/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ece7d78ae8c5a2e71179b5
        failing since 28 days (last pass: v5.12.10, first fail: v5.12.10-17=
4-g38004b22b0ae)

    2021-07-13T01:09:28.028296  /lava-4186876/1/../bin/lava-test-case<8>[  =
 11.273991] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-13T01:09:28.028646     =

 =20
