Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA29A2C010E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgKWIDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbgKWIDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 03:03:16 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27D7C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 00:03:15 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id bj5so7639784plb.4
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 00:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h8jY64VJhBh6ok0FiDEAsotou4IaMJrZteSbOiBO3fI=;
        b=hpWsnPmUJcq3vBJWEeHBiqJOaB0KPzQ7e6U4HI+CCL2/ZwBC9/zApuyeIRLz2ytqv2
         SvSGY7UtvYw5Bc9zF+UteI4bWoXIx2J5rK3QfeLtoHdT0cfXc5omNaNj1z/osQCbuZfP
         wSdONIrgz1bOALo8vY+IFWpcB+kEfLrq6d8E5naXPzAJKEwjK28hfDBaWgZ1lDCb0JAb
         LkhaIth9xJWE6/eR1CdnPMAEWHerzkR363m/+Su7z2TJjBnduPB93xdwdyzG8EqdlOdi
         jBf50yMD8EjlcNTLDjgsLpK5cwKTXEfzOqG/ESvRqC0bN2Bd27LYj4aRLyBa5twhE0l8
         IUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h8jY64VJhBh6ok0FiDEAsotou4IaMJrZteSbOiBO3fI=;
        b=X56xwwNHFk0oy5f8IKwBpWhAN0uMGmBRms1B99DCEg5by83APmBLDGXUk8nz8khzWr
         55UIyHPISWOFWcHqmgfeKXxgr0dLpTiHlrrum5zqmc+fkitCqGROej6VRnBX+FOI2jH6
         0FphqZhdGB5jbY59dlw5RzFlXHYIYVVKPXwvLjMRG86nEyRgCHuBNbMgHQuRAvWXIbsh
         W4tHeDI0VULplr5MhEx2nbpA8wEUAqo39qMcuYpk1fEDVHDsjQFMHWe+DB4foOwgO/Hk
         rLNdE5ySRnHZedeVs9ag50lKV3Q1UX4VS/ZI5FYGWCNVfMIwBcAYt7obNLeGjvgnNurd
         NhmA==
X-Gm-Message-State: AOAM533boV7IjzBwQcLcB35DlFsqCouyfaDmBBwvBeqtoN45UYBmJWEC
        R39kiERmfnDsgHl1WceAjIuDdKJfr/UC2w==
X-Google-Smtp-Source: ABdhPJxKJ4m0XMs8pvPDr9cW5jieIj6LBAkhsmURULN2EieGG6kFTigsj7eCsb+iaSbm9uaScCyL6Q==
X-Received: by 2002:a17:902:aa94:b029:d8:5c6f:df56 with SMTP id d20-20020a170902aa94b02900d85c6fdf56mr22589500plr.71.1606118595057;
        Mon, 23 Nov 2020 00:03:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u6sm3916714pjn.56.2020.11.23.00.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 00:03:14 -0800 (PST)
Message-ID: <5fbb6cc2.1c69fb81.9efb0.a076@mx.google.com>
Date:   Mon, 23 Nov 2020 00:03:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.159-65-gf0b846fa9b5c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 179 runs,
 7 regressions (v4.19.159-65-gf0b846fa9b5c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 179 runs, 7 regressions (v4.19.159-65-gf0b84=
6fa9b5c)

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
nel/v4.19.159-65-gf0b846fa9b5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.159-65-gf0b846fa9b5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0b846fa9b5cf28c28d748488591ca1e98027465 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb36ce9bc1f32b66d8d8fd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fbb36ce9bc1f32b=
66d8d900
        new failure (last pass: v4.19.159-32-g9230dcfcb9bbb)
        1 lines

    2020-11-23 04:11:12.594000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-23 04:11:12.594000+00:00  (user:khilman) is already connected
    2020-11-23 04:11:28.545000+00:00  =00
    2020-11-23 04:11:28.545000+00:00  =

    2020-11-23 04:11:28.545000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-23 04:11:28.545000+00:00  =

    2020-11-23 04:11:28.545000+00:00  DRAM:  948 MiB
    2020-11-23 04:11:28.561000+00:00  RPI 3 Model B (0xa02082)
    2020-11-23 04:11:28.649000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-23 04:11:28.681000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (362 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb3aa53394a60fc5d8d90b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbb3aa53394a60=
fc5d8d910
        failing since 0 day (last pass: v4.19.159-26-g0e1af0d881d4, first f=
ail: v4.19.159-32-g9230dcfcb9bbb)
        2 lines =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb39a77a62bae3e0d8d926

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb39a77a62bae3e0d8d=
927
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb398eaa5975f924d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb398eaa5975f924d8d=
8fe
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb39869dde634ebdd8d914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb39869dde634ebdd8d=
915
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb3939b031432605d8d93a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb3939b031432605d8d=
93b
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb394f2e5b1067d8d8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-65-gf0b846fa9b5c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb394f2e5b1067d8d8d=
8ff
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
