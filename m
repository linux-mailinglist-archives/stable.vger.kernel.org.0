Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD3769F938
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 17:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbjBVQoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 11:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBVQoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 11:44:10 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD254C26
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 08:44:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m3-20020a17090ade0300b00229eec90a7fso2165804pjv.0
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 08:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Xp/iKolkv0Ma0WEfKKbzRxOrc1xRgJrkFSSFSb5MBrI=;
        b=cEXtcZ5ybeXyFRRCQiPnuNoFeUES1QitANTSjWFscM41qSnFOCG572/mD6JJhgRKf0
         qk/OCRYvkNIaTmSg3RmBOR7cdtBGT5tFFyb4HFvuB0H/pCJR3JBr7FE/KzxLMSEBe247
         UPWpMY9Np3BDzN6Rgl/4RoumHN/FKLuNW8tJDzxY33JnR3f4uAr8/EUfUtn9DyPdFVLw
         6IC4SEho2jaFINHTKMLgWVwhqTWs9DFtMXFokhV6i2PRUX5enNc3faSAa8AFX7XorqeE
         ThqMqB3wwoDFEQtJshuRHcqWkpn34EzQDuwF+AiJz9f+cyFDIXh99NVo7UG4S/Qj5cT+
         vvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xp/iKolkv0Ma0WEfKKbzRxOrc1xRgJrkFSSFSb5MBrI=;
        b=NmuXMY77136eNtOG1QOb0YYw2z1UjnpsG03SbONzwdgJWQxNN9lBVR/jIBytyWjScI
         VM2dMN9G4A+aZ3R0v4nT02Wrw6OGdxElLo7qATVdqQuuJ/UJfP7mpv1X+RBKR/E8p7v/
         8VS2cPsGbSuTBN0maYr1qkQiqfkIjWwbMBuXBSVLi7oZvW/kcJEVZoukP8Npmdgv1wXr
         TGDU0L7WoFkRWDYRrqtftc/x/NcII1bL5R6kmGsscW2Qy6pP1dg9lxqfF5Vi5j6p3xeL
         KJsTAKYyq1hvFJjFQ15nLAJFq1bLMlWMHnbTfQydnwX7AVxWqfwCSUMGINSaCFXSmjRv
         qtxg==
X-Gm-Message-State: AO0yUKUaYtoWOvVB5PvcZPxsXfcSmzYX0FYhiiXn5A6XxSHo0jy0Ecg5
        gHEIDL9UfbjJckp2SV/nU4zsxR/zGzbVO5o2Fho=
X-Google-Smtp-Source: AK7set8XLj0C6sj8PVzKfx3ya/nvR8bCZid+knT1pzSCLrehOuQGWN6upOb0PJafhGpyTgLrAmxXhw==
X-Received: by 2002:a05:6a20:3956:b0:c7:6d29:db39 with SMTP id r22-20020a056a20395600b000c76d29db39mr11305472pzg.11.1677084243120;
        Wed, 22 Feb 2023 08:44:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a62-20020a639041000000b004cd2eebc551sm5207501pge.62.2023.02.22.08.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 08:44:02 -0800 (PST)
Message-ID: <63f64652.630a0220.17556.955b@mx.google.com>
Date:   Wed, 22 Feb 2023 08:44:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.273
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 155 runs, 57 regressions (v4.19.273)
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

stable/linux-4.19.y baseline: 155 runs, 57 regressions (v4.19.273)

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

beaglebone-black             | arm    | lab-cip         | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =

imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =

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
/v4.19.273/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3eb67e3248e1d96ef4eaa43d9f5dc6ff2ba6db99 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f610c4047a7fe6368c865e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f610c4047a7fe6368c8667
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:55:12.367816  + set +x<8>[    7.129841] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9277125_1.4.2.3.1>

    2023-02-22T12:55:12.367917  =


    2023-02-22T12:55:12.469942  #

    2023-02-22T12:55:12.571039  / # #export SHELL=3D/bin/sh

    2023-02-22T12:55:12.571270  =


    2023-02-22T12:55:12.672161  / # export SHELL=3D/bin/sh. /lava-9277125/e=
