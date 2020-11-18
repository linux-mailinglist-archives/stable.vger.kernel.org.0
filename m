Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DAD2B7C12
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 12:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgKRLGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 06:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgKRLGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 06:06:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10679C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:06:43 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fw15so102537pjb.0
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/+ApSZNe+CxFAcTJU51SsX50N9/0Yvyk41/2EKasckE=;
        b=au1G+glGsaJhPY1+m9gZ88p/Hch+MkjdoxA52vxQ+/Wmry2DgqRU6U6cGa0ipnO2L8
         NMeNifoE6AsWsscoZLaaz8d5kQT0nXXyxB/vhnfraaeg+a73f7Y/KaJ7nMiWdFynLomV
         LT5qcB+HHmZiW09YIDFK6Su0www6ybKeQVddL4oQSaj9nBLb9/CH5L8PXp5d7yOPKAQi
         F5XjoIxXYsGvJQKITgQwBQ8hiD6ZObLZkRISatKgcLu3eCpqmQDNsq2xQshWf6Ahq4qB
         /4UcZLq55r+7Yk0yFZwfPaOevkMcOcsaIL3LJOiQzQN9iuGAuhMiRflFEdiBwwckm/O9
         O7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/+ApSZNe+CxFAcTJU51SsX50N9/0Yvyk41/2EKasckE=;
        b=Szo2Gau//SG1FkE6ZGpuoWtgCglpX9j6BtvZI+9AMXsoBZpXWNP7HceoRW5G7vyn7b
         QBFbkWzSlE3aQVBJL1wZa78+25TFe5IB8TYRZB26dE23cjDWl1KxNJvwU5pmr/KNaIXA
         MhCRDZQ3rgf9vqELCBhGOtvTCmH7MqBm3sEcjqwA8tm/NliLpsGC/g81VCyAY1rxzr5F
         hA5XSoFZSSRQjWvAsedUGIvzxTK7VhQ4W0gEpoL2C/fjOrBvfwGZeMHoqO3ZVdtvCNLA
         LKoBvsglnKfoKrHewz8BfI8okKf/nL/xS923Hy0+aQeACqRY7CpYi+RFjE6scnySjTfv
         uWwg==
X-Gm-Message-State: AOAM532McCuVH8gsR31Dek7YsYnI03voaD0msxheLkrx6BkcS2G2c55M
        stdUgxljhwjoP5jUJwFGcdiDxdI/B4n+qA==
X-Google-Smtp-Source: ABdhPJwWeA4u8hDjzj5vgjBZlWD/ffqPCdGFr2HaC5kNDM6/MPMWgV8A0phbl68bNA/wugMG0GIoRw==
X-Received: by 2002:a17:902:7283:b029:d7:e4f5:adc7 with SMTP id d3-20020a1709027283b02900d7e4f5adc7mr4127160pll.20.1605697601909;
        Wed, 18 Nov 2020 03:06:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15sm21715650pgi.89.2020.11.18.03.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 03:06:41 -0800 (PST)
Message-ID: <5fb50041.1c69fb81.a2014.e8a2@mx.google.com>
Date:   Wed, 18 Nov 2020 03:06:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.157-102-g1d674327c1b7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 179 runs,
 8 regressions (v4.19.157-102-g1d674327c1b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 179 runs, 8 regressions (v4.19.157-102-g1d=
674327c1b7)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

beagle-xm            | arm   | lab-baylibre    | gcc-8    | omap2plus_defco=
nfig | 1          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.157-102-g1d674327c1b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.157-102-g1d674327c1b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d674327c1b7a5243fc8f01e52e226736f6f987f =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4ca4504aaf95350d8d91e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fb4ca4504aaf953=
50d8d921
        failing since 6 days (last pass: v4.19.157, first fail: v4.19.157-2=
6-ga8e7fec1fea1)
        1 lines

    2020-11-18 07:14:27.305000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-18 07:14:27.306000+00:00  (user:khilman) is already connected
    2020-11-18 07:14:42.811000+00:00  =00
    2020-11-18 07:14:42.811000+00:00  =

    2020-11-18 07:14:42.827000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-18 07:14:42.828000+00:00  =

    2020-11-18 07:14:42.828000+00:00  DRAM:  948 MiB
    2020-11-18 07:14:42.842000+00:00  RPI 3 Model B (0xa02082)
    2020-11-18 07:14:42.932000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-18 07:14:42.964000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
beagle-xm            | arm   | lab-baylibre    | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d0417d004ab089d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d0417d004ab089d8d=
90f
        new failure (last pass: v4.19.157-26-ga8e7fec1fea1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4cf81f5b40585f8d8d91e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb4cf81f5b4058=
5f8d8d923
        failing since 7 days (last pass: v4.19.155-42-g97cf958a4cd1, first =
fail: v4.19.157)
        2 lines =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4cbf6450d3705fed8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4cbf6450d3705fed8d=
8fe
        new failure (last pass: v4.19.157-26-ga8e7fec1fea1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4cc02450d3705fed8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4cc02450d3705fed8d=
908
        new failure (last pass: v4.19.157-26-ga8e7fec1fea1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4cc0f9faa5ca49ad8d969

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4cc0f9faa5ca49ad8d=
96a
        new failure (last pass: v4.19.157-26-ga8e7fec1fea1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4dad7314d17a237d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4dad7314d17a237d8d=
8fe
        new failure (last pass: v4.19.157-26-ga8e7fec1fea1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4df6fee045fdb42d8d946

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-102-g1d674327c1b7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4df6fee045fdb42d8d=
947
        new failure (last pass: v4.19.157-26-ga8e7fec1fea1) =

 =20
