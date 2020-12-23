Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1BF2E211A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 21:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgLWUEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 15:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbgLWUEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 15:04:04 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF92CC06179C
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 12:03:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b5so331357pjk.2
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 12:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7dNdlaIo4HsvX+JtzSn8WfP/Hi283+eFs181CGT6nOA=;
        b=hTrVWKpqCPl9q/Rz3JgqmAkmYEa0oDvNg8kbMlVs/bGwM7qYt7201z67hPFTuXapFl
         x2ELh2seDWjdRMLsMJbusfFiHyBQWI27jDMbpeCMdv19trym/S0gBDrO7nPwiNtYut/9
         TJ/QSUg+FrPsNJjMKErEfD6pejyI5imgWukKqXWRNCUOOZn4tKmdeobg7i+WOGVTFytD
         7InemSBqwJBnaPPpUkSfHCE4K2x7KYIsQRCvJVmz5zgg+aaBuJ48EuU4ruKwaj4H8vqf
         Z/D6bVvqxZLRKYk47JLVyD38VByduTVlDOg9psr4AZlIA+One/oBtLzVbIhT/KynPixX
         3/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7dNdlaIo4HsvX+JtzSn8WfP/Hi283+eFs181CGT6nOA=;
        b=NCWMda1l63H9t6qO60MLGTSuKVNN8eDIgBUnw5R/tGNi1m+VOiy1ypLfSqQ75SH8W+
         hD/gZMyuZgzgsIKfe/vwT4EeCOskYw6FLPU3iWbqKf35ZnQPfKBROlDdq0/x68A9sOP5
         0O+TaZpqiTDPapiDN7ovQBc+LeyL6IbkDXsminnJPMEwZZr8yN6/1bOnaNgBfk8WwTsN
         cZoVzF4L0pS1Ty2UPxiJWXvfvCPWA72gXmjGhYMLlACHUjtrUkyHqzCJRVd0H/tII8eX
         xncthzzm7is8kLtT6Ta+mLtjsKj9W23IrmqY1d2I4n96jngfQhHpBj1/C/UHs4Uk3eH4
         neDA==
X-Gm-Message-State: AOAM533Hmspfn6S+pbs3qNDrIw911wz5sMmZLkuCIpNvMOZYdlvw40bg
        MlUmkN/IyqPVEbGfl8cMItIoUFFh2nn1oA==
X-Google-Smtp-Source: ABdhPJyhRwjLKGXNu0oRuyaySogU6RdUwlntg8+MuD5TVIvyCuiP52Ghenh8qUhCq9udPqp27ulLdw==
X-Received: by 2002:a17:90a:4892:: with SMTP id b18mr1158265pjh.64.1608753802962;
        Wed, 23 Dec 2020 12:03:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v19sm419567pjg.50.2020.12.23.12.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 12:03:22 -0800 (PST)
Message-ID: <5fe3a28a.1c69fb81.c0c2.14c4@mx.google.com>
Date:   Wed, 23 Dec 2020 12:03:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.85-71-gd411bcecc6b72
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 128 runs,
 5 regressions (v5.4.85-71-gd411bcecc6b72)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 128 runs, 5 regressions (v5.4.85-71-gd411bcec=
c6b72)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.85-71-gd411bcecc6b72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.85-71-gd411bcecc6b72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d411bcecc6b72fcb5aeacfc965d80e0690cb60a8 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe369b77045f05d33c94dad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe369b77045f05d33c94=
dae
        failing since 33 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe367836ae4a95a3dc94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe367836ae4a95a3dc94=
cc8
        failing since 39 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe3679ef7f3693019c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe3679ef7f3693019c94=
cbe
        failing since 39 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe36797f7f3693019c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe36797f7f3693019c94=
cba
        failing since 39 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe367676889d66d44c94d01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.85-71=
-gd411bcecc6b72/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe367676889d66d44c94=
d02
        failing since 39 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
