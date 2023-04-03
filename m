Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC96D4D93
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 18:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjDCQZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 12:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDCQY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 12:24:59 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48FF1FD3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:24:31 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id w4so28536843plg.9
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 09:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680539071;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7Fm66FadEjEuKgAD2RKPz02KVp54f2ydkcjV8f67thU=;
        b=yOwjlH+NIZAnuqWqJ022x1K1DcCcAJw3wJmeMKwoX9Mcv0jloN0kg21F9dxzEfJs7r
         WP3ev/U4bvwyFqLbRv0VaF6XLFOQYwjCd2IgeBX4BMfDPiMIxwOSzsPgLm+pVU3dTvZZ
         FiprRF+2VI4OrWhNbJ5P4qGjR2gLoqk1jdJL3I9jqQh95hGHhSWGXr0q/sDMnbUv9up3
         v/wz9bquNiB7oiHno7rDX9V5qveOXMLU13EZRczy6fpeYxc7egBT9V5gDQwzIZTc/6wy
         4JwK0smGBzM2pszykd/I7ODiNr8QnFKItk6vO10HO2ov1RE8xSYCP9Qj+krVau+EKWft
         WqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539071;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Fm66FadEjEuKgAD2RKPz02KVp54f2ydkcjV8f67thU=;
        b=li1byqzox9BZ4KK3myNhiSnegCfANZPQytgX7yB/7zXoz6LJ4MJWeMUIWeIAzcubnk
         pYE5nQy9LuwEcv7XbXpEB54cewbOY/NaUdjl7vFSzEKLKsYRRS5fsR3dAoKXoQPkudn6
         NP1hzElpO/F+G81V+1JLAjbkXvB3WU2IL8kQ8ZiHUyb+j0oli+S6Pi9MoSJx2F4+NQQE
         f0YbUr2rx/dDkA9xpk823cMMJloO2ss3HGkzLiKx++BzkAJUT3brt0gYE1bqprmS1rxH
         qbWp8sBfeb/ReX4CBGW+irBzxsNROZijXLnGCcetl/ZHFJJ4WcLi2zZRJZvdlmsjAQ8Z
         3SYw==
X-Gm-Message-State: AAQBX9chzUPZdbXBEso8EpiIeuxS8inpaMyoWR7vTaERPjVcIhQTz4Qm
        Ds2s/B/0ry3XI/9V0X9fDJ9wkNwzSt+vXuJHxPh55g==
X-Google-Smtp-Source: AKy350aWGSMTsq/kHlhzVnk2413qUoZBu+QuNDDumhQ4zAjXrfEV3AQmBd+2AbqhYQkaS+NGyjSIlg==
X-Received: by 2002:a05:6a20:7f56:b0:d9:63c3:e298 with SMTP id e22-20020a056a207f5600b000d963c3e298mr18760321pzk.10.1680539070824;
        Mon, 03 Apr 2023 09:24:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d26-20020aa7815a000000b0062608a7557fsm7190849pfn.75.2023.04.03.09.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 09:24:30 -0700 (PDT)
Message-ID: <642afdbe.a70a0220.7d3a3.d66f@mx.google.com>
Date:   Mon, 03 Apr 2023 09:24:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-164-g4296d0f5e624b
Subject: stable-rc/linux-5.10.y baseline: 171 runs,
 7 regressions (v5.10.176-164-g4296d0f5e624b)
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

stable-rc/linux-5.10.y baseline: 171 runs, 7 regressions (v5.10.176-164-g42=
96d0f5e624b)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176-164-g4296d0f5e624b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-164-g4296d0f5e624b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4296d0f5e624b087028399edee642828ce87bb1b =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642acc441ba2221ac362f7c6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642acc441ba2221ac362f7cb
        failing since 75 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-04-03T12:53:10.013404  <8>[   11.098066] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3467604_1.5.2.4.1>
    2023-04-03T12:53:10.119900  / # #
    2023-04-03T12:53:10.223935  export SHELL=3D/bin/sh
    2023-04-03T12:53:10.224964  #
    2023-04-03T12:53:10.327328  / # export SHELL=3D/bin/sh. /lava-3467604/e=
