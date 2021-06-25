Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A533B48F4
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 20:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFYSwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 14:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhFYSwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 14:52:11 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E97CC061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 11:49:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g4so5996840pjk.0
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 11:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wdqZ8wuDprepnT1LxnCxnSwlQvS5Hy6sxP5yQ8a2tgE=;
        b=V6uHpGyLYNJ6I/H0P00xNITDWGjkEHpclbEstABXbL1z1DhDKkK4XqYMk2WRBmWgd+
         CZjNs2vOLjbIo1RQjwCug0MEeT216CFBLXiSEypxxrRhWhhOJf6GBfc4g0u/qaOTigIV
         xXwMW8745UdG9RsHX7gWUwZYRR1rV9wdyeW/Ax6wbab8jlfjAN81aB34JF+c9jUaFxH1
         G0ycKWsTEOBXWtF7+lJbWRUCGxN6WbNt4l0jHlCaVi2IVGsZe5xKlze13uCBNDqXD4lI
         kUB1yK92ArbdeysUvexPh8sMuVHv8odz0t4si+51xTHC5OtjooC1ZzyKtCUvJZ5K9S2H
         nzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wdqZ8wuDprepnT1LxnCxnSwlQvS5Hy6sxP5yQ8a2tgE=;
        b=e9fZPerzxIQ2pGNnp2gzkK4A6y0BwxfWMj1voug/Juan1PesgFYFrjAUWk1qSNNIg/
         VZsWZn4tAXJgPpa1Uw6aK7WWrWUhPtKruwfvYEEZxFSAajs+fpmAbCsqdIwpPQ+PIXQw
         oTNvdPiZBZaFe7yH9nSfKHYHvYir2Pd/hjxkZ5Y3LbwUxwNsGEljGQUlzrahzc07jN0T
         o6qNI2awdSyrMcoeFRRHvI9sJUWjhM6jw7vfG3rI1cazAGjgKlKoQj667yY7ZZqhZTVf
         GWa03IMALA2f8se9MOf69tQkx2BBeMx7tYfYqU+Jh54j2ODxOHRjT3ES2c/T8ulEAwZ9
         CLFQ==
X-Gm-Message-State: AOAM531UeyKHs3mHttgJ2NQtu0Yhav8Sn2ct2BMhzG4b+zdDwXdj1lIr
        F/YkdbYhSHMsj+38kba+5IOwRfPuQWMbY26T
X-Google-Smtp-Source: ABdhPJxstDftMEeI/61AUNPFxwWJ2YXwYc7Ud/g4U8coO5km7NgRfGc6w6AN7vKcepbjVHRZKTr6dw==
X-Received: by 2002:a17:90a:448d:: with SMTP id t13mr12747705pjg.116.1624646989022;
        Fri, 25 Jun 2021 11:49:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nr20sm11607999pjb.46.2021.06.25.11.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 11:49:48 -0700 (PDT)
Message-ID: <60d6254c.1c69fb81.2029e.fe31@mx.google.com>
Date:   Fri, 25 Jun 2021 11:49:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.128-12-g81a84977c1ba
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 110 runs,
 4 regressions (v5.4.128-12-g81a84977c1ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 110 runs, 4 regressions (v5.4.128-12-g81a8497=
7c1ba)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.128-12-g81a84977c1ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.128-12-g81a84977c1ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      81a84977c1ba724edfa2d00ccf975747025c9ada =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d5f1c06468569a8341327e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-1=
2-g81a84977c1ba/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-1=
2-g81a84977c1ba/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5f1c06468569a83413=
27f
        new failure (last pass: v5.4.128-10-g0a9712e2f437) =

 =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d6081458af9556d44132cd

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-1=
2-g81a84977c1ba/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.128-1=
2-g81a84977c1ba/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d6081458af9556d44132ea
        failing since 10 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-25T16:45:00.089856  /lava-4095439/1/../bin/lava-test-case
    2021-06-25T16:45:00.095261  <8>[   13.196608] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d6081458af9556d44132eb
        failing since 10 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-25T16:45:01.109513  /lava-4095439/1/../bin/lava-test-case
    2021-06-25T16:45:01.126607  <8>[   14.216241] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d6081458af9556d4413303
        failing since 10 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-06-25T16:45:02.534362  /lava-4095439/1/../bin/lava-test-case
    2021-06-25T16:45:02.551226  <8>[   15.641550] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
