Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C55F6A2A94
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 16:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBYPxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 10:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBYPxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 10:53:08 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DB7FF1D
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 07:53:03 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l1so2017478pjt.2
        for <stable@vger.kernel.org>; Sat, 25 Feb 2023 07:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SvCKjJbe+re+3N9mUHha9pYLpG2eJzjtaAk6vA/GPwE=;
        b=L5DRmuBqG5LwVTliCnD1MUDKP3x94Ku7GLSTLD/rB3gvNow1FBVpaDX+DYWbMSRsvS
         E83S5Mi3V1lhgpPjlYHfiGsiZeswcun/8J+UMX4u2oM5f7H39+TXw3Nuple6sLvHaxe8
         3fDTGT0A5vS0V3vFWsidm3AIDUuBpRB5r1T46A0UNqT+GUGgHzh+uLgbO3CK2tOUuiww
         I6UXhRC/Q1RGno3skgl7rvwN48pNSAvXmrV9ObNXMHbxrTk4UWU+pIEQsjK/7969nfbC
         4vCMI9KSxavl6s++ql9bsMEcsMAouGBFpgHu0UCIrnDkqPfA0ILgqwTOJOMRRtb7AeIm
         Qf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SvCKjJbe+re+3N9mUHha9pYLpG2eJzjtaAk6vA/GPwE=;
        b=c3BG+yDjiW8wcF+BCb8vlWTE2sPRupzYp0K0oc7ZVHupTa+tJVaxmYtD1kdS5LskwA
         ovD1h/udd1t/yV9W691SDXlh5d7m41w33ZKP6JiIXB7IYxpuE5AfvEeKnHpVXU0Ovfup
         W1tsGNWy+xISGU3WI69vbkkcB4nTZ6vdqEHq1UAQ1xXN3rbYFFmNswfYgK46gOXiUYiU
         H7z6Yqi/PcJVufm8M7Xt0TU5sl32Nccz0Edlq+oPDoGoCh34TKZHWuLYEsBsXGR2kVHH
         mURRP6uHTHoxfS8v4/5yVda1Px9tqvFUShhSOVtslgsAzSSTp4tz5oW55rS1kUVKnU6l
         sNaA==
X-Gm-Message-State: AO0yUKX3TuIQ9lZIDnrlBjHi0Y5QRboASEePVwopyDHVXANH9XQsSSYB
        5FMziAuvFAecVGwPRREirMyhtyD5bZ30a+Vs/MORDQ==
X-Google-Smtp-Source: AK7set+Xp7NZ4Ec5yUwDfu1vzX8V++Mb2fArhJz46w1cbNv3uQxPR37wokVNKbLetLWRL5lUvmLo9w==
X-Received: by 2002:a17:903:1103:b0:19c:bcda:ac72 with SMTP id n3-20020a170903110300b0019cbcdaac72mr9281515plh.56.1677340381250;
        Sat, 25 Feb 2023 07:53:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mm13-20020a17090b358d00b0023417fec520sm3330188pjb.44.2023.02.25.07.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 07:53:00 -0800 (PST)
Message-ID: <63fa2edc.170a0220.ccaf0.65dc@mx.google.com>
Date:   Sat, 25 Feb 2023 07:53:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.274
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 143 runs, 53 regressions (v4.19.274)
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

stable/linux-4.19.y baseline: 143 runs, 53 regressions (v4.19.274)

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

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

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
fig                    | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.274/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.274
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2e3d9118e4e62b90603d61abd45d8bb29ebe7920 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f9e4555f008fcf8c865f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f9e4555f008fcf8c8668
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:06:39.581855  + set +x

    2023-02-25T12:06:39.588256  <8>[    9.386682] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9329761_1.4.2.3.1>

    2023-02-25T12:06:39.690815  =


    2023-02-25T12:06:39.792011  / # #export SHELL=3D/bin/sh

    2023-02-25T12:06:39.792863  =


    2023-02-25T12:06:39.894767  / # export SHELL=3D/bin/sh. /lava-9329761/e=
nvironment

    2023-02-25T12:06:39.895561  =


    2023-02-25T12:06:39.997537  / # . /lava-9329761/environment/lava-932976=
