Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764816D2C20
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 02:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjDAAjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 20:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjDAAjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 20:39:48 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D7A1A463
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:39:47 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id kq3so22872285plb.13
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 17:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680309586;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=V2o5LkOTPNsxkhmrD5SyCYDhppU7dMffYmS/rcbIxWQ=;
        b=HD4H0vVduwXR55r30IY014twVhznAkIRt+yo84ZoYg9qWm0QTIWRExDw4ixYdQmh6I
         VruCtFsx3sl/M4SwnLRk4b/UXrGQ/vzuggerJrHhWoDND4hJklFpt7FEMY1IDOPm+pAi
         uMwQd2ietcJPLj+1pTcXiQoAllcjUIbjFQdIZYBO4xTDy0f3EWiC0ZOsMp/84qgmxu5G
         p6HEX1eC2lcZPnLOmTqXhKt2COc+pTdtUZlaVZ16/rC58z+o6EH1Zynrq7z9SrVqFAJp
         4OJpoLSe8sZzsPTzbxCG1OfW1ELknJaPuesuwB68j2mZ6UwiDqafQsB9zauiFuT0yb0r
         CY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680309586;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V2o5LkOTPNsxkhmrD5SyCYDhppU7dMffYmS/rcbIxWQ=;
        b=H81MBqX62U/kxjybDpUPpDDQ3kESHmxzVmQ3WpKykB3YkJr9llVn6m45l88q4iKk92
         lwJOEj5CGTdnmvBy9MCYQU3+LAgF0MWA/Z3FcK638vw9o8nDWGDuKAfhKAzSCLUV0cwF
         BdW4Qgb7itBWmzHNj3te69RHEuDEVoVEQuCTS1HP3tAvKL+eQZgCoxSjXynJDa5hTCSQ
         KY0cXS05LYcp9eTn1Ah29WFZwFDQwHHRgNmlj1Arrt2YGFpBFJRexEk9nM2Snv+51hiz
         vMd5P5cVRfW5GLPvMdgFLbz5WVaCmpafx3iO+KS39uySFCnjf6cMZh5GAa9T8lPiVQs+
         xeUA==
X-Gm-Message-State: AAQBX9dXyR2FnDZH9iSse4oGRQ9UGAQXjRhuVdRihNPNqtHQNrNnD5+Y
        RPzxYw0DUX7h2BNuztmO7sDcLr1Ns7AyeKlrSzu25g==
X-Google-Smtp-Source: AKy350ZrC9UBUkpMO7LfnKiNMO3LDDgQ53OYvFeH7iILtsJNkcx1QMeOTuchC+aceagSMOPEwrABzQ==
X-Received: by 2002:a17:902:da8a:b0:1a2:89eb:3d1a with SMTP id j10-20020a170902da8a00b001a289eb3d1amr8267808plx.6.1680309586576;
        Fri, 31 Mar 2023 17:39:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id az3-20020a170902a58300b001a281063ab4sm2109056plb.233.2023.03.31.17.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 17:39:46 -0700 (PDT)
Message-ID: <64277d52.170a0220.85086.53f8@mx.google.com>
Date:   Fri, 31 Mar 2023 17:39:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-124-gb6fdd5aa4004
Subject: stable-rc/queue/5.10 baseline: 175 runs,
 8 regressions (v5.10.176-124-gb6fdd5aa4004)
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

stable-rc/queue/5.10 baseline: 175 runs, 8 regressions (v5.10.176-124-gb6fd=
d5aa4004)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-124-gb6fdd5aa4004/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-124-gb6fdd5aa4004
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b6fdd5aa40046f30a55663bdcb2b676abae6ae3b =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64274d9d9d0f598ea962f76c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64274d9d9d0f598ea962f=
76d
        new failure (last pass: v5.10.176-124-gb73d9f9b7024) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64274b2318406bcb9b62f79f

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64274b2318406bcb9b62f7c8
        failing since 45 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-31T21:05:27.022582  <8>[   20.951822] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 260091_1.5.2.4.1>
    2023-03-31T21:05:27.131045  / # #
    2023-03-31T21:05:27.233602  export SHELL=3D/bin/sh
    2023-03-31T21:05:27.234233  #
    2023-03-31T21:05:27.336137  / # export SHELL=3D/bin/sh. /lava-260091/en=
vironment
    2023-03-31T21:05:27.337026  =

    2023-03-31T21:05:27.439200  / # . /lava-260091/environment/lava-260091/=
bin/lava-test-runner /lava-260091/1
    2023-03-31T21:05:27.440447  =

    2023-03-31T21:05:27.445089  / # /lava-260091/bin/lava-test-runner /lava=
