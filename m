Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22A52C80F4
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 10:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgK3JZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 04:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgK3JZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 04:25:48 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F84C0613CF
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 01:25:08 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e5so965946pjt.0
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 01:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4CJd1EemNtWpZ0nFajn56bVeW84TUZCuMjnTcaLGgVA=;
        b=ZhYo81xah4g1GfwVFCJb7O0kNLqmWZaU+wv5x4vAus2TsA6jJLgZVPAAzQPDyPS6j7
         mN7vHdpqlRnzfTBX0SFeyWijutLT8ni76GvSZ/IY60QveKq3KtKMmCIDENz/N1vEgGMN
         vek31mhq9jN+DTPVE4CJRuK7vE/f5r1jETCYOLa2ykGLblp4FJLgVu5AyJG6Lcxf9Btr
         ZGOLE3fXqVvJD0dIMy/UOZyZ9CQO2K/BNHdxlip0XKqrefzT9pJQJ+4VvYAWAVntFxHE
         7gEGwM144MvjqaVC3OzAjx4JRTIHNyRVe4osG/UfDxTO+VPedDF4GDGWolKQra7H1VcE
         //rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4CJd1EemNtWpZ0nFajn56bVeW84TUZCuMjnTcaLGgVA=;
        b=WsRWjIRLEzWPqER0oWdLdnEJKJBD0v1Fuoobi8b0gOOuw3MRNd3TdCPTf05o2r2AVr
         lrd9zAUsq6fm89fls5iCZJ+M6GqlvosuW2mUQ5wjIq5et8nKISN1X5cQmPYTAgsxqKg7
         LNhkrXwseQTy1Cqb/yUmtEG5DyEMizWTz7WkRvioB59jv6gGAjwBn48HGeQ0BxNOmAmj
         H60+o+zHs1jtB38NvyjnzgmIaXT2cjbGl9W9at7P991BxCumdX24s+/Y9aOFy+H8QK21
         1kgrd9Mox1C6HorrMg+IcMRAzKhBY2OLJ4LxHM7fi5eh9XfajZJ1HyfWTfSXcjxMsKZs
         +ViA==
X-Gm-Message-State: AOAM531tArHPBtFA7ZMqwt5S9EPfsNRJSdL6CyETANd/XiX4AODyVNcO
        gbKczS0TWAgo4+GZZ28Jtj/XID2k7voIfg==
X-Google-Smtp-Source: ABdhPJwTWbxXGhG0SXsfN30MDUbzuEUG4ilFNMeQp8yLiD2YTaJujfUrKMLCvcZW/7uLaI7CtzqcdA==
X-Received: by 2002:a17:90b:350a:: with SMTP id ls10mr25727742pjb.192.1606728307598;
        Mon, 30 Nov 2020 01:25:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s15sm15511953pga.43.2020.11.30.01.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 01:25:07 -0800 (PST)
Message-ID: <5fc4ba73.1c69fb81.f2ede.16d0@mx.google.com>
Date:   Mon, 30 Nov 2020 01:25:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.80-80-gf3d77b1bb4ab1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 202 runs,
 7 regressions (v5.4.80-80-gf3d77b1bb4ab1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 202 runs, 7 regressions (v5.4.80-80-gf3d77b1b=
b4ab1)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.80-80-gf3d77b1bb4ab1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.80-80-gf3d77b1bb4ab1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3d77b1bb4ab10e88d63d6b8a9c95cb9f46e463d =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47aeb91dcd07eb0c94cb9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fc47aeb91dcd07e=
b0c94cbc
        new failure (last pass: v5.4.80-21-g225247457b66)
        2 lines

    2020-11-30 04:51:56.729000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-30 04:51:56.729000+00:00  (user:khilman) is already connected
    2020-11-30 04:52:11.815000+00:00  =00
    2020-11-30 04:52:11.815000+00:00  =

    2020-11-30 04:52:11.815000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-30 04:52:11.815000+00:00  =

    2020-11-30 04:52:11.815000+00:00  DRAM:  948 MiB
    2020-11-30 04:52:11.830000+00:00  RPI 3 Model B (0xa02082)
    2020-11-30 04:52:11.917000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-30 04:52:11.949000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (380 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc48021c57d7feb28c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc48021c57d7feb28c94=
cc9
        failing since 9 days (last pass: v5.4.78-5-g843222460ebea, first fa=
il: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47eb07860e91d9fc94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47eb07860e91d9fc94=
cec
        failing since 16 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47ebb7860e91d9fc94d09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47ebb7860e91d9fc94=
d0a
        failing since 16 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47eb57860e91d9fc94cfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47eb57860e91d9fc94=
cfe
        failing since 16 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc4882578571275f3c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc4882578571275f3c94=
cbe
        failing since 16 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc47e75f25e592987c94d11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-80=
-gf3d77b1bb4ab1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc47e75f25e592987c94=
d12
        failing since 16 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
