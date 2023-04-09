Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53686DC12C
	for <lists+stable@lfdr.de>; Sun,  9 Apr 2023 21:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDITQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Apr 2023 15:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDITQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Apr 2023 15:16:55 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31412698
        for <stable@vger.kernel.org>; Sun,  9 Apr 2023 12:16:53 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a25c4e26afso6866825ad.1
        for <stable@vger.kernel.org>; Sun, 09 Apr 2023 12:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681067813; x=1683659813;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c+j54L/Lu4qrlOaDDGISVEcij9dhLD0U0BlulFrmwxU=;
        b=gjf8/L8Io3/Pw/nPNUyuRV7NR5M3pnPWekZMKDi25KkuPunPAVUAxjZMEQaiGWzTNh
         J+SulgBH5CzwjhQU5oxnGagm5QDZg+jtJbyCjwTFhuOQz32i2kqFPU6DWJT6vaxv5SiK
         F+Jyh3JjjmbnKZM/+myy51rydxhaya7lOVB54Ifz/Lclb1wgT7oF2TdItV0sq/JiQ/4o
         l5xnlJOB4upeNv7mAkACltYT0sf4jzAIP94GJa9eaDwF2vbhicrOvPYyimetRUlfuSWe
         L9vvFyhGtpjui0pbE+Ms0BNWXoXfSMfuMOlowzCU2SUkS24Pv42+ENot4K72jz/Taw5V
         +Rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681067813; x=1683659813;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c+j54L/Lu4qrlOaDDGISVEcij9dhLD0U0BlulFrmwxU=;
        b=KEpoWn/b9JEhBljn48Jct2MhwavWsPOtmebVxQ9lixo8NNeSDLvGqiC+vCrgMeSc4L
         IPZamgdx2VSdvde0pcbRbzto5gtIALYJYDXn6PQ99lrcbBFYkQOtJ7973BCLkpXCviPI
         sFmVgiIdKcqU97ZYgDNfsRgB2niFpom1ELAI1wUhHLf1/zKRrXoKz7Irvwnn243QBeZF
         JD0TMpI6sMMtt6P1ck6iKKrnCW1K3LXMNOR6Ls0DPLN9qyikfjC6l3/vfCnG+4SDyLpe
         fGhZcOp/gv0WMTWz6AW6t8IsluJkLDOsURtG3bICTY9U1Z/Y+o2FqZYU6e6yIEgYOE6C
         pBjw==
X-Gm-Message-State: AAQBX9cf9ojs5VE9WZBaqnoUaE+rIcSGastvrTMFrC9q6VZ7DLxNHTSe
        dXUV8expjSHB9sS2kq5YgOFRk2m5nRLk1F0HWF8=
X-Google-Smtp-Source: AKy350a4Z0mT8Nf3exgQkJIFt7eQCdvB13Ti1hqKgktqLbF8VKhpp+MaWI7S7Ia1LpYtu0BcmuIhWg==
X-Received: by 2002:aa7:956d:0:b0:5a8:aca5:817d with SMTP id x13-20020aa7956d000000b005a8aca5817dmr6583262pfq.5.1681067812726;
        Sun, 09 Apr 2023 12:16:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c12-20020aa78e0c000000b0062b5a55835dsm6399533pfr.213.2023.04.09.12.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Apr 2023 12:16:52 -0700 (PDT)