nvironment
    2023-04-03T12:53:10.328340  =

    2023-04-03T12:53:10.430743  / # . /lava-3467604/environment/lava-346760=
4/bin/lava-test-runner /lava-3467604/1
    2023-04-03T12:53:10.432228  =

    2023-04-03T12:53:10.436864  / # /lava-3467604/bin/lava-test-runner /lav=
a-3467604/1
    2023-04-03T12:53:10.445946  <3>[   11.531847] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/642acb7bd55e8ebf6e62f7b1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-r=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642acb7bd55e8ebf6e62f7b4
        failing since 30 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-04-03T12:49:29.415028  [   14.065331] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1193676_1.5.2.4.1>
    2023-04-03T12:49:29.519553  / # #
    2023-04-03T12:49:29.620798  export SHELL=3D/bin/sh
    2023-04-03T12:49:29.621351  #
    2023-04-03T12:49:29.722753  / # export SHELL=3D/bin/sh. /lava-1193676/e=
nvironment
    2023-04-03T12:49:29.723560  =

    2023-04-03T12:49:29.825275  / # . /lava-1193676/environment/lava-119367=
6/bin/lava-test-runner /lava-1193676/1
    2023-04-03T12:49:29.826143  =

    2023-04-03T12:49:29.827888  / # /lava-1193676/bin/lava-test-runner /lav=
a-1193676/1
    2023-04-03T12:49:29.844578  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642accd2645d8beec162f7a4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642accd2645d8beec162f7a9
        failing since 5 days (last pass: v5.10.176, first fail: v5.10.176-1=
05-g18265b240021)

    2023-04-03T12:55:35.047783  + <8>[   14.481763] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9850460_1.4.2.3.1>

    2023-04-03T12:55:35.051277  set +x

    2023-04-03T12:55:35.152709  /#

    2023-04-03T12:55:35.253909   # #export SHELL=3D/bin/sh

    2023-04-03T12:55:35.254120  =


    2023-04-03T12:55:35.355002  / # export SHELL=3D/bin/sh. /lava-9850460/e=
nvironment

    2023-04-03T12:55:35.355236  =


    2023-04-03T12:55:35.456142  / # . /lava-9850460/environment/lava-985046=
0/bin/lava-test-runner /lava-9850460/1

    2023-04-03T12:55:35.456441  =


    2023-04-03T12:55:35.460721  / # /lava-9850460/bin/lava-test-runner /lav=
a-9850460/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642accce02037f1d9462f76c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642accce02037f1d9462f771
        failing since 5 days (last pass: v5.10.176, first fail: v5.10.176-1=
05-g18265b240021)

    2023-04-03T12:55:29.282835  <8>[   13.102506] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9850320_1.4.2.3.1>

    2023-04-03T12:55:29.285612  + set +x

    2023-04-03T12:55:29.387765  =


    2023-04-03T12:55:29.488786  / # #export SHELL=3D/bin/sh

    2023-04-03T12:55:29.488999  =


    2023-04-03T12:55:29.589868  / # export SHELL=3D/bin/sh. /lava-9850320/e=
nvironment

    2023-04-03T12:55:29.590109  =


    2023-04-03T12:55:29.691010  / # . /lava-9850320/environment/lava-985032=
0/bin/lava-test-runner /lava-9850320/1

    2023-04-03T12:55:29.691304  =


    2023-04-03T12:55:29.696292  / # /lava-9850320/bin/lava-test-runner /lav=
a-9850320/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ac9e919067a495562f792

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642ac9e919067a495562f=
793
        failing since 11 days (last pass: v5.10.175-100-g1686e1df6521, firs=
t fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642acbcae210b59f7d62f793

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-164-g4296d0f5e624b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642acbcae210b59f7d62f799
        failing since 20 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-03T12:51:15.364802  /lava-9850248/1/../bin/lava-test-case

    2023-04-03T12:51:15.376136  <8>[   35.213179] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642acbcae210b59f7d62f79a
        failing since 20 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-03T12:51:13.306177  <8>[   33.140579] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-03T12:51:14.328330  /lava-9850248/1/../bin/lava-test-case

    2023-04-03T12:51:14.338903  <8>[   34.176082] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
