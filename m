Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829896B6247
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 01:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjCLA2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 19:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCLA2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 19:28:20 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148761A968
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 16:28:16 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id k2so1478480pll.8
        for <stable@vger.kernel.org>; Sat, 11 Mar 2023 16:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678580894;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ItMo9smQm5eTAgAPJmzIx5PVdYvEsrg9DX0b9TKWWsQ=;
        b=PSL0OwAF8meN7lNnLWTyORV87dk+a6ptLXgrj20a73NSOjy50PYL3AynfLEglkodNk
         3Y375pWYYjRYJ2w5UFgypHOSD2/ggaLQw2VP2CECCHbxh28TWsdnZCb091v/eewfI77a
         q22rr2eMsGMahD195txeSuJPsOJTBL9K5xYjahUy2hCUvY2NI1ow1MW7HpepRXDFgXqE
         HhrMyvfoquNBMESF2xivLRQdJRYR0EVMNus93nGkJ7xgsyuANh3UQ07uCZoG5HSoBDFa
         5s8Xndag8xNIdGx6Y+OtQn1mYoXyr3pAURQhlpmT90S1ZSPxYw2d2o85BkHSaHc//CQN
         Agcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678580894;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ItMo9smQm5eTAgAPJmzIx5PVdYvEsrg9DX0b9TKWWsQ=;
        b=zWDpd2oJsZ6wzliz4fVqn6uSzHIy7WpOuJi4xOymqLapxDKjZkLBHHgQ2SPmHY2zAn
         rjkdxzuBjyrxnOdTq6IFq9EMZ9yr4jdVMGzcpfDFKZCMMjg81YGZrjWQHIHwtueV9v0l
         GdbjwXXDcaNm9AYDvHdby6OypFEJZpvEj//UKwAyRIoCheEOJZ5cqgcE/qb3XI998xsG
         j9ScC6A1UqUdGik68PC40HKlJT1bmwzQqVoeOWO7ry0tKqlSArC7O5+w+5kyVWlG/Pej
         x+ZXjgvIKfR21+2pL2sL3kLEBZeSruvfjAD8FjGvr4IOlS9RSUETivCLRRWLzmoEjna1
         yrRw==
X-Gm-Message-State: AO0yUKW8K6+slnUYfQJiS9i6Wvb/X9iIj3Sg1+0jMsg6m12xxnnICeQv
        jBEdFwtYTLpmFrEjIajFIbS5YL33Okxbxfc1g70=
X-Google-Smtp-Source: AK7set92biWPWcjBYFdDG+zLq5oZTZgtvLNtBSF4L8EDEZmzaDoZ7nMWrPKF1LwqDB9LA55jBfugkg==
X-Received: by 2002:a17:903:2349:b0:19e:64b9:41c6 with SMTP id c9-20020a170903234900b0019e64b941c6mr37597740plh.60.1678580893892;
        Sat, 11 Mar 2023 16:28:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c10-20020a170902c1ca00b0019aa8149cc9sm2061597plc.35.2023.03.11.16.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 16:28:13 -0800 (PST)
Message-ID: <640d1c9d.170a0220.b56d8.3ac6@mx.google.com>
Date:   Sat, 11 Mar 2023 16:28:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.275-252-gcb3c41fc75db9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 150 runs,
 29 regressions (v4.19.275-252-gcb3c41fc75db9)
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

stable-rc/queue/4.19 baseline: 150 runs, 29 regressions (v4.19.275-252-gcb3=
c41fc75db9)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | multi_v5_de=
fconfig         | 1          =

beaglebone-black           | arm   | lab-broonie   | gcc-10   | omap2plus_d=
efconfig        | 1          =

cubietruck                 | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =

meson-gxl-s905d-p230       | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

