Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CE03BF14C
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 23:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhGGVT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 17:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhGGVT6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Jul 2021 17:19:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE36C061574
        for <stable@vger.kernel.org>; Wed,  7 Jul 2021 14:17:18 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h1so1787862plf.6
        for <stable@vger.kernel.org>; Wed, 07 Jul 2021 14:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DwCEZM4e0cebR4fpWcWUnrbr2tj5KAhRUi/74mM/bNY=;
        b=uGTBPYI2aKI3kK6JsdPzRxOSt3/EBO+yFdE1QEvji1Fxtp6GpqAYuD6LEXE9mBUudj
         iBDolCFaXMAa5Z86bFRLRxOoWRvpPCZj6JJfZWDU5FNRhtxCWM1xqFoa6SETR8T2yIGx
         MX5QUXqbep03wTTF0Oz3EXxUD3dyh1WzZu6x2QyJeD2OM0vTvpLbNwQOpKEJ4P9UM2O+
         5BF8ydCmn0HEK2jUQdoaSN87pV/ZtZaxTSkRV7+tAOsYhFGSKOrpEpB96jevP2Lu7Xhb
         /3Yf9z0odoMf0evV+wX1/Aj/hVKb94wPq9PwM/6yDftm2kuxcjrKBhxRX+xwo4SHMt0v
         Q+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DwCEZM4e0cebR4fpWcWUnrbr2tj5KAhRUi/74mM/bNY=;
        b=CQKleGEU9JyKPbAbDis8a3V0AsGVaiBSej3IUoUBXDUOzZBVFTdBtpIGA69rtrWgkL
         0wjiLdsPt0olF0N5THn5Qg5bwqxBKhG/6qb6CGXxQOPLrwYKOnu9Cs8oASQ7vWIs+uTr
         B13/nOCDqBNlIcysUIUOq6fWnZJFaXxv04WYVstU/nBHbVOa4qiRsmcl/tYDz7QqKeth
         zfLIsNxXGg7f+UEGd5aJHvFcV67bJlnhupxDUTAQE+6L5iPRGEZdcvk+GZjvES4qXJQY
         l1p69ZGKya0wEZHh8bfqdbnd4z0ibCJRUr0Bs3o1hbk9xQyL2TD/n+bLk5cnQZEjj/MS
         yXcA==
X-Gm-Message-State: AOAM531pBl+QlrpCsopLyvuF/xAi2/MeHoy4sVDlqjkVRrjSzK9cE846
        KwcdObRDCB9SBCA4MHaLLTP/vWxYPzHcGR0V
X-Google-Smtp-Source: ABdhPJxXmQt6RY5P4vNK8Fi2Yh7rMVQ5egmcFdC42kpZFLNF9XinSHt1Dbs54SqfCcIYKlx6suSIWg==
X-Received: by 2002:a17:902:6b84:b029:ee:f966:1911 with SMTP id p4-20020a1709026b84b02900eef9661911mr22836553plk.69.1625692637352;
        Wed, 07 Jul 2021 14:17:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm110190pjq.14.2021.07.07.14.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 14:17:17 -0700 (PDT)
Message-ID: <60e619dd.1c69fb81.b984f.0a41@mx.google.com>
Date:   Wed, 07 Jul 2021 14:17:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.238-21-g49bfe4ee578d0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 169 runs,
 4 regressions (v4.14.238-21-g49bfe4ee578d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 169 runs, 4 regressions (v4.14.238-21-g49bfe=
4ee578d0)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.238-21-g49bfe4ee578d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-21-g49bfe4ee578d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      49bfe4ee578d04f7e5f29a543daee41f820ec89d =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e5fc6a613e5e03a91179cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g49bfe4ee578d0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g49bfe4ee578d0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e5fc6a613e5e03a9117=
9cc
        failing since 128 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60e5e9e3d18ee1cf50117982

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g49bfe4ee578d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g49bfe4ee578d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e5e9e3d18ee1cf50117996
        failing since 22 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-07T17:52:31.201500  /lava-4153498/1/../bin/lava-test-case
    2021-07-07T17:52:31.218678  [   16.651931] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-07T17:52:31.219158  /lava-4153498/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e5e9e3d18ee1cf501179af
        failing since 22 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-07T17:52:27.755939  /lava-4153498/1/../bin/lava-test-case[   13=
.201435] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-07-07T17:52:27.756348  =

    2021-07-07T17:52:28.769013  /lava-4153498/1/../bin/lava-test-case
    2021-07-07T17:52:28.786534  [   14.220263] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e5e9e3d18ee1cf501179b0
        failing since 22 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
