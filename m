Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9197E40CD21
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 21:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhIOTYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 15:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbhIOTYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 15:24:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3E8C061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 12:22:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v19so2847956pjh.2
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 12:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JcpcgF+rGF/9dODcckuhz2PIwFsdr7qJJ1npa7MpxIA=;
        b=Rus6p6uHTiGERNzpoZllbYzK6geF8LXY5C7ZiCWLOKwBuMXraCQUv2lwzWC7FtM4Jt
         N9g8gdF6AVT0Kf5Y8mDRnrvV3uotg11DmAEs2RBwz3XpzblfpJDGLHM9NESYi9pWbxze
         V7aYvl26rP7bEpsKlgZ+NmP79nzKXF/WEAFowkC6bRx5X52HVpPLXsbehjsmFkUtfuCz
         QL7w4xHmuqrRDIObsKIfOrcdc9FVGPhbh8So+LBUPyv4796HGs6GI5rtXfEGGFWRUYBY
         o86EnDOILcRrDQ9m5dF+jkRBD/9a9EjGXcAymM00jISN2NmA3wXQzheSketvEI2cbNpc
         UfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JcpcgF+rGF/9dODcckuhz2PIwFsdr7qJJ1npa7MpxIA=;
        b=3yy5nSlWs7SvJ1xv2BAU1YvdlqJQYmhiE1aIsnWw8rB8REpb4kCDjTBZ2LBYBMX/sW
         rrdONCleKn4hxRg4fjhvThT5uOMkPxO9CGIHInOJ06YH3hW5tHmzYYoV2yRTCGVoVeUm
         0wP9a87nuh7RWantrkSEyZ1elNBKPw8TlIIJN6cV2duHM7bbrcwr5s6lJqi+A1a6l/Mt
         fltKKNBITTylHhrqDaMfA3GgUrvrUqvs74O02RxNKz69MLqhZEXry2PJApQX3WwVDB5r
         KPrE52YfEvxK2ViL4WFaL7s927Ff/VlGtYDbifn/s5y24JzVYNDoyUY6VCayC5H34bxS
         x5Zg==
X-Gm-Message-State: AOAM532SLp12QyZ+cJXWKR7TaApQaPmW6r68Krkv55Sk/972iuiwTwE1
        UKVSCaPe2/sp6v/ndMSO3SRtv2QjLGOmyz+a7VI=
X-Google-Smtp-Source: ABdhPJz/cfEL2CqzpCpZXds35YhxlwfT5NpQqIyTBRu92X5WFCnk60eROOvsmF7ntNVV/RZ/g7VQYQ==
X-Received: by 2002:a17:90a:86:: with SMTP id a6mr10120921pja.190.1631733767498;
        Wed, 15 Sep 2021 12:22:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s192sm717683pgc.23.2021.09.15.12.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 12:22:47 -0700 (PDT)
Message-ID: <61424807.1c69fb81.de65c.3108@mx.google.com>
Date:   Wed, 15 Sep 2021 12:22:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 206 runs, 8 regressions (v4.19.206)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 206 runs, 8 regressions (v4.19.206)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.206/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.206
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b172b44fcb1771e083aad806fa96f3f60e2ddfac =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61322db245f9fdc2c9d5969b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61322db245f9fdc2c9d59=
69c
        failing since 289 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61323713c561c1e6d3d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61323713c561c1e6d3d59=
667
        failing since 289 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61322dfc2d9d890f7ad59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61322dfc2d9d890f7ad59=
666
        failing since 289 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61336b4d797fa3ac1dd5967b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61336b4d797fa3ac1dd59=
67c
        failing since 289 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6132a28de892fad574d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132a28de892fad574d59=
666
        failing since 289 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6132390a2143394334d59665

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6132390a2143394334d59679
        failing since 80 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-12T18:21:50.586882  /lava-4502601/1/../bin/lava-test-case
    2021-09-12T18:21:50.604044  <8>[   17.605384] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-12T18:21:50.604349  /lava-4502601/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6132390a2143394334d59692
        failing since 80 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-12T18:21:48.162491  /lava-4502601/1/../bin/lava-test-case<8>[  =
 15.163164] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-12T18:21:48.162873  =

    2021-09-12T18:21:48.163118  /lava-4502601/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6132390a2143394334d59693
        failing since 80 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-12T18:21:47.126230  /lava-4502601/1/../bin/lava-test-case
    2021-09-12T18:21:47.131653  <8>[   14.143644] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
