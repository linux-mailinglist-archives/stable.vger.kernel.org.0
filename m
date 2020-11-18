Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23CE2B88D6
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 00:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgKRX55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 18:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgKRX54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 18:57:56 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D73C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 15:57:56 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id j19so2518203pgg.5
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 15:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U3mN2A+EbaSbRnDxo7JgbnxA5c56VFs9S3rEi0zQJXo=;
        b=Ft0M8oXqC23z/B/EMi1SesfpxN6ZO8RI91uDZsVPKlZJOF68FqK70mAtotlbymeuR6
         GFy0nYTxchScFhXocCCgXWJoiUjtCP6aeZXfT2qEY3FDTDGF+bJyyE6rc8dS3lQPiSOR
         rmnWMqz2/YUNFi4BfpQ7Gn0P99lYI18/mUSUGfSwsqBJLgyb5BV1nRJscm8pV+5L10O2
         H33cbXPkoUK3yJZ9lvw8DP9iCmw00VhcPiDPoHMiP0RDpJFc8EpYQVSRtSOqGFR7Chx1
         Kjjfv2E2H0B9ORz+71cNk0lmg288udK0A4ZigjDMdNpvnwHQm1e11eZsSo66Qure6oHu
         ObLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U3mN2A+EbaSbRnDxo7JgbnxA5c56VFs9S3rEi0zQJXo=;
        b=YUy8eJhhTvFRdVxc9DnMOBZvu5b3BYqXYH/4fgwEwDyVqI1lHMqmDh6OSxAhJKvBSd
         eGMHH6Rnwbla2h1fyuwAA4ZfU/3rTCNf0nZ5aXe8+yFJkQfSv3Kn8AmDsHg6iFj0F1cm
         djwPaKj3rddgaJhCtlFMUUlPbHBFQiiH05w9mUizRNKSGanvHdUVyx32otLgDxIQK6zQ
         dJDlFLw5JKIIoB/lzYTfLkZA/iPNuOC0Y+TX4eQjhMZLnQIC6J8pDZVLd33KdUYiO2EZ
         GFkg/gXIEezfo6zxC9k9SpCLKCsvxrKAQvYcOfLA7rZGN0KdM4sNn2qPWihxayYXfsQe
         Fyuw==
X-Gm-Message-State: AOAM531vwZgaicurnFQi7LGr+qIbdrr0MCp7jIic43ULbZhf5qrjKojo
        leA37kVOMCvRXHmx+cVDkjDOcPJKPeh0uw==
X-Google-Smtp-Source: ABdhPJzWpwudXTizR1iJx6TTdbUE2/idFByrwCytnf7Fdp4p95wbc0xHCXPmeB19B25ffvUuUT0cUw==
X-Received: by 2002:a17:90a:a891:: with SMTP id h17mr1462724pjq.149.1605743875630;
        Wed, 18 Nov 2020 15:57:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cv4sm3703700pjb.1.2020.11.18.15.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 15:57:54 -0800 (PST)
Message-ID: <5fb5b502.1c69fb81.d8ba8.72b1@mx.google.com>
Date:   Wed, 18 Nov 2020 15:57:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.243-77-g646866ecd6a7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 143 runs,
 10 regressions (v4.9.243-77-g646866ecd6a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 143 runs, 10 regressions (v4.9.243-77-g646866=
ecd6a7)

Regressions Summary
-------------------

platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =

panda                 | arm    | lab-collabora   | gcc-8    | omap2plus_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora   | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =

qemu_i386-uefi        | i386   | lab-baylibre    | gcc-8    | i386_defconfi=
g      | 1          =

qemu_x86_64           | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =

r8a7795-salvator-x    | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.243-77-g646866ecd6a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.243-77-g646866ecd6a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      646866ecd6a7a2706a1288d3c2d2790f1ef664b1 =



Test Regressions
---------------- =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb581fb1d4a60d510d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb581fb1d4a60d510d8d=
8fe
        failing since 20 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
panda                 | arm    | lab-collabora   | gcc-8    | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb58338d01bda2f25d8d90f

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb58338d01bda2=
f25d8d914
        new failure (last pass: v4.9.243-77-gb25c2d614872)
        2 lines

    2020-11-18 20:25:23.645000+00:00  f], .magic: dead4ead, .owner: <none>/=
-1, .owner_[   20.298126] usb 3-1.1: New USB device strings: Mfr=3D0, Produ=
ct=3D0, SerialNumber=3D0
    2020-11-18 20:25:23.646000+00:00  cpu: -1
    2020-11-18 20:25:23.672000+00:00  [   20.333587] smsc95xx v1.0.5   =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5823325f00f3abbd8d92b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5823325f00f3abbd8d=
92c
        failing since 4 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5823bf0cac28123d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5823bf0cac28123d8d=
8fe
        failing since 4 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb58241af5e6f19a5d8d910

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb58241af5e6f19a5d8d=
911
        failing since 4 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-collabora   | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb588586631ddf33ad8d900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb588586631ddf33ad8d=
901
        failing since 4 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5820325f00f3abbd8d906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5820325f00f3abbd8d=
907
        failing since 4 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_i386-uefi        | i386   | lab-baylibre    | gcc-8    | i386_defconfi=
g      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb581d63f944c8540d8d94d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb581d63f944c8540d8d=
94e
        new failure (last pass: v4.9.243-77-gb25c2d614872) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_x86_64           | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb581266209aa4325d8d92d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb581266209aa4325d8d=
92e
        new failure (last pass: v4.9.243-77-gb25c2d614872) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
r8a7795-salvator-x    | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb57f08219e801863d8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.243-7=
7-g646866ecd6a7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb57f08219e801863d8d=
902
        failing since 0 day (last pass: v4.9.243-24-ga8ede488cf7a, first fa=
il: v4.9.243-77-g36ec779d6aa89) =

 =20
