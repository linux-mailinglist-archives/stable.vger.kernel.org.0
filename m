Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7083FE2D4
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243346AbhIATRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhIATRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 15:17:31 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D36C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 12:16:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so440212pjr.1
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 12:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NG2XU7PLD9r7FTqMSwCeLbcT0MFQ5+XyC0w7t+oGd90=;
        b=h1Qhn/+gebsSlkxcbT6Q5iUd+7+pnyKkO/05dLTpuhZUKiWKaKUv4K33QXGMMtd3T4
         E6gtBNQXtFbw9VieRCo4gZth7jTbZroIDmPF7GPpJ5bLLmmI8G/KknAa2ZufzGGN2LZU
         Hm94uyXtEwCEtAoh7ufbsA0GO7tSSVRNRNRxf820aXD5j4rCcdm0tcm95iwLDkZvGRkM
         sx54qEmEp+qjF49rYFe22VHPa48x93wigEC+wPZQkIFsuu0y9r04zjjZp6mA/t+k3qDa
         sRqVYMq1ljrNi1HO5vyoX9f3TQZLEYKpESZEpk5dBLe96g99wsaisEPFeC0xfzdgZxv/
         ZiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NG2XU7PLD9r7FTqMSwCeLbcT0MFQ5+XyC0w7t+oGd90=;
        b=jh8uI9E8ato8Fg4114VA2OLCQ+DYT7M9mSvhX3fzDozssUa10wXT/ANwWYo9HXS0uW
         3nk0eHAmIPMOY7zXx4kJWBcGDsBRgMSlfqTfKK8P3qD6rRKjHkNwBaHcyNvjdaU0XjI6
         dXQfqhgj4V0AM96WIlOaDRV0jX5PsCQOmKCfEjiqIwQ0x+NyhnkaKBemnFpo6aDWHm8R
         6BdYcYbCbpy9C1YI+BO80oHwH38q6BxLhjASM4yqdkcjIzlCZsAWFRmA4aT84hUUjLUq
         uszYupWqP3DWQqoHbUcyMWVJ8dBtJArdwDU0F/HzQIhgIkymm2eGnsnpNpq6O4pHUIXn
         EfFg==
X-Gm-Message-State: AOAM533G7MOzyevFDE/QCNl7U51N0JoQNcPhzpJrpKTAgta2GjPebr28
        Tu1VI5z3zkLKy3b2IRU2PKaspDjLnoOPLe1WgtY=
X-Google-Smtp-Source: ABdhPJyl7ehBuGlXuuoXxlgphLZVF4r4TqsvRKoHAMzWlCbafL0eGbeP4nIzc6wTT7anKA1YKFg5ow==
X-Received: by 2002:a17:902:d50b:b0:138:8d81:95f1 with SMTP id b11-20020a170902d50b00b001388d8195f1mr883550plg.58.1630523793092;
        Wed, 01 Sep 2021 12:16:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm271019pjp.50.2021.09.01.12.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 12:16:32 -0700 (PDT)
Message-ID: <612fd190.1c69fb81.4ed9e.1284@mx.google.com>
Date:   Wed, 01 Sep 2021 12:16:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.61-103-g4cd5172c2ba3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 196 runs,
 5 regressions (v5.10.61-103-g4cd5172c2ba3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 196 runs, 5 regressions (v5.10.61-103-g4cd51=
72c2ba3)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-103-g4cd5172c2ba3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-103-g4cd5172c2ba3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4cd5172c2ba314bd18f1a7ef617d4f1b6b3d95aa =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612fa4debedbbae92fd5968c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
103-g4cd5172c2ba3/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
103-g4cd5172c2ba3/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fa4debedbbae92fd59=
68d
        failing since 62 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/612fa49f2a3aaf1545d59677

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
103-g4cd5172c2ba3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
103-g4cd5172c2ba3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/612fa49f2a3aaf1545d59687
        failing since 78 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-01T16:04:33.711541  /lava-4428836/1/../bin/lava-test-case
    2021-09-01T16:04:33.729044  <8>[   13.244223] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-01T16:04:33.729536  /lava-4428836/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/612fa49f2a3aaf1545d5969f
        failing since 78 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-01T16:04:32.284670  /lava-4428836/1/../bin/lava-test-case
    2021-09-01T16:04:32.302939  <8>[   11.817103] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-01T16:04:32.303425  /lava-4428836/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/612fa49f2a3aaf1545d596a0
        failing since 78 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-01T16:04:31.264828  /lava-4428836/1/../bin/lava-test-case
    2021-09-01T16:04:31.270749  <8>[   10.797344] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/612fa19c90d6726429d596dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
103-g4cd5172c2ba3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
103-g4cd5172c2ba3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fa19c90d6726429d59=
6de
        new failure (last pass: v5.10.61-100-g568e40c72849) =

 =20
