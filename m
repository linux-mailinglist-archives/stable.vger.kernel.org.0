Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F2168BCCB
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 13:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjBFMbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 07:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBFMbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 07:31:33 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564F112052
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 04:31:29 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 144so8216354pfv.11
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 04:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hkYFRKP90XkS0VxS5n+NaUZSOFl0nsRehLaZ8OlKGJs=;
        b=dTCUi1XlUS1IeYVC5W1K7rFM1tqvGDcyasOPKwIe5LarDkjbEOxInMhJCsvzhl54RQ
         SPPgqaGOB7mRmnongMPZ7FyMWJyJDSgjPr4x73uaLSrmf5wBiCK0TSLqDuRoc5O9al4C
         CLOyt7wdRKUFDsmLfAOK67q4Z3LEcrCOThOGRbiV6ISkp6zchCYOTeTl3mwRE8GJz/9v
         PjtOEjShosxtkaL2vcyy0Le2Yg7X/6zr/Y29Y6MWIW+kBznFlZfd2+qdfN5Mq3STd8Kq
         /xn1tOZYmqk7c8TE+os0u1meBjYWRxgyttBvood1SrxhB0FDLzGHIs+9NP5IPdQv6PxI
         7olw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hkYFRKP90XkS0VxS5n+NaUZSOFl0nsRehLaZ8OlKGJs=;
        b=duLH/XyT29gBswQfHm4n1/u/6UjVGUr75OR/Dx3Du09CxOAlmYQQEVhqwbV+do8jak
         vsFd0Kh5sS6lBrAJHmWGYPChIZ3afngtFFqC8X2keh2pz8EeOGmkiUc8cl/z7kqa3JZi
         EMAPb2zLUG3CK5fuXHLJt+J0lN6TQ8ulODUsehPGe6ETsmFl7qUrQijUqbdJRLxRaNKB
         /1kacaQJx6ub9PrEppBz7XDrBOlH/Akyfjf0ej2rFxbnsYospe7CcwbiNfcX5roN+WXZ
         Y1OJch59mglwxye4OPJTb07PfqdloVOzUZBxGKD6eVCx6N3oEd3WJG95gPMk5wFVaL90
         IELw==
X-Gm-Message-State: AO0yUKWpdRkcmJP1cByJibqw14yg4hLfhI5JhKBK/a0w4mZUPKcu3pmC
        0QGt71GHPq1VZcqHQdHa/xoO/x8qOThOoTwfIkk=
X-Google-Smtp-Source: AK7set/OFCO+UnqQ/bX4MPHSKlqZzzmsc1xOFXCPmM+rXh/SUTMFIc8mge9/aZ/uk8AwKaTJcyBazw==
X-Received: by 2002:a62:5254:0:b0:594:1f1c:3d2f with SMTP id g81-20020a625254000000b005941f1c3d2fmr10012244pfb.4.1675686686995;
        Mon, 06 Feb 2023 04:31:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a184-20020a621ac1000000b0058bacd6c4e8sm6929760pfa.207.2023.02.06.04.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 04:31:26 -0800 (PST)
Message-ID: <63e0f31e.620a0220.b649c.b0d7@mx.google.com>
Date:   Mon, 06 Feb 2023 04:31:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.272
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 154 runs, 55 regressions (v4.19.272)
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

stable/linux-4.19.y baseline: 154 runs, 55 regressions (v4.19.272)

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

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
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

r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =

rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =

sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-10   | defcon=
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

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =

zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.272/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.272
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      53b696f0584acce2e90db69272a2a11aab138370 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c8c55f49cd7c13915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0c8c55f49cd7c13915ebe
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T09:30:27.544889  + set +x

    2023-02-06T09:30:27.550961  <8>[   11.459913] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9032766_1.4.2.3.1>

    2023-02-06T09:30:27.653197  #

    2023-02-06T09:30:27.653501  =


    2023-02-06T09:30:27.754226  / # #export SHELL=3D/bin/sh

    2023-02-06T09:30:27.754506  =


    2023-02-06T09:30:27.855470  / # export SHELL=3D/bin/sh. /lava-9032766/e=
