Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAD741B217
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 16:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhI1OcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 10:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241016AbhI1Ob7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 10:31:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8F6C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 07:30:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 75so5001793pga.3
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 07:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U8f0FA9TU8vph7TVQ8Si706agfHlzefANIZd37e2Xz8=;
        b=igLMUMPx+os4YT2XYNS6Gxq48WTwchXORf713IibWLixBZEv+C2MqoqRh1FRKRaFKg
         d4iBVQfGHi1wgKKi/rMo1G3URo1iHtUaPJTSpkEfg9BUNq84/I7eqBDP5AypgbKOBgqD
         a4YgV3WnC5yypY8xueX52QQCLHV/Eld2ohd+io7ZMQCS7XReecg/yPiN0lSlq07cpGCv
         e4niZ9yvl7lGGf8daxTXthJw2HNWZ4e6NE2qbV1+qUi2l4UB8yBF8SPKAWuuuamBMV3A
         ccLKZFef71F2zgVu7Zk/wjhLRewpHSJ82qfhSLe2RS4TGNXwrw5M5yq9YkZXZt/Kp+SC
         2RCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U8f0FA9TU8vph7TVQ8Si706agfHlzefANIZd37e2Xz8=;
        b=2bTxyNZf96uqqEBE+4QUigCzUh9O/Tx+X20iWhYFG11ZBrzzDhFg1V48UZdNt7h51S
         7+7cOoZCv+ER5jGhDVVX6gyLubha3ZMxMP+QvyPPMGDS3fgSba8+h4bAHS0Ydz62q1Qi
         94PftGnjt5pn7jv8WdvvT+2U0uKDTYbwNvxk+ZfI+oLshO9pF66KvgtSO5MqZ65+Y+GC
         m98CUSGRdSQMJNTmk/JAJNMNcGo4K+sQza95AjEhJ6E8aDR5RyWRNV670Vnq7BNmx7P1
         rc57m+UxzUYZvI9JnjpxrtNtejnXau8WAl1kpFOBxQaYk+ss9liHZgKiYCUUIEPIVHZL
         p0Xg==
X-Gm-Message-State: AOAM531aEJq84My1VMKYLRt+3aTWi51fMkUNlg2RZMXxcVij2SPpgPFH
        XFZWyqILEwPYWOzcliwsm68e1F/mOZuqJCnT
X-Google-Smtp-Source: ABdhPJw7h9kJ+u5LyvuySQzyI4YSlQKxdywW98MWoLPwzPQxsuopN8DFJF1gM1pFZDFJ6WztifyJcg==
X-Received: by 2002:a63:105c:: with SMTP id 28mr3589408pgq.187.1632839419908;
        Tue, 28 Sep 2021 07:30:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4sm2900964pjr.32.2021.09.28.07.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 07:30:19 -0700 (PDT)
Message-ID: <615326fb.1c69fb81.71747.9422@mx.google.com>
Date:   Tue, 28 Sep 2021 07:30:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248-42-g0933954630a3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 133 runs,
 7 regressions (v4.14.248-42-g0933954630a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 133 runs, 7 regressions (v4.14.248-42-g093=
3954630a3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.248-42-g0933954630a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.248-42-g0933954630a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0933954630a380751622feb117678ff03b9a9bba =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6152f398fd59be3cbf99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152f398fd59be3cbf99a=
2e0
        failing since 317 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6152fa9a0a7b85d93f99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152fa9a0a7b85d93f99a=
2f8
        failing since 317 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6152f3bfe09d75feda99a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152f3bfe09d75feda99a=
310
        failing since 317 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6152f7c6b04e95b6cf99a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152f7c6b04e95b6cf99a=
2f3
        failing since 317 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/615304da04a6082fa199a2db

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-42-g0933954630a3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615304da04a6082fa199a2ef
        failing since 105 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-28T12:04:28.509283  /lava-4592962/1/../bin/lava-test-case
    2021-09-28T12:04:28.526437  [   16.722846] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615304da04a6082fa199a308
        failing since 105 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-28T12:04:26.078548  /lava-4592962/1/../bin/lava-test-case
    2021-09-28T12:04:26.095240  [   14.291750] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615304da04a6082fa199a309
        failing since 105 days (last pass: v4.14.236, first fail: v4.14.236=
-50-g2e03cf25d5d0)

    2021-09-28T12:04:25.059447  /lava-4592962/1/../bin/lava-test-case
    2021-09-28T12:04:25.064937  [   13.272982] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
