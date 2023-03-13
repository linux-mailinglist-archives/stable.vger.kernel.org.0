Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26B6B7DE7
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 17:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjCMQoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 12:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjCMQoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 12:44:01 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F93025977
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 09:43:50 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so4021755pjt.5
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 09:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678725829;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=C7XMeGnEL1QjXmD86TZ4SPOcO9YxlOLfu2mBP7o3XwU=;
        b=36Luq08MgRD3RLHFXYzS2xH1DU/uxmSXdagGUV+Xx8TfJ0aPbrCAy5hnCJ2vX9/m/j
         OIRQdLVA3ONwjjPlg3WEizTmEOGTKxrTedPPvtH4zJ/n4clnutn7bOK7AC92VgyKzT6c
         E9qJWSSU7fjwoOq+Zu+EtdiLVQmqwKURs2gSa5RaubAtmFwU8AZi+evk1a9V9SBTKPWe
         hHRB11wyECmFfoJbK7O+GWLuBHhnjP7sHDrEkXAe4uzPowGCoasSKz0TRjr1WrlnUHTE
         NWaUa4U2oDypS4VMsBsUdevbTl3Xmz33mrqDL5D5cd9Y8+V7ElhuSrwiV39T+VXVNI+M
         ZFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678725829;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7XMeGnEL1QjXmD86TZ4SPOcO9YxlOLfu2mBP7o3XwU=;
        b=OrGu/mz/ewEUq24SEqISDBdVkxY+5XYAKVESKIqR49L81FdciJpOFr0VGJQXeDPEdH
         7giU4juf/tgasJZrph4HJehscH+k+moIpvky3zCwXskdx3q+jd63PAe21wj6UtD19sUE
         VgyphhsaYcfxEs6AesFId5C30UD88JHNGDvo2DLkyJtv0ZOtxwvW8+mEGBNrC/t0I2bX
         qAu5UpLP2JfmGBZFkNO+CupqwmBSRPAHlKD1xj2W32HRAqnLjBVZA84zcP5n2WIm308j
         P0RHjsSEpsZ2OBf4TfW1dZgSROz4Of0FciLTC8gGC0mTUxPvE4yrRE3T7eXUAOVQyFat
         eDwg==
X-Gm-Message-State: AO0yUKXVTzjWhsupfftqcSsKm3vLGIsZhbMCwMv1OtzstRSG6z0qtWwt
        zbzWdA3+Gxw2C2Fx8Ru9GT3Qd3JRA7/mKAIZ56SBzg==
X-Google-Smtp-Source: AK7set8DeA3uA/oltrd8ISwG+GlBNK7XFSet139Lf5/+AY4M3SPvhWUSevCwlj3pP+LCoGXrK6+hOw==
X-Received: by 2002:a17:902:d2c3:b0:19a:f02c:a05b with SMTP id n3-20020a170902d2c300b0019af02ca05bmr44039808plc.3.1678725828071;
        Mon, 13 Mar 2023 09:43:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b0019f9fd5c24asm90255plg.207.2023.03.13.09.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 09:43:47 -0700 (PDT)
Message-ID: <640f52c3.170a0220.8533b.05c8@mx.google.com>
Date:   Mon, 13 Mar 2023 09:43:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.277
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 140 runs, 53 regressions (v4.19.277)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 140 runs, 53 regressions (v4.19.277)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

r8a7796-m3ulcb               | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =

sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.277/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.277
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4f95ee925a2ba6ca1a101e1d7b60656aa5067ea3 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1b3b8f7585ee318c863f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1b3b8f7585ee318c8648
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:46:33.721039  + set +x<8>[   10.060908] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9584738_1.4.2.3.1>

    2023-03-13T12:46:33.721605  =


    2023-03-13T12:46:33.829679  / # #

    2023-03-13T12:46:33.932657  export SHELL=3D/bin/sh

    2023-03-13T12:46:33.933499  #

    2023-03-13T12:46:34.035469  / # export SHELL=3D/bin/sh. /lava-9584738/e=
