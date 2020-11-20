Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736A32BAC02
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 15:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgKTOhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 09:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgKTOhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 09:37:24 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72AAC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:37:23 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id w6so8048416pfu.1
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+/3bL5zWec/2h5ycQ6kSimCCrddHRIuUtbW1f819nBs=;
        b=E49Ui2/22OjZdzIWSZJ2bCy1PCYBEgQ2sqZ2T4hL2Qd0+1+nbgBgPIozBF4E6oNNX4
         YPmz5mL/mzajH8nryjOLor7ylYVIhZxMc2iQOyaYQrPWcMRcpzxPJimupFm2X+zOJNN8
         kUhySxKsJbIr4/hcgVBbGaJ+FuLIdDcyljklwfvpDv0Q6GQ4nUn46xiteD9K0CD4a0z+
         a+oXjbCg8KzfoQk8nS+rjIT/qnoiHCQ7vU8U2tKD0ek1wlOqW+23CVwwFEHaS7X++UWI
         FrAOCFCvGYMqe1vPGzYn0MVKHO1QPSWaofy8ATiSXN7KG4yTrDRZvvUDrV2RcxOk5sCM
         rYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+/3bL5zWec/2h5ycQ6kSimCCrddHRIuUtbW1f819nBs=;
        b=hjI+7xU2EKUYMJlSX2zrlqyaIXrsX/YsO2yHb4InNTlXCMxHQVix1wrTjX1cxJvDvR
         +XS5actIiAWW/P3LbyVO4bDVKVz23JUAhaHp4zNQxVGB5oKVdrDn6BCkOATuzdJLHDes
         YF7Cp+9Blc/tQbi1DX4Le1tg45hFoMKuPKGL9qj5X1QDLtP2ikWq1MFFaRag7w4b2GjW
         T5cWi9guXzhe+/2jtk80sc0gQts+aNrKVyIHVtxfV/b4GyPMih9BIdlEUurUZnTfmOvN
         biMdpmJOZ1dHtXJ2HqKoDtcVe0PswlQfCg2EPeDoygtVv5mtSQqJnbtLpYVOjkBK9bhX
         OMrg==
X-Gm-Message-State: AOAM533d+NjLqw0Stma9RyQ51+djMYX8K55VdKrMIR2qDXAAid1Gt+uR
        CTaSODGb9gEk2mpX6QXM1jVOuxt6kQfkRg==
X-Google-Smtp-Source: ABdhPJyFDAIVWA8ZpI4QQxYZB7pWaF7DgjjPCmHlVwLnsuVRD7uRmsWyqsUhxK2BWJls2xoQSgeupQ==
X-Received: by 2002:a17:90b:1081:: with SMTP id gj1mr10394264pjb.15.1605883042854;
        Fri, 20 Nov 2020 06:37:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d68sm3968199pfc.135.2020.11.20.06.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 06:37:22 -0800 (PST)
Message-ID: <5fb7d4a2.1c69fb81.73175.7873@mx.google.com>
Date:   Fri, 20 Nov 2020 06:37:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.78-13-g06e16b66c3e15
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 176 runs,
 8 regressions (v5.4.78-13-g06e16b66c3e15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 176 runs, 8 regressions (v5.4.78-13-g06e16b66=
c3e15)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-rock2-square   | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.78-13-g06e16b66c3e15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.78-13-g06e16b66c3e15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06e16b66c3e15a7effd48631de4bdccad4656a2e =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79fd9fb908cb178d8d92a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79fd9fb908cb178d8d=
92b
        failing since 22 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a00bdd19825dd5d8d917

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fb7a00bdd19825d=
d5d8d91a
        failing since 0 day (last pass: v5.4.78-5-g843222460ebea, first fai=
l: v5.4.78-13-g81acf0f7c6ec)
        2 lines

    2020-11-20 10:50:50.073000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-20 10:50:50.073000+00:00  (user:khilman) is already connected
    2020-11-20 10:51:04.964000+00:00  =00
    2020-11-20 10:51:04.964000+00:00  =

    2020-11-20 10:51:04.964000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-20 10:51:04.964000+00:00  =

    2020-11-20 10:51:04.964000+00:00  DRAM:  948 MiB
    2020-11-20 10:51:04.979000+00:00  RPI 3 Model B (0xa02082)
    2020-11-20 10:51:05.066000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-20 10:51:05.098000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (380 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79faa2d7de656b2d8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79faa2d7de656b2d8d=
8ff
        failing since 0 day (last pass: v5.4.78-5-g843222460ebea, first fai=
l: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a06ab147ce1c76d8d92b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a06ab147ce1c76d8d=
92c
        failing since 6 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a07547a7e1278dd8d919

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a07547a7e1278dd8d=
91a
        failing since 6 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a0124b9b85ab9bd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a0124b9b85ab9bd8d=
8fe
        failing since 6 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
rk3288-rock2-square   | arm   | lab-collabora | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a1f232c8a7a13fd8d91d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a1f232c8a7a13fd8d=
91e
        new failure (last pass: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7a25df43eec0677d8d925

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-13=
-g06e16b66c3e15/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7a25df43eec0677d8d=
926
        failing since 25 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
