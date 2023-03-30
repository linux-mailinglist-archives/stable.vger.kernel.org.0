Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BB76D083A
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 16:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjC3O0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 10:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjC3O0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 10:26:42 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D06AC
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 07:26:41 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q206so11417846pgq.9
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 07:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680186400;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lI2AxG1lfXweUpW3HDlbPnojsGtcDYQOXu7MS2LuaM4=;
        b=RLyODElT6vbdvqSqF03e3+Fllah458vfzmgpgr/18EDx2+5CKiXus+aG79/rWgPd2H
         xlnG9f7Ia5mhqSl4Ed/8TOCwen/sV69GQWWhHNXL0yfOyBjF3v1PI2oLWOXSEDOblRSW
         2k7q9zp96uq2ADSnigum64LqgMsoZMIr8AfNhgWIPr85H/uU+MKGVtLLWScW0ct6VACg
         tHRWIZfOz46lhb6xfsQN2aQVas2p4lbJ1i7I8MmCZlGC31vbagbwIEG/AC5xIu/KmfbF
         Z20Oa70OqubeaRN8h7VetSBjU8x0TSE5zQ+4VBhN7YfdOEYOGfARFRgy4PvusZWvS6Hl
         +BVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680186400;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lI2AxG1lfXweUpW3HDlbPnojsGtcDYQOXu7MS2LuaM4=;
        b=jJhfMhdTpX7IaXrI5LvWfyD6BCxt74EKoYDs7yp7qEmf6O6RJwMuAUNYpjFrSEOrwl
         p63WpUR/kvAvXqLO3nciwY6V31fq79VFBloH7X6HnrBLjZI4IDyvHG37gFUFW3Sl0Czh
         BHglO2TIaoLRgBZT+n6NySTJALcLFGnDZ+cLkytgnjD1f/xbwdeOAzY5siGI/J6UdILw
         j8ZF0L7WR5yXeegAJZ9y1xH6RSOJVoS/2Q8P+CqIj3cCWZCYnFgI/rmYpjR8cWsjYEC4
         8pzZL79uTRqtJZ7WHlpx4R8av90yV9nyWQB3vh6rdX9oqn8B9pNhsAIMZuTzCXTeu988
         oYuw==
X-Gm-Message-State: AAQBX9fBQDpo0nGde9XVFpbm2L/+0xStcTiR4gTrUroEM28NQedR7hiZ
        p/Ce5QQM1JRzux4Boa2HgZBnzYOeiUHgbPtMxG8L2Q==
X-Google-Smtp-Source: AKy350b4TUH2VxqxAAOSU83roUMuiMSE0iaVeohMmxNPnanGajV33poTi26Mw/idwHkkceOXgE09cA==
X-Received: by 2002:a62:585:0:b0:627:ea74:3484 with SMTP id 127-20020a620585000000b00627ea743484mr20790728pff.22.1680186400121;
        Thu, 30 Mar 2023 07:26:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i16-20020aa78d90000000b0062dcf5c01f9sm1206595pfr.36.2023.03.30.07.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:26:39 -0700 (PDT)
Message-ID: <64259c1f.a70a0220.4323d.1ea3@mx.google.com>
Date:   Thu, 30 Mar 2023 07:26:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-104-g2b4187983740
Subject: stable-rc/queue/5.10 baseline: 173 runs,
 7 regressions (v5.10.176-104-g2b4187983740)
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

stable-rc/queue/5.10 baseline: 173 runs, 7 regressions (v5.10.176-104-g2b41=
87983740)

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
nel/v5.10.176-104-g2b4187983740/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-104-g2b4187983740
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2b4187983740fc5b2a1920e44249da0d8a5babcd =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64256563deb0bb87ca62f7b3

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64256563deb0bb87ca62f7e9
        failing since 44 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-30T10:32:39.677841  <8>[   15.849635] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 248326_1.5.2.4.1>
    2023-03-30T10:32:39.822442  / # #
    2023-03-30T10:32:39.936652  export SHELL=3D/bin/sh
    2023-03-30T10:32:39.941024  #
    2023-03-30T10:32:40.048430  / # export SHELL=3D/bin/sh. /lava-248326/en=
vironment
    2023-03-30T10:32:40.052798  =

    2023-03-30T10:32:40.162473  / # . /lava-248326/environment/lava-248326/=