-260091/1
    2023-03-31T21:05:27.539763  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64274cc7a93f896e0862f7ee

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64274cc7a93f896e0862f7f3
        failing since 64 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-31T21:12:11.605386  <8>[   11.139276] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3460173_1.5.2.4.1>
    2023-03-31T21:12:11.712555  / # #
    2023-03-31T21:12:11.814253  export SHELL=3D/bin/sh
    2023-03-31T21:12:11.814774  #
    2023-03-31T21:12:11.916005  / # export SHELL=3D/bin/sh. /lava-3460173/e=
nvironment
    2023-03-31T21:12:11.916442  =

    2023-03-31T21:12:12.017641  / # . /lava-3460173/environment/lava-346017=
3/bin/lava-test-runner /lava-3460173/1
    2023-03-31T21:12:12.018288  =

    2023-03-31T21:12:12.018471  / # /lava-3460173/bin/lava-test-runner /lav=
a-3460173/1<3>[   11.530943] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-03-31T21:12:12.023304   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642748d9b0ec85a87462f770

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642748d9b0ec85a87462f775
        failing since 1 day (last pass: v5.10.176-61-g2332301f1fab4, first =
fail: v5.10.176-104-g2b4187983740)

    2023-03-31T20:55:37.672288  + set +x

    2023-03-31T20:55:37.679084  <8>[   10.719884] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9835176_1.4.2.3.1>

    2023-03-31T20:55:37.783633  / # #

    2023-03-31T20:55:37.884541  export SHELL=3D/bin/sh

    2023-03-31T20:55:37.884748  #

    2023-03-31T20:55:37.985692  / # export SHELL=3D/bin/sh. /lava-9835176/e=
nvironment

    2023-03-31T20:55:37.985911  =


    2023-03-31T20:55:38.086910  / # . /lava-9835176/environment/lava-983517=
6/bin/lava-test-runner /lava-9835176/1

    2023-03-31T20:55:38.087236  =


    2023-03-31T20:55:38.091361  / # /lava-9835176/bin/lava-test-runner /lav=
a-9835176/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642748e3b0ec85a87462f863

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642748e3b0ec85a87462f868
        failing since 1 day (last pass: v5.10.176-61-g2332301f1fab4, first =
fail: v5.10.176-104-g2b4187983740)

    2023-03-31T20:55:52.133661  + set<8>[   13.030029] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9835191_1.4.2.3.1>

    2023-03-31T20:55:52.134090   +x

    2023-03-31T20:55:52.241195  /#

    2023-03-31T20:55:52.344120   # #export SHELL=3D/bin/sh

    2023-03-31T20:55:52.344846  =


    2023-03-31T20:55:52.446736  / # export SHELL=3D/bin/sh. /lava-9835191/e=
nvironment

    2023-03-31T20:55:52.447516  =


    2023-03-31T20:55:52.549576  / # . /lava-9835191/environment/lava-983519=
1/bin/lava-test-runner /lava-9835191/1

    2023-03-31T20:55:52.550864  =


    2023-03-31T20:55:52.556069  / # /lava-9835191/bin/lava-test-runner /lav=
a-9835191/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64274be76034f4ba9b62f813

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64274be76034f4ba9b62f819
        failing since 17 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-31T21:08:42.635503  /lava-9835236/1/../bin/lava-test-case

    2023-03-31T21:08:42.646585  <8>[   35.268633] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64274be76034f4ba9b62f81a
        failing since 17 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-31T21:08:41.598125  /lava-9835236/1/../bin/lava-test-case

    2023-03-31T21:08:41.609065  <8>[   34.231184] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64274c7a5d077aeda862f7d5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb6fdd5aa4004/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64274c7a5d077aeda862f7da
        failing since 58 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-31T21:11:03.438184  / # #
    2023-03-31T21:11:03.539866  export SHELL=3D/bin/sh
    2023-03-31T21:11:03.540216  #
    2023-03-31T21:11:03.641546  / # export SHELL=3D/bin/sh. /lava-3460164/e=
nvironment
    2023-03-31T21:11:03.641899  =

    2023-03-31T21:11:03.743240  / # . /lava-3460164/environment/lava-346016=
4/bin/lava-test-runner /lava-3460164/1
    2023-03-31T21:11:03.743856  =

    2023-03-31T21:11:03.749569  / # /lava-3460164/bin/lava-test-runner /lav=
a-3460164/1
    2023-03-31T21:11:03.847547  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-31T21:11:03.848076  + cd /lava-3460164/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