nvironment

    2023-02-22T12:55:12.672334  =


    2023-02-22T12:55:12.773232  / # . /lava-9277125/environment/lava-927712=
5/bin/lava-test-runner /lava-9277125/1

    2023-02-22T12:55:12.773510  =


    2023-02-22T12:55:12.778589  / # /lava-9277125/bin/lava-test-runner /lav=
a-9277125/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f610cc6d4f541e4d8c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f610cc6d4f541e4d8c8638
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:55:22.202659  + set +x

    2023-02-22T12:55:22.208912  <8>[   11.296062] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9277138_1.4.2.3.1>

    2023-02-22T12:55:22.314043  / # #

    2023-02-22T12:55:22.415195  export SHELL=3D/bin/sh

    2023-02-22T12:55:22.415420  #

    2023-02-22T12:55:22.516372  / # export SHELL=3D/bin/sh. /lava-9277138/e=
nvironment

    2023-02-22T12:55:22.516611  =


    2023-02-22T12:55:22.617523  / # . /lava-9277138/environment/lava-927713=
8/bin/lava-test-runner /lava-9277138/1

    2023-02-22T12:55:22.617850  =


    2023-02-22T12:55:22.623012  / # /lava-9277138/bin/lava-test-runner /lav=
a-9277138/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6118273765a8c298c8663

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6118273765a8c298c866c
        failing since 16 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-02-22T12:58:20.751617  + set +x
    2023-02-22T12:58:20.756735  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 54472_1.5.2.=
4.1>
    2023-02-22T12:58:20.869712  / # #
    2023-02-22T12:58:20.972638  export SHELL=3D/bin/sh
    2023-02-22T12:58:20.973430  #
    2023-02-22T12:58:21.075398  / # export SHELL=3D/bin/sh. /lava-54472/env=
ironment
    2023-02-22T12:58:21.076178  =

    2023-02-22T12:58:21.178133  / # . /lava-54472/environment/lava-54472/bi=
n/lava-test-runner /lava-54472/1
    2023-02-22T12:58:21.179388  =

    2023-02-22T12:58:21.185816  / # /lava-54472/bin/lava-test-runner /lava-=
54472/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f61214eb820f56688c8655

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f61214eb820f56688c865e
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T13:00:46.529919  <8>[   16.140536] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 54506_1.5.2.4.1>
    2023-02-22T13:00:46.639011  / # #
    2023-02-22T13:00:46.742917  export SHELL=3D/bin/sh
    2023-02-22T13:00:46.743740  #
    2023-02-22T13:00:46.845687  / # export SHELL=3D/bin/sh<6>[   16.354432]=
 usb 1-1: new low-speed USB device number 3 usi. /lava-54506/environment
    2023-02-22T13:00:46.846495  ng musb-hdrc
    2023-02-22T13:00:46.846891  =

    2023-02-22T13:00:46.948725  / # . /lava-54506/environment/lava-54506/bi=
n/lava-test-runner /lava-54506/1
    2023-02-22T13:00:46.949912  =

    2023-02-22T13:00:46.950344  / # <3>[   16.504418] usb 1-1: device descr=
iptor read/64, error -71 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f617cdf89bf066538c8642

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f617cdf89bf066538c8649
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T13:25:15.310342  <8>[    8.965160] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 856422_1.5.2.4.1>
    2023-02-22T13:25:15.420797  / # #
    2023-02-22T13:25:15.523496  export SHELL=3D/bin/sh
    2023-02-22T13:25:15.524291  #
    2023-02-22T13:25:15.626284  / # export SHELL=3D/bin/sh. /lava-856422/en=
vironment
    2023-02-22T13:25:15.627050  =

    2023-02-22T13:25:15.729004  / # . /lava-856422/environment/lava-856422/=
bin/lava-test-runner /lava-856422/1
    2023-02-22T13:25:15.730255  =

    2023-02-22T13:25:15.736349  / # /lava-856422/bin/lava-test-runner /lava=
