Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F363FF50A
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 22:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhIBUkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 16:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344271AbhIBUkK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 16:40:10 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6176DC061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 13:39:11 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q68so3238969pga.9
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 13:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WFkSt1Ebq2jTnEe99H9sh0pYkmDl87GNcQZE4wsBNY0=;
        b=wD9YdHOmSlw6o+h29FNAp+r3K6PMpQZrWxuPcvG4RULXZOvrbIpr4PYL97V8Wgr+JT
         uCJqjJWTbCWqsU9yFyLI3/B/kSgGxM8aDPWt36eadCTPhngzvSQyZ8ZU6FDgsDaGRYML
         y4mBH96jY9IdXzvIdpeu0Uzlpz4A86krH8nRABuSGq5s2rrFysewqK1xoynLKHDV2eip
         XlCwwyVzBbvMjJ3rHBoNsga+lxzNnJkFMRbfX/3/8HFDBA94ohrQ4BX/FPi8GI/gfSEt
         yqXRXIxd1NsQPMy8sGiMhNA7G7pCTvy0cAWDo1laCIwQXfMiKiXHr6x3o6RTOHCtwAmp
         2YmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WFkSt1Ebq2jTnEe99H9sh0pYkmDl87GNcQZE4wsBNY0=;
        b=cy9+OLSf4Hi2txicwa3oM6Ypx8fpKmSRLjRutXyxs8gU7ZQy6tf+WGfghnGw+l0MB6
         hzfpu2v3A/TEfnDrVD8R3dk9qOwh4lbQKFurWNznhtZ9JNHoqdTDUu3WVFKkC+fZsLZg
         N3iTn88FdpGyaCNYoIVhc/LGGJwDVFb0wAoBryGTR0s71nsr57UdR62bNp8pA4sPdwII
         LnUwPsJWg/WEQsJvivwWxdnvSJ+fUTw1N7cP8MR+aLY427rgSdQNF2ytmAbi8YLd6gDU
         g/AWE0DMwdntEHARtKsqXGPISKamwlwnR3Z+hE2fKkTaGjv526u+sXSoUbkcfEfdIkjp
         bBpg==
X-Gm-Message-State: AOAM533lejkFzbo8+Z0YulvrOobrwceW7DHKKMHRT0o3Fzbv4QbBAJYw
        0Hkxwakg1TgUudoyfJhzaC7He4tFQ5Fopfck
X-Google-Smtp-Source: ABdhPJzSbvPRyDKm9nPA+uC4ELE5kpEM/OCcgGWEXDUpgq0xlpBq6ay9tSHcJdPIqFgyrL5vH5qb8Q==
X-Received: by 2002:a63:fe41:: with SMTP id x1mr208394pgj.272.1630615150577;
        Thu, 02 Sep 2021 13:39:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a12sm2907715pjq.16.2021.09.02.13.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:39:10 -0700 (PDT)
Message-ID: <6131366e.1c69fb81.e150.8092@mx.google.com>
Date:   Thu, 02 Sep 2021 13:39:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.245-23-gec888d1c52cb
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 180 runs,
 4 regressions (v4.14.245-23-gec888d1c52cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 180 runs, 4 regressions (v4.14.245-23-gec888=
d1c52cb)

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
nel/v4.14.245-23-gec888d1c52cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.245-23-gec888d1c52cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ec888d1c52cb234611f070400a987dd19ea07ec5 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61311a0d53edf89811d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-gec888d1c52cb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-gec888d1c52cb/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61311a0d53edf89811d59=
666
        failing since 185 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61311265e09b7f9650d596a0

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-gec888d1c52cb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.245=
-23-gec888d1c52cb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61311265e09b7f9650d596af
        failing since 79 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-02T18:05:18.350598  /lava-4436761/1/../bin/lava-test-case
    2021-09-02T18:05:18.367228  [   16.665103] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61311265e09b7f9650d596c8
        failing since 79 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-02T18:05:14.905543  /lava-4436761/1/../bin/lava-test-case[   13=
.214372] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-02T18:05:14.905938  =

    2021-09-02T18:05:15.918576  /lava-4436761/1/../bin/lava-test-case
    2021-09-02T18:05:15.935229  [   14.233192] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61311265e09b7f9650d596ca
        failing since 79 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