nvironment

    2023-02-06T09:30:27.855682  =


    2023-02-06T09:30:27.956598  / # . /lava-9032766/environment/lava-903276=
6/bin/lava-test-runner /lava-9032766/1

    2023-02-06T09:30:27.956947  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C523NA-A20057-coral     | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c8db3bc101773a915ed8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C=
523NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0c8db3bc101773a915edd
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T09:30:48.632384  + set +x

    2023-02-06T09:30:48.638720  <8>[   10.779870] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9032713_1.4.2.3.1>

    2023-02-06T09:30:48.743672  / # #

    2023-02-06T09:30:48.844694  export SHELL=3D/bin/sh

    2023-02-06T09:30:48.844897  #

    2023-02-06T09:30:48.945839  / # export SHELL=3D/bin/sh. /lava-9032713/e=
nvironment

    2023-02-06T09:30:48.946053  =


    2023-02-06T09:30:49.046989  / # . /lava-9032713/environment/lava-903271=
3/bin/lava-test-runner /lava-9032713/1

    2023-02-06T09:30:49.047268  =


    2023-02-06T09:30:49.052843  / # /lava-9032713/bin/lava-test-runner /lav=
a-9032713/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
at91sam9g20ek                | arm    | lab-broonie     | gcc-10   | multi_=
v5_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc1b9b00adeff4915ed7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc1b9b00adeff4915edc
        new failure (last pass: v4.19.271)

    2023-02-06T08:36:26.214998  + set +x
    2023-02-06T08:36:26.220181  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 259385_1.5.2=
.4.1>
    2023-02-06T08:36:26.333479  / # #
    2023-02-06T08:36:26.435846  export SHELL=3D/bin/sh
    2023-02-06T08:36:26.436665  #
    2023-02-06T08:36:26.538681  / # export SHELL=3D/bin/sh. /lava-259385/en=
vironment
    2023-02-06T08:36:26.539459  =

    2023-02-06T08:36:26.641507  / # . /lava-259385/environment/lava-259385/=
bin/lava-test-runner /lava-259385/1
    2023-02-06T08:36:26.642849  =

    2023-02-06T08:36:26.649339  / # /lava-259385/bin/lava-test-runner /lava=
-259385/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bd34f059c9d4de915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bd34f059c9d4de915=
ed4
        new failure (last pass: v4.19.271) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bbe0f1d8c62569915ed8

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bbe0f1d8c62569915edd
        failing since 12 days (last pass: v4.19.268, first fail: v4.19.271)

    2023-02-06T08:35:26.546886  + set +x<8>[   25.578308] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3294704_1.5.2.4.1>
    2023-02-06T08:35:26.547402  =

    2023-02-06T08:35:26.660801  / # #
    2023-02-06T08:35:26.763720  export SHELL=3D/bin/sh
    2023-02-06T08:35:26.764482  #
    2023-02-06T08:35:26.866257  / # export SHELL=3D/bin/sh. /lava-3294704/e=
nvironment
    2023-02-06T08:35:26.867022  =

    2023-02-06T08:35:26.968760  / # . /lava-3294704/environment/lava-329470=
4/bin/lava-test-runner /lava-3294704/1
    2023-02-06T08:35:26.970050  =

    2023-02-06T08:35:26.975489  / # /lava-3294704/bin/lava-test-runner /lav=
a-3294704/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bcecf9f4cfa136915ebd

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bcecf9f4cfa136915ec2
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:39:48.313384  <8>[   11.421458] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 259496_1.5.2.4.1>
    2023-02-06T08:39:48.423379  / # #
    2023-02-06T08:39:48.526553  export SHELL=3D/bin/sh
    2023-02-06T08:39:48.527476  #
    2023-02-06T08:39:48.527929  / # export SHELL=3D/bin/sh<6>[   11.634287]=
 usb 1-1: new low-speed USB device number 3 using musb-hdrc
    2023-02-06T08:39:48.630042  . /lava-259496/environment
    2023-02-06T08:39:48.630978  =

    2023-02-06T08:39:48.733117  / # . /lava-259496/environment/lava-259496/=