nvironment

    2023-03-13T12:46:34.036316  =


    2023-03-13T12:46:34.138378  / # . /lava-9584738/environment/lava-958473=
8/bin/lava-test-runner /lava-9584738/1

    2023-03-13T12:46:34.139706  =


    2023-03-13T12:46:34.145439  / # /lava-9584738/bin/lava-test-runner /lav=
a-9584738/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1b26c0ccdb3fc68c86aa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1b26c0ccdb3fc68c86b3
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:46:18.291515  + set +x

    2023-03-13T12:46:18.298279  <8>[   11.829748] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9584711_1.4.2.3.1>

    2023-03-13T12:46:18.403020  / # #

    2023-03-13T12:46:18.504050  export SHELL=3D/bin/sh

    2023-03-13T12:46:18.504263  #

    2023-03-13T12:46:18.605195  / # export SHELL=3D/bin/sh. /lava-9584711/e=
nvironment

    2023-03-13T12:46:18.605415  =


    2023-03-13T12:46:18.706340  / # . /lava-9584711/environment/lava-958471=
1/bin/lava-test-runner /lava-9584711/1

    2023-03-13T12:46:18.706626  =


    2023-03-13T12:46:18.711484  / # /lava-9584711/bin/lava-test-runner /lav=
a-9584711/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1957e575495a3a8c8649

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1957e575495a3a8c8652
        failing since 35 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-03-13T12:38:27.530009  + set +x
    2023-03-13T12:38:27.534368  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 151719_1.5.2=
.4.1>
    2023-03-13T12:38:27.648702  / # #
    2023-03-13T12:38:27.751724  export SHELL=3D/bin/sh
    2023-03-13T12:38:27.752483  #
    2023-03-13T12:38:27.854430  / # export SHELL=3D/bin/sh. /lava-151719/en=
vironment
    2023-03-13T12:38:27.855253  =

    2023-03-13T12:38:27.957227  / # . /lava-151719/environment/lava-151719/=
bin/lava-test-runner /lava-151719/1
    2023-03-13T12:38:27.958590  =

    2023-03-13T12:38:27.965070  / # /lava-151719/bin/lava-test-runner /lava=
-151719/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1cd0d68d451b728c8634

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1cd0d68d451b728c863d
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:53:16.545899  <8>[   11.791385] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 151814_1.5.2.4.1>
    2023-03-13T12:53:16.725215  / # #
    2023-03-13T12:53:16.854060  export SHELL=3D/bin/sh
    2023-03-13T12:53:16.861290  <6>[   11.835349] usb 1-1: new low-speed US=
B device number 3 using musb-hdrc
    2023-03-13T12:53:16.865122  #<3>[   11.985345] usb 1-1: device descript=
or read/64, error -71
    2023-03-13T12:53:16.868786  =

    2023-03-13T12:53:16.872578  / # export SHELL=3D/bin/sh
    2023-03-13T12:53:16.983879  / # . /lava-151814/environment
    2023-03-13T12:53:17.100419  /lava-151814/bin/lava-test-runner /lava-151=
814/1
    2023-03-13T12:53:17.113203  . /lava-151814/environment<3>[   12.255344]=
 usb 1-1: device descriptor read/64, error -71 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f2d4d0e448d36b38c862f

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f2d4d0e448d36b38c8636
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T14:03:40.950952  <8>[    8.897843] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 874389_1.5.2.4.1>
    2023-03-13T14:03:41.060460  / # #
    2023-03-13T14:03:41.163053  export SHELL=3D/bin/sh
    2023-03-13T14:03:41.163811  #
    2023-03-13T14:03:41.265758  / # export SHELL=3D/bin/sh. /lava-874389/en=
vironment
    2023-03-13T14:03:41.266397  =

    2023-03-13T14:03:41.368024  / # . /lava-874389/environment/lava-874389/=
