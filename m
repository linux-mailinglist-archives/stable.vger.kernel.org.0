Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6924F3B0DB2
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 21:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhFVToP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 15:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbhFVToN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 15:44:13 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD39C061760
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 12:35:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c5so368292pfv.8
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 12:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FVW7LLGfv/Hvx/NHq4Qj7PhTHIIbP+IgvEfLnfWR2jE=;
        b=S4TFmvKqqsKLuAHmOq5ZIe9JaxEUJ4Xy0pxirJDLw7jEK0HZVejQ10XNQLykFHQ2yg
         Kvs2mSlgMAa4piBqeM5zwcUuZZRHzDNyZs/uuRAJN+yB0FB3BWVwMzICuEilqKpqLcU8
         i9WegY3f6bZB27JiTjzehra+Dk2bvnWapMI1ElBhlukBm+NuMGw5k2+8Q0Z61tQ3x2dF
         zuAgnn+byzi5tWYqdEOHORFaV8PiKMvxVDKHYA/Ju8FfdgCkbqh3HjZOHuoLA1jcHT5H
         ynBaLmNJjAEABxU76mUxMZ+gSUrxeOuzflsJB9lPn/o54q7QPCreakLy9abrEofk4gGF
         M6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FVW7LLGfv/Hvx/NHq4Qj7PhTHIIbP+IgvEfLnfWR2jE=;
        b=Yx2gMHoZEnmLmY3kyCCDYoZciehR7dwvv46ev9yCmco/maeigbuJAuePh/7WBxk/uX
         rrPJXsEFuomjnb+x/9CMlY+WVf40CAdJE/MG9U8lwV1fzbRPEbhFMBmdefPfnP36raQ4
         ny+/DJ8lh4WsYcHuKI+R598y786yaJlGbY6SabqVukoTWutZRfgVbw+fayuhjfAmSMLz
         gfx5bb5HvELYM7j4xHq5ZTzgggEovsdPEPgkcxy2XexbB15SKHixvGzfmPh1GEpzIcUW
         aknxbcrp8OjnOO4mqdpl7ksuQpkk/eUKzm9XdGY18IHmJQQaBZer/nM5EPTLU/XFOKmO
         0Sww==
X-Gm-Message-State: AOAM530/PioN7QbpOVaHz0umRYhERf6O4++QYNvMjrQugYPTUo8S+3kE
        J7VpRoliqRk7Yi0orQsbMEQMaGRDENg9uQ==
X-Google-Smtp-Source: ABdhPJxMNctcFJ/nExYQcVOGltE8r4SY40A2ZNAUaHTyoLcqedWY8qwrZChVLA6CqkGQnlpPHiBx1A==
X-Received: by 2002:a65:6118:: with SMTP id z24mr222817pgu.325.1624390556857;
        Tue, 22 Jun 2021 12:35:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u16sm124612pfg.86.2021.06.22.12.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:35:56 -0700 (PDT)
Message-ID: <60d23b9c.1c69fb81.63fca.0874@mx.google.com>
Date:   Tue, 22 Jun 2021 12:35:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.45-144-g9affbf10e0b6
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 174 runs,
 7 regressions (v5.10.45-144-g9affbf10e0b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 174 runs, 7 regressions (v5.10.45-144-g9affb=
f10e0b6)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
bcm2837-rpi-3-b        | arm64  | lab-baylibre  | gcc-8    | defconfig     =
               | 1          =

meson-g12b-odroid-n2   | arm64  | lab-baylibre  | gcc-8    | defconfig     =
               | 1          =

meson-gxbb-p200        | arm64  | lab-baylibre  | gcc-8    | defconfig     =
               | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =

rk3288-veyron-jaq      | arm    | lab-collabora | gcc-8    | multi_v7_defco=
nfig           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.45-144-g9affbf10e0b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.45-144-g9affbf10e0b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9affbf10e0b647b84699cd607989131e24e3ef20 =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
bcm2837-rpi-3-b        | arm64  | lab-baylibre  | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60d209bbe05b1784dc413276

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60d209bce05b1784=
dc413279
        failing since 2 days (last pass: v5.10.45-11-g1c6876f47d62, first f=
ail: v5.10.45-73-g44b60e817cf7)
        1 lines

    2021-06-22T16:02:32.706831  / # =

    2021-06-22T16:02:32.717703  =

    2021-06-22T16:02:32.821021  / # #
    2021-06-22T16:02:32.829642  #
    2021-06-22T16:02:34.088647  / # export SHELL=3D/bin/sh
    2021-06-22T16:02:34.099144  export SHELL=3D/bin/sh[   17.930236] hwmon =
hwmon1: Undervoltage detected!
    2021-06-22T16:02:34.099345  =

    2021-06-22T16:02:35.721247  / # . /lava-475051/environment
    2021-06-22T16:02:35.737054  . /lava-475051/environment
    2021-06-22T16:02:38.684816  / # /lava-475051/bin/lava-test-runner /lava=
-475051/0 =

    ... (10 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
meson-g12b-odroid-n2   | arm64  | lab-baylibre  | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60d20a70ca4241d0bb413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d20a70ca4241d0bb413=
267
        new failure (last pass: v5.10.45-73-g44b60e817cf7) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
meson-gxbb-p200        | arm64  | lab-baylibre  | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60d20b872160407a6141326a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d20b872160407a61413=
26b
        new failure (last pass: v5.10.45-73-g44b60e817cf7) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60d2075b73eb3db5ca4132a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-collabor=
a/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d2075b73eb3db5ca413=
2a6
        new failure (last pass: v5.10.45-73-g44b60e817cf7) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
rk3288-veyron-jaq      | arm    | lab-collabora | gcc-8    | multi_v7_defco=
nfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60d2260a5f042c5be6413266

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.45-=
144-g9affbf10e0b6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d2260a5f042c5be6413283
        failing since 7 days (last pass: v5.10.43-44-g253317604975, first f=
ail: v5.10.43-130-g87b5f83f722c)

    2021-06-22T18:03:48.119766  /lava-4074072/1/../bin/lava-test-case
    2021-06-22T18:03:48.125773  <8>[   11.348973] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d2260a5f042c5be6413284
        failing since 7 days (last pass: v5.10.43-44-g253317604975, first f=
ail: v5.10.43-130-g87b5f83f722c)

    2021-06-22T18:03:49.139554  /lava-4074072/1/../bin/lava-test-case
    2021-06-22T18:03:49.156633  <8>[   12.368335] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-22T18:03:49.157179  /lava-4074072/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d2260a5f042c5be641329c
        failing since 7 days (last pass: v5.10.43-44-g253317604975, first f=
ail: v5.10.43-130-g87b5f83f722c)

    2021-06-22T18:03:50.581627  /lava-4074072/1/../bin/lava-test-case<8>[  =
 13.793711] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-22T18:03:50.582055  =

    2021-06-22T18:03:50.582398  /lava-4074072/1/../bin/lava-test-case   =

 =20