bin/lava-test-runner /lava-248326/1
    2023-03-30T10:32:40.174599  =

    2023-03-30T10:32:40.178734  / # /lava-248326/bin/lava-test-runner /lava=
-248326/1
    2023-03-30T10:32:40.279608  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6425641f71f7a3444b62f76c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425641f71f7a3444b62f76f
        failing since 62 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-30T10:27:18.717284  + set +x<8>[   11.106446] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3454757_1.5.2.4.1>
    2023-03-30T10:27:18.717821  =

    2023-03-30T10:27:18.827250  / # #
    2023-03-30T10:27:18.930693  export SHELL=3D/bin/sh
    2023-03-30T10:27:18.931713  #
    2023-03-30T10:27:19.033770  / # export SHELL=3D/bin/sh. /lava-3454757/e=
nvironment
    2023-03-30T10:27:19.034834  =

    2023-03-30T10:27:19.136933  / # . /lava-3454757/environment/lava-345475=
7/bin/lava-test-runner /lava-3454757/1
    2023-03-30T10:27:19.138780  =

    2023-03-30T10:27:19.139864  / # /lava-3454757/bin/lava-test-runner /lav=
a-3454757/1<3>[   11.530965] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425636b0000db1b1562f7ac

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425636b0000db1b1562f7b1
        new failure (last pass: v5.10.176-61-g2332301f1fab4)

    2023-03-30T10:24:33.020461  + <8>[   10.222232] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9813511_1.4.2.3.1>

    2023-03-30T10:24:33.020619  set +x

    2023-03-30T10:24:33.122683  #

    2023-03-30T10:24:33.122995  =


    2023-03-30T10:24:33.223724  / # #export SHELL=3D/bin/sh

    2023-03-30T10:24:33.223954  =


    2023-03-30T10:24:33.324903  / # export SHELL=3D/bin/sh. /lava-9813511/e=
nvironment

    2023-03-30T10:24:33.325129  =


    2023-03-30T10:24:33.426069  / # . /lava-9813511/environment/lava-981351=
1/bin/lava-test-runner /lava-9813511/1

    2023-03-30T10:24:33.426380  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425636d0000db1b1562f7b9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425636d0000db1b1562f7be
        new failure (last pass: v5.10.176-61-g2332301f1fab4)

    2023-03-30T10:24:31.705922  + set +x<8>[   12.614834] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9813475_1.4.2.3.1>

    2023-03-30T10:24:31.706013  =


    2023-03-30T10:24:31.808051  /#

    2023-03-30T10:24:31.909299   # #export SHELL=3D/bin/sh

    2023-03-30T10:24:31.909504  =


    2023-03-30T10:24:32.010434  / # export SHELL=3D/bin/sh. /lava-9813475/e=
nvironment

    2023-03-30T10:24:32.010640  =


    2023-03-30T10:24:32.111566  / # . /lava-9813475/environment/lava-981347=
5/bin/lava-test-runner /lava-9813475/1

    2023-03-30T10:24:32.111861  =


    2023-03-30T10:24:32.116803  / # /lava-9813475/bin/lava-test-runner /lav=
a-9813475/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642566fde0c99e061b62f76c

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642566fde0c99e061b62f772
        failing since 16 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-30T10:39:48.887498  /lava-9813646/1/../bin/lava-test-case

    2023-03-30T10:39:48.899013  <8>[   35.238516] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642566fde0c99e061b62f773
        failing since 16 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-30T10:39:47.850464  /lava-9813646/1/../bin/lava-test-case

    2023-03-30T10:39:47.861692  <8>[   34.201615] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642563dc303769025162f781

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-104-g2b4187983740/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642563dc303769025162f786
        failing since 56 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-30T10:26:19.278324  / # #
    2023-03-30T10:26:19.380105  export SHELL=3D/bin/sh
    2023-03-30T10:26:19.380556  #
    2023-03-30T10:26:19.481902  / # export SHELL=3D/bin/sh. /lava-3454758/e=
nvironment
    2023-03-30T10:26:19.482400  =

    2023-03-30T10:26:19.583793  / # . /lava-3454758/environment/lava-345475=
8/bin/lava-test-runner /lava-3454758/1
    2023-03-30T10:26:19.584558  =

    2023-03-30T10:26:19.589477  / # /lava-3454758/bin/lava-test-runner /lav=
a-3454758/1
    2023-03-30T10:26:19.688404  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-30T10:26:19.688999  + cd /lava-3454758/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