bin/lava-test-runner /lava-874389/1
    2023-03-13T14:03:41.369105  =

    2023-03-13T14:03:41.375541  / # /lava-874389/bin/lava-test-runner /lava=
-874389/1
    2023-03-13T14:03:41.441779  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c61c440d4c9f08c8640

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c61c440d4c9f08c8649
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:51:27.340641  <8>[    7.352335] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3407639_1.5.2.4.1>
    2023-03-13T12:51:27.449743  / # #
    2023-03-13T12:51:27.551808  export SHELL=3D/bin/sh
    2023-03-13T12:51:27.552183  #
    2023-03-13T12:51:27.653365  / # export SHELL=3D/bin/sh. /lava-3407639/e=
nvironment
    2023-03-13T12:51:27.653765  =

    2023-03-13T12:51:27.755001  / # . /lava-3407639/environment/lava-340763=
9/bin/lava-test-runner /lava-3407639/1
    2023-03-13T12:51:27.755552  =

    2023-03-13T12:51:27.760523  / # /lava-3407639/bin/lava-test-runner /lav=
a-3407639/1
    2023-03-13T12:51:27.844072  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c532c794a28608c86a1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c532c794a28608c86aa
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:51:16.410920  / # #

    2023-03-13T12:51:16.513989  export SHELL=3D/bin/sh

    2023-03-13T12:51:16.514828  #

    2023-03-13T12:51:16.617031  / # export SHELL=3D/bin/sh. /lava-9584924/e=
nvironment

    2023-03-13T12:51:16.617870  =


    2023-03-13T12:51:16.720025  / # . /lava-9584924/environment/lava-958492=
4/bin/lava-test-runner /lava-9584924/1

    2023-03-13T12:51:16.721290  =


    2023-03-13T12:51:16.733420  / # /lava-9584924/bin/lava-test-runner /lav=
a-9584924/1

    2023-03-13T12:51:16.840213  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-13T12:51:16.840779  + cd /lava-9584924/1/tests/1_bootrr
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640f19d15bded5c9058c8638

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f19d15bded5c9058c8641
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:40:38.831787  + set +x[    7.155467] <LAVA_SIGNAL_ENDRUN =
0_dmesg 919778_1.5.2.3.1>
    2023-03-13T12:40:38.831955  =

    2023-03-13T12:40:38.939363  / # #
    2023-03-13T12:40:39.041113  export SHELL=3D/bin/sh
    2023-03-13T12:40:39.041640  #
    2023-03-13T12:40:39.142888  / # export SHELL=3D/bin/sh. /lava-919778/en=
vironment
    2023-03-13T12:40:39.143397  =

    2023-03-13T12:40:39.244621  / # . /lava-919778/environment/lava-919778/=
bin/lava-test-runner /lava-919778/1
    2023-03-13T12:40:39.245225  =

    2023-03-13T12:40:39.247882  / # /lava-919778/bin/lava-test-runner /lava=
-919778/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c29edb3a177da8c864c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c29edb3a177da8c8655
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:50:37.557033  + set +x
    2023-03-13T12:50:37.557192  [    4.792540] <LAVA_SIGNAL_ENDRUN 0_dmesg =
919780_1.5.2.3.1>
    2023-03-13T12:50:37.663497  / # #
    2023-03-13T12:50:37.765083  export SHELL=3D/bin/sh
    2023-03-13T12:50:37.765527  #
    2023-03-13T12:50:37.866814  / # export SHELL=3D/bin/sh. /lava-919780/en=
vironment
    2023-03-13T12:50:37.867267  =

    2023-03-13T12:50:37.968509  / # . /lava-919780/environment/lava-919780/=
bin/lava-test-runner /lava-919780/1
    2023-03-13T12:50:37.969043  =

    2023-03-13T12:50:37.971791  / # /lava-919780/bin/lava-test-runner /lava=
