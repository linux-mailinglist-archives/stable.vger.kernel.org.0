Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32C540208E
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 22:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbhIFTwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 15:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhIFTwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 15:52:01 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CF9C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 12:50:56 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s29so6329303pfw.5
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 12:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Bnvg4KOAdfg+Ll4TT1rFf8bFztYkPR38ct3u7UNC0Yw=;
        b=Io0c50lr1EH2+F4LTr7TkfuPc34+XnUD/roCH5TFJXm9rc7wPTUbT9vJBuGyfx6gy7
         3CrYFUdl5NFhBmPNRB9ulPQ7fxuCWJJZRigvYCr02M1RG/fAp0AVx6VmuQhTu31HDg5+
         8XvL4DWbQ0Tlg+houo1r6ZXyT1wmKl37kt/qT8YvavIEbxor5sq181rjhjhd2VvTMRQF
         zJKzXFFE9oza76tQs07Vmm/8nV6vywtLpiVY0YY4SX3PUZv3VGI7ytBdw1w8FDCIkPgc
         JkcR7QCa5YKKD5bLkFtHyTSl8yQUbitL4yO/1keVOzYFWhgBkd7rOjqgM+VYXXRR2phl
         z0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Bnvg4KOAdfg+Ll4TT1rFf8bFztYkPR38ct3u7UNC0Yw=;
        b=ejPQRRr72l58Tq99walz2SyhujYy1ZH6HQArLD5BjGaixhrnM66q3pWOMtaTK/Bofp
         8LzfFNUOd8Wv1HCd4bzrIFO4cmSVrJddNUav6nkHl/5vlx89OyBpExYTnIBV/2XZNXnd
         cLFX2BEl+Fxw+hfQXDp3sZ2d6SFTrTntIE7KuhZ7e2mxoUxpXuSwttFX1QQSJ+GbnJJS
         UYtT3lshZi0TYYloILfUtRh88eqBTc8MehsuRDVfpJ3wAIeUG6cG+mW4T7cTY17/EjAr
         QXu6zT+iI8/bXSK115cwHwGf2ByEmGcGS4slHJonEP3V6gh8wKFnARdnHBubrGCQ2S11
         5iCA==
X-Gm-Message-State: AOAM531Fal8utT7wBrsRUNsHszg/T7Kv+WcP9zc++UbaI6Qt08tXY2ra
        2rJDERPb8hPYIoTG1NkorYw5P5yYMRZPqAIj
X-Google-Smtp-Source: ABdhPJzR+z5o4Fn5OZd31RhhgcyFnd6nM7DT4J/vkI2cAXO3U+D+ssuYEoYqKGouOQAuwbaZvBBkPw==
X-Received: by 2002:a63:30d:: with SMTP id 13mr13887966pgd.289.1630957855991;
        Mon, 06 Sep 2021 12:50:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m26sm8778095pfo.146.2021.09.06.12.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 12:50:55 -0700 (PDT)
Message-ID: <6136711f.1c69fb81.d1997.8871@mx.google.com>
Date:   Mon, 06 Sep 2021 12:50:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.206-14-g5eeb78b3bd0e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 161 runs,
 7 regressions (v4.19.206-14-g5eeb78b3bd0e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 161 runs, 7 regressions (v4.19.206-14-g5ee=
b78b3bd0e)

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
nel/v4.19.206-14-g5eeb78b3bd0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.206-14-g5eeb78b3bd0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5eeb78b3bd0e0d6fabb7a308a7a872ae356f0211 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363bd69529c85dbbd59695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363bd69529c85dbbd59=
696
        failing since 292 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363c06c9e88ce3ffd59679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363c06c9e88ce3ffd59=
67a
        failing since 292 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363bc415d5c3c6b0d59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363bc415d5c3c6b0d59=
675
        failing since 292 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61363b42b8c9b78f75d5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61363b42b8c9b78f75d59=
67e
        failing since 292 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/613643380d42e6cb08d5968e

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-14-g5eeb78b3bd0e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613643380d42e6cb08d596a2
        failing since 83 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-06T16:34:50.170805  /lava-4459249/1/../bin/lava-test-case<8>[  =
 17.878578] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-06T16:34:50.171303  =

    2021-09-06T16:34:50.171716  /lava-4459249/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613643380d42e6cb08d596ba
        failing since 83 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-06T16:34:47.710679  /lava-4459249/1/../bin/lava-test-case
    2021-09-06T16:34:47.727536  <8>[   15.436393] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613643380d42e6cb08d596bb
        failing since 83 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-06T16:34:46.691606  /lava-4459249/1/../bin/lava-test-case
    2021-09-06T16:34:46.697189  <8>[   14.417012] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
