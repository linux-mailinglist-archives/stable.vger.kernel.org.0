Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE1E4020B4
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 22:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhIFU36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 16:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhIFU36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 16:29:58 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0AFC061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 13:28:53 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c17so7815326pgc.0
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 13:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l93intzqAqPpO+kHfmRE+CVceo91VxV3u2XHsHz5Xm8=;
        b=qUzQwG7vYTVK44GzAGQ9vQ3IbF3qabNS/USoYD1BtjZ0R7+kZ2q5FxL0oTpwb15BqE
         CCYCWlEE5QuioQhqLRcw8pYXCw3bNh6Vwb3GyaAUWpB5iH1wIiP8cddeqq9l/1dw/uBl
         FepoedF78nGmdXyZpx6KkB841gE8pcUjdpW32ZH/LAVnnPTqPljkC2np+NPlI8zKZJ64
         ophxShAnbR0G/L7TReRmqezLJ+mhu4JiXwyzs6Fr/sAWW/CsA7pjHExsaU7iEL+D5/Px
         A2WTKwKPcYIV4OJD7A7gLOXrEC7otJ5bb3REPY5QZGLQlrIaJBtA4LzLIGUKEJHXAFuW
         wkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l93intzqAqPpO+kHfmRE+CVceo91VxV3u2XHsHz5Xm8=;
        b=qxwaXpPx+G8BojKFGBtTADdIXBwi3Hf3j0Q6tAZj2BAcWdLWyvG6TPxIURyN7PqcHU
         Z8kL4fOr1lCZwut29mP/TjxgIXtLEMjoYZs41fJgtJbuj2n3WNcru/t3nzOH70nO+Jyp
         CwvLJyc7Br8N0cgUhY2XuQaz8ZXHaIPcQCKsIgegoWHm8JA+7x47fkdFzZax0bzKlCNB
         rXFgVGh2ZYQKtW6kcNPrQSDriXYLDG/Kc/5vyCUYshuTEaw/I78BaxsJADurTGzqErcZ
         1gTILODcubdYgJT7HcFZm3E3RI6Q0eGZOT8h16BqP8nuuubHFJf0KcG3iMkW934h7z56
         0gdw==
X-Gm-Message-State: AOAM533aLh6vUee9R+REN++XGees44ADOEtwbIfk/ij0asEKhv5lJDH4
        i/CKjWkw7xUU6usxN2X0L8uYMf5/RWvxxKGW
X-Google-Smtp-Source: ABdhPJxxsKpF22jtIpeViPLqFAWp/l/e+m45He7Uz3Vcd4uk+yr3VlHZ1PAo3Nrw7GGZNpOH+/WdOw==
X-Received: by 2002:a63:7519:: with SMTP id q25mr18447pgc.63.1630960132246;
        Mon, 06 Sep 2021 13:28:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g19sm249947pjl.25.2021.09.06.13.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 13:28:52 -0700 (PDT)
Message-ID: <61367a04.1c69fb81.32ce4.1439@mx.google.com>
Date:   Mon, 06 Sep 2021 13:28:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-12-g1b71d94946d6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 155 runs,
 4 regressions (v4.14.246-12-g1b71d94946d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 155 runs, 4 regressions (v4.14.246-12-g1b71d=
94946d6)

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
nel/v4.14.246-12-g1b71d94946d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-12-g1b71d94946d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b71d94946d6bbea0614012e475fd343fd8a9b8f =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61364c96947cb765bed596cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g1b71d94946d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g1b71d94946d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61364c96947cb765bed59=
6cc
        failing since 189 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61364f6e543b5f12efd5967c

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g1b71d94946d6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-12-g1b71d94946d6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61364f6e543b5f12efd59690
        failing since 83 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T17:26:56.190631  /lava-4459656/1/../bin/lava-test-case
    2021-09-06T17:26:56.207232  [   17.698990] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-06T17:26:56.207615  /lava-4459656/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61364f6e543b5f12efd596a9
        failing since 83 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T17:26:52.746210  /lava-4459656/1/../bin/lava-test-case[   14=
.248909] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-09-06T17:26:52.746771  =

    2021-09-06T17:26:53.759252  /lava-4459656/1/../bin/lava-test-case
    2021-09-06T17:26:53.775979  [   15.267639] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61364f6e543b5f12efd596aa
        failing since 83 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
