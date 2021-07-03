Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AB73BA6A9
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 03:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhGCBof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 21:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhGCBof (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 21:44:35 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E79FC061762
        for <stable@vger.kernel.org>; Fri,  2 Jul 2021 18:42:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 21so10825075pfp.3
        for <stable@vger.kernel.org>; Fri, 02 Jul 2021 18:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fiLtwtFrT2obLQT58VycRTLuvA9LAS4OeNvhndB7uyw=;
        b=18YZixcsro3RKrl2P2lz9meiRKDe7SVTwkVg7Iw7qSZAATLZy5sPvsOzHHn3NO+neO
         UBxdEe2EzYTZUtRJeVNMDHClxdeMGcQb5fHhQZwuJbqkVAthiuM7d3RUsA16SWQgmDZK
         4iKLj3kUQ+PNbuu2sFrXs0emSJLzEl92aZR7jrCvN8vBZR3uPO4Qt9HR8N8Soj2tAXjf
         KZ0c0bYQzI0TTl+DAc1OjKjCpQc57bePhwbrFubrsmj3PkHyB0MaD0BwgvG8/uLr3zEA
         IY//m+z1W5XChG+C+inTWVdKeCST+uRj3z5tHlpvjGBde7l2Hk5OjPHZV7vQou4P7wdU
         ejrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fiLtwtFrT2obLQT58VycRTLuvA9LAS4OeNvhndB7uyw=;
        b=Ztm0K3JCm2XNxQNhmn1H8wJxwQQBy9vb9tvUGmJrcLNmqme1TibPNcbWPpTBRvN3tA
         9+2STqcnaAC5vZK+4tNVgQ1T1b1utOmyzhyUv+vSa5XOWIHNDtldAd2a8RA/FSkMFHZP
         1YZSZZeyNdGKdo/vV1073Mw2EYBeyqD1HSqtjERyiFCJRbrJ9cmPsdZmiNOsYGWGTj5a
         kh/UhRSTA/qGTkt+t6qUK/OVIS0slB7OVB7p78XMVPThl0B8jvUFgSZPYPyT4kYlBxvo
         R13YqONBqOvjF9f/B06vhwo+eHFegO5LXFy0JYNktP9HY91zPqSC86svrsyw1D+8bLlC
         enNQ==
X-Gm-Message-State: AOAM532ShXQJL3sbVhvLOkJlsg8tmssHFwH0t+a7m2OsMwuOapVtDFyC
        sac1IKgRZXwmrr6PrzwZsYeVIOuaJCMOFFat
X-Google-Smtp-Source: ABdhPJwj0tziExoF6WbHav6mj9dkbOTcwMWGQokEZaDENECTgeleOBUEGy99PXlJdBsDDLZKL9wIxg==
X-Received: by 2002:a63:471f:: with SMTP id u31mr2842873pga.85.1625276521760;
        Fri, 02 Jul 2021 18:42:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t66sm4893312pfb.102.2021.07.02.18.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 18:42:01 -0700 (PDT)
Message-ID: <60dfc069.1c69fb81.31d46.1d6a@mx.google.com>
Date:   Fri, 02 Jul 2021 18:42:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.238-19-gde73aa6e4dbd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 165 runs,
 4 regressions (v4.14.238-19-gde73aa6e4dbd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 165 runs, 4 regressions (v4.14.238-19-gde73a=
a6e4dbd)

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
nel/v4.14.238-19-gde73aa6e4dbd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-19-gde73aa6e4dbd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de73aa6e4dbd33c961e6d36664eaceed6de81101 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60dfa397f8100dcb0f11798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-gde73aa6e4dbd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-gde73aa6e4dbd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dfa397f8100dcb0f117=
990
        failing since 123 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60df8f95c165f742cb11796b

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-gde73aa6e4dbd/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-19-gde73aa6e4dbd/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60df8f95c165f742cb117983
        failing since 17 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60df8f95c165f742cb11799c
        failing since 17 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60df8f95c165f742cb11799d
        failing since 17 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-02T22:13:20.836178  /lava-4130415/1/../bin/lava-test-case
    2021-07-02T22:13:20.841471  [   12.801494] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