-919780/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx7d-sdb                    | arm    | lab-nxp         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c72a56decf17d8c866c

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c72a56decf17d8c8673
        failing since 53 days (last pass: v4.19.267, first fail: v4.19.270)

    2023-03-13T12:51:32.605759  <8>[   12.923183] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 1171350_1.5.2.4.1>
    2023-03-13T12:51:32.711279  / # #
    2023-03-13T12:51:33.871534  export SHELL=3D/bin/sh
    2023-03-13T12:51:33.877225  #
    2023-03-13T12:51:35.424506  / # export SHELL=3D/bin/sh. /lava-1171350/e=
nvironment
    2023-03-13T12:51:35.430282  =

    2023-03-13T12:51:38.250966  / # . /lava-1171350/environment/lava-117135=
0/bin/lava-test-runner /lava-1171350/1
    2023-03-13T12:51:38.256971  =

    2023-03-13T12:51:38.266628  / # /lava-1171350/bin/lava-test-runner /lav=
a-1171350/1
    2023-03-13T12:51:38.363670  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1a2af9a95aca608c868d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1a2af9a95aca608c8=
68e
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d72d94545ccb48c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1d72d94545ccb48c8=
64f
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f20568e6fe07cd98c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f20568e6fe07cd98c8=
634
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f22724a86b19d608c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f22724a86b19d608c8=
655
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f19fe59f9b886c88c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f19fe59f9b886c88c8=
645
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1a28f9a95aca608c8671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1a28f9a95aca608c8=
672
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d733d9669647f8c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1d733d9669647f8c8=
642
        failing since 189 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f2042a59fd822c78c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f2042a59fd822c78c8=
639
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f22feeb185abc218c86ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f22feeb185abc218c8=
6ae
        failing since 189 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d3178787b1a9c8c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1d3178787b1a9c8c8=
63f
        failing since 189 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1a2b66253332578c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1a2b66253332578c8=
63b
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d743d9669647f8c8647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1d743d9669647f8c8=
648
        failing since 189 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f2057aeeb4634fa8c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f2057aeeb4634fa8c8=
640
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f234ec8d9a917ce8c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f234ec8d9a917ce8c8=
645
        failing since 189 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d335931b6f60f8c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1d335931b6f60f8c8=
635
        failing since 189 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1a29f9a95aca608c867f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1a29f9a95aca608c8=
680
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d71d94545ccb48c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1d71d94545ccb48c8=
64b
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f2043a59fd822c78c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f2043a59fd822c78c8=
63c
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f224a4a86b19d608c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f224a4a86b19d608c8=
631
        failing since 305 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f19fcbea80bbd848c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f19fcbea80bbd848c8=
63e
        failing since 226 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1bc2ab34bacff98c8666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640f1bc2ab34bacff98c8=
667
        failing since 107 days (last pass: v4.19.266, first fail: v4.19.267=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7796-m3ulcb               | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f30fd8e649d8c018c863f

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-r8a7796-m3ulcb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-r8a7796-m3ulcb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f30fd8e649d8c018c8648
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T14:19:30.594750  / # #

    2023-03-13T14:19:30.698065  export SHELL=3D/bin/sh

    2023-03-13T14:19:30.698917  #

    2023-03-13T14:19:30.801030  / # export SHELL=3D/bin/sh. /lava-9584905/e=
nvironment

    2023-03-13T14:19:30.801834  =


    2023-03-13T14:19:30.903974  / # . /lava-9584905/environment/lava-958490=
5/bin/lava-test-runner /lava-9584905/1

    2023-03-13T14:19:30.905280  =


    2023-03-13T14:19:30.919589  / # /lava-9584905/bin/lava-test-runner /lav=
a-9584905/1

    2023-03-13T14:19:30.966752  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-13T14:19:30.967267  + cd /lav<8>[   17.570142] <LAVA_SIGNAL_STA=
RTRUN 1_bootrr 9584905_1.5.2.4.5>
 =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/640f1c4637c63d60508c86aa

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/640f1c4637c63d60508c86de
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:50:54.175679  BusyBox v1.31.1 (2023-03-03 12:54:59 UTC)<8=
>[   13.103045] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-03-13T12:50:54.178726   multi-call binary.

    2023-03-13T12:50:54.179028  =


    2023-03-13T12:50:54.192577  Usage: seq [-w] [-s SEP] [FIRST [INC]] LA<8=
>[   13.121907] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-cec-present RESULT=3Dfail>
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/640f1c4637c63d60508c86df
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270) =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c4637c63d60508c86f2
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:50:50.325959  <8>[    9.254819] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-03-13T12:50:50.336060  + <8>[    9.267154] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9584921_1.5.2.3.1>

    2023-03-13T12:50:50.336262  set +x

    2023-03-13T12:50:50.442568  #

    2023-03-13T12:50:50.544640  / # #export SHELL=3D/bin/sh

    2023-03-13T12:50:50.545124  =


    2023-03-13T12:50:50.646416  / # export SHELL=3D/bin/sh. /lava-9584921/e=