1/bin/lava-test-runner /lava-9329761/1

    2023-02-25T12:06:39.998789  =


    2023-02-25T12:06:40.003945  / # /lava-9329761/bin/lava-test-runner /lav=
a-9329761/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fa32dbb8ca0e348c866f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fa32dbb8ca0e348c8678
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:08:01.320354  + set +x

    2023-02-25T12:08:01.326222  <8>[   10.633941] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9329728_1.4.2.3.1>

    2023-02-25T12:08:01.430929  #

    2023-02-25T12:08:01.532055  / # #export SHELL=3D/bin/sh

    2023-02-25T12:08:01.532216  =


    2023-02-25T12:08:01.633071  / # export SHELL=3D/bin/sh. /lava-9329728/e=
nvironment

    2023-02-25T12:08:01.633239  =


    2023-02-25T12:08:01.734114  / # . /lava-9329728/environment/lava-932972=
8/bin/lava-test-runner /lava-9329728/1

    2023-02-25T12:08:01.734365  =


    2023-02-25T12:08:01.736676  / # /lava-9329728/bin/lava-test-runner /lav=
a-9329728/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f96ccbb25cd7608c866b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f96ccbb25cd7608c8674
        failing since 19 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-02-25T12:04:41.781313  + set +x
    2023-02-25T12:04:41.786310  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 74317_1.5.2.=
4.1>
    2023-02-25T12:04:41.899233  / # #
    2023-02-25T12:04:42.002115  export SHELL=3D/bin/sh
    2023-02-25T12:04:42.002943  #
    2023-02-25T12:04:42.104885  / # export SHELL=3D/bin/sh. /lava-74317/env=
ironment
    2023-02-25T12:04:42.105664  =

    2023-02-25T12:04:42.207727  / # . /lava-74317/environment/lava-74317/bi=
n/lava-test-runner /lava-74317/1
    2023-02-25T12:04:42.209012  =

    2023-02-25T12:04:42.215439  / # /lava-74317/bin/lava-test-runner /lava-=
74317/1 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f93b6fca86f6898c8648

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f93b6fca86f6898c8651
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:04:03.439803  <8>[   11.757318] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 74284_1.5.2.4.1>
    2023-02-25T12:04:03.549104  / # #
    2023-02-25T12:04:03.652163  export SHELL=3D/bin/sh
    2023-02-25T12:04:03.653070  #
    2023-02-25T12:04:03.653509  / # export SHELL=3D/bin/sh<6>[   11.965104]=
 usb 1-1: new low-speed USB device number 3 using musb-hdrc
    2023-02-25T12:04:03.755502  . /lava-74284/environment
    2023-02-25T12:04:03.756458  =

    2023-02-25T12:04:03.858579  / # . /lava-74284/environment/lava-74284/bi=
n/lava-test-runner /lava-74284/1
    2023-02-25T12:04:03.860015  =

    2023-02-25T12:04:03.860422  / # <3>[   12.115139] usb 1-1: device descr=
iptor read/64, error -71 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f94c6fca86f6898c86c7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f94c6fca86f6898c86d0
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:04:19.299189  / # #

    2023-02-25T12:04:19.402411  export SHELL=3D/bin/sh

    2023-02-25T12:04:19.403319  #

    2023-02-25T12:04:19.505454  / # export SHELL=3D/bin/sh. /lava-9329688/e=
nvironment

    2023-02-25T12:04:19.506344  =


    2023-02-25T12:04:19.608744  / # . /lava-9329688/environment/lava-932968=
8/bin/lava-test-runner /lava-9329688/1

    2023-02-25T12:04:19.610132  =


    2023-02-25T12:04:19.622617  / # /lava-9329688/bin/lava-test-runner /lav=
