Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881296D4BCD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjDCP0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 11:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjDCP0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:26:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D801FEA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:26:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l7so27548528pjg.5
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 08:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680535591;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4/MudlWidT4ecgrWhGQElMfV16A53vF6hGKSNXpghS4=;
        b=L2nw97+MQtd4T2nt6vXybclWCie/npIq/XX8XapgP+bXOgO5anwmYm7zy5hrDoAAGx
         PRLtoeuX/tMldNyQ9g2lOtIHXE0Wbh75KhEJc0nZMAi75RayeCtMLCj7JuaFB1/a95QV
         EZn+W5u8u5qN11QidWo6zmXojed3R19J5KrsfYQN6I2WLTAQI23nIQImpFzCk3zZQf4O
         2/GZHUNdM/UDFaqetzK5srb+z7lwKH/bzpYcmkJPshn4cOflYfNBoIJW1fj5inXSGLzC
         BRNjT9Ndpq55Gk+AgLEkMn0WJgQwLgifbL/xg4o1R6lL7xnNew9uxqx+6EJZQq2vC8/P
         NXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680535591;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4/MudlWidT4ecgrWhGQElMfV16A53vF6hGKSNXpghS4=;
        b=zSWaqxu4+9Gwn35DLPC4WRTbexezB3ex3MlOhMi5PHEgYIhHu6QUPeVqwi+6W4tWkd
         aEDGBPY70XYdKXVjratk+G/a/IU7tLLNAk0erT/K2EnLFli5cScdS0mSaoasFUQ6BWt8
         mGeoJBkuX9DBZv3reC4HGRmtnsbi1p0kckwb2BpoxSnhe8A6O5/o237uuYturL8aplTP
         ucHQelQX/R7I2He3DtibbmV7BXhwdrJoijwMiJV4e0euEf6zCIJ4mPf+fvxjFVq/tzLE
         npP81et+YPor+/yM+HwzeL74pCzhTZV+drZoIuJY7b/lbE0Lh/NMgKzTV4A/A/W4s/v6
         sWtA==
X-Gm-Message-State: AAQBX9fniv75YxgYvsfKfntuL+aGVTozSLgWcd7SAXfNWBDfRogpkfk3
        gaOf4XW7cOfIdSNaeJX7EWmbDOexs3SnDH35LAX5ag==
X-Google-Smtp-Source: AKy350Zy7DrJHA6fkVATtMh8ysGFONNpeh95zX2DVrhL6ayDXYieQAS7mlNxjiu9r8YCFM3dujswXw==
X-Received: by 2002:a05:6a20:65a1:b0:cc:5f8f:4f7a with SMTP id p33-20020a056a2065a100b000cc5f8f4f7amr20004694pzh.27.1680535590637;
        Mon, 03 Apr 2023 08:26:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y1-20020a056a001c8100b0062ddcad2cbesm7211020pfw.145.2023.04.03.08.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 08:26:30 -0700 (PDT)
Message-ID: <642af026.050a0220.13021.d74c@mx.google.com>
Date:   Mon, 03 Apr 2023 08:26:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-163-g5222940bc4fa
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 7 regressions (v5.10.176-163-g5222940bc4fa)
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

stable-rc/queue/5.10 baseline: 165 runs, 7 regressions (v5.10.176-163-g5222=
940bc4fa)

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
nel/v5.10.176-163-g5222940bc4fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-163-g5222940bc4fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5222940bc4faf44c352ceafcb14f6c6a5d731ff2 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642abd7b832c13d6dc62f797

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642abd7b832c13d6dc62f7cd
        failing since 48 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-03T11:50:03.642366  <8>[   20.125582] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 269222_1.5.2.4.1>
    2023-04-03T11:50:03.755263  / # #
    2023-04-03T11:50:03.858228  export SHELL=3D/bin/sh
    2023-04-03T11:50:03.859015  #
    2023-04-03T11:50:03.960868  / # export SHELL=3D/bin/sh. /lava-269222/en=
vironment
    2023-04-03T11:50:03.962042  =

    2023-04-03T11:50:04.064949  / # . /lava-269222/environment/lava-269222/=
bin/lava-test-runner /lava-269222/1
    2023-04-03T11:50:04.066778  =

    2023-04-03T11:50:04.070344  / # /lava-269222/bin/lava-test-runner /lava=