nvironment

    2023-03-13T12:50:50.646916  =


    2023-03-13T12:50:50.748237  / # . /lava-9584921/environment/lava-958492=
1/bin/lava-test-runner /lava-9584921/1

    2023-03-13T12:50:50.748854  =

 =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/640f194960eb77a26d8c8656

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/640f194960eb77a26d8c867c
        failing since 361 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-03-13T12:38:22.732134  <8>[   34.882626] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>

    2023-03-13T12:38:23.745224  /lava-9584537/1/../bin/lava-test-case

    2023-03-13T12:38:23.753910  <8>[   35.904961] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/640f194960eb77a26d8c8691
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:38:22.261252  12:31:33 UTC) multi-call binary.

    2023-03-13T12:38:22.261677  =


    2023-03-13T12:38:22.265925  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-03-13T12:38:22.266213  =

   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/640f194960eb77a26d8c8692
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:38:22.235233  	<8>[   34.382446] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Drk3399-gru-sound-driver-dp-present RESULT=3Dfail>

    2023-03-13T12:38:22.238382  -w	Pad to last with leading zeros

    2023-03-13T12:38:22.241120  	-s SEP	String separator

    2023-03-13T12:38:22.244613  /lava-9584537/1/../bin/lava-test-case

    2023-03-13T12:38:22.257811  BusyBox v1.31.1 (2023-03-03 <8>[   34.40542=
5] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-max98357A-p=
resent RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/640f194960eb77a26d8c8693
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:38:22.217065  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-03-13T12:38:22.217406  =


    2023-03-13T12:38:22.222260  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-03-13T12:38:22.224769  FIRST, INC default to 1.

    2023-03-13T12:38:22.224910  =

   =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/640f194960eb77a26d8c8694
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:38:22.185752  <8>[   34.336080] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-present RESULT=3Dpass>

    2023-03-13T12:38:22.201627  BusyBox v1.31.1 (2023-03-03 12:31:33 UTC) m=
ulti-call binary.

    2023-03-13T12:38:22.202140  =


    2023-03-13T12:38:22.212416  <8>[   34.359745] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-da7219-present RESULT=3Dfail>
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c472c794a28608c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c472c794a28608c8638
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:50:53.567698  + set +x
    2023-03-13T12:50:53.569791  <8>[   17.150159] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 412277_1.5.2.4.1>
    2023-03-13T12:50:53.679446  / # #
    2023-03-13T12:50:53.782092  export SHELL=3D/bin/sh
    2023-03-13T12:50:53.783073  #
    2023-03-13T12:50:53.783607  / # <3>[   17.299055] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-03-13T12:50:53.885445  export SHELL=3D/bin/sh. /lava-412277/enviro=
nment
    2023-03-13T12:50:53.886302  =

    2023-03-13T12:50:53.988120  / # . /lava-412277/environment/lava-412277/=
bin/lava-test-runner /lava-412277/1
    2023-03-13T12:50:53.989686   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c9fb3d9b517af8c867b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c9fb3d9b517af8c8684
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:52:31.375093  <8>[   15.943390] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 151789_1.5.2.4.1>
    2023-03-13T12:52:31.480513  / # #
    2023-03-13T12:52:31.582918  export SHELL=3D/bin/sh
    2023-03-13T12:52:31.583765  #
    2023-03-13T12:52:31.685647  / # export SHELL=3D/bin/sh. /lava-151789/en=
vironment
    2023-03-13T12:52:31.686527  =

    2023-03-13T12:52:31.788930  / # . /lava-151789/environment/lava-151789/=
bin/lava-test-runner /lava-151789/1
    2023-03-13T12:52:31.790095  =

    2023-03-13T12:52:31.794306  / # /lava-151789/bin/lava-test-runner /lava=
-151789/1
    2023-03-13T12:52:31.825898  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c23199c565b338c864c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c23199c565b338c8655
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:50:29.555415  / # #
    2023-03-13T12:50:29.657539  export SHELL=3D/bin/sh
    2023-03-13T12:50:29.658086  #
    2023-03-13T12:50:29.759885  / # export SHELL=3D/bin/sh. /lava-412276/en=
vironment
    2023-03-13T12:50:29.760977  =

    2023-03-13T12:50:29.862926  / # . /lava-412276/environment/lava-412276/=
bin/lava-test-runner /lava-412276/1
    2023-03-13T12:50:29.864216  =

    2023-03-13T12:50:29.874213  / # /lava-412276/bin/lava-test-runner /lava=
-412276/1
    2023-03-13T12:50:29.938724  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-13T12:50:29.939297  + cd /lava-412276/<8>[   15.633218] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 412276_1.5.2.4.5> =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c3237c63d60508c865a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c3237c63d60508c8663
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:50:49.760729  / # #

    2023-03-13T12:50:49.862571  export SHELL=3D/bin/sh

    2023-03-13T12:50:49.863104  #

    2023-03-13T12:50:49.964475  / # export SHELL=3D/bin/sh. /lava-9584902/e=
nvironment

    2023-03-13T12:50:49.964852  =


    2023-03-13T12:50:50.066189  / # . /lava-9584902/environment/lava-958490=
2/bin/lava-test-runner /lava-9584902/1

    2023-03-13T12:50:50.066827  =


    2023-03-13T12:50:50.070848  / # /lava-9584902/bin/lava-test-runner /lav=
a-9584902/1

    2023-03-13T12:50:50.142933  + export 'TESTRUN_ID=3D1_bootrr'

    2023-03-13T12:50:50.143169  + cd /lava-9584902<8>[   15.625686] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 9584902_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1cabdc1ddda25f8c8644

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1cabdc1ddda25f8c864d
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:52:38.508548  <8>[   17.481467] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 412281_1.5.2.4.1>
    2023-03-13T12:52:38.615372  / # #
    2023-03-13T12:52:38.717772  export SHELL=3D/bin/sh
    2023-03-13T12:52:38.718780  #
    2023-03-13T12:52:38.820449  / # export SHELL=3D/bin/sh. /lava-412281/en=
vironment
    2023-03-13T12:52:38.821414  =

    2023-03-13T12:52:38.923104  / # . /lava-412281/environment/lava-412281/=
bin/lava-test-runner /lava-412281/1
    2023-03-13T12:52:38.924245  =

    2023-03-13T12:52:38.939369  / # /lava-412281/bin/lava-test-runner /lava=
-412281/1
    2023-03-13T12:52:39.065537  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1c5ce398c897cc8c863e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1c5ce398c897cc8c8647
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:51:23.751260  + set +x
    2023-03-13T12:51:23.753072  <8>[    9.135868] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3407643_1.5.2.4.1>
    2023-03-13T12:51:23.858220  / # #
    2023-03-13T12:51:23.960011  export SHELL=3D/bin/sh
    2023-03-13T12:51:23.960509  #
    2023-03-13T12:51:24.061852  / # export SHELL=3D/bin/sh. /lava-3407643/e=
nvironment
    2023-03-13T12:51:24.062220  =

    2023-03-13T12:51:24.163511  / # . /lava-3407643/environment/lava-340764=
3/bin/lava-test-runner /lava-3407643/1
    2023-03-13T12:51:24.164126  =

    2023-03-13T12:51:24.184533  / # /lava-3407643/bin/lava-test-runner /lav=
a-3407643/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/640f18d55cc9c611b88c8652

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f18d55cc9c611b88c865b
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:36:27.971470  <8>[    7.947271] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3407566_1.5.2.4.1>
    2023-03-13T12:36:28.077190  / # #
    2023-03-13T12:36:28.179207  export SHELL=3D/bin/sh
    2023-03-13T12:36:28.179750  #
    2023-03-13T12:36:28.281258  / # export SHELL=3D/bin/sh. /lava-3407566/e=
nvironment
    2023-03-13T12:36:28.281666  =

    2023-03-13T12:36:28.383110  / # . /lava-3407566/environment/lava-340756=
6/bin/lava-test-runner /lava-3407566/1
    2023-03-13T12:36:28.383808  =

    2023-03-13T12:36:28.402557  / # /lava-3407566/bin/lava-test-runner /lav=
a-3407566/1
    2023-03-13T12:36:28.467354  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d23a7dd6012ef8c8654

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1d23a7dd6012ef8c865d
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:54:45.423847  + set +x
    2023-03-13T12:54:45.425994  <8>[   11.201935] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 412278_1.5.2.4.1>
    2023-03-13T12:54:45.534125  / # #
    2023-03-13T12:54:45.637011  export SHELL=3D/bin/sh
    2023-03-13T12:54:45.637572  #
    2023-03-13T12:54:45.739197  / # export SHELL=3D/bin/sh. /lava-412278/en=
vironment
    2023-03-13T12:54:45.739844  =

    2023-03-13T12:54:45.841441  / # . /lava-412278/environment/lava-412278/=
bin/lava-test-runner /lava-412278/1
    2023-03-13T12:54:45.842458  =

    2023-03-13T12:54:45.844169  / # /lava-412278/bin/lava-test-runner /lava=
-412278/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/640f194f0d4815ea378c8639

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f194f0d4815ea378c8642
        failing since 53 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:38:24.675515  + set +x
    2023-03-13T12:38:24.677606  <8>[   15.520439] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 412268_1.5.2.4.1>
    2023-03-13T12:38:24.785355  / # #
    2023-03-13T12:38:24.887652  export SHELL=3D/bin/sh
    2023-03-13T12:38:24.888255  #
    2023-03-13T12:38:24.989950  / # export SHELL=3D/bin/sh. /lava-412268/en=
vironment
    2023-03-13T12:38:24.990536  =

    2023-03-13T12:38:25.092170  / # . /lava-412268/environment/lava-412268/=
bin/lava-test-runner /lava-412268/1
    2023-03-13T12:38:25.093185  =

    2023-03-13T12:38:25.095088  / # /lava-412268/bin/lava-test-runner /lava=
-412268/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1cfbf8d5fc66928c8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1cfbf8d5fc66928c8662
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:54:04.335309  <8>[   18.300078] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-03-13T12:54:04.339559  + set +x

    2023-03-13T12:54:04.345184  <8>[   18.312716] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9584913_1.5.2.3.1>

    2023-03-13T12:54:04.455251  =


    2023-03-13T12:54:04.556911  / # #export SHELL=3D/bin/sh

    2023-03-13T12:54:04.557663  =


    2023-03-13T12:54:04.659570  / # export SHELL=3D/bin/sh. /lava-9584913/e=
nvironment

    2023-03-13T12:54:04.660430  =


    2023-03-13T12:54:04.762663  / # . /lava-9584913/environment/lava-958491=
3/bin/lava-test-runner /lava-9584913/1

    2023-03-13T12:54:04.764125  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1a2af9a95aca608c8682

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1a2af9a95aca608c868b
        failing since 52 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-03-13T12:41:58.035069  : 139, stack limit =3D 0x(ptrval))

    2023-03-13T12:41:58.043565  kern  :emerg : Stack: (0xc2c4d<8>[   18.804=
481] <LAVA_SIGNAL_ENDRUN 0_dmesg 9584525_1.5.2.3.1>

    2023-03-13T12:41:58.045630  f2c to 0xc2c4e000)

    2023-03-13T12:41:58.053391  kern  :emerg : df20:                       =
     c02e8180 00000000 00000000 c026d82c 00000003

    2023-03-13T12:41:58.061554  kern  :emerg : df40: c2cb8780 be9baf74 c2c4=
