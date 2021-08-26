Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F683F8E91
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243424AbhHZTPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 15:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbhHZTPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 15:15:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2AAC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:14:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id e15so2399387plh.8
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 12:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PY0jhBTpi1J4vqZ0sCKWuC+qR5/uJg1zwtgKVLBeJwg=;
        b=sK/cjDRRN/YB0WqXSjPX4xQY77yG3HjRt+bALU5GBJGZOTTrarcQYKmLGQGGpp1Z19
         Mzr3gAWAQ4cFf8M+HXwVwhcbUyBYOGK5dv9byA0q5Y2xSWuMVwJpPrcXUDLl8ZJcrMhZ
         kS1AZWqcOoNg6dEZgtknr/KGMQCtMS9D55Me3qyU9gDkXDMn6FYIA0/KHZHAbAfPJiif
         sxU7+VW7sfrzOLm9duYZ8Jh6LHOx9vXEl+rfSeWrwOD7ohCoITpI6h1X31xNfmTHdUYf
         kceUs04C2spId93pXZhub8UZglZbAw8JT/6ijglVAPJvzis9nfOkeiitU41qW9KukYaM
         2ASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PY0jhBTpi1J4vqZ0sCKWuC+qR5/uJg1zwtgKVLBeJwg=;
        b=qXiTw3J5W2yQjINTfawSSxWDK7Y9Mi3+4jCklucwqSSfiCEfcvWZybm7uzB2X3+4O7
         ONbppmr3cKjfVUsy+Niw+SWy7WGlRjzpJ7/htBxJUhRzupvh6Z1uRx3/7zLcenBSES01
         lFbQM/koK8QBaNhyLG7gw3Pck0s5P8naVKB93zomZA0kqrx29c9r7UNHYRueoPEBmxsT
         yPKQ0TFc/Z1pR8/vKyA7ugZq90Gwjjbyn++Q9UR+o/i3JyWFiyoYvQr3D/NnXFOjQvqe
         u+BKYZgrz7zvKf3UYIPgbWiay2of+GAI30itL72d/xSDkNEx3zuilOegO7cIXX0dxggI
         FlQg==
X-Gm-Message-State: AOAM530ls5wiymUqgGjHWwHMfqu5y0xel4dOEt18lQeqML9yxoMFx3sV
        ux9b9a78ft3JsmLtJy6M14goNrQ2Zk0APZ8O
X-Google-Smtp-Source: ABdhPJyoaF6Z9MqSt1azVbzBC/HH7PWjOOyHvCmDzWl+danQHR+j4ymtcuYrwChpE4Di+o5xrCiVrA==
X-Received: by 2002:a17:90a:b016:: with SMTP id x22mr18343359pjq.205.1630005291294;
        Thu, 26 Aug 2021 12:14:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm3533923pjq.5.2021.08.26.12.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:14:51 -0700 (PDT)
Message-ID: <6127e82b.1c69fb81.ab9da.9d27@mx.google.com>
Date:   Thu, 26 Aug 2021 12:14:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.60-94-g36cbc97d5d99
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 7 regressions (v5.10.60-94-g36cbc97d5d99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 189 runs, 7 regressions (v5.10.60-94-g36cbc9=
7d5d99)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
am57xx-beagle-x15            | arm   | lab-baylibre  | gcc-8    | omap2plus=
_defconfig | 1          =

hip07-d05                    | arm64 | lab-collabora | gcc-8    | defconfig=
           | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
           | 1          =

rk3288-veyron-jaq            | arm   | lab-collabora | gcc-8    | multi_v7_=
defconfig  | 3          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-8    | defconfig=
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-94-g36cbc97d5d99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-94-g36cbc97d5d99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36cbc97d5d99a9c2f51d3679d3454ee9fdaad205 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
am57xx-beagle-x15            | arm   | lab-baylibre  | gcc-8    | omap2plus=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6127b3e40787e2a0018e2c8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-am57xx=
-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-am57xx=
-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b3e40787e2a0018e2=
c8d
        new failure (last pass: v5.10.60-94-g933a0fb6cc52) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
hip07-d05                    | arm64 | lab-collabora | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6127d2e607338fa74e8e2c92

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127d2e607338fa74e8e2=
c93
        failing since 56 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6127b162b63f71b25b8e2c9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-a31=
1d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b162b63f71b25b8e2=
c9b
        new failure (last pass: v5.10.60-94-g933a0fb6cc52) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
rk3288-veyron-jaq            | arm   | lab-collabora | gcc-8    | multi_v7_=
defconfig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6127b9316b3b8da32a8e2c85

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6127b9316b3b8da32a8e2c99
        failing since 72 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-26T15:54:09.420421  /lava-4418494/1/../bin/lava-test-case
    2021-08-26T15:54:09.437942  <8>[   13.762231] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-26T15:54:09.438380  /lava-4418494/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6127b9316b3b8da32a8e2cb1
        failing since 72 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-26T15:54:07.994657  /lava-4418494/1/../bin/lava-test-case
    2021-08-26T15:54:08.011768  <8>[   12.335564] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-26T15:54:08.012232  /lava-4418494/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6127b9316b3b8da32a8e2cb2
        failing since 72 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-26T15:54:06.974731  /lava-4418494/1/../bin/lava-test-case
    2021-08-26T15:54:06.980007  <8>[   11.315517] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/6127b0bb3b4c8001dd8e2cb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
94-g36cbc97d5d99/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6127b0bb3b4c8001dd8e2=
cb2
        new failure (last pass: v5.10.60-94-g933a0fb6cc52) =

 =20
