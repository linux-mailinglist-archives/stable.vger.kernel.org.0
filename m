Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97352F94C6
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 20:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbhAQS75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 13:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbhAQS7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 13:59:55 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58583C061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 10:59:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v1so8058076pjr.2
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 10:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZVsuZ9FnY7uJ22jtUdcoFPRwS+JucV/Oze9JDoVessA=;
        b=ephYf7CJWd4ftSLGZb8IPcZYthVDYX2cSeOaYrFESeSAY5JGTNjGOPBMJsCkQITLZJ
         iOOm7LcQX9P7mYHrrAZ2+TB6eFrnnZMba+zWNWwL4ZRaGwNhNU5VvQ0TJvLui2ZwuJCE
         4sU5sRwXbYAQnun+nb126p6lnfpNzWsIUfIlVmvrRwdLJDICmezG2WViNC+6UsQJ3KQu
         +qk5m+T3zVszEgskTXdb+vTGHzOvNhlVxUcdsJ1H60R96eqETYMZohw8wnVZQ+TIcxm/
         z+gURWReJ2AnDn2UQta9zey0RnvOuh0/xDdjqD0hszCcVFN+9uA8kbaVkmH6k7vTmc26
         +Png==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZVsuZ9FnY7uJ22jtUdcoFPRwS+JucV/Oze9JDoVessA=;
        b=dXCLZBlZ0yIHB0bw6kQpl15C2NYQ75vFHbvTY0W7QAF064688fJdjNRi5QQfBv7lud
         kKoehNPq3MilIaabD9RhPDXcOcxsScpuyR9/KsVoatUfmlrHm4xLelE28JH//lWQtpet
         pgrcxsd9oYN4+jOQM/BH1hMpLud05cfMzk52s51U/oHny6NLs2zW7oGMt6BWKFrxZrXz
         z1Uv+aThXZuiL3iGEUghUlXUdOh0oi4uASovvI1DmiaLp1rHD1qK60mhosc6vgLobTGK
         BBmgukzyYNnkU1+6SusuzlRHiFBGS5/s2iblPf8QJb1BeURHZHr8xzGHZRqQLLxaOO9b
         7Sng==
X-Gm-Message-State: AOAM532ehXG+EuKsOw7GmW4znTbw1r5orr8k9gUQE4l99BXd+e4w84jB
        ltKwkrJsxqf76PUS4EdARyKB3+ZYYnfUzQ==
X-Google-Smtp-Source: ABdhPJz+dzbKllATWbtKmkQd/DrJqbYoNbSel0xTdpFWx2zwApEiwCvHVbglyrG2aEak0TT6cg9O9w==
X-Received: by 2002:a17:902:ed88:b029:de:86f9:3e06 with SMTP id e8-20020a170902ed88b02900de86f93e06mr9650299plj.46.1610909948582;
        Sun, 17 Jan 2021 10:59:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o193sm14183522pfg.27.2021.01.17.10.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 10:59:07 -0800 (PST)
Message-ID: <600488fb.1c69fb81.2903d.3dda@mx.google.com>
Date:   Sun, 17 Jan 2021 10:59:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.167-55-gb4942424ad93
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 177 runs,
 7 regressions (v4.19.167-55-gb4942424ad93)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 177 runs, 7 regressions (v4.19.167-55-gb4942=
424ad93)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
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
nel/v4.19.167-55-gb4942424ad93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.167-55-gb4942424ad93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b4942424ad93b57e7c05808c253e71e0a7e32336 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6004565880c9e4f47dc94cdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004565880c9e4f47dc94=
cdd
        new failure (last pass: v4.19.167-43-g7a15ea567512) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600458316e10082053c94ccf

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600458316e10082=
053c94cd4
        new failure (last pass: v4.19.167-43-g7a15ea567512)
        2 lines

    2021-01-17 15:30:52.908000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-17 15:30:52.926000+00:00  <8>[   22.884368] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600454ce741b6565a4c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600454ce741b6565a4c94=
cd9
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600454d8741b6565a4c94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600454d8741b6565a4c94=
ce8
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600458071703e23b1ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600458071703e23b1ac94=
cba
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600454996ac62dc9d3c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600454996ac62dc9d3c94=
cba
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004549481fb38aae9c94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-55-gb4942424ad93/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004549481fb38aae9c94=
cec
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
