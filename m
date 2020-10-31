Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A1E2A1786
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 14:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgJaNEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 09:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgJaNEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 09:04:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0D1C0613D5
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:04:23 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id z24so7269977pgk.3
        for <stable@vger.kernel.org>; Sat, 31 Oct 2020 06:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zszjN3AqtAqVFzoYPShdBZJX418c/vyPMn91+LmMLM0=;
        b=LYbb+a07a2WDiYtlyrrMKzIBt++vYv0SbgFEnA2v8CHEtPZzfoYLxTU2uKHkrX1qRk
         4cyAz62fPpfUnz4Fw/tmQwtg7PjWMQUsnFQY3J/YDCAQx0JS15ggQlDrc2um6hxsTcBU
         plsOaYTg+V8aHd4p79iDE+Fn9Bwe07lyfpeWZYmPEQR2C+hGWFCaiZiLKMCrSdxfxnyC
         CZ/lxDSr4R0LSMvjjeJQq4Do67YhWtloWyDaZ/STArZww83s/QJTjkbYTjz1vjNan2Cw
         /efzDZ2hQOM6o+wYTknHP2ZNS1i0m9OxZccfr2G0s3BH8ZZ5qIynYBkmMxIKSYmqP2vu
         BFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zszjN3AqtAqVFzoYPShdBZJX418c/vyPMn91+LmMLM0=;
        b=VvhQBb20haMe1i2vb5U/cOLiAwKvew66/ljJkQcFk2M2jpucS3OSEbh/vutCsFUAuc
         oavMTll6W7AnP5yUKJARCVWR6rA8P9r+7XGjvS3/ir8rvEmRbS7c/xSPIHOgTpg1R5Xa
         FZ3qCFZTUYy6oz4hLAqj3ULTIAmCpSTvxBTEGMZ79wJjxur/7eFv4een6n4ejUytb0aV
         BuIskH/bxBSNHzvdHGZHhJFIxGfoWgEnt30DsUd91UkHa5bnvmb37XsO4xHQMSRgJeRk
         FrSuMpFGCPiMJ8K09KDzk6+BoOON1T7oAfjoAPYX2PZBB/x3ElP9nuUQLlQfRQNL0hx6
         Sy7A==
X-Gm-Message-State: AOAM5321MlQTfak6UHiakeKXxJAWsCP8NLnWGO/2d1L//EEC2JetG6jm
        9CvW4yb4g7nuDRLxlYg6aZN6fX3HxOfUPw==
X-Google-Smtp-Source: ABdhPJwsYbtgaoyBMSoegLTVv/GkPABK7hIEewM9F6PUEvikL6epkc9j8iR6/ZqYo1rPerpS5bWuUQ==
X-Received: by 2002:a63:4916:: with SMTP id w22mr5987226pga.353.1604149462944;
        Sat, 31 Oct 2020 06:04:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h4sm8184903pgc.13.2020.10.31.06.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 06:04:22 -0700 (PDT)
Message-ID: <5f9d60d6.1c69fb81.5cf87.2e80@mx.google.com>
Date:   Sat, 31 Oct 2020 06:04:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-9-g328e1d6ad32e
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 205 runs,
 4 regressions (v5.4.73-9-g328e1d6ad32e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 205 runs, 4 regressions (v5.4.73-9-g328e1d6ad=
32e)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

beaglebone-black      | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.73-9-g328e1d6ad32e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.73-9-g328e1d6ad32e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      328e1d6ad32ea2f42cadabb3c8f89ccc193b7b6a =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d27ca9bbf3f839f3fe80f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d27ca9bbf3f839f3fe=
810
        failing since 2 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d259de62f76d29d3fe7f9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9d259de62f76d2=
9d3fe7fe
        failing since 0 day (last pass: v5.4.73-9-ga9c55e5daa9c, first fail=
: v5.4.73-9-g812d5e88da7e)
        1 lines

    2020-10-31 08:49:21.954000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-31 08:49:21.955000+00:00  (user:khilman) is already connected
    2020-10-31 08:49:36.949000+00:00  =00
    2020-10-31 08:49:36.949000+00:00  =

    2020-10-31 08:49:36.949000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-31 08:49:36.965000+00:00  =

    2020-10-31 08:49:36.965000+00:00  DRAM:  948 MiB
    2020-10-31 08:49:36.981000+00:00  RPI 3 Model B (0xa02082)
    2020-10-31 08:49:37.069000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-31 08:49:37.101000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
beaglebone-black      | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d2a8fc7ff9cec9f3fe7e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beaglebone=
-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beaglebone=
-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d2a8fc7ff9cec9f3fe=
7e8
        new failure (last pass: v5.4.73-9-g98c61b1447e0) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9d2a371c5a6c081f3fe7f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g328e1d6ad32e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9d2a371c5a6c081f3fe=
7f8
        failing since 5 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