bin/lava-test-runner /lava-259496/1
    2023-02-06T08:39:48.734601  =

    2023-02-06T08:39:48.735021  / # <3>[   11.784273] usb 1-1: device descr=
iptor read/64, error -71 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc908d5ab2aeed915ecb

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc908d5ab2aeed915ed0
        failing since 12 days (last pass: v4.19.270, first fail: v4.19.271)

    2023-02-06T08:38:29.822191  + set +x<8>[   18.267015] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 259452_1.5.2.4.1>
    2023-02-06T08:38:29.822531  =

    2023-02-06T08:38:29.934497  / # #
    2023-02-06T08:38:30.036802  export SHELL=3D/bin/sh
    2023-02-06T08:38:30.037476  #
    2023-02-06T08:38:30.139153  / # export SHELL=3D/bin/sh. /lava-259452/en=
vironment
    2023-02-06T08:38:30.139777  =

    2023-02-06T08:38:30.241394  / # . /lava-259452/environment/lava-259452/=
bin/lava-test-runner /lava-259452/1
    2023-02-06T08:38:30.242462  =

    2023-02-06T08:38:30.246777  / # /lava-259452/bin/lava-test-runner /lava=
-259452/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc1e9b00adeff4915ee5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc1e9b00adeff4915eea
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T08:36:32.552265  <8>[    7.403192] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3294717_1.5.2.4.1>
    2023-02-06T08:36:32.663828  / # #
    2023-02-06T08:36:32.766886  export SHELL=3D/bin/sh
    2023-02-06T08:36:32.767885  #
    2023-02-06T08:36:32.870191  / # export SHELL=3D/bin/sh. /lava-3294717/e=
nvironment
    2023-02-06T08:36:32.871137  =

    2023-02-06T08:36:32.973378  / # . /lava-3294717/environment/lava-329471=
7/bin/lava-test-runner /lava-3294717/1
    2023-02-06T08:36:32.975119  =

    2023-02-06T08:36:32.980161  / # /lava-3294717/bin/lava-test-runner /lav=
a-3294717/1
    2023-02-06T08:36:33.063737  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6q-sabrelite              | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c9140153571c0f915ec7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-imx6q-sabrelite.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0c9140153571c0f915ecc
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T09:31:46.473375  / # #

    2023-02-06T09:31:46.576587  export SHELL=3D/bin/sh

    2023-02-06T09:31:46.577421  #

    2023-02-06T09:31:46.679310  / # export SHELL=3D/bin/sh. /lava-9032692/e=
nvironment

    2023-02-06T09:31:46.680136  =


    2023-02-06T09:31:46.782311  / # . /lava-9032692/environment/lava-903269=
2/bin/lava-test-runner /lava-9032692/1

    2023-02-06T09:31:46.783589  =


    2023-02-06T09:31:46.795814  / # /lava-9032692/bin/lava-test-runner /lav=
a-9032692/1

    2023-02-06T09:31:46.902792  + export 'TESTRUN_ID=3D1_bootrr'

    2023-02-06T09:31:46.903352  + cd /lava-9032692/1/tests/1_bootrr
 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | imx_v6=
_v7_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bbaf4d7fc8c9d2915eb9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-re=
vd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bbaf4d7fc8c9d2915ebe
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:34:30.043982  + set +x[    7.088304] <LAVA_SIGNAL_ENDRUN =
0_dmesg 899066_1.5.2.3.1>
    2023-02-06T08:34:30.044187  =

    2023-02-06T08:34:30.151639  / # #
    2023-02-06T08:34:30.253406  export SHELL=3D/bin/sh
    2023-02-06T08:34:30.253808  #
    2023-02-06T08:34:30.355176  / # export SHELL=3D/bin/sh. /lava-899066/en=