a-9329688/1

    2023-02-25T12:04:19.728566  + export 'TESTRUN_ID=3D1_bootrr'

    2023-02-25T12:04:19.729127  + cd /lava-9329688/1/tests/1_bootrr
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fa5ba5555c43ca8c8667

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fa5ba5555c43ca8c8670
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:08:50.570334  + set +x[    7.111495] <LAVA_SIGNAL_ENDRUN =
0_dmesg 912961_1.5.2.3.1>
    2023-02-25T12:08:50.570499  =

    2023-02-25T12:08:50.677389  / # #
    2023-02-25T12:08:50.779148  export SHELL=3D/bin/sh
    2023-02-25T12:08:50.779666  #
    2023-02-25T12:08:50.880807  / # export SHELL=3D/bin/sh. /lava-912961/en=
vironment
    2023-02-25T12:08:50.881261  =

    2023-02-25T12:08:50.982438  / # . /lava-912961/environment/lava-912961/=
bin/lava-test-runner /lava-912961/1
    2023-02-25T12:08:50.982927  =

    2023-02-25T12:08:50.985666  / # /lava-912961/bin/lava-test-runner /lava=
-912961/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f91b63bdadd8d68c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f91b63bdadd8d68c8638
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:03:31.958735  + set +x
    2023-02-25T12:03:31.958904  [    4.884452] <LAVA_SIGNAL_ENDRUN 0_dmesg =
912958_1.5.2.3.1>
    2023-02-25T12:03:32.064940  / # #
    2023-02-25T12:03:32.166511  export SHELL=3D/bin/sh
    2023-02-25T12:03:32.166907  #
    2023-02-25T12:03:32.268175  / # export SHELL=3D/bin/sh. /lava-912958/en=
vironment
    2023-02-25T12:03:32.268580  =

    2023-02-25T12:03:32.370007  / # . /lava-912958/environment/lava-912958/=
bin/lava-test-runner /lava-912958/1
    2023-02-25T12:03:32.370712  =

    2023-02-25T12:03:32.373203  / # /lava-912958/bin/lava-test-runner /lava=
-912958/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fbfda7c063e2528c8679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fbfda7c063e2528c8=
67a
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fef91ac414747c8c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fef91ac414747c8c8=
634
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc9b1ee8d4cc4e8c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fc9b1ee8d4cc4e8c8=
649
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63fa001f813e79eb1c8c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63fa001f813e79eb1c8c8=
655
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fbe7a7c063e2528c8634

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fbe7a7c063e2528c8=
635
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fee04b3a6cfcee8c867f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fee04b3a6cfcee8c8=
680
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc1165e77af77b8c865f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fc1165e77af77b8c8=
660
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fef6b57ac887018c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fef6b57ac887018c8=
641
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc5fbd4a7e2a8f8c86ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fc5fbd4a7e2a8f8c8=
700
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9ff5734999406a28c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9ff5734999406a28c8=
63d
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fbe7c72e1997a68c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fbe7c72e1997a68c8=
634
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fee04b3a6cfcee8c867c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fee04b3a6cfcee8c8=
67d
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc128acbb0b1948c86df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fc128acbb0b1948c8=
6e0
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fef7b57ac887018c8643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fef7b57ac887018c8=
644
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc60e9358aaee78c865e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fc60e9358aaee78c8=
65f
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9ff7f6d0fa641608c8661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9ff7f6d0fa641608c8=
662
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fbfbc72e1997a68c8680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fbfbc72e1997a68c8=
681
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fee14b3a6cfcee8c8682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fee14b3a6cfcee8c8=
683
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc13e16bbbd0278c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fc13e16bbbd0278c8=
63f
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fef8b57ac887018c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fef8b57ac887018c8=
647
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc886ae9c1d41b8c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fc886ae9c1d41b8c8=
656
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9ffa72d5be706468c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9ffa72d5be706468c8=
654
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fbe8c72e1997a68c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fbe8c72e1997a68c8=
63a
        failing since 173 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fef4e86a0e137e8c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9fef4e86a0e137e8c8=
649
        failing since 210 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9faece957661a7b8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f9faece957661a7b8c8=
630
        failing since 91 days (last pass: v4.19.266, first fail: v4.19.267) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/63f9f93b6fca86f6898c8653

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/63f9f93b6fca86f6898c8686
        failing since 36 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:03:58.930641  BusyBox v1.31.1 (2023-02-17 15:41:33 UTC)<8=
