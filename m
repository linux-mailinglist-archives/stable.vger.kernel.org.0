Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECFF6E8050
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjDSR1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 13:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjDSR1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 13:27:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AC065B5
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 10:27:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-24756a12ba0so1826629a91.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 10:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681925270; x=1684517270;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VSZeMMc6hzF+JDcspidfOiGlvqJnHklFW5N/Px2xg6w=;
        b=CbPnau9H+a0ENULb9/TbwFVNB4yq6Vq0nwixYbgNQi+qiaxaPlIiYJYh3Sg4m3MHwc
         x6U+v6JCrcUXEpEkBoIb3xTUzX/xqk1BWMdU9txxX5N6hhlj45TxrFTTZ0UdBNTMIj9h
         MqF5Drngl01PLMMNbBrVoVhExNfVYGBqYprekLT8aZhC5KteG0V0luVfYv3dUmulbLRV
         t9cVtacxit4cY2Hn+vOqoi+Im/EnrXWcwHl1Px78Fbt5VB3H9fMldyTxb6nprW+TAgjF
         guIL07IE6GD8UT2xSB8y2kgvemke4oxgIO+5DZkOC9vR/yN9Y2yj9NMkofCgzwJtoOAQ
         +AAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681925270; x=1684517270;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VSZeMMc6hzF+JDcspidfOiGlvqJnHklFW5N/Px2xg6w=;
        b=bJpCp5FrpQbVR0jKmvZRHYq6UrUVHsKRlbESMCGpEujqPUJ9UpgJ4tIttTaFSNf8p7
         UbPq/yaIlc1c+HiNtLVM5PmCE8UiVZMge13WAQyFe8jBe8s8I7y8oilLWWWgnYwHpv5C
         w5IYmIElvi9zVQ/UOnpEOQfh0MEhZ6mc3qDUx94RkQOeVW0KG5G9hfIwJTjkqV5XlDz7
         V9/mbyjpOC+Ovnkyi9Bo3SkX8PxW2iBBE8Z8a1he3T1s/JboxBmGmExqWc3Mp2sM3d6o
         r8kMKOUi7WTb1AOIKLJlAge9fpVIwyx5SlLh2jJHhqSMaYzHPFwVt43htxAoH9K23jPb
         dtRA==
X-Gm-Message-State: AAQBX9ckd6TJljzNZCy8yvWrNZs0it+Qv5Ht/gIBJdbSdYkkVtRKvNr4
        hPaUbdJfnxJKfObSdJw4ljEnA5/z5b4UN25uhnLZ5/Wh
X-Google-Smtp-Source: AKy350YBcVdJy2Nk4rHQPiqQoBWfOpMciM3tKIdESwcLo2h9m8zMH6NXG+YuzBMymVLk8koR1rukqg==
X-Received: by 2002:a17:90b:4c8e:b0:23f:9448:89c2 with SMTP id my14-20020a17090b4c8e00b0023f944889c2mr3692326pjb.7.1681925270022;
        Wed, 19 Apr 2023 10:27:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lk6-20020a17090b33c600b0024702e5dda0sm1649161pjb.39.2023.04.19.10.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 10:27:49 -0700 (PDT)
Message-ID: <64402495.170a0220.df6bc.388a@mx.google.com>
Date:   Wed, 19 Apr 2023 10:27:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-293-gbda27f73d6bb8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 7 regressions (v5.10.176-293-gbda27f73d6bb8)
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

stable-rc/queue/5.10 baseline: 172 runs, 7 regressions (v5.10.176-293-gbda2=
7f73d6bb8)

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

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-293-gbda27f73d6bb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-293-gbda27f73d6bb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bda27f73d6bb895e0aeb7774edd4836660f4bda6 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff0e1b6c32fc8ff2e863a

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff0e1b6c32fc8ff2e866d
        failing since 64 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-19T13:47:00.859179  <8>[   20.529930] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 354297_1.5.2.4.1>
    2023-04-19T13:47:00.967371  / # #
    2023-04-19T13:47:01.070424  export SHELL=3D/bin/sh
    2023-04-19T13:47:01.070918  #
    2023-04-19T13:47:01.172824  / # export SHELL=3D/bin/sh. /lava-354297/en=
vironment
    2023-04-19T13:47:01.173394  =

    2023-04-19T13:47:01.275325  / # . /lava-354297/environment/lava-354297/=
