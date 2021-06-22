Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50003B0DD6
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 21:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbhFVTxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 15:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbhFVTxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 15:53:34 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D28C061760
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 12:51:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so2905241pjo.3
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 12:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ctN5eYjzG4iYA8TsaQ48NIZdm8WkI4nqEJlf15h0MBE=;
        b=n81NDH7yzYnfd670psj5WJAEclELmqlNaDUALgZnY2kGtHN8jNiQq3HMKJC7KpBnMr
         08MscbQuok/ph8wyYl/Xg8wKuLKryP4e7uawVO7I7DmCWIQQrMqHWKNVZLVqKThfPt9o
         OrDXc5KM8ggfdh26dzwRewYgg4yBzytES8ETGnFXBGUjJa7890Yci7hyh6DQIv/Ewy46
         JFtLIUUeXoa/PteDADN3YeaMU2YmXJeSfgAs+vZmKcGCyIsRgcNiRtzM5mIALKIn+Bno
         RR7JmOm3ErbabtS457MOMCk1h22fIHQqi7G0NqKsUux6PrOZynfSDVycSsa4LlluULA7
         v/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ctN5eYjzG4iYA8TsaQ48NIZdm8WkI4nqEJlf15h0MBE=;
        b=KGTF8YSPNXA6T0Jh71//R2aEWo1zAXaVuEFIAbBWe8kb/nfY9XFLyiuQerWTGf0mG/
         E2x0dH9on2RnVIfV7duBAr+BstLmiS/0r99kb+XbGMbGkxLmMobaLElqUWisV3jJ/6d1
         Rmmrfsqn0MjfvaYvoZVvrx+5g4pyNTwiAQkD8DSvekSuOJOBeJ5/1v4IvJ1/gfZ/9bIl
         y5QPNWdgUi5eeXsFmP6U2wMVEs5PX3ApqEajoTD+2MLDGRyYvw71ONF2GHWDShpxKbFh
         HkqCrapuFCBtss8Dl1xcknc5iPR7X96m2MomagZYlZLfO4gM7bTfvfw4hJOuN+bkb+/j
         1VzQ==
X-Gm-Message-State: AOAM530gEuyEaOBBreNlGeQNaPe/ygLDu2Z8VrseuL43XLzORuv1ktBa
        Cagapj6XARpadohfzyimuGgJTHDc01tK+Q==
X-Google-Smtp-Source: ABdhPJwYipdoSbzNiaDZqPNNRsMURlA4+8OgSsloerq1h+vHJnGZtmVxco3rEydnso4jD2qbQtA05Q==
X-Received: by 2002:a17:90a:5408:: with SMTP id z8mr5674372pjh.144.1624391477244;
        Tue, 22 Jun 2021 12:51:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm150908pfo.92.2021.06.22.12.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:51:16 -0700 (PDT)
Message-ID: <60d23f34.1c69fb81.cbb58.0a3c@mx.google.com>
Date:   Tue, 22 Jun 2021 12:51:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.12-176-g9d7145f72380
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 170 runs,
 5 regressions (v5.12.12-176-g9d7145f72380)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 170 runs, 5 regressions (v5.12.12-176-g9d714=
5f72380)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =

bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =

rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.12-176-g9d7145f72380/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.12-176-g9d7145f72380
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d7145f72380d42cf06347432bfabe1133e0570b =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b    | arm64 | lab-baylibre  | gcc-8    | defconfig          =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60d20e83819d895b914132c6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
176-g9d7145f72380/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
176-g9d7145f72380/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60d20e83819d895b=
914132c9
        new failure (last pass: v5.12.12-110-gea4648ae9df2)
        1 lines

    2021-06-22T16:23:11.247599  / # =

    2021-06-22T16:23:11.257790  =

    2021-06-22T16:23:11.361255  / # #
    2021-06-22T16:23:11.369590  #
    2021-06-22T16:23:12.627926  / # export SHELL=3D/bin/sh
    2021-06-22T16:23:12.638427  export SHELL=3D/bin/sh
    2021-06-22T16:23:14.259914  / # . /lava-475173/environment
    2021-06-22T16:23:14.270441  [   18.083920] hwmon hwmon1: Undervoltage d=
etected!
    2021-06-22T16:23:14.270648  . /lava-475173/environment
    2021-06-22T16:23:17.226743  / # /lava-475173/bin/lava-test-runner /lava=
-475173/0 =

    ... (11 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60d20c680c643c685a413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
176-g9d7145f72380/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
176-g9d7145f72380/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d20c680c643c685a413=
267
        new failure (last pass: v5.12.12-110-gea4648ae9df2) =

 =



platform           | arch  | lab           | compiler | defconfig          =
| regressions
-------------------+-------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq  | arm   | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60d2285e29c4043fcb413282

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
176-g9d7145f72380/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.12-=
176-g9d7145f72380/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d2285e29c4043fcb41329f
        failing since 7 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-22T18:13:43.787465  /lava-4074112/1/../bin/lava-test-case<8>[  =
 15.143586] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-22T18:13:43.787830     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d2285e29c4043fcb4132a0
        failing since 7 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-22T18:13:44.800536  /lava-4074112/1/../bin/lava-test-case
    2021-06-22T18:13:44.806057  <8>[   16.163389] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d2285e29c4043fcb4132b8
        failing since 7 days (last pass: v5.12.10-48-g5e97c6651365, first f=
ail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-22T18:13:46.231630  /lava-4074112/1/../bin/lava-test-case
    2021-06-22T18:13:46.237551  <8>[   17.593593] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
