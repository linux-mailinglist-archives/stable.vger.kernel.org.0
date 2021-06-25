Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7029E3B4737
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 18:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhFYQMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 12:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhFYQMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 12:12:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EFBC061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 09:09:53 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f10so4975803plg.0
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 09:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a6jCZe7wIM+4rlHIllbxte9WXOYQoD1eDcZbZ5Xdt8g=;
        b=hvgemUUjHbelqAX6kXOd2+Ubp/u08wAWWKkhd1LnKUHTGnKFaJfivU+Ki4zLDO6ToQ
         851549VZp2pwYRWYUWBroyTx5kaQujXWs3cls2tyUz+7Ma4kGfJ5Ewp35Mi3GteJ8nZj
         s3eEApaG1T82rhrcQmsp3jwaIe3boUcWiqaBiQwYzFY/YOcY7KouNuxPV2qQkeUE4Cqb
         wCMS2/0AE2NddJL1HprRcPcLEd37J+zsC9N5WX6Y4GlsgwqpNuHmoRaGUXR7C9E6tULT
         +V8XpcP9RDxCi110Krg4FJe+I4CXHonRYSOIDP72FCvydCOL8GOZnhv4HSk9Dr7TiBiF
         ojOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a6jCZe7wIM+4rlHIllbxte9WXOYQoD1eDcZbZ5Xdt8g=;
        b=uRud2uPPe1CkrMhF0efuNvIq3yqSaAxfF9oz+Re/m7wc5GGu0H1nxILn/p4eJh8sjb
         3m943JkcVkc2ayaiIgme+wDafvnjXNslZAsIcz1uMzUam63HvY7rexXYSgTOsTeCg92F
         7b5f4MWhmwPESD8OoLe4f8MWk/Emj3KRiIRuJDL2DGJZkijAaJ8MMvnzqHmRkRhspz0P
         Zqc0eUj+DiV2EZh0Q1joYUt60w8H6ksH6eWd8nb0daFp9XAOUmKtyS0KRxOgUtt/k5ls
         WemXzCwTx782fOKdgJwjB82WrItXGGSUTgD653nY3FNGyXz5B3hdC4JCvzPtEZ/+FuNR
         wvVA==
X-Gm-Message-State: AOAM531WLQI9dBw7BO+HlWjQc091i8KxwoaT0E2cxcsD7fa7IIefAhpO
        bvd8mbE/iAdOmRMN+rrzDNw+LWBtHy3PBJLx
X-Google-Smtp-Source: ABdhPJwMTM+ot/12P/u3GWUkzYKGNSRdgdUnTGKaQhdU+AZSgDyDqyVPl3i5bUBieAioCzVfVk+QeQ==
X-Received: by 2002:a17:90a:d913:: with SMTP id c19mr12194053pjv.142.1624637393076;
        Fri, 25 Jun 2021 09:09:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i6sm6794121pgg.50.2021.06.25.09.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 09:09:52 -0700 (PDT)
Message-ID: <60d5ffd0.1c69fb81.e71a4.20ec@mx.google.com>
Date:   Fri, 25 Jun 2021 09:09:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.13-10-g22f406ce15cb
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 161 runs,
 4 regressions (v5.12.13-10-g22f406ce15cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 161 runs, 4 regressions (v5.12.13-10-g22f406=
ce15cb)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.13-10-g22f406ce15cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.13-10-g22f406ce15cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22f406ce15cb9ac07afcb4bca9d749f631e7ccb4 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d5d0652134e3c89c41327a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
10-g22f406ce15cb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
10-g22f406ce15cb/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5d0652134e3c89c413=
27b
        failing since 0 day (last pass: v5.12.12-176-g9d7145f72380, first f=
ail: v5.12.13-1-g71fb3603a537) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d5e2295daa130b6f41327b

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
10-g22f406ce15cb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
10-g22f406ce15cb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5e2295daa130b6f413298
        failing since 10 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-25T14:03:14.950351  /lava-4094488/1/../bin/lava-test-case
    2021-06-25T14:03:14.955991  <8>[   11.605646] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5e2295daa130b6f413299
        failing since 10 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-25T14:03:15.987601  /lava-4094488/1/../bin/lava-test-case<8>[  =
 12.625181] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-25T14:03:15.987891  =

    2021-06-25T14:03:15.988060  /lava-4094488/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5e22a5daa130b6f4132b1
        failing since 10 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-25T14:03:17.396988  /lava-4094488/1/../bin/lava-test-case
    2021-06-25T14:03:17.414044  <8>[   14.052608] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
