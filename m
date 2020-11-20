Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEAC2BB0B8
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgKTQiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbgKTQiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:38:54 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3182C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:38:54 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id v5so4318094pff.10
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j63efT4xwKA1moxOYaU++7V9NytwIABa1MKOmEStmgM=;
        b=rjziVPiS8x6548vyumqVlNXdfUlfGOdZ2uNsnPO0l8AK2gA4mwF5Aw+CfZA6Dz43M5
         wcQ0FDjhe6uZFCqpOYyJOXZ3vCb0uc6aI2BrcEHz1LjRYRZoPuEbZN2Em0xHLfiNZaET
         AeJF4od0jg/d/m/S8y70mYlNdYzF6mZVeUSHkrpmN4jRYsZUoVb1n1OK+2SAoK4o+Q1n
         jPvs+0FHEf6yvWez8h//5eMBGqw5himlLP9r4i8LGwFDH4WAu7aRZL0jedFbZFUBYQvY
         AST4vOTtC1T/rLuGTHO8Bf2H++DdLYeZPuYUcqVjLKOtOfOU8HAUICpXH5wj2V801+ey
         qb3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j63efT4xwKA1moxOYaU++7V9NytwIABa1MKOmEStmgM=;
        b=G3H2uGkJNToGtv6Y44uLpY435/fPNCd5DG1/MtesFvpzQGOVGBAsnzXmUxsOnurGOO
         uwAxcM/M5U409myLq/+JvMB5XFtw9wcN1rf//wGGVQoYz/25O2D64eklpRvEiMcu9uje
         XpCZAkU5vH8In2KQrO8u7vGP1g9Kws+W9bHMAG4rQN9SXhg0ZlHY9acSd+HjYx9Gl4aA
         LorJZmOrFNy8STsMwfBOrGuSCfC9kF89qXRIMJ2USK1NbbzUuD5zuRuj+NSdJj+rXPOd
         Dd3WjZyYFVlA4DGPq4uNzSobiZ9HZxttgwU2kAZ9n4o41Xb9eqtbBu8stsRBORfObUOd
         SArw==
X-Gm-Message-State: AOAM530t9swODnJlqDZhZIzCC/yX1h1ccDfOUEqAqAzp0UhHA46RlIkk
        BQFOZchODdCj876YtSdR+0+cEBW+nasUIA==
X-Google-Smtp-Source: ABdhPJzdcYoeKwLTzkiG0czMYQFks7Zqv5hGHowtjIAtDvyy9wTOx/1dh5A/qyWYzj3t+chUn9OYTw==
X-Received: by 2002:aa7:9490:0:b029:197:cb4b:b678 with SMTP id z16-20020aa794900000b0290197cb4bb678mr6103905pfk.59.1605890333809;
        Fri, 20 Nov 2020 08:38:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t20sm4253504pjg.25.2020.11.20.08.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:38:53 -0800 (PST)
Message-ID: <5fb7f11d.1c69fb81.f42a5.7c2d@mx.google.com>
Date:   Fri, 20 Nov 2020 08:38:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.78-18-gea92920d046be
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 175 runs,
 8 regressions (v5.4.78-18-gea92920d046be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 175 runs, 8 regressions (v5.4.78-18-gea9292=
0d046be)

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

hip07-d05             | arm64 | lab-collabora | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.78-18-gea92920d046be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.78-18-gea92920d046be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea92920d046bee86876dc51ba95a34d2056cb9a0 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7bc92ad35f7a466d8d91e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7bc92ad35f7a466d8d=
91f
        failing since 222 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b8060a380a2301d8d920

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fb7b8060a380a23=
01d8d923
        new failure (last pass: v5.4.78)
        1 lines

    2020-11-20 12:33:21.577000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-20 12:33:21.577000+00:00  (user:khilman) is already connected
    2020-11-20 12:33:37.090000+00:00  =00
    2020-11-20 12:33:37.091000+00:00  =

    2020-11-20 12:33:37.091000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-20 12:33:37.091000+00:00  =

    2020-11-20 12:33:37.091000+00:00  DRAM:  948 MiB
    2020-11-20 12:33:37.106000+00:00  RPI 3 Model B (0xa02082)
    2020-11-20 12:33:37.194000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-20 12:33:37.226000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7bd554095c7a5cad8d948

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7bd554095c7a5cad8d=
949
        failing since 0 day (last pass: v5.4.77-152-ga3746663c3479, first f=
ail: v5.4.78) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hip07-d05             | arm64 | lab-collabora | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7b9ff0a5f483dc0d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7b9ff0a5f483dc0d8d=
922
        new failure (last pass: v5.4.78) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7bcf57af3bbbfced8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7bcf57af3bbbfced8d=
914
        failing since 5 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7bcf71e8bd1a47dd8d91d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7bcf71e8bd1a47dd8d=
91e
        failing since 5 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7bcb4876218cc67d8d90f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7bcb4876218cc67d8d=
910
        failing since 5 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
stm32mp157c-dk2       | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7be884d2a53cba3d8d912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.78-=
18-gea92920d046be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7be884d2a53cba3d8d=
913
        failing since 23 days (last pass: v5.4.72-55-g7fa6d77807db, first f=
ail: v5.4.72-409-gab6643bad070) =

 =20
