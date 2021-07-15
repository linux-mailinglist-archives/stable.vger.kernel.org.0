Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302433C9665
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 05:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbhGODTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 23:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbhGODT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 23:19:28 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85016C061764
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 20:16:34 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l11so2866639pji.5
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 20:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hGyqyxI0/3PyVewxmepgDnNrieC8g8TijJi/qshpCG8=;
        b=WIFKDK1bis6VKe4rqNd3uxX3VtNRiwER5ByNsvEcxRUmu7hmS+Av3NYy9aqrksQXBm
         SJil4E9V66+/lnkLA9aGKqTa0QpaxzVEkw+zcSST1Rb19fBr9HepBhTDHHjfS2x1zSIw
         A1rOmvAws3FTf1tKyLgejmGYl0r9eHn2GdN50ln1d+VXQxfwfVXwVuZcZmlDXQDV07Bp
         mIWTUjTvW45wrsU1V9TJvsfR8DOO1nUsER3oxYYl8dHET6gx+32xDG3ezkcSRst78jBC
         Lce3amMN+y34KAzXHE5zpcnNj/s4Oph0ew/7pBFQEW/lqs72WzJb6/9R+C8CoYyCI3It
         io+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hGyqyxI0/3PyVewxmepgDnNrieC8g8TijJi/qshpCG8=;
        b=dndZlbVOQAoyM1eH1B+11gzQ/wTO2P6p0s4iyrK+QMsAFZh4f3egguZkpzMjtllO5/
         JrRidIcM8F2qnYSiBk0VPMdfEKI0z9ry+okt6OTM0x28/NWm9c7O7tUAM+fTM1yR6Il/
         Fz+LmPhkuojaASCKXU1+n7G2lWOs35kzF6Xkgt4uCkjgeRxutUtp+onqTyalu2JydsW2
         K8s3gq950tvtKyjmxwDl7EBlrFOym9uKCRU80ypcUztjTZvTpGz18FXJ2SnkWzG17jXs
         SGCrM5/DBwB2rRdhfNBe5cznFhZBzGaTmXgfqiZ5AfvK7gWXOoRiAzwHi6/EZrBrojsj
         6NuA==
X-Gm-Message-State: AOAM532IuqJMZN0dvRPWNu602SQZrS2ULrkH6BeQ4PvK5rylJ3sXZsvf
        hWSzKecbP9iIGf2Kk6UeVZvJtqjczU+Ulup3
X-Google-Smtp-Source: ABdhPJyTppN0ah1LMvromALMISY/aBQdVANHx2D2OVbyhV9tloLRmDO3V+vygZIodKW+ePJsHs2vSw==
X-Received: by 2002:a17:902:8e88:b029:11e:b703:83f1 with SMTP id bg8-20020a1709028e88b029011eb70383f1mr1393258plb.79.1626318993652;
        Wed, 14 Jul 2021 20:16:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20sm7115104pjh.46.2021.07.14.20.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 20:16:33 -0700 (PDT)
Message-ID: <60efa891.1c69fb81.2c836.8250@mx.google.com>
Date:   Wed, 14 Jul 2021 20:16:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
X-Kernelci-Kernel: v5.12.17-153-ga65b3f168efa
Subject: stable-rc/queue/5.12 baseline: 178 runs,
 7 regressions (v5.12.17-153-ga65b3f168efa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 178 runs, 7 regressions (v5.12.17-153-ga65b3=
f168efa)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
beagle-xm         | arm   | lab-baylibre  | gcc-8    | multi_v7_defconfig  =
| 1          =

beagle-xm         | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 1          =

hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig           =
| 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig           =
| 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.17-153-ga65b3f168efa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.17-153-ga65b3f168efa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a65b3f168efa21960164deca7212b1d41a46791d =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
beagle-xm         | arm   | lab-baylibre  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ef74244071f5853d8a939e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef74244071f5853d8a9=
39f
        failing since 0 day (last pass: v5.12.16-704-g811a519d7fbbb, first =
fail: v5.12.16-702-gf996b03ef63d7) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
beagle-xm         | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ef75a1c45edfaf0c8a93a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef75a1c45edfaf0c8a9=
3a1
        failing since 0 day (last pass: v5.12.16-704-g811a519d7fbbb, first =
fail: v5.12.16-702-gf996b03ef63d7) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ef80f464cc4c9cf38a93a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef80f464cc4c9cf38a9=
3a6
        failing since 13 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60ef78f5bca0c754408a93a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef78f5bca0c754408a9=
3a3
        new failure (last pass: v5.12.16-702-gf996b03ef63d7) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig  =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60ef9d98e0afc42d4a8a939f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.17-=
153-ga65b3f168efa/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef9d98e0afc42d4a8a93b7
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-15T02:29:30.151623  /lava-4200981/1/../bin/lava-test-case<8>[  =
 14.990895] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-15T02:29:30.151961  =

    2021-07-15T02:29:30.152154  /lava-4200981/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef9d98e0afc42d4a8a93cf
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-15T02:29:28.723454  /lava-4200981/1/../bin/lava-test-case<8>[  =
 13.562734] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-15T02:29:28.723802  =

    2021-07-15T02:29:28.723998  /lava-4200981/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef9d98e0afc42d4a8a93d0
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-15T02:29:27.686258  /lava-4200981/1/../bin/lava-test-case
    2021-07-15T02:29:27.691772  <8>[   12.543091] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
