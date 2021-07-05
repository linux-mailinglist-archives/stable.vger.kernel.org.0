Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B223BC2B5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhGESgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 14:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhGESgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 14:36:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D831C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 11:33:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 21so17347666pfp.3
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 11:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SOb47blQa9S9HP3eotMXjJFGA0TJ6lx6XBsi7x/VyHw=;
        b=i8Zaz4v4mMw5Fjp9NFqf0BnKcvw104XWPuIHTwHzOd9U6MZ00u7dXa+11Pao+kAo+9
         mhB22ZchOglZOrhSlfQlJwc7DMS0Ku5Hzwd1U2W6DohMnvyMgzkMIFqQ6L9Er2+mV4Lc
         FSNiV5Lzn6yIAlqBZsWKCKbfavoY5wfn711qPMEGGiHV3Ba9ZUGgYAUsXtXl4Lcm1yCz
         ksujMEAACFVyNOJYV/C2X6rp51OcZ2wzRvPmcg5lGGqrJ1bnt96Zhg0t3e3RGIxJ50NC
         fjfmCRFIw5HmpqMjqA9pNLNGrsD2IM9YrryNDcYdnAC4i/lWRbNGPmeVN5p7XQjvvwKF
         AYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SOb47blQa9S9HP3eotMXjJFGA0TJ6lx6XBsi7x/VyHw=;
        b=qtTWI7G36b3dP9EoaPUBOmcI6fiR1UveGJNmA6uVw6ESxVju1FRln9/GPH49iUmGBq
         hajgun0XgwANnUOaYN+XBITA80OZ6DWX6kVLpJvvWQy79neQQCev5NnapaI8JHbJtV3F
         2XjzLizW241F2iVA6dTw/1I31MmKdEoNYDkIxN2FamutjUFyPRXooFLy9hD4u4FF4jMu
         WqDmGzQ6gvWF/zrPkAVwTccR87pAwjpsapO4CaO6ChciP1l0YM5NwZfSNyGtwFmxinvD
         Sf1L0rccccJvc/QL9E/74pKgEEbujwV2c6jg2zugglEUJFQKHzKJd+W4S/rEX+HfkvPy
         2AJg==
X-Gm-Message-State: AOAM533MFhYtAcEXDxk8wXPdqEFvc35FbTCwWHITkF8UHkMoth+fjjav
        gE5kcBajBIR8kXHqiHaIZg3xZO90LYLX10Hb
X-Google-Smtp-Source: ABdhPJzcDSslF9wIZc9YABF/S1tp8C4kKQLfwDqcm7NhXPQkNM17FHJ7sBFjdgLYy+XhWP6VZYQBuw==
X-Received: by 2002:a63:4b23:: with SMTP id y35mr16995215pga.179.1625510020539;
        Mon, 05 Jul 2021 11:33:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23sm11706854pjq.2.2021.07.05.11.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 11:33:40 -0700 (PDT)
Message-ID: <60e35084.1c69fb81.54f7d.22fe@mx.google.com>
Date:   Mon, 05 Jul 2021 11:33:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.238-21-g933ae1c53f09
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 143 runs,
 4 regressions (v4.14.238-21-g933ae1c53f09)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 143 runs, 4 regressions (v4.14.238-21-g933ae=
1c53f09)

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
nel/v4.14.238-21-g933ae1c53f09/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-21-g933ae1c53f09
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      933ae1c53f0970724afb83110dcf39b78579948f =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e32302bd27388c1d11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g933ae1c53f09/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g933ae1c53f09/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e32302bd27388c1d117=
96b
        failing since 126 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60e34cd48c222a6835117976

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g933ae1c53f09/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-g933ae1c53f09/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e34cd48c222a683511798e
        failing since 20 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-05T18:17:50.785043  /lava-4143221/1/../bin/lava-test-case
    2021-07-05T18:17:50.802197  [   16.531829] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e34cd48c222a68351179a7
        failing since 20 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-05T18:17:48.353302  /lava-4143221/1/../bin/lava-test-case
    2021-07-05T18:17:48.370190  [   14.099696] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-05T18:17:48.370473  /lava-4143221/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e34cd48c222a68351179a8
        failing since 20 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-05T18:17:47.334530  /lava-4143221/1/../bin/lava-test-case
    2021-07-05T18:17:47.339999  [   13.080783] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
