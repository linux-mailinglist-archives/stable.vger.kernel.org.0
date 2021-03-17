Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09F533FA4C
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 22:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhCQVJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 17:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhCQVJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 17:09:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F11C06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:09:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v23so190640ple.9
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d9GneiwF5WM5RjZJkvYbfXTyjDyqbC62PBSqYD9Zl0Y=;
        b=daGTzT72c1xWyUXjieQcsxoniJbfKb2Zr5M6f73hfuV6TwHQz5VcwCNvJMghkPZE5B
         CBSGszseLaTehsXlyx3eY2bEza4PBseINrinnc1ZBZW/CNjIFO1ikSVbUgaovrPg58cd
         mxF4gClTt3Jwd8evNmmhjVsypOOYfqAjVwK33LHmKsVl8ct2Nngo9t1dJxhfHDg3CaDM
         ThrHbLI84DiRLL07y59FR1srf9yEY1cX617aI1CUqbtiP9DU0QU1VDKJtYYi8mcGgwHo
         SmB3ZSwV7JfAKpQ45VEW5l+0TaDNmi1rGRCMR9GSfBBwvbS7wZPUhHbA9ArSZHDckNeD
         wIiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d9GneiwF5WM5RjZJkvYbfXTyjDyqbC62PBSqYD9Zl0Y=;
        b=ZJ4iErhVl8Lem3otO8sZf2PW6ipjbezCXVoVLBwI1cRlnTqMbIMeUgeKGe8RqwvlzE
         rESNZ1EbrRb0i2FhvVm6YsXzYx0/+gQgP5WNXF91zKb9gS1W9GTqVe4TnclctVGZlIJm
         lbCW0HPSi5Hq+Ki2GwPMa2xuELQzarXC4u4hlDoWh/pHlt/B0j20KggrreP8r2ShN+bN
         Yv6hKeNXYTjbYnkNpWz7ucv9+k+CyBBL2wrfIGafNKgOMtbwWEQCOl40yo6viDZDaQFC
         1aEG+oXaQAYeEZrxz5bby+7S1sj4M7wKeiWGdz9QXb4I4TAqbRxHs5CZhKIWDnwTUUVO
         PU8g==
X-Gm-Message-State: AOAM533uMblr31Hp7Pk1P8Swk9KdyDj4cgAJk8ZxusDTg4TM41din0Vu
        a+CSfGTAad3He2K+fUwp83FJBXO0u6+ijA==
X-Google-Smtp-Source: ABdhPJxDK714BAeJljrz6JW7yGwSOb0BP5gk2kKeFfyB48ipUGX+bg9rmFUCC9uVac8mJ1qmRYtByA==
X-Received: by 2002:a17:90a:5b11:: with SMTP id o17mr822947pji.32.1616015390439;
        Wed, 17 Mar 2021 14:09:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm4432303pjm.1.2021.03.17.14.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 14:09:50 -0700 (PDT)
Message-ID: <6052701e.1c69fb81.9c621.d091@mx.google.com>
Date:   Wed, 17 Mar 2021 14:09:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-119-g4ae23d3caade8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 168 runs,
 8 regressions (v4.19.180-119-g4ae23d3caade8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 168 runs, 8 regressions (v4.19.180-119-g4ae2=
3d3caade8)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =

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
nel/v4.19.180-119-g4ae23d3caade8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-119-g4ae23d3caade8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ae23d3caade83cd2d2b32c0f1137d20c7951cb3 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =


  Details:     https://kernelci.org/test/plan/id/60523c4c0853a203eeaddcd6

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60523c4c0853a203=
eeaddcd9
        new failure (last pass: v4.19.180-119-g7f6af756c8016)
        1 lines

    2021-03-17 17:27:36.047000+00:00  Connected to meson-gxm-q200 console [=
channel connected] (~$quit to exit)
    2021-03-17 17:27:36.047000+00:00  (user:khilman) is already connected
    2021-03-17 17:27:47.117000+00:00  GXM:BL1:dc8b51:76f1a5;FEAT:ADFC318C:0=
;POC:3;RCY:0;EMMC:0;READ:0;CHK:AA;SD:0;READ:0;0.0;CHK:0;
    2021-03-17 17:27:47.169000+00:00  no sdio debug board detected =

    2021-03-17 17:27:47.169000+00:00  TE: 311137
    2021-03-17 17:27:47.169000+00:00  =

    2021-03-17 17:27:47.169000+00:00  BL2 Built : 11:58:42, May 27 2017. =

    2021-03-17 17:27:47.169000+00:00  gxl gc3c9a84 - xiaobo.gu@droid05
    2021-03-17 17:27:47.169000+00:00  =

    2021-03-17 17:27:47.169000+00:00  set vcck to 1120 mv =

    ... (527 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60523c4c0853a20=
3eeaddcdb
        new failure (last pass: v4.19.180-119-g7f6af756c8016)
        3 lines

    2021-03-17 17:28:29.022000+00:00  kern  :emerg : Process udevd (pid:<8>=
[   16.692976] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNI=
TS=3Dlines MEASUREMENT=3D3>
    2021-03-17 17:28:29.022000+00:00   1522, stack<8>[   16.700250] <LAVA_S=
IGNAL_ENDRUN 0_dmesg 806219_1.5.2.4.1>
    2021-03-17 17:28:29.022000+00:00   limit =3D 0x(____ptrval____))
    2021-03-17 17:28:29.023000+00:00  kern  :emerg : Code: 17ffffef f9401bf=
7 17ffffed f9001bf7 (d4210000) =

    2021-03-17 17:28:29.023000+00:00  + set +x
    2021-03-17 17:28:29.127000+00:00  / # #   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60523ded89c227c926addcd5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60523ded89c227c=
926addcda
        failing since 1 day (last pass: v4.19.180-116-g4e76c9761792, first =
fail: v4.19.180-119-g7f6af756c8016)
        2 lines

    2021-03-17 17:35:36.273000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-17 17:35:36.287000+00:00  <8>[   22.584747] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60523bb6b7211ac148addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60523bb6b7211ac148add=
cbe
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60523bbe9ee5aaa0c4addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60523bbe9ee5aaa0c4add=
cbe
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052467afeda887b34addd3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052467afeda887b34add=
d3c
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60523b5c373ba23b06addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60523b5c373ba23b06add=
cba
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60523b6ffcee20bfd5addcf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-119-g4ae23d3caade8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60523b6ffcee20bfd5add=
cf7
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
