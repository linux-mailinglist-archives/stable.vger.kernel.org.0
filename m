Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AB53C888A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 18:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhGNQVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 12:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbhGNQVk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 12:21:40 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DFCC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 09:18:48 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v7so3007398pgl.2
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 09:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/U2/ycfgfRQt0OB4ABpAAesB6TyhD4PV4afyZBKM4GI=;
        b=KSCrfe9myv2qxnputVLa/+gdPm7i5p9caxSxPLsWzA6XqLDXZgJQpFCPVWdbiIMgXy
         w8n4snKDkKGI++X3cvcojxIrUEUyqQEiLtDYbtlJGs2lip4KQzm9OZeDdGCtScL7jo1W
         VKpnolWX6fI9EKlQOOYyLFRoSG2EGbstgKBbEZU2dXHq7d4+ZYI2+M3ElN+UaQLU39NJ
         xPLZxUp6VkGiGPHzHJCvJa8YI9i6XO3gHudmmyLPva4jBibKX4OOKCCSHtHwvQncI3tZ
         jYKAOpctKeOhzD1fVhAJfSHsUR2pE8u2h4FCzQvKTHT2CgClA0PtjblJ8FG9L8TdoiiZ
         hAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/U2/ycfgfRQt0OB4ABpAAesB6TyhD4PV4afyZBKM4GI=;
        b=d9oh4lHUgEEp/+NEY+n7GpbV+kJSwXeMB4kZH5ARmupJSVPYjgU+GG4JJ+xTJVThCN
         C5xi9dteKlLFouUAM6iZdZMnNjdH+szCeaJ310/tHMEiPxSUKg6V3QLd4HPlyTPgObgW
         DRV6d6eRdQ94qBJgpxTKXuhH9gMszxiKmDx0oE0T2IOZQaNoqtjgNhFDpMKpC01KDdS1
         i1CVgZhtNbHImVin+COvSePGNPXWy92oVNlGfdYhsK1Bg3gtS6XlzTFu0cWhO4YffcTX
         F8WCgqT62iN6d8y9Fsbx8CMpntX1zaH+nyuLFUSY3BAQ2nLqsl/okx8ubiDDgYuFVx1t
         8cwg==
X-Gm-Message-State: AOAM530mc2bHG2f9EO4RM/dsj26hm/YbLtbHUmsv0D0ySZxollS4xzAx
        XuJJ8XLs1EewAwRNt4Vm375jTThJWURmhJsp
X-Google-Smtp-Source: ABdhPJyyQf/0mTuuT0EuL4jklJwORDApifbMm1vZ02YbJrNpqyc7a7peXcOnVpG3ZeefOzyAKiZUmw==
X-Received: by 2002:a63:eb04:: with SMTP id t4mr10647195pgh.84.1626279528102;
        Wed, 14 Jul 2021 09:18:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u23sm3958764pgk.38.2021.07.14.09.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 09:18:47 -0700 (PDT)
Message-ID: <60ef0e67.1c69fb81.adbd6.aba6@mx.google.com>
Date:   Wed, 14 Jul 2021 09:18:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
X-Kernelci-Kernel: v5.12.16-704-g811a519d7fbbb
Subject: stable-rc/queue/5.12 baseline: 203 runs,
 5 regressions (v5.12.16-704-g811a519d7fbbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 203 runs, 5 regressions (v5.12.16-704-g811a5=
19d7fbbb)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.16-704-g811a519d7fbbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.16-704-g811a519d7fbbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      811a519d7fbbb90138fdca36f307081d662ab6fa =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60eed7e60428244bae8a93be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
704-g811a519d7fbbb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
704-g811a519d7fbbb/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eed7e60428244bae8a9=
3bf
        new failure (last pass: v5.12.16-706-ge2aabcece18e) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60eefb16031bdb7bc38a93b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
704-g811a519d7fbbb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
704-g811a519d7fbbb/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eefb16031bdb7bc38a9=
3b3
        failing since 13 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60eee98c72282b62fd8a93ac

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
704-g811a519d7fbbb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
704-g811a519d7fbbb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eee98c72282b62fd8a93c4
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-14T13:41:14.784881  /lava-4196318/1/../bin/lava-test-case
    2021-07-14T13:41:14.801864  <8>[   14.616214] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-14T13:41:14.802122  /lava-4196318/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eee98c72282b62fd8a93dc
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-14T13:41:13.354568  /lava-4196318/1/../bin/lava-test-case
    2021-07-14T13:41:13.372274  <8>[   13.186320] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-14T13:41:13.372564  /lava-4196318/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eee98c72282b62fd8a93dd
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-14T13:41:12.335122  /lava-4196318/1/../bin/lava-test-case
    2021-07-14T13:41:12.340431  <8>[   12.166652] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