vironment
    2023-02-06T08:34:30.355817  =

    2023-02-06T08:34:30.457087  / # . /lava-899066/environment/lava-899066/=
bin/lava-test-runner /lava-899066/1
    2023-02-06T08:34:30.457732  =

    2023-02-06T08:34:30.460106  / # /lava-899066/bin/lava-test-runner /lava=
-899066/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx6qp-wandboard-revd1       | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc139b00adeff4915ec9

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6qp-wandboard-rev=
d1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc139b00adeff4915ece
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:36:11.097741  + set +x
    2023-02-06T08:36:11.097934  [    4.857839] <LAVA_SIGNAL_ENDRUN 0_dmesg =
899071_1.5.2.3.1>
    2023-02-06T08:36:11.204059  / # #
    2023-02-06T08:36:11.305521  export SHELL=3D/bin/sh
    2023-02-06T08:36:11.305905  #
    2023-02-06T08:36:11.407069  / # export SHELL=3D/bin/sh. /lava-899071/en=
vironment
    2023-02-06T08:36:11.407466  =

    2023-02-06T08:36:11.508657  / # . /lava-899071/environment/lava-899071/=
bin/lava-test-runner /lava-899071/1
    2023-02-06T08:36:11.509254  =

    2023-02-06T08:36:11.511535  / # /lava-899071/bin/lava-test-runner /lava=
-899071/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc5239bb7a78f0915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bc5239bb7a78f0915=
ed1
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bea91f584448ab915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bea91f584448ab915=
ed4
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bceaf9f4cfa136915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bceaf9f4cfa136915=
eba
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bea3838e2cdfe5915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bea3838e2cdfe5915=
eba
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c9d904ff03eb2b915f02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0c9d904ff03eb2b915=
f03
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0cb2edb490e3a88915f5a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0cb2edb490e3a88915=
f5b
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc51e4285bf5aa915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bc51e4285bf5aa915=
ec6
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0beab1f584448ab915ed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0beab1f584448ab915=
eda
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc4b39bb7a78f0915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bc4b39bb7a78f0915=
eba
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bea5838e2cdfe5915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bea5838e2cdfe5915=
ec0
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c9a0d2b9a5b475915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv2-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0c9a0d2b9a5b475915=
ebd
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0cb552d13d9b09c915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0cb552d13d9b09c915=
edc
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc2a8fd6b4d83b915ef5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bc2a8fd6b4d83b915=
ef6
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0beaa838e2cdfe5915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0beaa838e2cdfe5915=
ec6
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc3832e98a00e6915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bc3832e98a00e6915=
ed5
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bea41f584448ab915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bea41f584448ab915=
ece
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c99fc5a8f27483915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0c99fc5a8f27483915=
eba
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3        | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0cb425f0e2b3a92915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0cb425f0e2b3a92915=
eca
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc298fd6b4d83b915ef1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bc298fd6b4d83b915=
ef2
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-baylibre    | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bead838e2cdfe5915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bead838e2cdfe5915=
ecc
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc37e5b4debaf1915edd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bc37e5b4debaf1915=
ede
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bf1b02e6dafa34915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0bf1b02e6dafa34915=
eba
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0c99e9aaa11207c915f69

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-virt-gicv3-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0c99e9aaa11207c915=
f6a
        failing since 269 days (last pass: v4.19.239, first fail: v4.19.242=
) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip         | gcc-10   | shmobi=
le_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0badad906eb4cfc915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e0badad906eb4cfc915=
ed5
        failing since 72 days (last pass: v4.19.266, first fail: v4.19.267) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3288-veyron-jaq            | arm    | lab-collabora   | gcc-10   | multi_=
v7_defconfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/63e0ce0d54793b288f915eeb

  Results:     61 PASS, 8 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.dwhdmi-rockchip-driver-cec-present: https://kernelci.or=
