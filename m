Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992663DE18F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 23:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhHBVVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 17:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbhHBVVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 17:21:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F723C061796
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 14:21:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso1868060pjo.1
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 14:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cIS54Deaguz0OlVAaiCGVRN9gtseVCQRR+Nhpxnm6FY=;
        b=WEixjz9D8JJ8yIhUhcgf/Klr8wL4p4ikX3kwrKsSP3HvVb42qseZ5j33Pwibu7yE9M
         oASXdgJJJ+ymZSV39k598MTwqmbGLhILzZfm3gWGcLwiQc9r60AHRoRapjMHNxmbvB6z
         ywWcB+dm4RyJzhCVktjiILcYRDg9KM2MAO2Mz6Z7ENeQIP7TCKeg9AQhHkbCwbfbteE0
         uzteFJZgQhgFK4/ljRz654X7vwAX0PyWwQSckkPcoFUWzTpI7T1BviPMGrYYV7reKDCT
         Zo9JMMZ1zDmBxjtyY4DnhC1SCD1jY/lfyiW9SGMDKzNT27NCBHLw/F7HA6GsUUECFvdL
         8p5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cIS54Deaguz0OlVAaiCGVRN9gtseVCQRR+Nhpxnm6FY=;
        b=bMxfy7RL1buZQzhO37/29e0//aM5JzSRiK1qwdrKA5OUtckFPrLcw74YlzM89xf5uL
         feqj41R3y95wFVQCkwqX948QH7hLMatFOfdHFAPh188M3dS1onvgu0Hc6WuzKFzd61/n
         KYlTzHySmHzGHjse9KI4JtoYNpoE7IzQ+aTHPkZXd+ZF4AyMKAf/VZRUku7QgcNhP2GM
         hnWuq5SvCwPsy2DZCCE5qW1zh2qHPhVMPYqNL3ZQzREdsFNIkKn3/AO7WFhweXTbx0AV
         8cAydwA49MkgM7NNjK5k5c8id4sKJyoya8vbzk4z5XEFuqe9Wc1dN5IY+I/kbW4d+4eW
         L9dQ==
X-Gm-Message-State: AOAM532g5OedK1a7d38zCgLM0S4Bg3FgSsVyvfLQ0JF92QUhfeVFSN2R
        uNc0IesuerFRHUtSZwFA2C32vg5SLFMnVu+3
X-Google-Smtp-Source: ABdhPJwFh0C9DxTKOPQrWoyPrEyCBi95opD76+d0EplpZTFJ2nd7qShSkuIZvJ4mDUVY0sKcfNCwDA==
X-Received: by 2002:a05:6a00:24d1:b029:33d:d5ad:b903 with SMTP id d17-20020a056a0024d1b029033dd5adb903mr19297834pfv.0.1627939294715;
        Mon, 02 Aug 2021 14:21:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm14085025pgs.23.2021.08.02.14.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:21:34 -0700 (PDT)
Message-ID: <610861de.1c69fb81.b7d23.901b@mx.google.com>
Date:   Mon, 02 Aug 2021 14:21:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.137-40-g8601afe73869
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 166 runs,
 4 regressions (v5.4.137-40-g8601afe73869)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 166 runs, 4 regressions (v5.4.137-40-g8601afe=
73869)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.137-40-g8601afe73869/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.137-40-g8601afe73869
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8601afe73869a6cb4fd2efdbea502b6b6ead35b8 =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/610826fa9ec430aa1db13676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
0-g8601afe73869/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
0-g8601afe73869/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610826fa9ec430aa1db13=
677
        new failure (last pass: v5.4.137-41-ge6ba61752450) =

 =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6108415d76c165a7b6b13669

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
0-g8601afe73869/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
0-g8601afe73869/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6108415e76c165a7b6b13687
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T19:02:39.740665  /lava-4308960/1/../bin/lava-test-case
    2021-08-02T19:02:39.746101  <8>[   13.775021] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6108415e76c165a7b6b13688
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T19:02:38.721880  /lava-4308960/1/../bin/lava-test-case
    2021-08-02T19:02:38.727389  <8>[   12.755910] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6108415e76c165a7b6b136b1
        failing since 48 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-02T19:02:41.185923  /lava-4308960/1/../bin/lava-test-case<8>[  =
 15.201554] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-02T19:02:41.186248  =

    2021-08-02T19:02:41.186496  /lava-4308960/1/../bin/lava-test-case   =

 =20
