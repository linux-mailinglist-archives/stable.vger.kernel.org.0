Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11F46ECBC4
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 14:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjDXMEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 08:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDXMEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 08:04:32 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7101708
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 05:04:30 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a66911f5faso36522355ad.0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 05:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682337869; x=1684929869;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KQEu/HuL8pT4kzNY2V1T5LUAPNUvLceI/f5CM0+/5Ic=;
        b=Mij79NDJZZVyZCXgnM2hRq6VS79SiIAztYUhngMmqtKji47Mx2AbG3+mlQN9TxaNGY
         JMU4V9MQcvKHp3w7ELVvN+OV/8SEPo3CiXpOm49K9L8snoAc657e8SvqsHdP+QxfXZyY
         sIeTIYiyDF/f+OSwWcHWJWsSFKkjBaklMtbD6IA1/AWh8qAks2cI63b0yO71y78e2hAc
         M3H//hjir8+rqLNbhoyKV+9IRuY5eHaLfrx/JNNEelUTISmei1Vs71wwfbPyf2EkRNo9
         349s9IuF1r42iFrBLaT0R4GMMxJStIJF2+nPKAAHEahIzJP7fkj0LNQWVgO7qUJcIzEL
         rCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682337869; x=1684929869;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQEu/HuL8pT4kzNY2V1T5LUAPNUvLceI/f5CM0+/5Ic=;
        b=Qfx637tEmOrTTVStTNLsgJYJLlS6rSARuTcmYaA8zrIGNzD7ZY3yRzEkupGzLp8/EX
         8rrHFelV+2PITWsGYYpkvwJ5iWCDcXkYrCgEMThvab4tso+y0kB4O3UwiO5KsjdR1sGu
         XapWeoWQ+RyKHXdxI2gJAhdmUxfufgbITghtMvagCqPq5Ef5fQNcaPRDpNH/x1y+3P+Q
         Nv58fnFHJrMvGYmne/ZpNKD1TM/EZ76z0WJQu09iLwDNiHOqE2bf89LONYBhS3gRrxHr
         3NGcC9/SjhRJ5WMpQJX3M27OMgr5yYD3xpLHDeOwGA6yZPUfkz0i1tJR6+ebtlTx2pHh
         DKZw==
X-Gm-Message-State: AAQBX9fPHWKGlRIK/lAYMj0YEnZdL+02jAR+YCYtm2GWvAzxhPfJ3qIF
        rxxqSw6no7ZOA+s7zp2zop4gYp5IShK1NE57cYnMXQ==
X-Google-Smtp-Source: AKy350bgdcTAuvr3DCJuGdXr/86VFaUYJV1JNhkp5yAXyVXzRsbBkYfqzqUZpFp5X21hFweAeoutbQ==
X-Received: by 2002:a17:902:e849:b0:1a9:3a8c:d590 with SMTP id t9-20020a170902e84900b001a93a8cd590mr16251484plg.16.1682337869553;
        Mon, 24 Apr 2023 05:04:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5-20020a170902ee4500b001a064282b11sm6533965plo.151.2023.04.24.05.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 05:04:28 -0700 (PDT)
