Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD2C3C3ECE
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhGKSxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhGKSxA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:53:00 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FCCC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:50:13 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u3so2764228plf.5
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RU9mk1mLNMAlFxsTZo8cyLJAqeNuZCH4BQ4MdDRuBWo=;
        b=jmXH2shci9qXSnRLCpuzdB+/r/XxDTuKJIC6idA4x1mTtgIM8CxpvH/p81aKFf55/7
         XSlBBGFhbUGBGP7211qf25hwEFAhvUnvH3gPn7xhSOGifzHout3Mv7ORXc982HlFQNc0
         Az3jQz0BxAbQTID7ssKev5ZTCe92hW90PuLmp2mHdOMQX/yNuIeOfSXcIFpo9Ldc0GoD
         tu7/5c9t/83UJMzEN+Tk1QxBzBwz1ufSkoot2vBQA6cryvEFrGFgv1SFXSyYlsGcEAsE
         i1JNzTlZtTjpfzO0qKgxI3I3jthMUFgO7j7GPhAEYZnEtPLdXMVgGZ3jN3JkS4Go0Y1b
         DJnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RU9mk1mLNMAlFxsTZo8cyLJAqeNuZCH4BQ4MdDRuBWo=;
        b=Lyt18x8K+uwqMX+gQd40moZ7Ev3AmGr9gxLOovJIwrM/W5Gs8hnse3vPb5S6YTGyQ8
         Jgzpw6vqbfJsYUVX205O8mi/j90W+rUxct2uN6ILdgZmQeCzaI2KTSpnEbLGlMUT7TNl
         3PDWJwpncwyIO/oRm64k+ZhVkg8FFiJOxlLYs39ecf/ekdaMcgf+QUukbNvNO9hHdQhS
         7LCyCY6J22jX96cy+Ttsu+EvYxysML4vh0sLkK4QDbX+HmsmMXCn+Q6kxlFJzgtfNnEw
         Amjf/OhhKTYBkcGLOeiaX+1kdhVHUyoF8/9GuAoi1N3zRARM0ojYL4LCb9P1iwNYmEzm
         lH5Q==
X-Gm-Message-State: AOAM533rXnOG0OAFV6P7vQnGTXijZ9YbASW9JqcW3w5zUw210wRRnK9T
        YaK/dkVf+y73MMzAar4THH0b2WSNH0AkU1yK
X-Google-Smtp-Source: ABdhPJwN/zgC4mrrKbTqp4cW5NxcT7yi64OobYwknHygJUTjgt/9oJqE21/Abt0rWWr2B7iG9KOSRA==
X-Received: by 2002:a17:90a:1de3:: with SMTP id v90mr40001507pjv.219.1626029412817;
        Sun, 11 Jul 2021 11:50:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm11399837pgk.66.2021.07.11.11.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 11:50:12 -0700 (PDT)
Message-ID: <60eb3d64.1c69fb81.d98e5.29af@mx.google.com>
Date:   Sun, 11 Jul 2021 11:50:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.239-36-g5208c26617d8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 4 regressions (v4.14.239-36-g5208c26617d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 4 regressions (v4.14.239-36-g5208c=
26617d8)

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
nel/v4.14.239-36-g5208c26617d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-36-g5208c26617d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5208c26617d8bd99ae346cf6bb9a7f445eb0e476 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0c473c951ddb88117987

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-36-g5208c26617d8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-36-g5208c26617d8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0c473c951ddb88117=
988
        failing since 132 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60eb1b8ca0c5040fe31179e1

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-36-g5208c26617d8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-36-g5208c26617d8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb1b8ca0c5040fe31179f5
        failing since 26 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb1b8ca0c5040fe3117a0e
        failing since 26 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb1b8ca0c5040fe3117a0f
        failing since 26 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-11T16:25:24.205240  /lava-4176175/1/../bin/lava-test-case
    2021-07-11T16:25:24.210724  [   13.488583] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
