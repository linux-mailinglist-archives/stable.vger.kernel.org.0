Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5C9406C7D
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhIJMwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbhIJMwJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 08:52:09 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64113C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 05:50:58 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t1so1724159pgv.3
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 05:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BvHEq0jwHXs4bkytzl0cqkTF99RGVf4DHi7k6Z2HgWc=;
        b=JOatsy8ZMwY8oluiE62E6uSU1sdbJ5ikhkqEO9/T8QcnqbP0Sr4ffMiWNvSaaY/2NJ
         Qu4kSmbEu0l7sSUJOesnH79KSeAFPW53ML3/l29XErHUykCG4z4BdPUeNhy4kxNenS05
         tCY1l2DpbA1BqXW7CuBuupt35ZyGUVKybeGm07C1ZZwFrwnGyv8SfezXdJmKQhSsHv8T
         mjAEP9xPPFnfllGfCwcP9bYj4XPfUEsx7VO8RdbMJYfP9TiZHiWVqFRyljDe12d+6LQg
         a1AvOpXIYr8tMPaVfjtjTx1VThy9UT0pD97oH/I6HM3XH8c2Es6RUjyReFwpmyuLOM6T
         IarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BvHEq0jwHXs4bkytzl0cqkTF99RGVf4DHi7k6Z2HgWc=;
        b=iprT0BUcbkqyJi6qkJH+tundhUU2Uwj3b/u9CKW/6HKGSRkpwMRSE8I5t0Pbtx/d38
         SPIaJPThjjf7CEBuzSi0xcwDG26Th/O/RN0qZ+kS2eXJZNCHCApvGN38c9F4yoJ4pVsH
         L/o9la6h8vTcDI6Q0wqwH34wDgFRvr3cJezrn6aOeqQh0QR7oZTKmDWL8DrU66uvDAg5
         i+Zv3o2bZETgZElpNBYlDdSKM4dho26yAdx2oP3L7QU+0axhAJux0O4KdVZwMUXRde1B
         yROk4z+T0TqY4di2iwrA1NnfDWbvZvvmcwSn2UzjR1PebH1vIzhExSLyimiJxwomiU9Z
         OjIQ==
X-Gm-Message-State: AOAM533OBRU6UAqRfjTc8mFfV+lbuMi5+BwXhDVnZcmgFls1YUH5vzmT
        A4KbJtk+bjYCRxSHPu8Sr0lekm/Mps3pufVy
X-Google-Smtp-Source: ABdhPJz/WJUPoZ65Hr29KehhrbJVT3v2t386gdO1XahXx7u8sAHxyjSH6ugqk9Ns17fRRaniaPhJOg==
X-Received: by 2002:a63:7984:: with SMTP id u126mr7143018pgc.468.1631278257803;
        Fri, 10 Sep 2021 05:50:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7sm4932813pja.21.2021.09.10.05.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 05:50:57 -0700 (PDT)
Message-ID: <613b54b1.1c69fb81.bc026.e2dc@mx.google.com>
Date:   Fri, 10 Sep 2021 05:50:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-16-g57271c4a00b1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 191 runs,
 6 regressions (v5.10.63-16-g57271c4a00b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 191 runs, 6 regressions (v5.10.63-16-g57271c=
4a00b1)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.63-16-g57271c4a00b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63-16-g57271c4a00b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57271c4a00b132769082f7181edd64d3bb5618fe =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b27af1193c59a89d59676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b27af1193c59a89d59=
677
        failing since 70 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b263e8ad5d9eb65d59692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b263e8ad5d9eb65d59=
693
        failing since 0 day (last pass: v5.10.63-1-g56ca228bc595, first fai=
l: v5.10.63-12-geb725290fd0a) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613b2e7e3e1a6cb1c0d5969d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613b2e7e3e1a6cb1c0d596b1
        failing since 87 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-10T10:07:40.807636  /lava-4489516/1/../bin/lava-test-case
    2021-09-10T10:07:40.824566  <8>[   13.894739] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613b2e7e3e1a6cb1c0d596c9
        failing since 87 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-10T10:07:39.388909  /lava-4489516/1/../bin/lava-test-case<8>[  =
 12.470212] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-10T10:07:39.389526     =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613b2e7e3e1a6cb1c0d596ca
        failing since 87 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-10T10:07:38.363732  /lava-4489516/1/../bin/lava-test-case
    2021-09-10T10:07:38.369416  <8>[   11.450768] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b24dd6cb040620ad596d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
16-g57271c4a00b1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b24dd6cb040620ad59=
6d6
        failing since 1 day (last pass: v5.10.63, first fail: v5.10.63-1-g5=
6ca228bc595) =

 =20
