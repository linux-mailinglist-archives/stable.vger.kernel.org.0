Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16203C92EF
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 23:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhGNVUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 17:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhGNVUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 17:20:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF64DC06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 14:17:19 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q10so3153362pfj.12
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 14:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KAdorowrGLoPEifYU57LSOtoytr0ZhRgmHRg7/7fjWw=;
        b=bxeH4ykkWuS1tj8LGRDWyQ8OJgw8V/abWGpUzPA8Ct+qjcttLKi0AXYq54DCIm1DM2
         8KAQjbr7lIAM6WH+rDc7u3M2ofblTPG2qDE3ek1XeS/QdaECOLav+c1erzdyPX/1shR2
         kxxmSPC3AkYfo+YR1nAHVuRCibjxFZprWC9AtEJ7v45CJB9n6MS4vTaHEjbj5MoLa3A8
         WuI53caBsxvt6nVtq/NSkMu77Qu3U3OdHYbsa8N/BsZWnOrBdqivUooNv5BliWm0dfQG
         arsHJ+uSzb9Vfzpzp0a+6PjqHlQUohCX94k7aPB/dmfNfPX+oSurSHTBeCjcWT2Y5iJl
         7Lkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KAdorowrGLoPEifYU57LSOtoytr0ZhRgmHRg7/7fjWw=;
        b=jXX0zCbCXyl2XgcLF6y6bjn9hzxJKRbaZSeMEgk3sYKIbkWiwUdiZdnN5IQ6f1rm+A
         FLqFv53ziazfHsZMiL2HrtcHffAB/HR1nWmVVYJM4GIEor0HaMlVPRv0OtzgG7tQTS2C
         ypl8YbTWQbp+5osIy2RBUMMks8odtl6ZLnN4HOvcjLhaCo4kRsIlwQ0a775/Cyvz++kw
         lPRlIuDp4VdaKU9DBdgCdlgbH7H1iowp00zmJOVlIu2gWpzlWyxR6ZWz6Un47EowFG+j
         SqEewG9o82stgMYvb1LqetND8GNB66xjt7pQNFlt8f8pdxdbMO9SNb3p4LZ/KDzFkVoA
         unxg==
X-Gm-Message-State: AOAM532zv/+WRg6Wyn5BStrgUFYCdM2Kcz0THnGlTjom0ZgKlSTpGwC8
        WsrasZE4nv+XebW9tmpr3lqUCerBYscw9TIc
X-Google-Smtp-Source: ABdhPJxcrkSCDwJnmikyS168VIx7PKAuKXTVaEyoKvneOrWjN/VacHK7PR/ubpANtZHqyinTQGbqlw==
X-Received: by 2002:a63:f556:: with SMTP id e22mr31178pgk.189.1626297438993;
        Wed, 14 Jul 2021 14:17:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13sm3947271pgp.16.2021.07.14.14.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 14:17:18 -0700 (PDT)
Message-ID: <60ef545e.1c69fb81.e8fbb.c752@mx.google.com>
Date:   Wed, 14 Jul 2021 14:17:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
X-Kernelci-Kernel: v5.12.16-702-gf996b03ef63d7
Subject: stable-rc/queue/5.12 baseline: 182 runs,
 7 regressions (v5.12.16-702-gf996b03ef63d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 182 runs, 7 regressions (v5.12.16-702-gf996b=
03ef63d7)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
 | 1          =

beagle-xm          | arm   | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

beagle-xm          | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 1          =

hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
 | 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.16-702-gf996b03ef63d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.16-702-gf996b03ef63d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f996b03ef63d7d732109ed0b0a95962cba14323c =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef1faddd03b817228a939e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef1faddd03b817228a9=
39f
        failing since 0 day (last pass: v5.12.16-706-ge2aabcece18e, first f=
ail: v5.12.16-704-g811a519d7fbbb) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
beagle-xm          | arm   | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef236ba44f9d5c658a93cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef236ba44f9d5c658a9=
3cd
        new failure (last pass: v5.12.16-704-g811a519d7fbbb) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
beagle-xm          | arm   | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef2111d96c15a7c68a93b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef2111d96c15a7c68a9=
3b2
        new failure (last pass: v5.12.16-704-g811a519d7fbbb) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
hip07-d05          | arm64 | lab-collabora | gcc-8    | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef23caf1aaeedd8f8a93ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef23caf1aaeedd8f8a9=
3ac
        failing since 13 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform           | arch  | lab           | compiler | defconfig          =
 | regressions
-------------------+-------+---------------+----------+--------------------=
-+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 3          =


  Details:     https://kernelci.org/test/plan/id/60ef2f3a434bfebaff8a93b8

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
702-gf996b03ef63d7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ef2f3a434bfebaff8a93d0
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-14T18:38:17.613828  /lava-4197970/1/../bin/lava-test-case
    2021-07-14T18:38:17.630988  <8>[   14.857208] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-14T18:38:17.631481  /lava-4197970/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ef2f3a434bfebaff8a93e5
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-14T18:38:16.204513  /lava-4197970/1/../bin/lava-test-case<8>[  =
 13.429380] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-14T18:38:16.205152  =

    2021-07-14T18:38:16.205620  /lava-4197970/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ef2f3a434bfebaff8a93e6
        failing since 29 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-14T18:38:15.165785  /lava-4197970/1/../bin/lava-test-case
    2021-07-14T18:38:15.171544  <8>[   12.409542] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