meson-gxm-q200             | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.275-252-gcb3c41fc75db9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.275-252-gcb3c41fc75db9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb3c41fc75db9399b88184b1281b2f2f9cd2ec59 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
at91sam9g20ek              | arm   | lab-broonie   | gcc-10   | multi_v5_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/640cea7ef29b4b505b8c8638

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640cea7ef29b4b505b8c8641
        failing since 4 days (last pass: v4.19.275-171-g62de1e6083f44, firs=
t fail: v4.19.275-191-g0939e40b20ce)

    2023-03-11T20:53:59.709770  + set +x
    2023-03-11T20:53:59.715005  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 146309_1.5.2=
.4.1>
    2023-03-11T20:53:59.828232  / # #
    2023-03-11T20:53:59.931170  export SHELL=3D/bin/sh
    2023-03-11T20:53:59.932060  #
    2023-03-11T20:54:00.033956  / # export SHELL=3D/bin/sh. /lava-146309/en=
vironment
    2023-03-11T20:54:00.034905  =

    2023-03-11T20:54:00.136836  / # . /lava-146309/environment/lava-146309/=
bin/lava-test-runner /lava-146309/1
    2023-03-11T20:54:00.137697  =

    2023-03-11T20:54:00.143875  / # /lava-146309/bin/lava-test-runner /lava=
-146309/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
beaglebone-black           | arm   | lab-broonie   | gcc-10   | omap2plus_d=
efconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/640ceb117b1cfe876a8c86af

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640ceb117b1cfe876a8c86b8
        failing since 0 day (last pass: v4.19.275-252-g4ba804160033d, first=
 fail: v4.19.275-252-ge9b6ff517cd5)

    2023-03-11T20:56:28.721614  + set +x<8>[   16.970367] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 146320_1.5.2.4.1>
    2023-03-11T20:56:28.722044  =

    2023-03-11T20:56:28.833765  / # #
    2023-03-11T20:56:28.936114  export SHELL=3D/bin/sh
    2023-03-11T20:56:28.936670  #
    2023-03-11T20:56:29.038946  / # export SHELL=3D/bin/sh. /lava-146320/en=
vironment
    2023-03-11T20:56:29.039510  =

    2023-03-11T20:56:29.141629  / # . /lava-146320/environment/lava-146320/=
bin/lava-test-runner /lava-146320/1
    2023-03-11T20:56:29.142546  =

    2023-03-11T20:56:29.147592  / # /lava-146320/bin/lava-test-runner /lava=