bin/lava-test-runner /lava-354297/1
    2023-04-19T13:47:01.276096  =

    2023-04-19T13:47:01.280831  / # /lava-354297/bin/lava-test-runner /lava=
-354297/1
    2023-04-19T13:47:01.376571  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff23ee040fdccf62e85f6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff23ee040fdccf62e85fb
        failing since 83 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-19T13:52:46.687490  <8>[   11.008919] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3512330_1.5.2.4.1>
    2023-04-19T13:52:46.796669  / # #
    2023-04-19T13:52:46.899830  export SHELL=3D/bin/sh
    2023-04-19T13:52:46.900667  #
    2023-04-19T13:52:47.002275  / # export SHELL=3D/bin/sh. /lava-3512330/e=
nvironment
    2023-04-19T13:52:47.002679  =

    2023-04-19T13:52:47.103826  / # . /lava-3512330/environment/lava-351233=
0/bin/lava-test-runner /lava-3512330/1
    2023-04-19T13:52:47.104547  =

    2023-04-19T13:52:47.109983  / # /lava-3512330/bin/lava-test-runner /lav=
a-3512330/1
    2023-04-19T13:52:47.127332  <3>[   11.450895] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff2b9db070a1d5c2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff2b9db070a1d5c2e85eb
        failing since 20 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-19T13:54:49.512453  + set +x

    2023-04-19T13:54:49.518927  <8>[    8.141971] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10046964_1.4.2.3.1>

    2023-04-19T13:54:49.627379  / # #

    2023-04-19T13:54:49.730051  export SHELL=3D/bin/sh

    2023-04-19T13:54:49.730402  #

    2023-04-19T13:54:49.831658  / # export SHELL=3D/bin/sh. /lava-10046964/=
environment

    2023-04-19T13:54:49.832318  =


    2023-04-19T13:54:49.934166  / # . /lava-10046964/environment/lava-10046=
964/bin/lava-test-runner /lava-10046964/1

    2023-04-19T13:54:49.935538  =


    2023-04-19T13:54:49.940123  / # /lava-10046964/bin/lava-test-runner /la=
va-10046964/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff20976cd29de462e867f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff20976cd29de462e8684
        failing since 20 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-19T13:51:48.412508  <8>[   11.297142] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10047034_1.4.2.3.1>

    2023-04-19T13:51:48.415996  + set +x

    2023-04-19T13:51:48.520985  / # #

    2023-04-19T13:51:48.621994  export SHELL=3D/bin/sh

    2023-04-19T13:51:48.622206  #

    2023-04-19T13:51:48.723096  / # export SHELL=3D/bin/sh. /lava-10047034/=
environment

    2023-04-19T13:51:48.723272  =


    2023-04-19T13:51:48.824043  / # . /lava-10047034/environment/lava-10047=
034/bin/lava-test-runner /lava-10047034/1

    2023-04-19T13:51:48.824365  =


    2023-04-19T13:51:48.828925  / # /lava-10047034/bin/lava-test-runner /la=
va-10047034/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643ff4620d31c01e1d2e8615

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643ff4620d31c01e1d2e861b
        failing since 36 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-19T14:01:59.815576  /lava-10047103/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643ff4620d31c01e1d2e861c
        failing since 36 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-19T14:01:58.780277  /lava-10047103/1/../bin/lava-test-case

    2023-04-19T14:01:58.791583  <8>[   33.965025] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643ff22767679606192e85e7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-gbda27f73d6bb8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ff22767679606192e85ec
        failing since 76 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-19T13:52:02.646293  <8>[    8.463619] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3512331_1.5.2.4.1>
    2023-04-19T13:52:02.764476  / # #
    2023-04-19T13:52:02.866310  export SHELL=3D/bin/sh
    2023-04-19T13:52:02.866807  #
    2023-04-19T13:52:02.968151  / # export SHELL=3D/bin/sh. /lava-3512331/e=
nvironment
    2023-04-19T13:52:02.968673  =

    2023-04-19T13:52:03.069850  / # . /lava-3512331/environment/lava-351233=
1/bin/lava-test-runner /lava-3512331/1
    2023-04-19T13:52:03.070633  =

    2023-04-19T13:52:03.076998  / # /lava-3512331/bin/lava-test-runner /lav=
a-3512331/1
    2023-04-19T13:52:03.141151  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
