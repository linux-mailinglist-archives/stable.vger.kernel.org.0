Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DD23CA57F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhGOS2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhGOS2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 14:28:15 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38453C06175F
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 11:25:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d1so3872942plg.0
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 11:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q5FpL4/fVTrWUt8NgIzNuuhPs5Em1FkxDNVMC63cST4=;
        b=F/w9bbRzCD8N5U0AwLwUVwDU8cqBKpnUKZIeeU3gXvyWXqjckklTNz5JVmReuf/4xN
         +hq0cW/kax5brJC5JgxvXSKKyQ5OePcWUBxoTHqU68Wa3UEPamnKxuH9bl1zl0htdr0M
         G8wP/LREyjee5xu3QFGNsl7sld0MEv+X/lMcPBHjQ1N/tQ3JuvezTl9Mht7pH3KXohdn
         M15CcDFZmInwhgYzqdDJ0Gu5wlaNUKxRl4sd6mQBZENF8ph/KYu6r731Ota8utPFAmvi
         5zNkFtt4MN6X1URPmHAs6x65V3sVZ9KlqnYYQ0IVVpXRInYaINmD3zWcnFoV3cRIlKdC
         DxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q5FpL4/fVTrWUt8NgIzNuuhPs5Em1FkxDNVMC63cST4=;
        b=qAxX4pJmNv/hz4vZaL7awtUq5DPFVyrXZPUoBeZw49n8xi0VMK1kB005RnWtOcYfCC
         zZxu/NBbqEl8QiQoHP3QGvu9J1MEHLAMZM5OrvT2xDgC1OHQ81lX4MJWNN/xD4Eyk19a
         aUqn0nyL8zjMwETPtt2paxsXK73RxAfp6+rFoEgLcjRQaSCbWm7Nrqt87INDhioKQXJu
         c1EM4CA5pO3A2pHRT1mwEiVFYbP/MZfPEFYaLg7zZ+tZKXLJ2jO7pSRQrLKNIW1lLCFY
         Q1VbnWE/A2Dujm9A7xRSAZLyENBSoWGEO+VpwF4AqXUfjjFmsiPDzxxSrI+FnJgWH44T
         2vuQ==
X-Gm-Message-State: AOAM530gLnbUKpL1efmuJMmU1+OIcwG+WFYpirUiiIdwg1lIvmqoWS57
        yNyc9W9q++m/pSNVkEFTrdPnR0o1zvQdFuoj
X-Google-Smtp-Source: ABdhPJwMlMWREGt2bZLSECw6VbnpOLMarbz+GWryXXHL8Ll9FHvTjetaQ769MH+fNVkMAJvBPvNmrg==
X-Received: by 2002:a17:90a:17a1:: with SMTP id q30mr5587509pja.190.1626373520522;
        Thu, 15 Jul 2021 11:25:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m21sm6087139pjz.36.2021.07.15.11.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 11:25:20 -0700 (PDT)
Message-ID: <60f07d90.1c69fb81.f6fe1.3504@mx.google.com>
Date:   Thu, 15 Jul 2021 11:25:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.132-92-gcd43e7d2a167
Subject: stable-rc/queue/5.4 baseline: 216 runs,
 11 regressions (v5.4.132-92-gcd43e7d2a167)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 216 runs, 11 regressions (v5.4.132-92-gcd43e7=
d2a167)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
          | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 9          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.132-92-gcd43e7d2a167/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.132-92-gcd43e7d2a167
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cd43e7d2a1670201107f0c80e894bccaf8061b7a =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f04a68a298ca9e2a8a93a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.132-9=
2-gcd43e7d2a167/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/bas=
eline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.132-9=
2-gcd43e7d2a167/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/bas=
eline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f04a68a298ca9e2a8a9=
3a2
        failing since 3 days (last pass: v5.4.130-4-g2151dbfa7bb2, first fa=
il: v5.4.131-344-g7da707277666) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f04c49ee28a0ae078a93a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.132-9=
2-gcd43e7d2a167/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.132-9=
2-gcd43e7d2a167/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f04c49ee28a0ae078a9=
3a4
        failing since 3 days (last pass: v5.4.130-4-g2151dbfa7bb2, first fa=
il: v5.4.131-344-g7da707277666) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 9          =


  Details:     https://kernelci.org/test/plan/id/60f04d0c3ee234c9f78a939b

  Results:     61 PASS, 9 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.132-9=
2-gcd43e7d2a167/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.132-9=
2-gcd43e7d2a167/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f04d0c3ee234c9f78a93b3
        failing since 30 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-15T14:57:56.352039  /lava-4203926/1/../bin/lava-test-case
    2021-07-15T14:57:56.369198  <8>[   21.386012] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-15T14:57:56.369426  /lava-4203926/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f04d0c3ee234c9f78a93cb
        failing since 30 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-15T14:57:54.928250  /lava-4203926/1/../bin/lava-test-case
    2021-07-15T14:57:54.944933  <8>[   19.962197] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f04d0c3ee234c9f78a93cc
        failing since 30 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-15T14:57:53.908830  /lava-4203926/1/../bin/lava-test-case
    2021-07-15T14:57:53.914150  <8>[   18.943040] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
60f04d0c3ee234c9f78a93da
        new failure (last pass: v5.4.131-349-g4bd89bb5de37)

    2021-07-15T14:57:52.618813  /lava-4203926/1/../bin/lava-test-case
    2021-07-15T14:57:52.619406  <8>[   17.651212] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-driver-present: https://kernelci.org/test/=
case/id/60f04d0c3ee234c9f78a93db
        new failure (last pass: v5.4.131-349-g4bd89bb5de37)

    2021-07-15T14:57:50.583919  /lava-4203926/1/../bin/lava-test-case<8>[  =
 15.612313] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dcros-ec-i2c-tunnel-probed =
RESULT=3Dfail>
    2021-07-15T14:57:50.584360  =

    2021-07-15T14:57:51.597435  /lava-4203926/1/../bin/lava-test-case
    2021-07-15T14:57:51.602565  <8>[   16.631502] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-driver-present RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-i2c-tunnel-probed: https://kernelci.org/test/ca=
se/id/60f04d0c3ee234c9f78a93dc
        new failure (last pass: v5.4.131-349-g4bd89bb5de37) =


  * baseline.bootrr.cros-ec-i2c-tunnel-driver-present: https://kernelci.org=
/test/case/id/60f04d0c3ee234c9f78a93dd
        new failure (last pass: v5.4.131-349-g4bd89bb5de37)

    2021-07-15T14:57:49.564768  /lava-4203926/1/../bin/lava-test-case<8>[  =
 14.592099] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dcros-ec-i2c-tunnel-driver-=
present RESULT=3Dfail>
    2021-07-15T14:57:49.565343     =


  * baseline.bootrr.cros-ec-dev-probed: https://kernelci.org/test/case/id/6=
0f04d0c3ee234c9f78a93de
        new failure (last pass: v5.4.131-349-g4bd89bb5de37)

    2021-07-15T14:57:48.540725  /lava-4203926/1/../bin/lava-test-case
    2021-07-15T14:57:48.541442  <8>[   13.573220] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-dev-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-dev-driver-present: https://kernelci.org/test/c=
ase/id/60f04d0c3ee234c9f78a93df
        new failure (last pass: v5.4.131-349-g4bd89bb5de37)

    2021-07-15T14:57:47.519383  /lava-4203926/1/../bin/lava-test-case
    2021-07-15T14:57:47.525275  <8>[   12.553411] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-dev-driver-present RESULT=3Dfail>   =

 =20
