Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50B73C967A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 05:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhGOD1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 23:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhGOD1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 23:27:38 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5D0C06175F
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 20:24:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p17so2460162plf.12
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 20:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UVOGixoRrE+kIM2l+j+TI03uwQ2idjE/TKb77Z7C3cc=;
        b=1Fxg6ekxNVu4aXsrRWgoibrvi89/QkPzMFG4cFavTZAGr8CpDaWWUv7TdDmFDWRICu
         oAqBO2dXEGDK+QrOfmeACsTGphRqaAyqvr6ZpkilsOw3jV5g7goOCKwCI5XphRyiNqO7
         StBEi88Mh2WH0r52Xqj2KrnqA62XfxJHx+Otw0aM9A9Fe32HpwvO5M9Am0EEJBWvtcA7
         /FzHm/zrPkLRg0TdQUy/qQ1e3JmxIumNPjfOC2HxryKKEpJMe2pXOe+KzoC/I2tCEsHK
         yp+VrvFm1LhRuuZtG12Mp+l/6Ud98s4XZI2EhdkQx3nUp4RGjlDFanRQkvcIndrKx7xB
         X8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UVOGixoRrE+kIM2l+j+TI03uwQ2idjE/TKb77Z7C3cc=;
        b=BV1WhLhouFkldYWqiwx2e1zFQE51ovpkXASdgjc3AnsPWAIZST+Ir04Sc3ff8ai7/s
         Vu3Fc/po6Wzwb1cQZAcvXUILRLh3YYhOOxjFbJLojcVw+vF6pvRJ3atG8YVe60IiWw+E
         4WGCMJa0Jb5xLJ+l6p6zyQfSfJyzJ5cLGZYxFhxIU7z0IozCFjPAXoHgbMrM0yI5RPdm
         6iTUdeDFIFYw5AJJQ6m7NU+FTNhuco2wrjVHsL/1zqeh6LnHWatjvrhlJVRGU3PnnWuU
         7RQ0J8cRtNaREj7QyGikU6q3VGEdGCgHXDuke/u2+CtonZGbMkgzqVWVIKPRGW5J0yGS
         F9yQ==
X-Gm-Message-State: AOAM533WFKLTNTSRo6LrnbAoMGO0XZstV5AlNNkutVowXgiNU4JH8B3n
        Sfv7eb5GCci2c49uT0cWKktrHD2hiV8buxSf
X-Google-Smtp-Source: ABdhPJw/ADa3UPUkF4MPav/dFT994HaEwWyp4Cm541vcU2nA13Wye1IqoZxPHPYyHLLi/QOYzH7B/A==
X-Received: by 2002:a17:90a:62ca:: with SMTP id k10mr1511686pjs.133.1626319484731;
        Wed, 14 Jul 2021 20:24:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y1sm4739583pgr.70.2021.07.14.20.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 20:24:44 -0700 (PDT)
Message-ID: <60efaa7c.1c69fb81.1f92c.0176@mx.google.com>
Date:   Wed, 14 Jul 2021 20:24:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.275-157-gc4d57648b4f5b
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 4 regressions (v4.9.275-157-gc4d57648b4f5b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 4 regressions (v4.9.275-157-gc4d576=
48b4f5b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.275-157-gc4d57648b4f5b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-157-gc4d57648b4f5b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4d57648b4f5b91f3180d7b465f502d3ff97d765 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef761473fab05b518a93be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef761573fab05b518a9=
3bf
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef761973fab05b518a93c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef761973fab05b518a9=
3c5
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef7609f02c56b05b8a93b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef7609f02c56b05b8a9=
3b3
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ef75bac45edfaf0c8a93ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-1=
57-gc4d57648b4f5b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ef75bac45edfaf0c8a9=
3af
        failing since 242 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