-856422/1
    2023-02-22T13:25:15.802816  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-cip         | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6117f73765a8c298c8656

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6117f73765a8c298c865d
        failing since 15 days (last pass: v4.19.271, first fail: v4.19.272)

    2023-02-22T12:58:23.560302  + set +x<8>[   11.713058] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 856403_1.5.2.4.1>
    2023-02-22T12:58:23.560618  =

    2023-02-22T12:58:23.674493  / # #
    2023-02-22T12:58:23.776429  export SHELL=3D/bin/sh
    2023-02-22T12:58:23.776894  #
    2023-02-22T12:58:23.878305  / # export SHELL=3D/bin/sh. /lava-856403/en=
vironment
    2023-02-22T12:58:23.878771  =

    2023-02-22T12:58:23.980218  / # . /lava-856403/environment/lava-856403/=
bin/lava-test-runner /lava-856403/1
    2023-02-22T12:58:23.980993  =

    2023-02-22T12:58:23.983166  / # /lava-856403/bin/lava-test-runner /lava=
-856403/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f611dbeb820f56688c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f611dbeb820f56688c8638
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T12:59:51.907928  + set +x<8>[    7.322543] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3364858_1.5.2.4.1>
    2023-02-22T12:59:51.909317  =

    2023-02-22T12:59:52.024307  / # #
    2023-02-22T12:59:52.128015  export SHELL=3D/bin/sh
    2023-02-22T12:59:52.129097  #
    2023-02-22T12:59:52.231206  / # export SHELL=3D/bin/sh. /lava-3364858/e=
nvironment
    2023-02-22T12:59:52.232519  =

    2023-02-22T12:59:52.335032  / # . /lava-3364858/environment/lava-336485=
8/bin/lava-test-runner /lava-3364858/1
    2023-02-22T12:59:52.336070  =

    2023-02-22T12:59:52.344898  / # /lava-3364858/bin/lava-test-runner /lav=
a-3364858/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f611b55f7bbe8d5f8c8652

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f611b55f7bbe8d5f8c865b
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:59:22.167118  + set +x

    2023-02-22T12:59:22.172592  <8>[    7.699727] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9277182_1.5.2.4.1>

    2023-02-22T12:59:22.280042  / # #

    2023-02-22T12:59:22.382861  export SHELL=3D/bin/sh

    2023-02-22T12:59:22.383703  #

    2023-02-22T12:59:22.485694  / # export SHELL=3D/bin/sh. /lava-9277182/e=
nvironment

    2023-02-22T12:59:22.486492  =


    2023-02-22T12:59:22.588602  / # . /lava-9277182/environment/lava-927718=
2/bin/lava-test-runner /lava-9277182/1

    2023-02-22T12:59:22.589872  =


    2023-02-22T12:59:22.592505  / # /lava-9277182/bin/lava-test-runner /lav=
