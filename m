Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388153ED8F4
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhHPO2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 10:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhHPO2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 10:28:22 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24226C061764
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 07:27:51 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so14385681pjb.3
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zvsNDoIVoG2f6MOtO+7oicVBPusIit1Z36VfoZBlgjA=;
        b=OKuK2zj2d+G/MR2/V3lCbxESp8LfR5eycwpPtvkDCSjAwIu7Tj9NzRMQb1QjypHANq
         HTc8kMr6Uu1vlfx5wySn+tySLJtMlUDcYuf49hbWADQfAZVjCzTwCtAX+5ZUHfgDv5h7
         R//7ne4Sd9MBO9M9L6xgYso3ydgsxi4HPa2znJ0j4O7ttFBXiYsUIq57tPM1svbBV6/N
         H6+wUOTHRb/vFxfahkNIPC0Kx7bmpCWv/k7neO3lF/gkBEG49N/HmEH0MzDwqkk9ll2x
         mXvt6TyooUjL1ynh2rO61Hvs8hycRKvomypm88wL9MwjGdiHngreElBpOrK4euzCnF0B
         JnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zvsNDoIVoG2f6MOtO+7oicVBPusIit1Z36VfoZBlgjA=;
        b=noGYN/OIj3XZk0U8skVqn2MtzBjbgGTFduofnqPjswrNQdH31D4Zqx1XGbG9qOJqXt
         TzrLbh0CjABMyr7JPTHKvc1fBdj0+wDnqlWmtTrhZ4mBSg8KRYiunniZNgdmS9Exsk7W
         GdBX7YL4da3kywdKuSQ7i2cGuA2YCNCsTAfb0uj/REqVCTqTXOMVj/Ptt75hvPugwNWC
         Rq/B2hkHcD9VArznZvW3J6aodeVwrYxMg/cq/n1NPb6Rj6nAyWbdzIcgMKPtBxPHcktG
         HZatyKWr13Q4UADpfjKcEOv8vrwLjIh1yfAJoj3f2jBvUVikWR94RpPPbmkpuX7inDJF
         uKaA==
X-Gm-Message-State: AOAM533++rRLcU7Z+0vAWNVyyz+7w13soLxcEjJ973I6sA4VD8Zf2ROi
        MbeqkIOF/pGHnvx6fZQoxaJrSVT7wI3vMAvC
X-Google-Smtp-Source: ABdhPJzmFg0dJnl46pMQ0sVuY6SHHTyH0NxNPNvuyFgPWvHTuMvciJe1o0yloHpEhIT1U3lG0cYEKQ==
X-Received: by 2002:a63:2541:: with SMTP id l62mr16699086pgl.183.1629124069786;
        Mon, 16 Aug 2021 07:27:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm1003638pfl.32.2021.08.16.07.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 07:27:49 -0700 (PDT)
Message-ID: <611a75e5.1c69fb81.7503a.265e@mx.google.com>
Date:   Mon, 16 Aug 2021 07:27:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.59-96-ge4ba0182192d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 177 runs,
 6 regressions (v5.10.59-96-ge4ba0182192d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 177 runs, 6 regressions (v5.10.59-96-ge4ba01=
82192d)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 1          =

imx6ul-14x14-evk         | arm   | lab-nxp       | gcc-8    | multi_v7_defc=
onfig | 1          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.59-96-ge4ba0182192d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.59-96-ge4ba0182192d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4ba0182192dd0ea1d21b956e474ca773cd1dc05 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/611a461ad69336a5dfb1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611a461ad69336a5dfb13=
66e
        failing since 45 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611a45284ea37c91b1b136bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611a45284ea37c91b1b13=
6bc
        new failure (last pass: v5.10.57-221-g59fda4eb754b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6ul-14x14-evk         | arm   | lab-nxp       | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611a465a0efd23f4e3b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-14x14=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611a465a0efd23f4e3b13=
66a
        new failure (last pass: v5.10.57-221-g59fda4eb754b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/611a46e48ce29e5f7db13661

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-ge4ba0182192d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611a46e48ce29e5f7db13679
        failing since 62 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-16T11:07:09.741629  /lava-4369931/1/../bin/lava-test-case
    2021-08-16T11:07:09.758622  <8>[   42.881928] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-16T11:07:09.759036  /lava-4369931/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611a46e48ce29e5f7db13690
        failing since 62 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-16T11:07:08.314624  /lava-4369931/1/../bin/lava-test-case
    2021-08-16T11:07:08.332620  <8>[   41.454745] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611a46e48ce29e5f7db13691
        failing since 62 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-16T11:07:07.294508  /lava-4369931/1/../bin/lava-test-case
    2021-08-16T11:07:07.300578  <8>[   40.435152] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
