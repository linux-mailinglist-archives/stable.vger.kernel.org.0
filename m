Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531A52D4E98
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 00:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgLIXQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 18:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbgLIXQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 18:16:09 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18BAC0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 15:15:28 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id w6so2231698pfu.1
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 15:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6sGj2KYyxqm1YFTpq8dkwFWELA4kDO6txYjQ/gPJA88=;
        b=068sxWsM9g9BZ/JgV5anetChheORIoN4j7xkPAK3lpgGkwaGoaK9go1IcvmHm3/UVt
         tyCbYAl/wcOK9BY0jns2uJTBnMd/rU1rY+U++0NP9NX1s7ku5MnyradSr4rl/2EqQb7l
         SfaAFY24m1kbVjpgAZ4pqrjmsP2c1NZPSzqYe6t530/wWDIvdp0icCU9lgfgNOFabsFJ
         qkrGzAb9D6KMCavD06jAVQTyO52RFV4TunQwqUCFLYIVdsboto/uHcjoESV/KKl2tGgT
         VrtSr34mA0UYav8WbQUgOE47U2fIz658xN7k33mFcwCgYyxwix64GkZhmVhQ1voYjY6u
         Zh0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6sGj2KYyxqm1YFTpq8dkwFWELA4kDO6txYjQ/gPJA88=;
        b=i/ieuDZiZ8IPOkPVItelASTIfoybSoSQFMHDeL58mAb6BurYzGT4LUNlCUhdigoBX5
         7pmy87B/D4tT3soSvN2VS35+TyX5AI3J/VE9YIdK8uXO+rb2jjc2nQ/Zc1pf0CvGJt08
         axMBujEp4yw1HglmQsjNDB/O6JA7x6MR/zsdSksfibe5PF3vC9SfrSrsHPoZzjFkkYa5
         hwZD8BSR/1CNGwxxnj4K+f7E9aimvwBbsc5cTdO6mluGJidOKns17R5VNxEgpKfRhtkJ
         DGB2U82l5THEeqn7JQshQdDpN5M368MRq8P6ejQ66tmlTTCVVqxZOLVi/ECAR54Z7sb/
         2RtA==
X-Gm-Message-State: AOAM533obu5fI5b4lYvR4NoyNiHcsbO5uXRQ6yEaEkki9e8D7OHeS4fh
        eAmSXeOmR1BuNj4qsDYyqEyTtf2pieMAhQ==
X-Google-Smtp-Source: ABdhPJzHjyenFsayiDf6vRMGIai1wZSX07gXhWhWbWUKVBqc43EmgohchqCXVezjcoqpiLOyzR01/w==
X-Received: by 2002:a17:90a:fe8:: with SMTP id 95mr4260800pjz.114.1607555728190;
        Wed, 09 Dec 2020 15:15:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm3925767pfq.136.2020.12.09.15.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 15:15:27 -0800 (PST)
Message-ID: <5fd15a8f.1c69fb81.1c25e.745e@mx.google.com>
Date:   Wed, 09 Dec 2020 15:15:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-39-g91f8eb162536
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 189 runs,
 7 regressions (v5.4.82-39-g91f8eb162536)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 189 runs, 7 regressions (v5.4.82-39-g91f8eb16=
2536)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
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

rk3288-rock2-square  | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.82-39-g91f8eb162536/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.82-39-g91f8eb162536
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91f8eb1625364b4af8331f7d3516ad593780e112 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd126f4284f6ea8e9c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd126f4284f6ea8e9c94=
cd5
        failing since 19 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd125d53a14c9f899c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd125d53a14c9f899c94=
ccb
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd126114af99efcb2c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd126114af99efcb2c94=
ccb
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd125d34096697ceac94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd125d44096697ceac94=
cc4
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd12584975f9f39b7c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd12584975f9f39b7c94=
cbb
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd14b6528a761b4dac94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd14b6528a761b4dac94=
ce1
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
rk3288-rock2-square  | arm   | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd12950d242fa1432c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-r=
ock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-39=
-g91f8eb162536/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-r=
ock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd12950d242fa1432c94=
cd1
        new failure (last pass: v5.4.82-39-ge908be9861d9) =

 =20