a-9277182/1
 =

    ... (15 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63f614d987d8ade7118c864d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f614d987d8ade7118c8656
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T13:12:49.014305  + set +x[    7.074709] <LAVA_SIGNAL_ENDRUN =
0_dmesg 910818_1.5.2.3.1>
    2023-02-22T13:12:49.014471  =

    2023-02-22T13:12:49.121907  / # #
    2023-02-22T13:12:49.223310  export SHELL=3D/bin/sh
    2023-02-22T13:12:49.223634  #
    2023-02-22T13:12:49.324854  / # export SHELL=3D/bin/sh. /lava-910818/en=
vironment
    2023-02-22T13:12:49.325356  =

    2023-02-22T13:12:49.426785  / # . /lava-910818/environment/lava-910818/=
bin/lava-test-runner /lava-910818/1
    2023-02-22T13:12:49.427290  =

    2023-02-22T13:12:49.430294  / # /lava-910818/bin/lava-test-runner /lava=
-910818/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6117edf0f2683d68c8658

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6117edf0f2683d68c8661
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:58:28.319373  [    4.934142] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-02-22T12:58:28.325718  + set +x
    2023-02-22T12:58:28.325870  [    4.943781] <LAVA_SIGNAL_ENDRUN 0_dmesg =
910804_1.5.2.3.1>
    2023-02-22T12:58:28.432580  / # #
    2023-02-22T12:58:28.534414  export SHELL=3D/bin/sh
    2023-02-22T12:58:28.534826  #
    2023-02-22T12:58:28.635893  / # export SHELL=3D/bin/sh. /lava-910804/en=
vironment
    2023-02-22T12:58:28.636330  =

    2023-02-22T12:58:28.737728  / # . /lava-910804/environment/lava-910804/=
bin/lava-test-runner /lava-910804/1
    2023-02-22T12:58:28.738263   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxm-khadas-vim2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6126098ca6e02798c8647

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6126098ca6e02798c8650
        new failure (last pass: v4.19.272)

    2023-02-22T13:02:16.270964  / # #
    2023-02-22T13:02:16.372802  export SHELL=3D/bin/sh
    2023-02-22T13:02:16.373200  #
    2023-02-22T13:02:16.474615  / # export SHELL=3D/bin/sh. /lava-3364887/e=
nvironment
    2023-02-22T13:02:16.475127  =

    2023-02-22T13:02:16.576565  / # . /lava-3364887/environment/lava-336488=
7/bin/lava-test-runner /lava-3364887/1
    2023-02-22T13:02:16.577257  =

    2023-02-22T13:02:16.582388  / # /lava-3364887/bin/lava-test-runner /lav=
a-3364887/1
    2023-02-22T13:02:16.650040  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-22T13:02:16.650568  + cd /lava-3364887/1/tests/1_bootrr =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6138fad274b91f08c86a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6138fad274b91f08c8=
6a9
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613f665b59882268c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f613f665b59882268c8=
634
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f61388ad274b91f08c8658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f61388ad274b91f08c8=
659
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f614f087d8ade7118c8674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f614f087d8ade7118c8=
675
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6136fb4343eab378c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6136fb4343eab378c8=
630
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613d22f3eab5d208c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f613d22f3eab5d208c8=
638
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6139008409ead938c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6139008409ead938c8=
630
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6140565b59882268c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6140565b59882268c8=
63a
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6138aad274b91f08c865b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6138aad274b91f08c8=
65c
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f614ef45e33633b38c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f614ef45e33633b38c8=
640
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f61369c9923d8c628c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f61369c9923d8c628c8=
65e
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613cd435b19762e8c866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f613cd435b19762e8c8=
66f
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6138e72396606a08c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6138e72396606a08c8=
639
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613f28671903def8c86c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f613f28671903def8c8=
6c3
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f61387ad274b91f08c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f61387ad274b91f08c8=
656
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6141265b59882268c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6141265b59882268c8=
641
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6136dad274b91f08c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6136dad274b91f08c8=
630
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613cc435b19762e8c866a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f613cc435b19762e8c8=
66b
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6138dad274b91f08c86a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6138dad274b91f08c8=
6a3
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613f47108d155de8c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f613f47108d155de8c8=
643
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f61386ad274b91f08c8652

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f61386ad274b91f08c8=
653
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f614ee87d8ade7118c866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f614ee87d8ade7118c8=
66f
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6136c69a389501d8c864b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f6136c69a389501d8c8=
64c
        failing since 170 days (last pass: v4.19.230, first fail: v4.19.257=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613d02f3eab5d208c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f613d02f3eab5d208c8=
633
        failing since 207 days (last pass: v4.19.230, first fail: v4.19.254=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f61041834b51fca18c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f61041834b51fca18c8=
655
        failing since 88 days (last pass: v4.19.266, first fail: v4.19.267) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/63f611b4ce3c3d25e08c8681

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/63f611b4ce3c3d25e08c86b5
        failing since 33 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:59:04.403653   multi-call binary.

    2023-02-22T12:59:04.404124  =

   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/63f611b4ce3c3d25e08c86b6
        failing since 33 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:59:04.399873  BusyBox v1.31.1 (2023-02-17 15:41:33 UTC)<8=
>[   12.518691] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>
   =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f611b4ce3c3d25e08c86c9
        failing since 33 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:59:00.563160  + <8>[    8.684795] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9277180_1.5.2.3.1>

    2023-02-22T12:59:00.564325  set +x

    2023-02-22T12:59:00.670684  =


    2023-02-22T12:59:00.773139  / # #export SHELL=3D/bin/sh

    2023-02-22T12:59:00.773911  =


    2023-02-22T12:59:00.875984  / # export SHELL=3D/bin/sh. /lava-9277180/e=
nvironment

    2023-02-22T12:59:00.876794  =


    2023-02-22T12:59:00.978780  / # . /lava-9277180/environment/lava-927718=
0/bin/lava-test-runner /lava-9277180/1

    2023-02-22T12:59:00.979360  =


    2023-02-22T12:59:00.980762  / # /lava-9277180/bin/lava-test-runner /lav=
a-9277180/1
 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/63f612f52fbdb641b68c8630

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63f612f52fbdb641b68c8656
        failing since 342 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-02-22T13:04:32.890659  =


    2023-02-22T13:04:33.906214  /lava-9277228/1/../bin/lava-test-case

    2023-02-22T13:04:33.913799  <8>[   36.005320] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/63f612f52fbdb641b68c865f
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:04:32.404280  s of INC.

    2023-02-22T13:04:32.406283  FIRST, INC default to 1.

    2023-02-22T13:04:32.406702  =


    2023-02-22T13:04:32.409217  	-w	Pad to last with leading zeros

    2023-02-22T13:04:32.411584  	-s SEP	String separator

    2023-02-22T13:04:32.415925  /lava-9277228/1/../bin/lava-test-case

    2023-02-22T13:04:32.430951  BusyBox v1.31.1 (2023-02-17 14:37:44 UTC) m=
ulti-call<8>[   34.515926] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-=
sound-driver-rt5514-present RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/63f612f52fbdb641b68c8660
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:04:32.374730  <8>[   34.458245] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-dp-present RESULT=3Dfail>

    2023-02-22T13:04:32.375166  =


    2023-02-22T13:04:32.376141  /lava-9277228/1/../bin/lava-test-case

    2023-02-22T13:04:32.382554  BusyBox v1.31.1 (2023-02-17 14:37:44 UTC) m=
ulti-call binary.

    2023-02-22T13:04:32.383379  =


    2023-02-22T13:04:32.387159  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-02-22T13:04:32.387964  =


    2023-02-22T13:04:32.402302  Print numbers from FIRST to LAST, in step<8=
>[   34.486703] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-drive=
r-max98357A-present RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/63f612f52fbdb641b68c8661
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:04:32.346442  =


    2023-02-22T13:04:32.346925  =


    2023-02-22T13:04:32.348759  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-02-22T13:04:32.349205  =


    2023-02-22T13:04:32.354049  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-02-22T13:04:32.357452  FIRST, INC default to 1.

    2023-02-22T13:04:32.357966  =


    2023-02-22T13:04:32.359910  	-w	Pad to last with leading zeros

    2023-02-22T13:04:32.362856  	-s SEP	String separator
   =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/63f612f52fbdb641b68c8662
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:04:32.344186  BusyBox v1.31.1 (2023-02-17 14:37:44 UTC) m=
ulti-call binary.<8>[   34.431645] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3=
399-gru-sound-driver-da7219-present RESULT=3Dfail>
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6127a191c0e476b8c8659

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6127a191c0e476b8c8662
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:02:26.987948  + set +x
    2023-02-22T13:02:26.989887  <8>[   17.109569] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 402442_1.5.2.4.1>
    2023-02-22T13:02:27.097780  / # #
    2023-02-22T13:02:27.200361  export SHELL=3D/bin/sh
    2023-02-22T13:02:27.201022  #
    2023-02-22T13:02:27.201375  / # export SHELL=3D/bin/sh<3>[   17.302544]=
 brcmfmac: brcmf_sdio_htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-02-22T13:02:27.303040  . /lava-402442/environment
    2023-02-22T13:02:27.303686  =

    2023-02-22T13:02:27.405370  / # . /lava-402442/environment/lava-402442/=
bin/lava-test-runner /lava-402442/1
    2023-02-22T13:02:27.406403   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6129db19d1e501e8c8635

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6129db19d1e501e8c863e
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:02:57.752780  <8>[   15.915672] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 54522_1.5.2.4.1>
    2023-02-22T13:02:57.858260  / # #
    2023-02-22T13:02:57.960290  export SHELL=3D/bin/sh
    2023-02-22T13:02:57.960952  #
    2023-02-22T13:02:58.062932  / # export SHELL=3D/bin/sh. /lava-54522/env=
ironment
    2023-02-22T13:02:58.063416  =

    2023-02-22T13:02:58.165060  / # . /lava-54522/environment/lava-54522/bi=
n/lava-test-runner /lava-54522/1
    2023-02-22T13:02:58.165967  =

    2023-02-22T13:02:58.170475  / # /lava-54522/bin/lava-test-runner /lava-=
54522/1
    2023-02-22T13:02:58.201634  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6126a98ca6e02798c865e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6126a98ca6e02798c8667
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:02:18.578575  <8>[   15.152642] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 402443_1.5.2.4.1>
    2023-02-22T13:02:18.685160  / # #
    2023-02-22T13:02:18.787383  export SHELL=3D/bin/sh
    2023-02-22T13:02:18.787913  #
    2023-02-22T13:02:18.889516  / # export SHELL=3D/bin/sh. /lava-402443/en=
vironment
    2023-02-22T13:02:18.890098  =

    2023-02-22T13:02:18.991528  / # . /lava-402443/environment/lava-402443/=
bin/lava-test-runner /lava-402443/1
    2023-02-22T13:02:18.992817  =

    2023-02-22T13:02:19.009676  / # /lava-402443/bin/lava-test-runner /lava=
-402443/1
    2023-02-22T13:02:19.066590  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6127c7c5896af568c8630

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6127c7c5896af568c8639
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:02:40.927539  / # #

    2023-02-22T13:02:41.029438  export SHELL=3D/bin/sh

    2023-02-22T13:02:41.029929  #

    2023-02-22T13:02:41.131367  / # export SHELL=3D/bin/sh. /lava-9277208/e=
nvironment

    2023-02-22T13:02:41.131837  =


    2023-02-22T13:02:41.233195  / # . /lava-9277208/environment/lava-927720=
8/bin/lava-test-runner /lava-9277208/1

    2023-02-22T13:02:41.234016  =


    2023-02-22T13:02:41.251863  / # /lava-9277208/bin/lava-test-runner /lav=
a-9277208/1

    2023-02-22T13:02:41.309537  + export 'TESTRUN_ID=3D1_bootrr'

    2023-02-22T13:02:41.309826  + cd /lava-9277208<8>[   15.623745] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 9277208_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f611c6a546d09ba18c8646

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f611c6a546d09ba18c864f
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:59:26.366124  <8>[   17.326901] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 402439_1.5.2.4.1>
    2023-02-22T12:59:26.472591  / # #
    2023-02-22T12:59:26.574793  export SHELL=3D/bin/sh
    2023-02-22T12:59:26.575355  #
    2023-02-22T12:59:26.676954  / # export SHELL=3D/bin/sh. /lava-402439/en=
vironment
    2023-02-22T12:59:26.677556  =

    2023-02-22T12:59:26.779222  / # . /lava-402439/environment/lava-402439/=
bin/lava-test-runner /lava-402439/1
    2023-02-22T12:59:26.780199  =

    2023-02-22T12:59:26.797240  / # /lava-402439/bin/lava-test-runner /lava=
-402439/1
    2023-02-22T12:59:26.923245  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f611988ac61344478c864a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f611988ac61344478c8653
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:58:54.572326  / # #
    2023-02-22T12:58:54.674232  export SHELL=3D/bin/sh
    2023-02-22T12:58:54.674747  #
    2023-02-22T12:58:54.776086  / # export SHELL=3D/bin/sh. /lava-3364854/e=
nvironment
    2023-02-22T12:58:54.776498  =

    2023-02-22T12:58:54.877864  / # . /lava-3364854/environment/lava-336485=
4/bin/lava-test-runner /lava-3364854/1
    2023-02-22T12:58:54.878572  =

    2023-02-22T12:58:54.884595  / # /lava-3364854/bin/lava-test-runner /lav=
a-3364854/1
    2023-02-22T12:58:54.932697  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-22T12:58:54.978536  + cd /lava-3364854/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63f61080c20e14b0f08c8664

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f61080c20e14b0f08c866d
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:54:14.986100  <8>[    7.812794] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3364843_1.5.2.4.1>
    2023-02-22T12:54:15.091822  / # #
    2023-02-22T12:54:15.193849  export SHELL=3D/bin/sh
    2023-02-22T12:54:15.194391  #
    2023-02-22T12:54:15.295856  / # export SHELL=3D/bin/sh. /lava-3364843/e=
nvironment
    2023-02-22T12:54:15.296366  =

    2023-02-22T12:54:15.397880  / # . /lava-3364843/environment/lava-336484=
3/bin/lava-test-runner /lava-3364843/1
    2023-02-22T12:54:15.398578  =

    2023-02-22T12:54:15.416788  / # /lava-3364843/bin/lava-test-runner /lav=
a-3364843/1
    2023-02-22T12:54:15.482705  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f612028dd0248b8e8c864e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f612028dd0248b8e8c8657
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T13:00:22.478484  + set +x
    2023-02-22T13:00:22.480497  <8>[   14.992615] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 402440_1.5.2.4.1>
    2023-02-22T13:00:22.587296  / # #
    2023-02-22T13:00:22.689324  export SHELL=3D/bin/sh
    2023-02-22T13:00:22.689844  #
    2023-02-22T13:00:22.791079  / # export SHELL=3D/bin/sh. /lava-402440/en=
vironment
    2023-02-22T13:00:22.791599  =

    2023-02-22T13:00:22.892946  / # . /lava-402440/environment/lava-402440/=
bin/lava-test-runner /lava-402440/1
    2023-02-22T13:00:22.893712  =

    2023-02-22T13:00:22.895273  / # /lava-402440/bin/lava-test-runner /lava=
-402440/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63f610fef3adc566e78c8675

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f610fef3adc566e78c867e
        failing since 34 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:56:16.577452  + set +x
    2023-02-22T12:56:16.579347  <8>[   15.486496] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 402435_1.5.2.4.1>
    2023-02-22T12:56:16.687512  / # #
    2023-02-22T12:56:16.789904  export SHELL=3D/bin/sh
    2023-02-22T12:56:16.790496  #
    2023-02-22T12:56:16.892368  / # export SHELL=3D/bin/sh. /lava-402435/en=
vironment
    2023-02-22T12:56:16.892933  =

    2023-02-22T12:56:16.994455  / # . /lava-402435/environment/lava-402435/=
bin/lava-test-runner /lava-402435/1
    2023-02-22T12:56:16.995427  =

    2023-02-22T12:56:16.997463  / # /lava-402435/bin/lava-test-runner /lava=
-402435/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63f611b75f7bbe8d5f8c865d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f611b75f7bbe8d5f8c8666
        failing since 33 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T12:59:18.242503  + set +x

    2023-02-22T12:59:18.247870  <8>[   18.252091] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9277191_1.5.2.3.1>

    2023-02-22T12:59:18.357981  #

    2023-02-22T12:59:18.359217  =


    2023-02-22T12:59:18.461684  / # #export SHELL=3D/bin/sh

    2023-02-22T12:59:18.462471  =


    2023-02-22T12:59:18.564626  / # export SHELL=3D/bin/sh. /lava-9277191/e=
nvironment

    2023-02-22T12:59:18.565417  =


    2023-02-22T12:59:18.667512  / # . /lava-9277191/environment/lava-927719=
1/bin/lava-test-runner /lava-9277191/1

    2023-02-22T12:59:18.668801  =

 =

    ... (14 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
tegra124-nyan-big            | arm    | lab-collabora   | gcc-10   | tegra_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6121ab10b927d3c8c8653

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6121ab10b927d3c8c865c
        failing since 33 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-22T13:00:58.707714  kern  :emerg : Process udev<8>[   18.452102=
] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines ME=
ASUREMENT=3D11>

    2023-02-22T13:00:58.710672  adm (pid: 139, stack limit =3D 0x(ptrval))

    2023-02-22T13:00:58.719093  kern  :emerg :<8>[   18.465731] <LAVA_SIGNA=
L_ENDRUN 0_dmesg 9277198_1.5.2.3.1>

    2023-02-22T13:00:58.720779   Stack: (0xc2c91f2c to 0xc2c92000)

    2023-02-22T13:00:58.729076  kern  :emerg : 1f20:                       =
     c02e7ff0 00000000 00000000 c026d69c 00000003

    2023-02-22T13:00:58.737194  kern  :emerg : 1f40: c2cd8cc0 be9aaf74 c2c9=
1f80 00000000 c2c90000 00000004 00000003 c0270550

    2023-02-22T13:00:58.745183  kern  :emerg : 1f60: edfd0668 c026d69c c2cd=
8cc0 c2cd8cc0 be9aaf74 00000003 c0101264 c02707b4

    2023-02-22T13:00:58.753505  kern  :emerg : 1f80: 00000000 00000000 c2c9=
1fb0 8bf5e696 b6fa97c0 00000003 b6fa97c0 be9aa468

    2023-02-22T13:00:58.761653  kern  :emerg : 1fa0: 00000004 c0101000 0000=
0003 b6fa97c0 00000003 be9aaf74 00000003 00000000

    2023-02-22T13:00:58.769722  kern  :emerg : 1fc0: 00000003 b6fa97c0 be9a=
a468 00000004 00000003 0003c90c be9aae58 00000003
 =

    ... (22 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63f6125b98ca6e02798c863c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f6125b98ca6e02798c8643
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:02:15.228318  <8>[    3.750237] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 856431_1.5.2.4.1>
    2023-02-22T13:02:15.333337  / # #
    2023-02-22T13:02:15.434458  export SHELL=3D/bin/sh
    2023-02-22T13:02:15.434706  #
    2023-02-22T13:02:15.535750  / # export SHELL=3D/bin/sh. /lava-856431/en=
vironment
    2023-02-22T13:02:15.535965  =

    2023-02-22T13:02:15.636948  / # . /lava-856431/environment/lava-856431/=
bin/lava-test-runner /lava-856431/1
    2023-02-22T13:02:15.637299  =

    2023-02-22T13:02:15.640209  / # /lava-856431/bin/lava-test-runner /lava=
-856431/1
    2023-02-22T13:02:15.677255  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63f613eb8671903def8c86b7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.273/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230217.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63f613eb8671903def8c86be
        failing since 34 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-22T13:08:40.401209  + set +x
    2023-02-22T13:08:40.402353  <8>[    3.716672] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 856435_1.5.2.4.1>
    2023-02-22T13:08:40.509685  / # #
    2023-02-22T13:08:40.611661  export SHELL=3D/bin/sh
    2023-02-22T13:08:40.612117  #
    2023-02-22T13:08:40.713492  / # export SHELL=3D/bin/sh. /lava-856435/en=
vironment
    2023-02-22T13:08:40.713950  =

    2023-02-22T13:08:40.815352  / # . /lava-856435/environment/lava-856435/=
bin/lava-test-runner /lava-856435/1
    2023-02-22T13:08:40.816186  =

    2023-02-22T13:08:40.819078  / # /lava-856435/bin/lava-test-runner /lava=
-856435/1 =

    ... (13 line(s) more)  =

 =20