>[   10.398256] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-02-25T12:03:58.931873   multi-call binary.

    2023-02-25T12:03:58.932400  =


    2023-02-25T12:03:58.936091  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-02-25T12:03:58.936620  =


    2023-02-25T12:03:58.941613  Print numbers from FIRST to LAST, in steps =
of INC.
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/63f9f93b6fca86f6898c8687
        failing since 36 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:03:58.911364  <8>[   10.380652] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwhdmi-rockchip-probed RESULT=3Dpass>
   =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f93b6fca86f6898c869b
        failing since 36 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:03:55.086729  + <8>[    6.559915] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9329681_1.5.2.3.1>

    2023-02-25T12:03:55.089734  set +x

    2023-02-25T12:03:55.195969  =


    2023-02-25T12:03:55.298371  / # #export SHELL=3D/bin/sh

    2023-02-25T12:03:55.299150  =


    2023-02-25T12:03:55.400899  / # export SHELL=3D/bin/sh. /lava-9329681/e=
nvironment

    2023-02-25T12:03:55.401729  =


    2023-02-25T12:03:55.503731  / # . /lava-9329681/environment/lava-932968=
1/bin/lava-test-runner /lava-9329681/1

    2023-02-25T12:03:55.504617  =


    2023-02-25T12:03:55.506972  / # /lava-9329681/bin/lava-test-runner /lav=
a-9329681/1
 =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/63f9fe577d62c0874f8c866b

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63f9fe577d62c0874f8c868f
        failing since 345 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-02-25T12:25:40.845134  /lava-9330031/1/../bin/lava-test-case<8>[  =
 35.221296] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s0-probed RESUL=
