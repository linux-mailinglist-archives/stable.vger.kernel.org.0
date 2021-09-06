Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B74401606
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 07:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238941AbhIFFi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 01:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238935AbhIFFi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 01:38:26 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D948C061575
        for <stable@vger.kernel.org>; Sun,  5 Sep 2021 22:37:22 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g184so5634090pgc.6
        for <stable@vger.kernel.org>; Sun, 05 Sep 2021 22:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7j+BK0D0PQs9De0F+ehVt+1WNfoG3pcKhw5YM3E7ozQ=;
        b=jeUo2bEB86bUEq5rTj+u1Jlt2Gkad2GxIW1XLQrD1/j5i6nSa7nFOI9dcZ3bTX986M
         syhh+vc9u+p5k+VmPxJsyOobae4nQ/clZ0iJPYALmQlOMFueqNvwiFuHsd1eoYJafBOC
         E1AqzDCZqUz5MAFPqd8KIHfMaSZMj0OrH0pyLMikxWswol4G34VQQoBxYke3qPv0ZlEC
         if7m8Tb1intEkYoDriZ8jL4J4lZoR5GymNG8FZpL8Vpcnz4KtzQt5ZlX23nDN24COkrk
         B11+EzX+kiV+irFG7BhjeTY7utWI5gxPAlLYih4EEJhjdLq1fxMe265Eg8WJLt6GVhIR
         txRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7j+BK0D0PQs9De0F+ehVt+1WNfoG3pcKhw5YM3E7ozQ=;
        b=sCfVs3yKA/d9RHllenQSZ/l7L2b6xZEMzQT0yr3Aa/oAyA0iYF1rfoOnNRu1pgNaDo
         UrYkkF4X+9FBBR3dQZt2O9+m4feGMhPK8kxx/QbgfpJ899R0ly0UH1kDB0C4xjw8c5kl
         vR5HIB4KObonC5/8eLP7IBpr8WY7aO0FpXwf7lFVYjzymT6y1a8hnG/v4YukTDbJw4ly
         LghvcdS95Un2Xa1KleAEboPxpZwip/fTbidploEKE3cNa1619xMTL7iYe/ACOGucR6+u
         oyfK7BP39DZahqB3+fcK8ymsRTZ2c0exfFdxCnqcNKEuAmiatqbn43VzvBzlQKfSA6rl
         fa7Q==
X-Gm-Message-State: AOAM531nNe0Jrfmg+RpSk5NyBiL8NAyBNIrv6Z+GexgMH3wiWNYGf59v
        zza5v3ZPCYKfdOyANCpSPDt+nuct4ZiMrI2I
X-Google-Smtp-Source: ABdhPJz6SvaaWf29ZSd9xNM+xbVTCAGERH7u8JTZnLYqVnseWa0MvFBd8acPZ2MWCaNd1Q46diFPFg==
X-Received: by 2002:a63:78c5:: with SMTP id t188mr10598545pgc.386.1630906641795;
        Sun, 05 Sep 2021 22:37:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 31sm7477711pgy.26.2021.09.05.22.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 22:37:21 -0700 (PDT)
Message-ID: <6135a911.1c69fb81.af917.63d9@mx.google.com>
Date:   Sun, 05 Sep 2021 22:37:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-7-ga910a8efc9ed
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 173 runs,
 4 regressions (v4.14.246-7-ga910a8efc9ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 173 runs, 4 regressions (v4.14.246-7-ga910a8=
efc9ed)

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
nel/v4.14.246-7-ga910a8efc9ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-7-ga910a8efc9ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a910a8efc9ed03f8a31547bdab02f1e737f8f3d0 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/613575f2482c8ecf54d59695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-7-ga910a8efc9ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-7-ga910a8efc9ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613575f2482c8ecf54d59=
696
        failing since 188 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61358018fdb62c8496d59665

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-7-ga910a8efc9ed/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-7-ga910a8efc9ed/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61358018fdb62c8496d59679
        failing since 82 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T02:42:15.548074  /lava-4454571/1/../bin/lava-test-case
    2021-09-06T02:42:15.565196  [   16.295376] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-06T02:42:15.565657  /lava-4454571/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61358018fdb62c8496d59692
        failing since 82 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T02:42:13.116201  /lava-4454571/1/../bin/lava-test-case
    2021-09-06T02:42:13.134561  [   13.863631] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-06T02:42:13.135048  /lava-4454571/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61358018fdb62c8496d59693
        failing since 82 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T02:42:12.096560  /lava-4454571/1/../bin/lava-test-case
    2021-09-06T02:42:12.102523  [   12.844623] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
