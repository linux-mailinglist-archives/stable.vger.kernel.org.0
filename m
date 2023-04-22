Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7882F6EB7C8
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 09:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDVHZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 03:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVHZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 03:25:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A95199D
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 00:25:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-24b3451b2fcso2089983a91.3
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 00:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682148335; x=1684740335;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yry7p/HVXjt3lmDm4XsI0ImT26VlW+7AEjllnshIvD8=;
        b=iWDsQDMVB3ctRXvz6VSG2st8A0RYuyUd7eLAlBoGqf00yPU9ym2YMdfp7/wwfV/+jm
         /sJfHYsjHHWNLkLG25+9NloSUOii2JL94joeJvY7DTz9/2wuAYSbZqfeUXzwiZLhyrso
         ALah+HsJTZVldmmlTeDAvgK0gT5ukHHGGZMSHamICsgQL9V89jiITR8kEA3sbOw4bxW+
         WZ6gl+40m1SWRMWnaNij7lxQFT1B+swYDspOo1ub7WYx6+uzvrqt28/CqLGIXru7J95+
         xzUguMIVM67tDMB/qWwH82L+p0/DhSB4LBrkkAZTz9+lCJVxPic5Tsf9k5p6BRD/oBCW
         QdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682148335; x=1684740335;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yry7p/HVXjt3lmDm4XsI0ImT26VlW+7AEjllnshIvD8=;
        b=RT2kqaqI4vSX7VU8s4PVJRV43Ni6q6Fj6F+vNEE5qI/WlPIbm4bw7bT5vQN2P3NWAS
         MQaWjYvsKn3gaPJdxCtE1RKgSwJfwNcEFcrkyoueYAM5EovrhTuo8B3Crn9HMMsQO+Ge
         ty0V52dPBeJVVhzkrgoV+c3tC6ZQxqGbvlr4VwZDuLYXnahKjN1g4DmMrTj1CVNAicgH
         c77pFUidABwchOz7k7o9ZM7O3nne4f1+lKjpefM03R15EjkGQ8fzyCZycodwadyRRqod
         hcCfOvuQiAR4heSDerPkZmKvUx5j8XlGK5vnN+Dbw2/IhQ4A1rX4XgYKjT0IcLo2EKJ7
         HHYw==
X-Gm-Message-State: AAQBX9d04eIYhwqbO1ZvZoFPMyAq9z1bkrEflZ73PCd6gdRgvdm3fFlE
        DU3x9ItJ38QNAQJL3l8wrNsdumRf442Z+C/f5/K0mEF+
X-Google-Smtp-Source: AKy350bKzzOGULboqTxSJ1Q3tioK6CSQiRKiuONARXPO+kq82IKCb0mDbrY7lkgeeuZUnipZJ3hwJg==
X-Received: by 2002:a17:90a:7004:b0:247:1e30:5880 with SMTP id f4-20020a17090a700400b002471e305880mr6978948pjk.38.1682148334641;
        Sat, 22 Apr 2023 00:25:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ij8-20020a170902ab4800b0019c93ee6902sm3582239plb.109.2023.04.22.00.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 00:25:34 -0700 (PDT)
Message-ID: <64438bee.170a0220.2c3ce.8084@mx.google.com>
Date:   Sat, 22 Apr 2023 00:25:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-321-gd75271f0747a8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 138 runs,
 6 regressions (v5.10.176-321-gd75271f0747a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 138 runs, 6 regressions (v5.10.176-321-gd752=
71f0747a8)

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

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-321-gd75271f0747a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-321-gd75271f0747a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d75271f0747a852cd19889031e88446c8b5c754e =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644356addcbda0f6cc2e8624

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644356addcbda0f6cc2e8657
        failing since 67 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-22T03:37:55.304192  <8>[   17.057114] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 370206_1.5.2.4.1>
    2023-04-22T03:37:55.446038  / # #
    2023-04-22T03:37:55.559557  export SHELL=3D/bin/sh
    2023-04-22T03:37:55.564301  #
    2023-04-22T03:37:55.671656  / # export SHELL=3D/bin/sh. /lava-370206/en=
vironment
    2023-04-22T03:37:55.676281  =

    2023-04-22T03:37:55.783774  / # . /lava-370206/environment/lava-370206/=
bin/lava-test-runner /lava-370206/1
    2023-04-22T03:37:55.791598  =

    2023-04-22T03:37:55.794888  / # /lava-370206/bin/lava-test-runner /lava=
-370206/1
    2023-04-22T03:37:55.902570  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/644358decc968f88852e85ef

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644358decc968f88852e85f4
        failing since 85 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-22T03:47:28.848291  + set +x<8>[   11.077562] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3521056_1.5.2.4.1>
    2023-04-22T03:47:28.848578  =

    2023-04-22T03:47:28.955320  / # #
    2023-04-22T03:47:29.058118  export SHELL=3D/bin/sh
    2023-04-22T03:47:29.059102  #
    2023-04-22T03:47:29.161270  / # export SHELL=3D/bin/sh. /lava-3521056/e=
nvironment
    2023-04-22T03:47:29.162272  =

    2023-04-22T03:47:29.162776  / # . /lava-3521056/environment<3>[   11.37=
1287] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-22T03:47:29.264764  /lava-3521056/bin/lava-test-runner /lava-35=
21056/1
    2023-04-22T03:47:29.266557   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644358724d2e5172412e8621

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644358724d2e5172412e8626
        failing since 22 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-22T03:45:47.148132  + set +x

    2023-04-22T03:45:47.154931  <8>[   14.088007] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10082291_1.4.2.3.1>

    2023-04-22T03:45:47.259887  / # #

    2023-04-22T03:45:47.360782  export SHELL=3D/bin/sh

    2023-04-22T03:45:47.361025  #

    2023-04-22T03:45:47.462001  / # export SHELL=3D/bin/sh. /lava-10082291/=
environment

    2023-04-22T03:45:47.462237  =


    2023-04-22T03:45:47.563209  / # . /lava-10082291/environment/lava-10082=
291/bin/lava-test-runner /lava-10082291/1

    2023-04-22T03:45:47.563564  =


    2023-04-22T03:45:47.567939  / # /lava-10082291/bin/lava-test-runner /la=
va-10082291/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64435884b2a67bba112e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64435884b2a67bba112e85eb
        failing since 22 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-22T03:45:52.121309  + set +x

    2023-04-22T03:45:52.127999  <8>[   13.058806] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10082324_1.4.2.3.1>

    2023-04-22T03:45:52.237893  / # #

    2023-04-22T03:45:52.340089  export SHELL=3D/bin/sh

    2023-04-22T03:45:52.340746  #

    2023-04-22T03:45:52.442455  / # export SHELL=3D/bin/sh. /lava-10082324/=
environment

    2023-04-22T03:45:52.443287  =


    2023-04-22T03:45:52.545418  / # . /lava-10082324/environment/lava-10082=
324/bin/lava-test-runner /lava-10082324/1

    2023-04-22T03:45:52.546496  =


    2023-04-22T03:45:52.551379  / # /lava-10082324/bin/lava-test-runner /la=
va-10082324/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64435a8f15e75e6ca12e865b

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-321-gd75271f0747a8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64435a8f15e75e6ca12e8661
        failing since 39 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-22T03:54:49.566739  <8>[   35.181722] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-22T03:54:50.589937  /lava-10082360/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64435a8f15e75e6ca12e8662
        failing since 39 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-22T03:54:48.532558  <8>[   34.146403] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-22T03:54:49.554860  /lava-10082360/1/../bin/lava-test-case
   =

 =20
