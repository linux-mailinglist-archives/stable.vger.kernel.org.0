Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAFE2C8028
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgK3IjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:39:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgK3IjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 03:39:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62900C0613D2
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 00:38:44 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id bj5so6098984plb.4
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 00:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n8ZXX4ap8JR22lr7j8jqjiwlI/qMV6V/rplDV4Mu8eQ=;
        b=uPigLuP9luxrCMCA8gdJGjWhiblgsitcgcB0a44YClK8UwzdLPQeDiAccyXep/BPrE
         1bIc6jFBgaXUEPE/OEQT6cOqvuVZLcsp9ukPNaWzEw1jBAHaByVwoOPT9x5gmQUFuqm7
         6acDgi1vDbYVPterMcK23IrXZY5167shRrbft8Qj8TF5xzp2FntgW+EIjfTH4PT4BQzH
         Qj+sFb9KdSFck7MYy75pg3YFFgPyhUna9Grt1Fu6Ygl8uOujDH2U/NsUZnGMSkxGLVB8
         ZJHKU0dl5eRJbA3bkBFglJzLpJq6m6E/6aDsFuQFx0HY9vVYHthL6RBu+WjXJhWs7nnh
         aZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n8ZXX4ap8JR22lr7j8jqjiwlI/qMV6V/rplDV4Mu8eQ=;
        b=h4Xyuu7nY+MlL435Q5VEf7cwbLGN0vz1SnDvVGHn49kn6NqYGv5t36YddIgiSjOuwX
         ksBjwB3u92OLflZ98yLhc7xHXPhjx8MpltMC5OGZLemWZvju8b1hfEXm2E9Y3C/aU9Ov
         BLPPPpliUswdghgRy9pWd69VFK9qgCPHaAAGk45sEu8FW2uIFnNP0T8BpWy3HiH7CRqk
         XeAEAwZ1AEIM/Ho5tzKJC1cYgdv2f5pacsRJ7J1uBwYfDagJ2dhArJtN0ywnKHM8jZ8Q
         3CoLyOyJh4CLRYNwLRTwPxa/zUEkSFQ9P4/TphrCo6upP8WiVeS78JA0ZoGZp2q8pKRf
         8Y3Q==
X-Gm-Message-State: AOAM532odJOrmFPbdtHUAGzKWIkJMiYVvR+ysiN1XofD0Zz4CPO3vxdP
        XF0rbs+AlItDQ8b8heYckeuHIn4skdvIFw==
X-Google-Smtp-Source: ABdhPJyA11pefpzWMQLyxRG4d2/317/IMUrEbooZbX2sRgHL4DMjvl9kZ4bSuMlA9Y3ryNcoYf8MMQ==
X-Received: by 2002:a17:90b:3591:: with SMTP id mm17mr25148441pjb.213.1606725523420;
        Mon, 30 Nov 2020 00:38:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d19sm21847276pjs.0.2020.11.30.00.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 00:38:42 -0800 (PST)
Message-ID: <5fc4af92.1c69fb81.f84fb.0a5f@mx.google.com>
Date:   Mon, 30 Nov 2020 00:38:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.160-50-ge829433bf8e6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 181 runs,
 7 regressions (v4.19.160-50-ge829433bf8e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 181 runs, 7 regressions (v4.19.160-50-ge8294=
33bf8e6)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.160-50-ge829433bf8e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.160-50-ge829433bf8e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e829433bf8e6c01093c301ae1510b41edb24ab2e =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc479c6ea34db892ac94ced

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fc479c6ea34db89=
2ac94cf0
        new failure (last pass: v4.19.160-13-g8733751e476a)
        1 lines

    2020-11-30 04:47:21.476000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-30 04:47:21.477000+00:00  (user:khilman) is already connected
    2020-11-30 04:47:37.160000+00:00  =00
    2020-11-30 04:47:37.160000+00:00  =

    2020-11-30 04:47:37.161000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-30 04:47:37.161000+00:00  =

    2020-11-30 04:47:37.161000+00:00  DRAM:  948 MiB
    2020-11-30 04:47:37.176000+00:00  RPI 3 Model B (0xa02082)
    2020-11-30 04:47:37.264000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-30 04:47:37.296000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47c6bded013ec0bc94cf2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc47c6bded013e=
c0bc94cf7
        new failure (last pass: v4.19.160-13-g8733751e476a)
        2 lines

    2020-11-30 05:00:22.951000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47b9f08baa92a42c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47b9f08baa92a42c94=
cbe
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47c31588694e42ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47c31588694e42ac94=
cba
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47bb2f5f1b7bc79c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47bb2f5f1b7bc79c94=
cba
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4850a01bfe7ba0bc94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4850a01bfe7ba0bc94=
cd6
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47b413ce08b2cc8c94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.160=
-50-ge829433bf8e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47b413ce08b2cc8c94=
cdf
        failing since 16 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
