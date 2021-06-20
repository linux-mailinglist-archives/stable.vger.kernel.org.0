Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A643ADDCB
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 10:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhFTI4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 04:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhFTI4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 04:56:55 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA39C061574
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 01:54:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y13so786388plc.8
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 01:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UcHFzECvG64ITvEHw4MPrHq5nlXCqVLumKmyXB9vvzE=;
        b=dyYymBS6zembghMiEQfzO38p2kvhBvUj2Xfjz4JLEbvUb7CjVmA4kfrilzfwdA8pJ7
         sa9UKs2mvepOWzKmEL3KYyI4iuyLWxfSVjnyVI3mPzbKF6Qvhs+FdEppHFeg5+yKR0D/
         e8ov7FJx0TRIkcXVxid051P7opPV5NSyrwp7wZC1R7cd5242b0DuyhvlhV/PEZUZ40PS
         XstG3m+9UBh5cVoij4LvZb3Ku+AYsPob40b3cnagqUYyZLXzud8Zmy3K2syqY6TJSpR0
         bLBsEIzMq6+RXaWGMohH50NgvTxZbuXF6LsqgWtH5Ftm9Pw0Qx+BdC7mnwAPvYn8ww+W
         RqQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UcHFzECvG64ITvEHw4MPrHq5nlXCqVLumKmyXB9vvzE=;
        b=Ikv/SGQCPwHPP9IAOFI+bzH2cYaVlPMpwtK1Ss09KxO8ZjRzrFgL8TL1C551myrqMm
         aME1yZ6KNA+3hpkZuhFMkTlRegK6dV07N+j2GMZja99G5nSZpuWJ8YV4Mu4HQSgskfaj
         j1Lfy5aiwH9lJK/hiJCL/uM1/sRkfrKBn2IyIO1+LjacMAJOx7rVU8bHdru6+MlEkqbm
         qNr2UqQNybo9rzmggH8TouO6Y3Xl9UuTX1uGb7dVmZmoqbPavj60IJL6okzsqnilMhz7
         CxoiPcjJpO8jf4zhj3k18MOotaCjAvpBQGpKO49018GHw3xtws4rPcyAURPghFz8Bz/N
         nCrA==
X-Gm-Message-State: AOAM5301q9Vhb++I//sHXjStcrrNe+UXfPd/Q8cRU0qBJQz8rrx5ZEhy
        ezR+gnfsH3brhG5jcEHpOKeU5jNfheftln+U
X-Google-Smtp-Source: ABdhPJw8yYzJ63JxQp/9xSnoJdPr/JS6eHXXWNOB2mxZiERh1rHxSt2mqIRPFn/JVEUPR8Oz444zfA==
X-Received: by 2002:a17:90b:4f44:: with SMTP id pj4mr30861796pjb.97.1624179282407;
        Sun, 20 Jun 2021 01:54:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v21sm825762pju.47.2021.06.20.01.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 01:54:42 -0700 (PDT)
Message-ID: <60cf0252.1c69fb81.3fac6.2101@mx.google.com>
Date:   Sun, 20 Jun 2021 01:54:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.45-73-g44b60e817cf7
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 4 regressions (v5.10.45-73-g44b60e817cf7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 182 runs, 4 regressions (v5.10.45-73-g44b60e=
817cf7)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.45-73-g44b60e817cf7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.45-73-g44b60e817cf7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44b60e817cf73821f7fa64a59647e13ccd1bf9ff =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ced1bbef668f9173413283

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
73-g44b60e817cf7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
73-g44b60e817cf7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60ced1bbef668f91=
73413286
        new failure (last pass: v5.10.45-11-g1c6876f47d62)
        2 lines

    2021-06-20T05:26:59.614335  / # =

    2021-06-20T05:26:59.624290  =

    2021-06-20T05:26:59.727647  / # #
    2021-06-20T05:26:59.736142  #
    2021-06-20T05:27:00.994352  / # export SHELL=3D/bin/sh
    2021-06-20T05:27:01.004865  export SHELL=3D/bin/sh
    2021-06-20T05:27:02.626996  / # . /lava-469340/environment
    2021-06-20T05:27:02.637494  . /lava-469340/environment
    2021-06-20T05:27:05.594570  / # /lava-469340/bin/lava-test-runner /lava=
-469340/0
    2021-06-20T05:27:05.605665  /lava-46[   29.994092] hwmon hwmon1: Underv=
oltage detected! =

    ... (11 line(s) more)  =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60cee7cc3447ac566f41326b

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
73-g44b60e817cf7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
73-g44b60e817cf7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60cee7cc3447ac566f413288
        failing since 5 days (last pass: v5.10.43-44-g253317604975, first f=
ail: v5.10.43-130-g87b5f83f722c)

    2021-06-20T07:01:25.449062  /lava-4063389/1/../bin/lava-test-case
    2021-06-20T07:01:25.454346  <8>[   11.313000] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60cee7cc3447ac566f413289
        failing since 5 days (last pass: v5.10.43-44-g253317604975, first f=
ail: v5.10.43-130-g87b5f83f722c)

    2021-06-20T07:01:26.487353  /lava-4063389/1/../bin/lava-test-case<8>[  =
 12.333246] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-20T07:01:26.488003  =

    2021-06-20T07:01:26.488461  /lava-4063389/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60cee7cc3447ac566f4132a1
        failing since 5 days (last pass: v5.10.43-44-g253317604975, first f=
ail: v5.10.43-130-g87b5f83f722c)

    2021-06-20T07:01:27.912430  /lava-4063389/1/../bin/lava-test-case<8>[  =
 13.759109] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-20T07:01:27.912978  =

    2021-06-20T07:01:27.913471  /lava-4063389/1/../bin/lava-test-case   =

 =20