df80 00000000 c2c4c000 00000004 00000003 c02706e0

    2023-03-13T12:41:58.069896  kern  :emerg : df60: edfe37f0 c026d82c c2cb=
8780 c2cb8780 be9baf74 00000003 c0101264 c0270944

    2023-03-13T12:41:58.078121  kern  :emerg : df80: 00000000 00000000 c2c4=
dfb0 69334240 b6eff7c0 00000003 b6eff7c0 be9ba468

    2023-03-13T12:41:58.085850  kern  :emerg : dfa0: 00000004 c0101000 0000=
0003 b6eff7c0 00000003 be9baf74 00000003 00000000

    2023-03-13T12:41:58.094151  kern  :emerg : dfc0: 00000003 b6eff7c0 be9b=
a468 00000004 00000003 0003c90c be9bae58 00000003

    2023-03-13T12:41:58.102649  kern  :emerg : dfe0: 00059120 be9ba440 b6bc=
5960 b6bc597c 60000010 00000003 00000000 00000000
 =

    ... (22 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1baeab34bacff98c8635

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1baeab34bacff98c863c
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:48:35.704592  <8>[    3.714793] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 874355_1.5.2.4.1>
    2023-03-13T12:48:35.810183  / # #
    2023-03-13T12:48:35.912239  export SHELL=3D/bin/sh
    2023-03-13T12:48:35.912730  #
    2023-03-13T12:48:36.014169  / # export SHELL=3D/bin/sh. /lava-874355/en=
vironment
    2023-03-13T12:48:36.014660  =

    2023-03-13T12:48:36.116124  / # . /lava-874355/environment/lava-874355/=
bin/lava-test-runner /lava-874355/1
    2023-03-13T12:48:36.116959  =

    2023-03-13T12:48:36.119700  / # /lava-874355/bin/lava-test-runner /lava=
-874355/1
    2023-03-13T12:48:36.156752  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/640f1d02f8d5fc66928c8667

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.277/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640f1d02f8d5fc66928c866e
        failing since 53 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-03-13T12:54:05.724668  + set +x
    2023-03-13T12:54:05.725791  <8>[    3.754514] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 874382_1.5.2.4.1>
    2023-03-13T12:54:05.832999  / # #
    2023-03-13T12:54:05.934856  export SHELL=3D/bin/sh
    2023-03-13T12:54:05.935410  #
    2023-03-13T12:54:06.036742  / # export SHELL=3D/bin/sh. /lava-874382/en=
vironment
    2023-03-13T12:54:06.037045  =

    2023-03-13T12:54:06.138250  / # . /lava-874382/environment/lava-874382/=
bin/lava-test-runner /lava-874382/1
    2023-03-13T12:54:06.139044  =

    2023-03-13T12:54:06.141647  / # /lava-874382/bin/lava-test-runner /lava=
-874382/1 =

    ... (13 line(s) more)  =

 =20