Message-ID: <64330f24.a70a0220.9399a.be95@mx.google.com>
Date:   Sun, 09 Apr 2023 12:16:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-191-g3d699b00964b
Subject: stable-rc/queue/5.10 baseline: 170 runs,
 7 regressions (v5.10.176-191-g3d699b00964b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 170 runs, 7 regressions (v5.10.176-191-g3d69=
9b00964b)

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
nel/v5.10.176-191-g3d699b00964b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-191-g3d699b00964b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3d699b00964b2c3b5431a93611df3ea1aea5502b =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6432dcfa30ee2a450479e971

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432dcfa30ee2a450479e9ab
        failing since 54 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-09T15:42:34.730514  + set +x
    2023-04-09T15:42:34.734422  <8>[   19.761358] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 303058_1.5.2.4.1>
    2023-04-09T15:42:34.846590  / # #
    2023-04-09T15:42:34.949861  export SHELL=3D/bin/sh
    2023-04-09T15:42:34.950649  #
    2023-04-09T15:42:35.052565  / # export SHELL=3D/bin/sh. /lava-303058/en=
vironment
    2023-04-09T15:42:35.053564  =

    2023-04-09T15:42:35.155602  / # . /lava-303058/environment/lava-303058/=
bin/lava-test-runner /lava-303058/1
    2023-04-09T15:42:35.156535  =

    2023-04-09T15:42:35.160118  / # /lava-303058/bin/lava-test-runner /lava=
-303058/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6432dd79a9da6afa4e79e97f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432dd79a9da6afa4e79e988
        failing since 73 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-09T15:44:39.017299  <8>[   11.119858] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3481234_1.5.2.4.1>
    2023-04-09T15:44:39.125860  / # #
    2023-04-09T15:44:39.227356  export SHELL=3D/bin/sh
    2023-04-09T15:44:39.228265  #
    2023-04-09T15:44:39.330185  / # export SHELL=3D/bin/sh. /lava-3481234/e=
nvironment
    2023-04-09T15:44:39.330942  =

    2023-04-09T15:44:39.432717  / # . /lava-3481234/environment/lava-348123=
4/bin/lava-test-runner /lava-3481234/1
    2023-04-09T15:44:39.433922  =

    2023-04-09T15:44:39.438898  / # /lava-3481234/bin/lava-test-runner /lav=
a-3481234/1
    2023-04-09T15:44:39.508814  <3>[   11.611665] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d8e9b49ff26a4179e97c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d8e9b49ff26a4179e985
        failing since 10 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-09T15:25:21.618312  + set +x

    2023-04-09T15:25:21.625196  <8>[   14.107640] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9920871_1.4.2.3.1>

    2023-04-09T15:25:21.730462  / # #

    2023-04-09T15:25:21.831547  export SHELL=3D/bin/sh

    2023-04-09T15:25:21.831757  #

    2023-04-09T15:25:21.932616  / # export SHELL=3D/bin/sh. /lava-9920871/e=
nvironment

    2023-04-09T15:25:21.932799  =


    2023-04-09T15:25:22.033698  / # . /lava-9920871/environment/lava-992087=
1/bin/lava-test-runner /lava-9920871/1

    2023-04-09T15:25:22.033994  =


    2023-04-09T15:25:22.038809  / # /lava-9920871/bin/lava-test-runner /lav=
a-9920871/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6432d8dfb49ff26a4179e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432d8dfb49ff26a4179e92b
        failing since 10 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-09T15:25:04.249829  <8>[   12.357341] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9920927_1.4.2.3.1>

    2023-04-09T15:25:04.253675  + set +x

    2023-04-09T15:25:04.358497  #

    2023-04-09T15:25:04.358763  =


    2023-04-09T15:25:04.459809  / # #export SHELL=3D/bin/sh

    2023-04-09T15:25:04.460037  =


    2023-04-09T15:25:04.561004  / # export SHELL=3D/bin/sh. /lava-9920927/e=
nvironment

    2023-04-09T15:25:04.561226  =


    2023-04-09T15:25:04.662211  / # . /lava-9920927/environment/lava-992092=
7/bin/lava-test-runner /lava-9920927/1

    2023-04-09T15:25:04.662525  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6432de47f7be4b9f1f79e942

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6432de47f7be4b9f1f79e94c
        failing since 26 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-09T15:48:12.831232  /lava-9920981/1/../bin/lava-test-case

    2023-04-09T15:48:12.841985  <8>[   34.948337] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6432de47f7be4b9f1f79e94d
        failing since 26 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-09T15:48:11.793158  /lava-9920981/1/../bin/lava-test-case

    2023-04-09T15:48:11.804129  <8>[   33.910846] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6432dd605f71e0c29d79e947

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-191-g3d699b00964b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6432dd605f71e0c29d79e950
        failing since 66 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-09T15:44:04.088107  / # #
    2023-04-09T15:44:04.189802  export SHELL=3D/bin/sh
    2023-04-09T15:44:04.190154  #
    2023-04-09T15:44:04.291470  / # export SHELL=3D/bin/sh. /lava-3481227/e=
nvironment
    2023-04-09T15:44:04.291832  =

    2023-04-09T15:44:04.393186  / # . /lava-3481227/environment/lava-348122=
7/bin/lava-test-runner /lava-3481227/1
    2023-04-09T15:44:04.393825  =

    2023-04-09T15:44:04.399558  / # /lava-3481227/bin/lava-test-runner /lav=
a-3481227/1
    2023-04-09T15:44:04.497465  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-09T15:44:04.498078  + cd /lava-3481227/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