Message-ID: <6446704c.170a0220.2f902.c827@mx.google.com>
Date:   Mon, 24 Apr 2023 05:04:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-359-g7760085da5bd1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 131 runs,
 7 regressions (v5.10.176-359-g7760085da5bd1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 131 runs, 7 regressions (v5.10.176-359-g7760=
085da5bd1)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

meson-g12b-odroid-n2         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-359-g7760085da5bd1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-359-g7760085da5bd1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7760085da5bd1f8445b0fa821854debf4569d03d =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64463cfe3d9d0f8ca12e85fb

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64463cff3d9d0f8ca12e862c
        failing since 69 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-24T08:25:15.398324  + set +x<8>[   20.324124] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 377390_1.5.2.4.1>
    2023-04-24T08:25:15.398713  =

    2023-04-24T08:25:15.509239  / # #
    2023-04-24T08:25:15.611345  export SHELL=3D/bin/sh
    2023-04-24T08:25:15.612018  #
    2023-04-24T08:25:15.714019  / # export SHELL=3D/bin/sh. /lava-377390/en=
vironment
    2023-04-24T08:25:15.714697  =

    2023-04-24T08:25:15.816779  / # . /lava-377390/environment/lava-377390/=
bin/lava-test-runner /lava-377390/1
    2023-04-24T08:25:15.818088  =

    2023-04-24T08:25:15.822753  / # /lava-377390/bin/lava-test-runner /lava=
-377390/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64463d1f0baf7ef4302e8607

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64463d1f0baf7ef4302e860c
        failing since 87 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-24T08:25:37.963804  + set +x<8>[   11.025972] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3526503_1.5.2.4.1>
    2023-04-24T08:25:37.964453  =

    2023-04-24T08:25:38.074092  / # #
    2023-04-24T08:25:38.177895  export SHELL=3D/bin/sh
    2023-04-24T08:25:38.179012  #
    2023-04-24T08:25:38.281338  / # export SHELL=3D/bin/sh. /lava-3526503/e=
nvironment
    2023-04-24T08:25:38.282440  =

    2023-04-24T08:25:38.384465  / # . /lava-3526503/environment/lava-352650=
3/bin/lava-test-runner /lava-3526503/1
    2023-04-24T08:25:38.386208  =

    2023-04-24T08:25:38.391312  / # /lava-3526503/bin/lava-test-runner /lav=
a-3526503/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64463d9c4ad625fd7d2e8609

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64463d9c4ad625fd7d2e860e
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-24T08:27:59.602240  + set +x

    2023-04-24T08:27:59.609231  <8>[   14.228148] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10100331_1.4.2.3.1>

    2023-04-24T08:27:59.713162  / # #

    2023-04-24T08:27:59.813850  export SHELL=3D/bin/sh

    2023-04-24T08:27:59.814051  #

    2023-04-24T08:27:59.914576  / # export SHELL=3D/bin/sh. /lava-10100331/=
environment

    2023-04-24T08:27:59.914778  =


    2023-04-24T08:28:00.015304  / # . /lava-10100331/environment/lava-10100=
331/bin/lava-test-runner /lava-10100331/1

    2023-04-24T08:28:00.015596  =


    2023-04-24T08:28:00.020448  / # /lava-10100331/bin/lava-test-runner /la=
va-10100331/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64463d405d792dabb62e85f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64463d405d792dabb62e85f6
        failing since 24 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-24T08:26:22.371640  <8>[   11.452600] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10100353_1.4.2.3.1>

    2023-04-24T08:26:22.374959  + set +x

    2023-04-24T08:26:22.476124  #

    2023-04-24T08:26:22.576950  / # #export SHELL=3D/bin/sh

    2023-04-24T08:26:22.577149  =


    2023-04-24T08:26:22.677693  / # export SHELL=3D/bin/sh. /lava-10100353/=
environment

    2023-04-24T08:26:22.677887  =


    2023-04-24T08:26:22.778430  / # . /lava-10100353/environment/lava-10100=
353/bin/lava-test-runner /lava-10100353/1

    2023-04-24T08:26:22.778709  =


    2023-04-24T08:26:22.783699  / # /lava-10100353/bin/lava-test-runner /la=
va-10100353/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
meson-g12b-odroid-n2         | arm64  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64463e8aaf1ba5b1ad2e86bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64463e8aaf1ba5b1ad2e8=
6bd
        new failure (last pass: v5.10.176-356-g1b4cbb1058e2a) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64463fd366a4f054f72e8663

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-359-g7760085da5bd1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64463fd366a4f054f72e8669
        failing since 41 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-24T08:37:23.404470  /lava-10100648/1/../bin/lava-test-case

    2023-04-24T08:37:23.415048  <8>[   62.133026] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64463fd366a4f054f72e866a
        failing since 41 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-24T08:37:21.341773  <8>[   60.058343] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-24T08:37:22.367869  /lava-10100648/1/../bin/lava-test-case

    2023-04-24T08:37:22.377886  <8>[   61.095901] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