T=3Dpass>

    2023-02-25T12:25:40.845460  =


    2023-02-25T12:25:41.862748  /lava-9330031/1/../bin/lava-test-case

    2023-02-25T12:25:41.870831  <8>[   36.246932] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/63f9fe577d62c0874f8c86a1
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:25:40.334154  ST to LAST, in steps of INC.

    2023-02-25T12:25:40.336543  FIRST, INC default to 1.

    2023-02-25T12:25:40.337192  =


    2023-02-25T12:25:40.340583  	-w	Pad to last with leading zeros

    2023-02-25T12:25:40.342743  	-s SEP	String separator

    2023-02-25T12:25:40.346791  /lava-9330031/1/../bin/lava-test-case

    2023-02-25T12:25:40.360085  BusyBox v1.31.1 (2023-02-17 14:37<8>[   34.=
730306] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-rt5514=
-present RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/63f9fe577d62c0874f8c86a2
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:25:40.302163  	-s SE<8>[   34.671808] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Drk3399-gru-sound-driver-dp-present RESULT=3Dfail>

    2023-02-25T12:25:40.303914  P	String separator

    2023-02-25T12:25:40.307682  /lava-9330031/1/../bin/lava-test-case

    2023-02-25T12:25:40.313600  BusyBox v1.31.1 (2023-02-17 14:37:44 UTC) m=
ulti-call binary.

    2023-02-25T12:25:40.314015  =


    2023-02-25T12:25:40.318384  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-02-25T12:25:40.318621  =


    2023-02-25T12:25:40.331729  Print numbers from FIR<8>[   34.701097] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-max98357A-present=
 RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/63f9fe577d62c0874f8c86a3
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:25:40.272569  Usage: seq [-w] [-s SEP] [FIRST [INC]] LA<8=
>[   34.641085] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-drive=
r-da7219-present RESULT=3Dfail>

    2023-02-25T12:25:40.279666  ST

    2023-02-25T12:25:40.280010  =


    2023-02-25T12:25:40.285111  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-02-25T12:25:40.287376  FIRST, INC default to 1.

    2023-02-25T12:25:40.287856  =


    2023-02-25T12:25:40.291729  	-w	Pad to last with leading zeros
   =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/63f9fe577d62c0874f8c86a4
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:25:40.246302  <8>[   34.620261] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-present RESULT=3Dpass>

    2023-02-25T12:25:40.257900  BusyBox v1.31.1 (2023-02-17 14:37:44 UTC) m=
ulti-call binary.

    2023-02-25T12:25:40.258227  =

   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fb052ffe62a9ed8c8662

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fb052ffe62a9ed8c866b
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:11:24.416407  + set +x
    2023-02-25T12:11:24.418307  <8>[   17.086443] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 404361_1.5.2.4.1>
    2023-02-25T12:11:24.526369  / # #
    2023-02-25T12:11:24.629079  export SHELL=3D/bin/sh
    2023-02-25T12:11:24.629699  #
    2023-02-25T12:11:24.731402  / # export SHELL=3D/bin/sh. /lava-404361/en=
vironment
    2023-02-25T12:11:24.731968  =

    2023-02-25T12:11:24.732347  / # <3>[   17.313742] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-02-25T12:11:24.834204  . /lava-404361/environment/lava-404361/bin/=
lava-test-runner /lava-404361/1
    2023-02-25T12:11:24.835265   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fb8307606fce3d8c866d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fb8307606fce3d8c8676
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:13:37.582207  <8>[   15.939525] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 74393_1.5.2.4.1>
    2023-02-25T12:13:37.687772  / # #
    2023-02-25T12:13:37.790040  export SHELL=3D/bin/sh
    2023-02-25T12:13:37.790560  #
    2023-02-25T12:13:37.892042  / # export SHELL=3D/bin/sh. /lava-74393/env=
ironment
    2023-02-25T12:13:37.892682  =

    2023-02-25T12:13:37.994167  / # . /lava-74393/environment/lava-74393/bi=
n/lava-test-runner /lava-74393/1
    2023-02-25T12:13:37.995003  =

    2023-02-25T12:13:37.999171  / # /lava-74393/bin/lava-test-runner /lava-=
74393/1
    2023-02-25T12:13:38.030935  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9faf376e724508c8c8772

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9faf376e724508c8c877b
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:11:18.949105  / # #
    2023-02-25T12:11:19.051408  export SHELL=3D/bin/sh
    2023-02-25T12:11:19.052172  #
    2023-02-25T12:11:19.153580  / # export SHELL=3D/bin/sh. /lava-404359/en=
vironment
    2023-02-25T12:11:19.154373  =

    2023-02-25T12:11:19.255890  / # . /lava-404359/environment/lava-404359/=
bin/lava-test-runner /lava-404359/1
    2023-02-25T12:11:19.256935  =

    2023-02-25T12:11:19.258870  / # /lava-404359/bin/lava-test-runner /lava=
-404359/1
    2023-02-25T12:11:19.331278  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-25T12:11:19.331636  + cd /lava-404359/<8>[   15.621633] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 404359_1.5.2.4.5> =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9faf6ec93109f868c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9faf6ec93109f868c8638
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:11:26.167855  / # #

    2023-02-25T12:11:26.271147  export SHELL=3D/bin/sh

    2023-02-25T12:11:26.271972  #

    2023-02-25T12:11:26.373993  / # export SHELL=3D/bin/sh. /lava-9329865/e=
nvironment

    2023-02-25T12:11:26.374932  =


    2023-02-25T12:11:26.477015  / # . /lava-9329865/environment/lava-932986=
5/bin/lava-test-runner /lava-9329865/1

    2023-02-25T12:11:26.477800  =


    2023-02-25T12:11:26.487834  / # /lava-9329865/bin/lava-test-runner /lav=
a-9329865/1

    2023-02-25T12:11:26.552342  + export 'TESTRUN_ID=3D1_bootrr'

    2023-02-25T12:11:26.552726  + cd /lava-9329865<8>[   15.634633] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 9329865_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f94b6fca86f6898c86bc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f94b6fca86f6898c86c5
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:04:01.050684  <8>[   17.429133] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 404354_1.5.2.4.1>
    2023-02-25T12:04:01.157186  / # #
    2023-02-25T12:04:01.259433  export SHELL=3D/bin/sh
    2023-02-25T12:04:01.259970  #
    2023-02-25T12:04:01.361525  / # export SHELL=3D/bin/sh. /lava-404354/en=
vironment
    2023-02-25T12:04:01.362078  =

    2023-02-25T12:04:01.463638  / # . /lava-404354/environment/lava-404354/=
bin/lava-test-runner /lava-404354/1
    2023-02-25T12:04:01.464540  =

    2023-02-25T12:04:01.481679  / # /lava-404354/bin/lava-test-runner /lava=
-404354/1
    2023-02-25T12:04:01.561861  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f93563bdadd8d68c8674

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f93563bdadd8d68c867d
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:03:33.440284  / # #
    2023-02-25T12:03:33.542305  export SHELL=3D/bin/sh
    2023-02-25T12:03:33.542871  #
    2023-02-25T12:03:33.644238  / # export SHELL=3D/bin/sh. /lava-3374308/e=
nvironment
    2023-02-25T12:03:33.644815  =

    2023-02-25T12:03:33.746204  / # . /lava-3374308/environment/lava-337430=
8/bin/lava-test-runner /lava-3374308/1
    2023-02-25T12:03:33.746898  =

    2023-02-25T12:03:33.751441  / # /lava-3374308/bin/lava-test-runner /lav=
a-3374308/1
    2023-02-25T12:03:33.847378  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-25T12:03:33.848035  + cd /lava-3374308/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fb7207606fce3d8c8650

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fb7207606fce3d8c8659
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:13:13.086938  / # #
    2023-02-25T12:13:13.188563  export SHELL=3D/bin/sh
    2023-02-25T12:13:13.189150  #
    2023-02-25T12:13:13.290491  / # export SHELL=3D/bin/sh. /lava-3374352/e=
nvironment
    2023-02-25T12:13:13.290854  =

    2023-02-25T12:13:13.392222  / # . /lava-3374352/environment/lava-337435=
2/bin/lava-test-runner /lava-3374352/1
    2023-02-25T12:13:13.392940  =

    2023-02-25T12:13:13.398201  / # /lava-3374352/bin/lava-test-runner /lav=
a-3374352/1
    2023-02-25T12:13:13.476064  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-25T12:13:13.476538  + cd /lava-3374352/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f987fc82f187df8c864f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f987fc82f187df8c8658
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:04:57.205739  + set +x
    2023-02-25T12:04:57.207582  <8>[   14.219103] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 404356_1.5.2.4.1>
    2023-02-25T12:04:57.314323  / # #
    2023-02-25T12:04:57.416308  export SHELL=3D/bin/sh
    2023-02-25T12:04:57.416851  #
    2023-02-25T12:04:57.518075  / # export SHELL=3D/bin/sh. /lava-404356/en=
vironment
    2023-02-25T12:04:57.518608  =

    2023-02-25T12:04:57.619982  / # . /lava-404356/environment/lava-404356/=
bin/lava-test-runner /lava-404356/1
    2023-02-25T12:04:57.620771  =

    2023-02-25T12:04:57.622366  / # /lava-404356/bin/lava-test-runner /lava=
-404356/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fc6be9358aaee78c8730

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fc6be9358aaee78c8739
        failing since 37 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:17:32.249466  + set +x
    2023-02-25T12:17:32.251479  <8>[   13.484510] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 404366_1.5.2.4.1>
    2023-02-25T12:17:32.359424  / # #
    2023-02-25T12:17:32.461745  export SHELL=3D/bin/sh
    2023-02-25T12:17:32.462282  #
    2023-02-25T12:17:32.563917  / # export SHELL=3D/bin/sh. /lava-404366/en=
vironment
    2023-02-25T12:17:32.564474  =

    2023-02-25T12:17:32.666144  / # . /lava-404366/environment/lava-404366/=
bin/lava-test-runner /lava-404366/1
    2023-02-25T12:17:32.667101  =

    2023-02-25T12:17:32.669614  / # /lava-404366/bin/lava-test-runner /lava=
-404366/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9f94f6fca86f6898c86d2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9f94f6fca86f6898c86db
        failing since 36 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:04:20.117018  <8>[   18.115708] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-02-25T12:04:20.120595  + set +x

    2023-02-25T12:04:20.127624  <8>[   18.128242] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9329679_1.5.2.3.1>

    2023-02-25T12:04:20.236377  =


    2023-02-25T12:04:20.338830  / # #export SHELL=3D/bin/sh

    2023-02-25T12:04:20.339613  =


    2023-02-25T12:04:20.441605  / # export SHELL=3D/bin/sh. /lava-9329679/e=
nvironment

    2023-02-25T12:04:20.442396  =


    2023-02-25T12:04:20.544496  / # . /lava-9329679/environment/lava-932967=
9/bin/lava-test-runner /lava-9329679/1

    2023-02-25T12:04:20.545777  =

 =

    ... (15 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fe2beb610a4ba68c865a

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fe2beb610a4ba68c8663
        failing since 36 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-25T12:24:50.627504  kern  :emerg : Process udevadm (pid<8>[   1=
8.489476] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3D=
lines MEASUREMENT=3D11>

    2023-02-25T12:24:50.629638  : 139, stack limit =3D 0x(ptrval))

    2023-02-25T12:24:50.638060  kern  :emerg : Stack: (0xc2c8d<8>[   18.503=
654] <LAVA_SIGNAL_ENDRUN 0_dmesg 9329956_1.5.2.3.1>

    2023-02-25T12:24:50.639977  f2c to 0xc2c8e000)

    2023-02-25T12:24:50.648226  kern  :emerg : df20:                       =
     c02e8030 00000000 00000000 c026d6dc 00000003

    2023-02-25T12:24:50.656101  kern  :emerg : df40: c2cc2e40 bea5bf74 c2c8=
df80 00000000 c2c8c000 00000004 00000003 c0270590

    2023-02-25T12:24:50.664225  kern  :emerg : df60: edfda4e0 c026d6dc c2cc=
2e40 c2cc2e40 bea5bf74 00000003 c0101264 c02707f4

    2023-02-25T12:24:50.672533  kern  :emerg : df80: 00000000 00000000 c2c8=
dfb0 a07266ca b6fca7c0 00000003 b6fca7c0 bea5b468

    2023-02-25T12:24:50.680703  kern  :emerg : dfa0: 00000004 c0101000 0000=
0003 b6fca7c0 00000003 bea5bf74 00000003 00000000

    2023-02-25T12:24:50.688778  kern  :emerg : dfc0: 00000003 b6fca7c0 bea5=
b468 00000004 00000003 0003c90c bea5be58 00000003
 =

    ... (23 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9faec89cb549d888c8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9faec89cb549d888c8660
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:11:09.722263  + set +x
    2023-02-25T12:11:09.723352  <8>[    3.730899] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 861071_1.5.2.4.1>
    2023-02-25T12:11:09.829259  / # #
    2023-02-25T12:11:09.930533  export SHELL=3D/bin/sh
    2023-02-25T12:11:09.930924  #
    2023-02-25T12:11:10.032035  / # export SHELL=3D/bin/sh. /lava-861071/en=
vironment
    2023-02-25T12:11:10.032392  =

    2023-02-25T12:11:10.133468  / # . /lava-861071/environment/lava-861071/=
bin/lava-test-runner /lava-861071/1
    2023-02-25T12:11:10.133936  =

    2023-02-25T12:11:10.136276  / # /lava-861071/bin/lava-test-runner /lava=
-861071/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f9fde456e4a2bc718c8647

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.274/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f9fde456e4a2bc718c864e
        failing since 37 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-25T12:23:59.431420  <8>[    3.736610] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 861103_1.5.2.4.1>
    2023-02-25T12:23:59.534413  / # #
    2023-02-25T12:23:59.635662  export SHELL=3D/bin/sh
    2023-02-25T12:23:59.635935  #
    2023-02-25T12:23:59.736919  / # export SHELL=3D/bin/sh. /lava-861103/en=
vironment
    2023-02-25T12:23:59.737180  =

    2023-02-25T12:23:59.838175  / # . /lava-861103/environment/lava-861103/=
bin/lava-test-runner /lava-861103/1
    2023-02-25T12:23:59.838580  =

    2023-02-25T12:23:59.841500  / # /lava-861103/bin/lava-test-runner /lava=
-861103/1
    2023-02-25T12:23:59.878564  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =20
