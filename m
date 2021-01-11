Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206102F1428
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbhAKNVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbhAKNVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 08:21:04 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5789AC061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 05:20:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id r4so9488448pls.11
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 05:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EwCNJu6dDs5xU56kGhsxLmxJaDUIt1J2/tsqF/DIsb4=;
        b=EOC/W5iyIBlcYRmxCKqESBYPdW40pOXVr4Y5ssOWATl/UF9lwY5XB00os4JDhInOE9
         iTxWuUpgmtBqpAgL+e+O5YvvlKc9o3DXjype7MXlFPBh+BRIEP4hHZsB3GqfmPuU4VWF
         rhByhT3ei3FwKGK3ty7Fzu5Fnvb148vyAzTituNvBJXEQcJaAvat0RNwLMAoWajZZlCZ
         9p6/h7ccUJXo2uJqXxcprRqOZFfNDHkWliQdBj3zU4F3eLwLi3+Byz0cs0cCR2Zi2ww5
         aejwrk/h3bfElphNHVBZBTLvpcikUNhkX3Z8H8jQlIB7a9Ix0diXzAshxNHQ5aRKRxi0
         rlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EwCNJu6dDs5xU56kGhsxLmxJaDUIt1J2/tsqF/DIsb4=;
        b=OiscS+cksjPMFd5dZMhNN4YUyRH3+fkUNAZna8a1zHpq3FyrXpK9LBnXh0Ocf3XVVZ
         v2LHTRCwe32jjZEwaVURFd0tQAbPtZe9GOOVq6bYAo2VcyCXgBdejQ4IWyloef8yFRCY
         nqFOiz9gyvjGRbO0cSQ26/B5MKuxQ0Up1MmQxlyr/LqZxnpm0v+FC7rqP1ttC6eInv7C
         Cp3CSXF5RZ6z+eCCriigR6I6M0mxbiX7yOqjTwY1sP5O++db2vDfQoG9KYHn/qJLORAa
         c7vvWHSpCtAzcXCGVpeqKiJP6RfwoC36dPrBDduXbc49f2BVWH6HB1u2QFcWj9qHEzpr
         oxRw==
X-Gm-Message-State: AOAM5329PbKgr47nJVM52qpaH8F6c0yhTqgSWoqklFWAiddiHWLUV4Qi
        6UcFzAPtn6ZLl57OtHrd2jz0Juogu6Q4cw==
X-Google-Smtp-Source: ABdhPJz3x7i3/eEKxxacyaRC5J7LUjrTMJ96M0w/XSybIZV7OaNconUUlwTncVnmLpLy4UbLPIfXcg==
X-Received: by 2002:a17:90a:67ce:: with SMTP id g14mr18263530pjm.33.1610371223400;
        Mon, 11 Jan 2021 05:20:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1sm17503078pfb.103.2021.01.11.05.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:20:22 -0800 (PST)
Message-ID: <5ffc5096.1c69fb81.e704c.611b@mx.google.com>
Date:   Mon, 11 Jan 2021 05:20:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.88-86-g2eb64a0e5630
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 193 runs,
 7 regressions (v5.4.88-86-g2eb64a0e5630)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 193 runs, 7 regressions (v5.4.88-86-g2eb64a0e=
5630)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.88-86-g2eb64a0e5630/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.88-86-g2eb64a0e5630
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2eb64a0e5630b8d2cec547082dbb1e7df9c6e451 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
hifive-unleashed-a00       | riscv | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc1c2846c0bd34aec94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc1c2846c0bd34aec94=
cbd
        failing since 51 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc1ee4896d5dac79c94d59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc1ee4896d5dac79c94=
d5a
        failing since 0 day (last pass: v5.4.88-9-gc0d3cc027f90, first fail=
: v5.4.88-48-gd231741ec3bc) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc1d9a993395b0ebc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc1d9a993395b0ebc94=
cc9
        failing since 58 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc1db4791d2d6669c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc1db4791d2d6669c94=
cc3
        failing since 58 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc1da8791d2d6669c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc1da8791d2d6669c94=
cba
        failing since 58 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc1d595aad8dc1edc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc1d595aad8dc1edc94=
cba
        failing since 58 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffc1d78993395b0ebc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-86=
-g2eb64a0e5630/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffc1d78993395b0ebc94=
cba
        failing since 58 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