-146320/1 =

    ... (12 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
cubietruck                 | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/640ce9b94775dcd3dd8c8638

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640ce9b94775dcd3dd8c8641
        failing since 53 days (last pass: v4.19.269-9-gce7b59ec9d48, first =
fail: v4.19.269-521-g305d312d039a)

    2023-03-11T20:50:44.587108  <8>[    7.358638] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3405384_1.5.2.4.1>
    2023-03-11T20:50:44.698981  / # #
    2023-03-11T20:50:44.802429  export SHELL=3D/bin/sh
    2023-03-11T20:50:44.803737  #
    2023-03-11T20:50:44.907006  / # export SHELL=3D/bin/sh. /lava-3405384/e=
nvironment
    2023-03-11T20:50:44.908127  =

    2023-03-11T20:50:45.010670  / # . /lava-3405384/environment/lava-340538=
4/bin/lava-test-runner /lava-3405384/1
    2023-03-11T20:50:45.012437  =

    2023-03-11T20:50:45.017531  / # /lava-3405384/bin/lava-test-runner /lav=
a-3405384/1
    2023-03-11T20:50:45.093357  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
meson-gxl-s905d-p230       | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640ceb33ef806393c98c865e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640ceb33ef806393c98c8667
        new failure (last pass: v4.19.275-252-ge9b6ff517cd5)

    2023-03-11T20:57:05.475409  + set +x<8>[   16.089890] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3405411_1.5.2.4.1>
    2023-03-11T20:57:05.475938  =

    2023-03-11T20:57:05.584626  / # #
    2023-03-11T20:57:05.688512  export SHELL=3D/bin/sh
    2023-03-11T20:57:05.689777  #
    2023-03-11T20:57:05.792773  / # export SHELL=3D/bin/sh. /lava-3405411/e=
nvironment
    2023-03-11T20:57:05.793847  =

    2023-03-11T20:57:05.896616  / # . /lava-3405411/environment/lava-340541=
1/bin/lava-test-runner /lava-3405411/1
    2023-03-11T20:57:05.898798  =

    2023-03-11T20:57:05.902096  / # /lava-3405411/bin/lava-test-runner /lav=
a-3405411/1 =

    ... (13 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
meson-gxm-q200             | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640ceb61fd6dde7eb98c869a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640ceb61fd6dde7eb98c86a3
        new failure (last pass: v4.19.275-252-ge9b6ff517cd5)

    2023-03-11T20:57:56.527123  <8>[   16.302194] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3405410_1.5.2.4.1>
    2023-03-11T20:57:56.667664  / # #
    2023-03-11T20:57:56.778431  export SHELL=3D/bin/sh
    2023-03-11T20:57:56.779959  #
    2023-03-11T20:57:56.883280  / # export SHELL=3D/bin/sh. /lava-3405410/e=
nvironment
    2023-03-11T20:57:56.884785  =

    2023-03-11T20:57:56.988212  / # . /lava-3405410/environment/lava-340541=
0/bin/lava-test-runner /lava-3405410/1
    2023-03-11T20:57:56.990941  =

    2023-03-11T20:57:57.000589  / # /lava-3405410/bin/lava-test-runner /lav=
a-3405410/1
    2023-03-11T20:57:57.064368  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebce0c6026e2338c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebce0c6026e2338c8=
643
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec2ff66f78ead98c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec2ff66f78ead98c8=
633
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640ced2bf9c7f2d4548c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640ced2bf9c7f2d4548c8=
630
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cedcc8f86f0a03f8c8657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cedcc8f86f0a03f8c8=
658
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebb09581a985dd8c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebb09581a985dd8c8=
63a
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec2620675d30bc8c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec2620675d30bc8c8=
640
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebcb0c6026e2338c863c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebcb0c6026e2338c8=
63d
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec3120675d30bc8c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec3120675d30bc8c8=
655
        failing since 305 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cecc7bd1a150d258c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cecc7bd1a150d258c8=
638
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cee30e03b9fc9918c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cee30e03b9fc9918c8=
64d
        failing since 305 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebafee09a6bfa98c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebafee09a6bfa98c8=
66c
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cecc7e235530a2b8c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cecc7e235530a2b8c8=
632
        failing since 305 days (last pass: v4.19.241-58-g5e77acf6dbb6, firs=
t fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebca0c6026e2338c8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebca0c6026e2338c8=
63a
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec2d20675d30bc8c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec2d20675d30bc8c8=
64b
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec63a50d3eb1078c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec63a50d3eb1078c8=
634
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640ced67f9c7f2d4548c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640ced67f9c7f2d4548c8=
649
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebaf9581a985dd8c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebaf9581a985dd8c8=
633
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec27625aea8cdf8c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec27625aea8cdf8c8=
655
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebcd0c6026e2338c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebcd0c6026e2338c8=
640
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec2e20675d30bc8c864e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec2e20675d30bc8c8=
64f
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cecef21443326a58c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cecef21443326a58c8=
637
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640ceda48f86f0a03f8c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640ceda48f86f0a03f8c8=
655
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640cebb09581a985dd8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cebb09581a985dd8c8=
637
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/640cec2820675d30bc8c8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.275=
-252-gcb3c41fc75db9/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640cec2820675d30bc8c8=
646
        failing since 228 days (last pass: v4.19.230-58-gbd840138c177, firs=
t fail: v4.19.253-43-g91137b502cfbd) =

 =20
