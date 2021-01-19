Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4A22FC4B6
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 00:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbhASXWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 18:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbhASXWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 18:22:42 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09241C061573
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:22:02 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id f63so5480375pfa.13
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 15:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MP81S00TTSHSYxYsK9tMJG4WhejQKvtfEzlyB3SaDpE=;
        b=gc5sTSwWT318ERKfQ52TJOeXmGJLcSzzj7dtaDhIQZwt8lQS9K+CbVoGi5ImbfLtDB
         uiu69265X3sRJfxZfmIogR615+/iUOV3xz9klHR5JFm4c+d+j4hp0XELRorTsm2CYNov
         DGFsMzWgE9JHxh7HSpiX44S5F+RYCMF4ze/P/DZTYEz6lGHbVGaa5eXH9xb6pJXqLeTN
         D3aMM0KSIRp7IuT5UMtSpgWUTHoJcSjLVnR32wnE3Z65xS08tTdb6g9S4xsiT5Cwc8jP
         Rba9+3odiRhyEgSB9qU1tGKDIboA1s/hQ3+IMz4jWAhaDVHOaF2Bqny//gZtaSf2wtli
         ZV9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MP81S00TTSHSYxYsK9tMJG4WhejQKvtfEzlyB3SaDpE=;
        b=QCheu0aGuTQ1rnApf4MGlqej+xmNp1GmpmELL5ltptfB1ha64gF5RzW9dSa2PQPNtN
         bMQH0v8yjzW4lhPLgnYmi1vufNyTrE4Xj9ok6Hu+AnCubgnOIypr5vOdYEt8iPotvJac
         MqHrRSVI4crrWsjutoTQjhfMIHZPXvTYH/VVk7GHWa6lG5FdLvMjHS0rhabxrKLe4HJS
         MhqcHaSblc+RzvxIeYNeKASQ4qCH44mnT8LMxIOP0NOYrTYxl8pLcFL27DEzw8ap5UkB
         XH2BnHhp+WCVy+e+9X9cvzGwHyPZsOPiIJMr1wynUWNwacTeewsDnIiGnsCH+rGyHnXU
         Mxvw==
X-Gm-Message-State: AOAM530HjApyN7eWVlHhAV9CMqmxUWNVjDqNyhsa4goi3JhXgWWuNL3S
        J1tV7jfSZkRWz4Ja7V7EWz9yYIUHSMfgwQ==
X-Google-Smtp-Source: ABdhPJwf3uBFTSdQFjeopJ4e23clRCH3uMpol9HvoboGpKkT8mJEfopwgjqs0X5D2gWOWd3QKOnckQ==
X-Received: by 2002:a63:585a:: with SMTP id i26mr6482568pgm.330.1611098521227;
        Tue, 19 Jan 2021 15:22:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 126sm177194pfu.31.2021.01.19.15.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:22:00 -0800 (PST)
Message-ID: <60076998.1c69fb81.f0d22.0c20@mx.google.com>
Date:   Tue, 19 Jan 2021 15:22:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.216-33-gafaeeec3a32b
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 8 regressions (v4.14.216-33-gafaeeec3a32b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 8 regressions (v4.14.216-33-gafaee=
ec3a32b)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

panda                 | arm   | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm64-virt-gicv3 | arm64 | lab-collabora   | gcc-8    | defconfig     =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.216-33-gafaeeec3a32b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.216-33-gafaeeec3a32b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afaeeec3a32b42db7091ccaccce5f69738ccaa63 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60073fbf610c5c75d6bb5d0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60073fbf610c5c75d6bb5=
d0c
        failing since 42 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
panda                 | arm   | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600735e4fdc782a3d7bb5d24

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600735e4fdc782a=
3d7bb5d29
        new failure (last pass: v4.14.216-19-g6b67a3fc25644)
        2 lines

    2021-01-19 19:41:21.026000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-01-19 19:41:21.050000+00:00  [   20.467864] smsc95xx 3-1.1:1.0 eth=
0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet,=
 4e:ca:4a:a3:36:9b
    2021-01-19 19:41:21.057000+00:00  [   20.482055] usbcore: registered ne=
w interface driver smsc95xx   =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6007341ed7644f077fbb5d4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6007341ed7644f077fbb5=
d4f
        failing since 66 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600734280741d4d264bb5d14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600734280741d4d264bb5=
d15
        failing since 66 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600734259ea390cf18bb5d0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600734259ea390cf18bb5=
d0e
        failing since 66 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600733fdcd2578a01cbb5d2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600733fdcd2578a01cbb5=
d2c
        failing since 66 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6007601f4d20be95e2bb5d1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6007601f4d20be95e2bb5=
d20
        failing since 66 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm64-virt-gicv3 | arm64 | lab-collabora   | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/600736db7db3fddd05bb5d2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm64/defconfig/gcc-8/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.216=
-33-gafaeeec3a32b/arm64/defconfig/gcc-8/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600736db7db3fddd05bb5=
d2b
        new failure (last pass: v4.14.216-19-g6b67a3fc25644) =

 =20
