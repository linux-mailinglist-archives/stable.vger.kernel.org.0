Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82DD03F8AB3
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 17:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhHZPIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 11:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242899AbhHZPIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 11:08:12 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21EFC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 08:07:17 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w7so2172938pgk.13
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 08:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n7q3FL5nwihU1h4oY++t2mak0ZDXWvwHBWl/B7Zv8bg=;
        b=cYJ/OIN/2lJCHAbk8fCcAtlzk/dwD0Ert0/DNCG1rFzLbv6jWp9Z00wYFv5KU7VhZl
         Tc8btg/ansFo+SOpPQVchHyn5DMyPCFKOtWbugL0mEjwOGJmVIWPTcwR3+V64zF9Jg87
         Jwz+I4bL8sI9YHi8otnW4ESP+Ic3YNrcoHUl9wJwuL3dzlyyfYnRR/7IYtvILgsvO3gB
         UbzFJg6+5QYIqOYdePZDy7qyAp7KaQLRvMpWq4x3R3A68BN0LXq3D00yjRFAFAu4jfc2
         SM6BSKBHuW21n/HqK9BUrbQb0H4wQLxoDEcyJdR57LyhKynEIZ1L5lOrMo8d8oC7CXdm
         /YGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n7q3FL5nwihU1h4oY++t2mak0ZDXWvwHBWl/B7Zv8bg=;
        b=R/ftleXzKp3Y0pEN5fpXoFyFmhNOcZDeCXkIpheN+3agZBy8wrTA9euXIE14QJvvg7
         75ue5GZ01sVOYZrE27E28uHBaeuU+xXB7XzhiV8akLj11pFlAFjba9EXOj2dXNeBmRiG
         xLQbrOCBTxog6OqRQKfUeMkJ7Oq6VJVLW84FIvWKUxy2oP5gFl7pULal3jHeGcVRUXKU
         5mv5X1LFsinzafQajUAufXqxhF7XJl1cU+FYpmiaAtO6EGqYrwuXioGpQfbgEx6CR7k2
         gjDXY+JMQ6wrL2UkohN1pKUfUxng0zdf+1EdUozQJCvVsrbHDnoTi+VEX7Hv3EcB04NL
         U8ag==
X-Gm-Message-State: AOAM532hcYqiD/IbShDdIDpzrF3QO5zlRIAXSbTa6lCuLJwMUNLITsZc
        gkvqTjXeI8HSpYUunK1Xu4FfGkS+IkqN1qLX
X-Google-Smtp-Source: ABdhPJxzYtwvL2UjNMknZ6SpIxSM6DFyioKrUOtEg43I+WEFCwu8iK92UASqiSXrq56wTqas8ay9iA==
X-Received: by 2002:a65:6a0d:: with SMTP id m13mr3687227pgu.371.1629990436985;
        Thu, 26 Aug 2021 08:07:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1sm4048903pgt.63.2021.08.26.08.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 08:07:16 -0700 (PDT)
Message-ID: <6127ae24.1c69fb81.7e6b9.b3ed@mx.google.com>
Date:   Thu, 26 Aug 2021 08:07:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.244-63-gafa238a9c097
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 155 runs,
 5 regressions (v4.14.244-63-gafa238a9c097)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 155 runs, 5 regressions (v4.14.244-63-gafa23=
8a9c097)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-63-gafa238a9c097/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-63-gafa238a9c097
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afa238a9c09718124fdf29ae54a338f3447982e1 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls2088a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61277d3f40374f24138e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gafa238a9c097/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gafa238a9c097/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61277d3f40374f24138e2=
c78
        failing since 1 day (last pass: v4.14.244-55-g3a7e56eceeeb, first f=
ail: v4.14.244-63-gc883e4dd09f2) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/612785d6e3dd3cf7408e2c7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gafa238a9c097/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gafa238a9c097/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612785d6e3dd3cf7408e2=
c7b
        failing since 178 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61277e4db22ae12d528e2c89

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gafa238a9c097/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-63-gafa238a9c097/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61277e4db22ae12d528e2c9d
        failing since 72 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-26T11:42:54.124990  /lava-4416052/1/../bin/lava-test-case
    2021-08-26T11:42:54.142442  [   16.778944] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-26T11:42:54.142940  /lava-4416052/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61277e4db22ae12d528e2caf
        failing since 72 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61277e4db22ae12d528e2cb0
        failing since 72 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-26T11:42:50.674961  /lava-4416052/1/../bin/lava-test-case
    2021-08-26T11:42:50.680341  [   13.329272] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