g/test/case/id/63e0ce0d54793b288f915f1b
        failing since 17 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T09:53:06.393031  BusyBox v1.31.1 (2023-01-27 15:57:34 UTC)<8=
>[   12.714890] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwhdmi-rockchip-driver=
-audio-present RESULT=3Dfail>

    2023-02-06T09:53:06.394661   multi-call binary.

    2023-02-06T09:53:06.394885  =


    2023-02-06T09:53:06.399359  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-02-06T09:53:06.399863  =


    2023-02-06T09:53:06.404488  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-02-06T09:53:06.414677  FIRST,<8>[   12.733578] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Ddwhdmi-rockchip-driver-cec-present RESULT=3Dfail>
   =


  * baseline.bootrr.dwhdmi-rockchip-driver-audio-present: https://kernelci.=
org/test/case/id/63e0ce0d54793b288f915f1c
        failing since 17 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T09:53:06.374722  =

   =


  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0ce0d54793b288f915f2f
        failing since 17 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T09:53:02.545555  <8>[    8.868670] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>

    2023-02-06T09:53:02.555330  + <8>[    8.880901] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9032697_1.5.2.3.1>

    2023-02-06T09:53:02.555529  set +x

    2023-02-06T09:53:02.662214  #

    2023-02-06T09:53:02.764124  / # #export SHELL=3D/bin/sh

    2023-02-06T09:53:02.764503  =


    2023-02-06T09:53:02.865791  / # export SHELL=3D/bin/sh. /lava-9032697/e=
nvironment

    2023-02-06T09:53:02.866174  =


    2023-02-06T09:53:02.967481  / # . /lava-9032697/environment/lava-903269=
