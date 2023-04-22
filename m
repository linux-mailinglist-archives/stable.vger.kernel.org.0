Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF936EBC02
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 00:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDVWiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 18:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjDVWiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 18:38:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F0526AC
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 15:38:10 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b5465fb99so2860171b3a.1
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 15:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682203089; x=1684795089;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UJWBF9Ku/f+5FCcNdZ68UQ6L3EB+AD4YbIFj38HMsl8=;
        b=0it3LeDZBMt2XdGKzue0lZ7aISIiA7eRPSNVoeDSOThD/xj3JuGaKse6UYcEDZuJWY
         OhAggLML6BIZoZY6rmGnX3xTbkAG6L/ybLULQfLmGl5NFAPTrDWQozF7R3V897CKBmYH
         U8R8EaNNHZs6JX7iQcHieF7AP6dQ63DixTycKVIrdCo23lbdrrZwgpdn0qjymv5TZ1of
         di/OfQeW7XZE5ZOuuYffz7NZjTOh5hUAcPDO8qwlQaBRwQaSucfkAhcwJ7VudjCFm6jc
         3AiZ8KGWzn4J42CL96WR09kxTZfUnczf0/MgFXN7mOtBd30Ak8ePzl+BQd24fZR99sSf
         CEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682203089; x=1684795089;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UJWBF9Ku/f+5FCcNdZ68UQ6L3EB+AD4YbIFj38HMsl8=;
        b=iPw2rSvwrtlWZfEw4Tqcbi8WjNNOoSSWE0HPdMMBIvKTHUY6QtKiKfh8ejUHIu+e23
         5YK1RmpbWAh5vdDY6YxrLw1U8PeSderTl84I3chEUfxpZjWDTItvhPpE0PkivwhJytTJ
         Qbjp+x43KD2+DVvpnsi2Qhyru0WLe/SFyR48fU3MkY8+E4fc1iNdsrx/o40SxATNQjfk
         RLZP5l6mHl3tiX1BvVljSllFDNzVU4rjaNVCZqNqKXOM8v7MPgAZY+wHNNSFkQECYEJI
         zhLgpq4SicmxaKPvh5sTyJJXKX7baEe+DiU1qn0gKETyOgI1nxzmdScuZB1u7kd4Q/mg
         PxRQ==
X-Gm-Message-State: AAQBX9dIJdwg6U9WLL/4OE9WCgyEsQXaROO9q1ddYDScchVfj9GQKcyE
        zTvs/iS2qsqhD23rrp8b7o5VjYhCxbMD4l1kNLaWcY8H
X-Google-Smtp-Source: AKy350acLidSC7vbIsUceCoi0Elqc4fRoWtZ8YXnudqe/hGXir//lahce7RyJFBWMC4j3+1WBY6Lig==
X-Received: by 2002:a05:6a00:188b:b0:639:243f:da25 with SMTP id x11-20020a056a00188b00b00639243fda25mr13464265pfh.22.1682203089387;
        Sat, 22 Apr 2023 15:38:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u6-20020a63f646000000b004fb5f4bf585sm4248555pgj.78.2023.04.22.15.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 15:38:09 -0700 (PDT)
Message-ID: <644461d1.630a0220.3364d.8a2b@mx.google.com>
Date:   Sat, 22 Apr 2023 15:38:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-329-g43116b257b3d3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 107 runs,
 6 regressions (v5.10.176-329-g43116b257b3d3)
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

stable-rc/queue/5.10 baseline: 107 runs, 6 regressions (v5.10.176-329-g4311=
6b257b3d3)

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
nel/v5.10.176-329-g43116b257b3d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-329-g43116b257b3d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43116b257b3d3dd4d8704a2837dda80abce82131 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64442972270844f0372e85f3

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442972270844f0372e8629
        failing since 67 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-22T18:37:19.169654  <8>[   20.415233] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 371423_1.5.2.4.1>
    2023-04-22T18:37:19.280058  / # #
    2023-04-22T18:37:19.383101  export SHELL=3D/bin/sh
    2023-04-22T18:37:19.383854  #
    2023-04-22T18:37:19.486241  / # export SHELL=3D/bin/sh. /lava-371423/en=
