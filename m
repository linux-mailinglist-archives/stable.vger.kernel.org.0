Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF9C3B4BDC
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 03:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFZBsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 21:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhFZBsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 21:48:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91030C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 18:46:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a2so9669547pgi.6
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 18:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e43VUwTATFK8E5Jxk/EUUzruGdwpYGB5TELEelic4co=;
        b=iQXnQ7x1ccEmzaycmnw6oBdFPVy4dV3enj5DKIMLnNGRMC4rVT/CreL/4sU3kXeXyr
         X4Wwb5sGYfeCc4UStMHlA634ii2Q1LqA1P0nnF6BEwXghOAQcmHm2zZhgaH0l3ZImz1K
         BfaHg3bC724ygdCqCy87EweYn0lRTavD9HwES7x/YkH4gQC13HbrwqrnvwrxNEoQvM1t
         xotjmkF73yxXoQobGkeGJHhtEKCeyKZ6KXpVn6hFT3A6BcMVZ8O+BcLprCptZ1Lx8Woe
         YfhEM+4wOk1s1X5tkulwiK6wofM2Li59b6wXamJHjhN90gAllWyMcJX6Q+gb+59VrWxn
         0f3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e43VUwTATFK8E5Jxk/EUUzruGdwpYGB5TELEelic4co=;
        b=NdNXYw/5S0Ut0lTHQQZ6rCzxul2WsWhoT6eoeGPcbBhz/d+HL4RCCaklgm8tjuyx5s
         rJlzu6eLxB7aUYplaYI28TrqGnp223CuvwYuDQ/0IUtWndEy0xNlLAMyOUq/V93r2dcE
         RdrpGSkeiwnn15scTF0Sv4uuZeqhb4CkcUSGGXSJw0WjZF1eRl3pwkVKbKBR5VPFUP6e
         jKxqnHBrr6yFP/g3rqVcU/EqdG2LWangsYlTpznXSR9Mt0hxGxOYmHLOvizMzCfkg/PF
         zocEjmMcKNFBGTifPqiqVOpAsrjMk+OKM9mc8PCGe8cdhgQraKzS4QdxkNqlouU10UWb
         L5DA==
X-Gm-Message-State: AOAM531TnX58YqKGcYX0SKkGyPvcgZfFv57whdxx3UX1sDXPK4kS0n48
        e+IaKm1+3nQ0iygEKNESIOwRlSpn+6AL6xUP
X-Google-Smtp-Source: ABdhPJynExmXXrVrZl2TnHu92ALn+Ne/B2ALiSrMchU1Z0U2laDSg9eb7vZC0VJy+4BWeZFotwaJRw==
X-Received: by 2002:a63:fa11:: with SMTP id y17mr12275369pgh.128.1624671991030;
        Fri, 25 Jun 2021 18:46:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7sm6619989pjd.55.2021.06.25.18.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 18:46:30 -0700 (PDT)
Message-ID: <60d686f6.1c69fb81.892ab.35d7@mx.google.com>
Date:   Fri, 25 Jun 2021 18:46:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.46-14-gbac30be5cb33
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 135 runs,
 5 regressions (v5.10.46-14-gbac30be5cb33)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 135 runs, 5 regressions (v5.10.46-14-gbac30b=
e5cb33)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
beaglebone-black       | arm    | lab-collabora | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-8    | x86_64_defconf=
ig    | 1          =

rk3288-veyron-jaq      | arm    | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.46-14-gbac30be5cb33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.46-14-gbac30be5cb33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bac30be5cb33a395b7e49de091abe695f8a835c8 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
beaglebone-black       | arm    | lab-collabora | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d65b8ca3583efa24413274

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
14-gbac30be5cb33/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
14-gbac30be5cb33/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d65b8ca3583efa24413=
275
        new failure (last pass: v5.10.46-12-g1088098ede9e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/60d652de3b714f0c2d41326b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
14-gbac30be5cb33/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
14-gbac30be5cb33/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d652de3b714f0c2d413=
26c
        new failure (last pass: v5.10.46-12-g1088098ede9e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
      | regressions
-----------------------+--------+---------------+----------+---------------=
------+------------
rk3288-veyron-jaq      | arm    | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60d652838840702de5413293

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
14-gbac30be5cb33/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
14-gbac30be5cb33/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d652838840702de54132b0
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-25T22:02:34.703980  /lava-4096976/1/../bin/lava-test-case
    2021-06-25T22:02:34.709754  <8>[   11.383028] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d652838840702de54132b1
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-25T22:02:35.741575  /lava-4096976/1/../bin/lava-test-case<8>[  =
 12.402612] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-25T22:02:35.741957  =

    2021-06-25T22:02:35.742271  /lava-4096976/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d652838840702de54132c9
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-25T22:02:37.147992  /lava-4096976/1/../bin/lava-test-case
    2021-06-25T22:02:37.165561  <8>[   13.826862] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-25T22:02:37.166080  /lava-4096976/1/../bin/lava-test-case   =

 =20