7/bin/lava-test-runner /lava-9032697/1

    2023-02-06T09:53:02.968095  =

 =

    ... (16 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 5          =


  Details:     https://kernelci.org/test/plan/id/63e0c902214de90ce0915edc

  Results:     79 PASS, 9 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63e0c902214de90ce0915efe
        failing since 326 days (last pass: v4.19.231, first fail: v4.19.235)

    2023-02-06T09:31:38.695963  /lava-9032791/1/../bin/lava-test-case

    2023-02-06T09:31:38.704542  <8>[   35.882657] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-rt5514-present: https://kernelc=
i.org/test/case/id/63e0c902214de90ce0915f13
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T09:31:37.212527  BusyBox v1.31.1 (2023-01-2<8>[   34.386083]=
 <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-driver-max98357A-pre=
sent RESULT=3Dfail>

    2023-02-06T09:31:37.214456  7 15:57:07 UTC) multi-call binary.

    2023-02-06T09:31:37.215232  =


    2023-02-06T09:31:37.220051  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-02-06T09:31:37.220505  =


    2023-02-06T09:31:37.235000  Print numbers from FIRST to LAST, in steps =
<8>[   34.408347] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drk3399-gru-sound-dri=
ver-rt5514-present RESULT=3Dfail>
   =


  * baseline.bootrr.rk3399-gru-sound-driver-max98357A-present: https://kern=
elci.org/test/case/id/63e0c902214de90ce0915f14
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T09:31:37.191715  	-w	Pad to last with leading zeros

    2023-02-06T09:31:37.194678  	-s SEP	String separator

    2023-02-06T09:31:37.198700  /lava-9032791/1/../bin/lava-test-case
   =


  * baseline.bootrr.rk3399-gru-sound-driver-dp-present: https://kernelci.or=
g/test/case/id/63e0c902214de90ce0915f15
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T09:31:37.167138  <8>[   34.340476] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-da7219-present RESULT=3Dfail>

    2023-02-06T09:31:37.167521  =


    2023-02-06T09:31:37.170485  Usage: seq [-w] [-s SEP] [FIRST [INC]] LAST

    2023-02-06T09:31:37.171209  =


    2023-02-06T09:31:37.176303  Print numbers from FIRST to LAST, in steps =
of INC.

    2023-02-06T09:31:37.178516  FIRST, INC default to 1.

    2023-02-06T09:31:37.178963  =

    2023-02-06T09:31:37.188365  <8>[   34.363119] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drk3399-gru-sound-driver-dp-present RESULT=3Dfail>

    2023-02-06T09:31:37.188832  =

   =


  * baseline.bootrr.rk3399-gru-sound-driver-da7219-present: https://kernelc=
i.org/test/case/id/63e0c902214de90ce0915f16
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T09:31:37.156361  BusyBox v1.31.1 (2023-01-27 15:57:07 UTC) m=
ulti-call binary.
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bb37a234800222915ebd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bb37a234800222915ec2
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T08:32:33.609069  + set +x
    2023-02-06T08:32:33.610956  <8>[   17.078367] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 392337_1.5.2.4.1>
    2023-02-06T08:32:33.718893  / # #
    2023-02-06T08:32:33.821487  export SHELL=3D/bin/sh
    2023-02-06T08:32:33.822145  #
    2023-02-06T08:32:33.923886  / # export SHELL=3D/bin/sh. /lava-392337/en=
vironment
    2023-02-06T08:32:33.924540  =

    2023-02-06T08:32:33.924878  / # <3>[   17.317720] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-02-06T08:32:34.026536  . /lava-392337/environment/lava-392337/bin/=
lava-test-runner /lava-392337/1
    2023-02-06T08:32:34.027553   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-baylibre    | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bbdbf1d8c62569915ebe

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bbdbf1d8c62569915ec3
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T08:35:11.544049  <8>[   15.867709] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3294686_1.5.2.4.1>
    2023-02-06T08:35:11.665442  / # #
    2023-02-06T08:35:11.771344  export SHELL=3D/bin/sh
    2023-02-06T08:35:11.772974  #
    2023-02-06T08:35:11.876647  / # export SHELL=3D/bin/sh. /lava-3294686/e=
nvironment
    2023-02-06T08:35:11.878280  =

    2023-02-06T08:35:11.981970  / # . /lava-3294686/environment/lava-329468=
6/bin/lava-test-runner /lava-3294686/1
    2023-02-06T08:35:11.984890  =

    2023-02-06T08:35:11.987208  / # /lava-3294686/bin/lava-test-runner /lav=
a-3294686/1
    2023-02-06T08:35:12.019625  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-a64-pine64-plus       | arm64  | lab-broonie     | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bb3d39fd4d8c01915ec5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bb3d39fd4d8c01915eca
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T08:32:44.078880  <8>[   15.912401] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 259428_1.5.2.4.1>
    2023-02-06T08:32:44.186401  / # #
    2023-02-06T08:32:44.289008  export SHELL=3D/bin/sh
    2023-02-06T08:32:44.289596  #
    2023-02-06T08:32:44.391446  / # export SHELL=3D/bin/sh. /lava-259428/en=
vironment
    2023-02-06T08:32:44.392019  =

    2023-02-06T08:32:44.494189  / # . /lava-259428/environment/lava-259428/=
bin/lava-test-runner /lava-259428/1
    2023-02-06T08:32:44.495376  =

    2023-02-06T08:32:44.500130  / # /lava-259428/bin/lava-test-runner /lava=
-259428/1
    2023-02-06T08:32:44.530995  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-clabbe      | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bb257336ab4541915ec4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bb257336ab4541915ec9
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T08:32:26.945112  / # #
    2023-02-06T08:32:27.047960  export SHELL=3D/bin/sh
    2023-02-06T08:32:27.048602  #
    2023-02-06T08:32:27.150100  / # export SHELL=3D/bin/sh. /lava-392340/en=
vironment
    2023-02-06T08:32:27.150733  =

    2023-02-06T08:32:27.252461  / # . /lava-392340/environment/lava-392340/=
bin/lava-test-runner /lava-392340/1
    2023-02-06T08:32:27.253532  =

    2023-02-06T08:32:27.267510  / # /lava-392340/bin/lava-test-runner /lava=
-392340/1
    2023-02-06T08:32:27.324529  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-06T08:32:27.325275  + cd /lava-392340/<8>[   15.634353] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 392340_1.5.2.4.5> =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun50i-h6-pine-h64           | arm64  | lab-collabora   | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0ce21cebebdad11915eda

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0ce21cebebdad11915edf
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T09:53:21.835230  / # #

    2023-02-06T09:53:21.937101  export SHELL=3D/bin/sh

    2023-02-06T09:53:21.937644  #

    2023-02-06T09:53:22.038983  / # export SHELL=3D/bin/sh. /lava-9032680/e=
nvironment

    2023-02-06T09:53:22.039548  =


    2023-02-06T09:53:22.140989  / # . /lava-9032680/environment/lava-903268=
0/bin/lava-test-runner /lava-9032680/1

    2023-02-06T09:53:22.141811  =


    2023-02-06T09:53:22.144966  / # /lava-9032680/bin/lava-test-runner /lav=
a-9032680/1

    2023-02-06T09:53:22.217013  + export 'TESTRUN_ID=3D1_bootrr'

    2023-02-06T09:53:22.217356  + cd /lava-9032680<8>[   15.631967] <LAVA_S=
IGNAL_STARTRUN 1_bootrr 9032680_1.5.2.4.5>
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-a33-olinuxino          | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc4f39bb7a78f0915ec2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc4f39bb7a78f0915ec7
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:37:16.122660  + set +x<8>[   17.349004] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 392344_1.5.2.4.1>
    2023-02-06T08:37:16.122978  =

    2023-02-06T08:37:16.229666  / # #
    2023-02-06T08:37:16.331983  export SHELL=3D/bin/sh
    2023-02-06T08:37:16.332641  #
    2023-02-06T08:37:16.434100  / # export SHELL=3D/bin/sh. /lava-392344/en=
vironment
    2023-02-06T08:37:16.434714  =

    2023-02-06T08:37:16.536320  / # . /lava-392344/environment/lava-392344/=
bin/lava-test-runner /lava-392344/1
    2023-02-06T08:37:16.537342  =

    2023-02-06T08:37:16.553940  / # /lava-392344/bin/lava-test-runner /lava=
-392344/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc040497966667915efc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-=
h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc040497966667915f01
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:35:54.133855  / # #
    2023-02-06T08:35:54.235586  export SHELL=3D/bin/sh
    2023-02-06T08:35:54.236120  #
    2023-02-06T08:35:54.337441  / # export SHELL=3D/bin/sh. /lava-3294716/e=
nvironment
    2023-02-06T08:35:54.337881  =

    2023-02-06T08:35:54.439230  / # . /lava-3294716/environment/lava-329471=
6/bin/lava-test-runner /lava-3294716/1
    2023-02-06T08:35:54.439938  =

    2023-02-06T08:35:54.445019  / # /lava-3294716/bin/lava-test-runner /lav=
a-3294716/1
    2023-02-06T08:35:54.540900  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-06T08:35:54.541390  + cd /lava-3294716/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0b995fbe56ff602915ebe

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0b995fbe56ff602915ec3
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:25:31.762897  <8>[    7.929651] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3294629_1.5.2.4.1>
    2023-02-06T08:25:31.868076  / # #
    2023-02-06T08:25:31.969803  export SHELL=3D/bin/sh
    2023-02-06T08:25:31.970181  #
    2023-02-06T08:25:32.071509  / # export SHELL=3D/bin/sh. /lava-3294629/e=
nvironment
    2023-02-06T08:25:32.071871  =

    2023-02-06T08:25:32.173236  / # . /lava-3294629/environment/lava-329462=
9/bin/lava-test-runner /lava-3294629/1
    2023-02-06T08:25:32.173856  =

    2023-02-06T08:25:32.193599  / # /lava-3294629/bin/lava-test-runner /lav=
a-3294629/1
    2023-02-06T08:25:32.257404  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc63e4285bf5aa915edc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc63e4285bf5aa915ee1
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:37:21.215610  + set +x
    2023-02-06T08:37:21.217546  <8>[   14.773867] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 392343_1.5.2.4.1>
    2023-02-06T08:37:21.325588  / # #
    2023-02-06T08:37:21.428106  export SHELL=3D/bin/sh
    2023-02-06T08:37:21.428684  #
    2023-02-06T08:37:21.530445  / # export SHELL=3D/bin/sh. /lava-392343/en=
vironment
    2023-02-06T08:37:21.531039  =

    2023-02-06T08:37:21.632723  / # . /lava-392343/environment/lava-392343/=
bin/lava-test-runner /lava-392343/1
    2023-02-06T08:37:21.633637  =

    2023-02-06T08:37:21.636285  / # /lava-392343/bin/lava-test-runner /lava=
-392343/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-orangepi-pc         | arm    | lab-clabbe      | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0b9f632691610ac915ed4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0b9f632691610ac915ed9
        failing since 18 days (last pass: v4.19.269, first fail: v4.19.270)

    2023-02-06T08:27:15.690576  <8>[    9.906945] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 392334_1.5.2.4.1>
    2023-02-06T08:27:15.798514  / # #
    2023-02-06T08:27:15.901262  export SHELL=3D/bin/sh
    2023-02-06T08:27:15.901884  #
    2023-02-06T08:27:16.003790  / # export SHELL=3D/bin/sh. /lava-392334/en=
vironment
    2023-02-06T08:27:16.004400  =

    2023-02-06T08:27:16.106235  / # . /lava-392334/environment/lava-392334/=
bin/lava-test-runner /lava-392334/1
    2023-02-06T08:27:16.107235  =

    2023-02-06T08:27:16.109170  / # /lava-392334/bin/lava-test-runner /lava=
-392334/1
    2023-02-06T08:27:16.153401  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bc0d8fd6b4d83b915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bc0d8fd6b4d83b915ebf
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T08:36:10.878197  <8>[    3.715603] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 841993_1.5.2.4.1>
    2023-02-06T08:36:10.981259  / # #
    2023-02-06T08:36:11.082503  export SHELL=3D/bin/sh
    2023-02-06T08:36:11.082832  #
    2023-02-06T08:36:11.183844  / # export SHELL=3D/bin/sh. /lava-841993/en=
vironment
    2023-02-06T08:36:11.184122  =

    2023-02-06T08:36:11.285144  / # . /lava-841993/environment/lava-841993/=
bin/lava-test-runner /lava-841993/1
    2023-02-06T08:36:11.285567  =

    2023-02-06T08:36:11.288154  / # /lava-841993/bin/lava-test-runner /lava=
-841993/1
    2023-02-06T08:36:11.325235  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
zynqmp-zcu102                | arm64  | lab-cip         | gcc-10   | defcon=
fig+arm64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e0bdc5057ac89e57915ecd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.272/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-cip/baseline-zynqmp-zcu102.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e0bdc5057ac89e57915ed0
        failing since 18 days (last pass: v4.19.268, first fail: v4.19.270)

    2023-02-06T08:43:34.209717  + set +x
    2023-02-06T08:43:34.210779  <8>[    3.715926] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 842050_1.5.2.4.1>
    2023-02-06T08:43:34.316829  / # #
    2023-02-06T08:43:34.418148  export SHELL=3D/bin/sh
    2023-02-06T08:43:34.418496  #
    2023-02-06T08:43:34.519564  / # export SHELL=3D/bin/sh. /lava-842050/en=
vironment
    2023-02-06T08:43:34.519946  =

    2023-02-06T08:43:34.620970  / # . /lava-842050/environment/lava-842050/=
bin/lava-test-runner /lava-842050/1
    2023-02-06T08:43:34.621488  =

    2023-02-06T08:43:34.623698  / # /lava-842050/bin/lava-test-runner /lava=
-842050/1 =

    ... (13 line(s) more)  =

 =20