vironment
    2023-04-22T18:37:19.486995  =

    2023-04-22T18:37:19.589368  / # . /lava-371423/environment/lava-371423/=
bin/lava-test-runner /lava-371423/1
    2023-04-22T18:37:19.590523  =

    2023-04-22T18:37:19.595544  / # /lava-371423/bin/lava-test-runner /lava=
-371423/1
    2023-04-22T18:37:19.697205  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64442ba5ef142812072e85f1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64442ba5ef142812072e85f6
        failing since 86 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-22T18:46:41.282551  + set +x<8>[   11.077458] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3521715_1.5.2.4.1>
    2023-04-22T18:46:41.282800  =

    2023-04-22T18:46:41.389456  / # #
    2023-04-22T18:46:41.490827  export SHELL=3D/bin/sh
    2023-04-22T18:46:41.491276  #
    2023-04-22T18:46:41.592509  / # export SHELL=3D/bin/sh. /lava-3521715/e=
nvironment
    2023-04-22T18:46:41.592915  =

    2023-04-22T18:46:41.694201  / # . /lava-3521715/environment/lava-352171=
5/bin/lava-test-runner /lava-3521715/1
    2023-04-22T18:46:41.694864  =

    2023-04-22T18:46:41.695079  / # <3>[   11.451017] Bluetooth: hci0: comm=
and 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644429e28539fe32202e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644429e28539fe32202e85eb
        failing since 23 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-22T18:39:19.708283  + set +x

    2023-04-22T18:39:19.714807  <8>[   10.333286] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10085877_1.4.2.3.1>

    2023-04-22T18:39:19.819368  / # #

    2023-04-22T18:39:19.920462  export SHELL=3D/bin/sh

    2023-04-22T18:39:19.920676  #

    2023-04-22T18:39:20.021605  / # export SHELL=3D/bin/sh. /lava-10085877/=
environment

    2023-04-22T18:39:20.021792  =


    2023-04-22T18:39:20.122727  / # . /lava-10085877/environment/lava-10085=
877/bin/lava-test-runner /lava-10085877/1

    2023-04-22T18:39:20.123015  =


    2023-04-22T18:39:20.127496  / # /lava-10085877/bin/lava-test-runner /la=
va-10085877/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644429ea8539fe32202e8624

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644429ea8539fe32202e8629
        failing since 23 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-22T18:39:25.938916  + set +x

    2023-04-22T18:39:25.945375  <8>[   13.201141] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10085920_1.4.2.3.1>

    2023-04-22T18:39:26.053354  =


    2023-04-22T18:39:26.155452  / # #export SHELL=3D/bin/sh

    2023-04-22T18:39:26.156080  =


    2023-04-22T18:39:26.257640  / # export SHELL=3D/bin/sh. /lava-10085920/=
environment

    2023-04-22T18:39:26.258281  =


    2023-04-22T18:39:26.360028  / # . /lava-10085920/environment/lava-10085=
920/bin/lava-test-runner /lava-10085920/1

    2023-04-22T18:39:26.361054  =


    2023-04-22T18:39:26.366248  / # /lava-10085920/bin/lava-test-runner /la=
va-10085920/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64442c8ac15418c65c2e85e6

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-329-g43116b257b3d3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64442c8ac15418c65c2e85ec
        failing since 39 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-22T18:50:46.607784  /lava-10086035/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64442c8ac15418c65c2e85ed
        failing since 39 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-22T18:50:45.570901  /lava-10086035/1/../bin/lava-test-case

    2023-04-22T18:50:45.581800  <8>[   33.965413] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
