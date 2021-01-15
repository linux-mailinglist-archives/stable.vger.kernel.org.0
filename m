Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACCE2F71F9
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 06:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbhAOFLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 00:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbhAOFLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 00:11:15 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5A3C061575
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 21:10:35 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id i7so5270446pgc.8
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 21:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E9ujVsABPwucOiS4aJmLNpTyifkKkjEJ7RY2MMlQuZE=;
        b=h337Fp7Qlv1LaoB+lO7jvMpEnu38579g4A7nODRtNYjFzLMHTn8x2xtdAga9ZjTZmY
         8ZN2N327hL4DFQP/LFf00WC1t4TU9DOq3/3NRFoMcJYKXy+NkPhmoU981tnVUw3iXAdv
         W4Z+vVS6ica1qU5TEJN3mzufvVPTp146ZRj2URm9BR0SWVQqafUG7O6b1dpgG2lp9CpT
         0xWis5H9aWldwyp1Xcvn8NtAY3AyGK++m+vEDG/7NXnf0BeCZjHxthdurQ/UIjVVqhNt
         8FbbZzfJHG5me4M+qY0F22twhWoPFc3JNugBy+9HCB4un/+3SxPLRiZMaybWBu1ee0Y0
         P5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E9ujVsABPwucOiS4aJmLNpTyifkKkjEJ7RY2MMlQuZE=;
        b=iPqookQqyzdTMRvYmBu4yuv2da9TaDMUdGby3rvNCXUbrIULhxMV3mqLyxlgzxEaH5
         qaaqn7IaQXAdnm43yb9k984wB4wo6M8lNmGPRdMk7ymlV+TNd9Ye15Fokeaj4K5bft1H
         3tVu3z5hbuCLV+lSG/1rCcg+0iGLhbFg/5dE07oZ7MC2PzernrQLjBndk1IRKhzaR5Yx
         Jx7Y8OnfrGIZQJoW6m6O6JUfMjIPKbHJABV/JYsP2j8kP58o0fByWWs4MlsVtW1RwwDF
         eRiFK9pigmjDFmx8mK0tb8eZcHot8Ylsv9gcZFaireUPdFX+i0kedLnJOc0R5Woh6TcA
         H8Jg==
X-Gm-Message-State: AOAM530iY3+Kd0CxG9YgLkwi0gL8IKX5EBMtNpnZ4OnVpl8PCm1BfTwx
        IZ8wwuSQtjlokZk9p0oiFPxKWVErr2yH6w==
X-Google-Smtp-Source: ABdhPJw8wrKyvrZWJKTgds7Gx01zsIevme+ramQ7kM510w2dBYgwwx08DZVs9m2zDzHclfNg0x4DIQ==
X-Received: by 2002:a63:da58:: with SMTP id l24mr10860750pgj.178.1610687434189;
        Thu, 14 Jan 2021 21:10:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2sm6699130pff.79.2021.01.14.21.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:10:33 -0800 (PST)
Message-ID: <600123c9.1c69fb81.e1488.1ae1@mx.google.com>
Date:   Thu, 14 Jan 2021 21:10:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.89-2-gbd8ab322cf04a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 184 runs,
 9 regressions (v5.4.89-2-gbd8ab322cf04a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 184 runs, 9 regressions (v5.4.89-2-gbd8ab322c=
f04a)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 3          =

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
el/v5.4.89-2-gbd8ab322cf04a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.89-2-gbd8ab322cf04a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bd8ab322cf04ac7c69deac1bb0a9a12c68f3cf0a =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 3          =


  Details:     https://kernelci.org/test/plan/id/6000e8e09aaa36be1cc94cec

  Results:     2 PASS, 3 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6000e8e09aaa36be=
1cc94cef
        new failure (last pass: v5.4.89-2-gdc084b4f7175)
        1 lines

    2021-01-15 00:57:19.795000+00:00  Trying 127.0.0.1...
    2021-01-15 00:57:19.796000+00:00  Connected to 127.0.0.1.
    2021-01-15 00:57:19.796000+00:00  Escape character is '^]'.
    2021-01-15 00:57:24.474000+00:00  =00
    2021-01-15 00:57:24.475000+00:00  =

    2021-01-15 00:57:24.490000+00:00  U-Boot 2017.01 (Nov 23 2017 - 03:58:1=
8 +0000)
    2021-01-15 00:57:24.491000+00:00  =

    2021-01-15 00:57:24.492000+00:00  DRAM:  753 MiB
    2021-01-15 00:57:24.522000+00:00  RPI 3 Model B (0xa22082)
    2021-01-15 00:57:24.538000+00:00  MMC:   bcm2835_sdhci: 0 =

    ... (742 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6000e8e09aaa36b=
e1cc94cf0
        new failure (last pass: v5.4.89-2-gdc084b4f7175)
        20 lines

    2021-01-15 00:58:55.633000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address eaeb3e1c
    2021-01-15 00:58:55.634000+00:00  kern  :alert : pgd =3D 7d5d00c9
    2021-01-15 00:58:55.634000+00:00  kern  :alert : [eaeb3e1c] *pgd=3D2ae0=
041e(bad)
    2021-01-15 00:58:55.635000+00:00  kern  :alert : Fixing recursive fault=
<8>[   42.863875] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail =
UNITS=3Dlines MEASUREMENT=3D20>
    2021-01-15 00:58:55.636000+00:00   but reboot is needed!
    2021-01-15 00:58:55.637000+00:00  kern  :alert : 8<--- cut here ---   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6000e8e09aaa36b=
e1cc94cf1
        new failure (last pass: v5.4.89-2-gdc084b4f7175)
        120 lines

    2021-01-15 00:58:55.674000+00:00  kern  :alert : pgd =3D c18c9a14
    2021-01-15 00:58:55.675000+00:00  kern  :alert : [00000000] *pgd=3D0000=
0000
    2021-01-15 00:58:55.677000+00:00  kern  :alert : Fixing recursive fault=
 but reboot is needed!
    2021-01-15 00:58:55.678000+00:00  kern  :alert : 8<--- cut here ---
    2021-01-15 00:58:55.679000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000020
    2021-01-15 00:58:55.679000+00:00  kern  :alert : pgd =3D c18c9a14
    2021-01-15 00:58:55.681000+00:00  kern  :alert : [00000020] *pgd=3D0000=
0000
    2021-01-15 00:58:55.681000+00:00  kern  :alert : Fixing recursive fault=
 but reboot is needed!
    2021-01-15 00:58:55.682000+00:00  kern  :alert : 8<--- cut here ---
    2021-01-15 00:58:55.720000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000000 =

    ... (94 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6000eb77c944b8a887c94cf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6000eb77c944b8a887c94=
cf4
        failing since 55 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6000eb25f7cae7ccb5c94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6000eb25f7cae7ccb5c94=
cbd
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6000ea82d6a03f925ac94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6000ea82d6a03f925ac94=
cc6
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6000ea79d6a03f925ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6000ea79d6a03f925ac94=
cba
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6000ec5084dbaa8191c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6000ec5084dbaa8191c94=
cba
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6000edae017dc461d3c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.89-2-=
gbd8ab322cf04a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6000edae017dc461d3c94=
ccc
        failing since 62 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