-269222/1
    2023-04-03T11:50:04.173986  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642abafa437db50d4662f783

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642abafa437db50d4662f788
        failing since 66 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-03T11:39:23.040043  <8>[   11.066274] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3467370_1.5.2.4.1>
    2023-04-03T11:39:23.149007  / # #
    2023-04-03T11:39:23.252744  export SHELL=3D/bin/sh
    2023-04-03T11:39:23.254088  #
    2023-04-03T11:39:23.356678  / # export SHELL=3D/bin/sh. /lava-3467370/e=
nvironment
    2023-04-03T11:39:23.357991  =

    2023-04-03T11:39:23.358647  / # . /lava-3467370/environment<3>[   11.37=
1565] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-03T11:39:23.461122  /lava-3467370/bin/lava-test-runner /lava-34=
67370/1
    2023-04-03T11:39:23.463157  =

    2023-04-03T11:39:23.468023  / # /lava-3467370/bin/lava-test-runner /lav=
a-3467370/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab8032d6bcdc85262f76c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab8032d6bcdc85262f771
        failing since 4 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-03T11:26:49.735786  + set +x

    2023-04-03T11:26:49.742365  <8>[   10.943644] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9849476_1.4.2.3.1>

    2023-04-03T11:26:49.847717  / # #

    2023-04-03T11:26:49.948791  export SHELL=3D/bin/sh

    2023-04-03T11:26:49.949026  #

    2023-04-03T11:26:50.049954  / # export SHELL=3D/bin/sh. /lava-9849476/e=
nvironment

    2023-04-03T11:26:50.050179  =


    2023-04-03T11:26:50.151069  / # . /lava-9849476/environment/lava-984947=
6/bin/lava-test-runner /lava-9849476/1

    2023-04-03T11:26:50.151451  =


    2023-04-03T11:26:50.156251  / # /lava-9849476/bin/lava-test-runner /lav=
a-9849476/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab80d0d91c3325062f7cb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab80d0d91c3325062f7d0
        failing since 4 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-03T11:26:48.384293  + set +x

    2023-04-03T11:26:48.391580  <8>[   12.302770] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9849514_1.4.2.3.1>

    2023-04-03T11:26:48.493624  #

    2023-04-03T11:26:48.493975  =


    2023-04-03T11:26:48.594995  / # #export SHELL=3D/bin/sh

    2023-04-03T11:26:48.595212  =


    2023-04-03T11:26:48.696113  / # export SHELL=3D/bin/sh. /lava-9849514/e=
nvironment

    2023-04-03T11:26:48.696305  =


    2023-04-03T11:26:48.797183  / # . /lava-9849514/environment/lava-984951=
4/bin/lava-test-runner /lava-9849514/1

    2023-04-03T11:26:48.797461  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642abf712ae5c630a662f787

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642abf712ae5c630a662f78d
        failing since 20 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-03T11:58:24.037157  <8>[   34.374322] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-03T11:58:25.063836  /lava-9849843/1/../bin/lava-test-case

    2023-04-03T11:58:25.074432  <8>[   35.411382] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642abf712ae5c630a662f78e
        failing since 20 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-03T11:58:24.025425  /lava-9849843/1/../bin/lava-test-case
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642abae9f527e45e1962f7dd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-163-g5222940bc4fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642abae9f527e45e1962f7e2
        failing since 60 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-03T11:39:02.979457  / # #
    2023-04-03T11:39:03.081531  export SHELL=3D/bin/sh
    2023-04-03T11:39:03.082068  #
    2023-04-03T11:39:03.183429  / # export SHELL=3D/bin/sh. /lava-3467374/e=
nvironment
    2023-04-03T11:39:03.183962  =

    2023-04-03T11:39:03.285417  / # . /lava-3467374/environment/lava-346737=
4/bin/lava-test-runner /lava-3467374/1
    2023-04-03T11:39:03.286215  =

    2023-04-03T11:39:03.290469  / # /lava-3467374/bin/lava-test-runner /lav=
a-3467374/1
    2023-04-03T11:39:03.394355  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-03T11:39:03.394753  + cd /lava-3467374/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
