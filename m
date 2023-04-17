Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC04A6E43EF
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 11:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjDQJdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 05:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDQJdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 05:33:03 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9383E35A5
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 02:32:16 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d15so7753820pll.12
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 02:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681723861; x=1684315861;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hJP6EqxjYF0DvhiEyyCka01YZp/V1GSisK9YMBUMAAQ=;
        b=KbLn8Nkl0OWdVW68heqQ3RXl+1FhLPGCi9WLYQJkmeH48pAi+BroAQuxP4jOatu9pR
         lrEJMYYRMif0aZV0DK9uKp8D6O2GH8l8iAYEBPBGTe7bfBqklr8SwcEOFglW+Eq5rNt2
         lTlbpSJzoDRPrYGAT4c3PncU4NM7l16t3PVqxyJpyZ7FF0x9Dy7UMXfXoP1uH0YEBk8G
         eP8W1XAah69XhcdavXFwS1xbWe2IzFBt5j/Y0vqJ8F2vkDJVuf2eR1BdHqeL5HA0B2TF
         ekMO4NDzIimZ/p4j/EdDR7OwYt7pFrz2UR2Ewx0EgnIH3GrK7SfmICKIsInBRIXp94xs
         g7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681723861; x=1684315861;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hJP6EqxjYF0DvhiEyyCka01YZp/V1GSisK9YMBUMAAQ=;
        b=bAssudcfb9LspWW72vnw/7GebvefASX9/nhn28BH9PZ3cDHLrhGAzwakDMijoXJLaX
         R39e+QMdso+G209+xTZ1/nVrsSq3ARBzwjfxntL+VJCEHZbrQ8jYGJQKonMDoIB1bVUQ
         63+eubR5Vnv1J0Rbn7B46QHiEVaUXyfRCahPDWfTgznehsqFaCCDWoNPkxZQgkRuLfx6
         82u7OC9fEIKuKyIFEjd6sTRvd3IlHhOizHU4vmvM3VNNJKGtSxVdHdDoZMd0bKgwYWhN
         nYc4M56W1dOJt+/Lj7W+c6a3GeNsY4jHPhj/lmJUshiFezwpvovv5sNg7y3JDNgFQAmg
         Yr5A==
X-Gm-Message-State: AAQBX9cANqE7QGs5LUA7QPRxtbcQO4/+cslaDCp1hkumu7pnDPDfvsdG
        G6oB1dYqnMLKb3oXjULqc8Rf4fs1b8LSOX3hjxhT/L5l
X-Google-Smtp-Source: AKy350ZOfxvqRcJYcaqPz8aXzh7Cnr8zmEfE/T9kS3MhTBVzcDEqTVJK+/2/8duzT3tNkkh18Pfpjw==
X-Received: by 2002:a17:90a:b006:b0:23a:177b:5bfa with SMTP id x6-20020a17090ab00600b0023a177b5bfamr13926961pjq.22.1681723860643;
        Mon, 17 Apr 2023 02:31:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15-20020a17090a1d0f00b0024499d4b72esm8302676pjd.51.2023.04.17.02.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 02:31:00 -0700 (PDT)
Message-ID: <643d11d4.170a0220.18d1b.2688@mx.google.com>
Date:   Mon, 17 Apr 2023 02:31:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-265-g7eea075a5aef
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 177 runs,
 7 regressions (v5.10.176-265-g7eea075a5aef)
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

stable-rc/queue/5.10 baseline: 177 runs, 7 regressions (v5.10.176-265-g7eea=
075a5aef)

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
nel/v5.10.176-265-g7eea075a5aef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-265-g7eea075a5aef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7eea075a5aef39b1d140971c43784b0b7438b040 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643ce0366334f71c7d2e8627

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643ce0366334f71c7d2e865b
        failing since 62 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-17T05:58:57.351671  <8>[   19.535359] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 340778_1.5.2.4.1>
    2023-04-17T05:58:57.459243  / # #
    2023-04-17T05:58:57.561346  export SHELL=3D/bin/sh
    2023-04-17T05:58:57.562060  #
    2023-04-17T05:58:57.663917  / # export SHELL=3D/bin/sh. /lava-340778/en=
vironment
    2023-04-17T05:58:57.664470  =

    2023-04-17T05:58:57.766184  / # . /lava-340778/environment/lava-340778/=
bin/lava-test-runner /lava-340778/1
    2023-04-17T05:58:57.767042  =

    2023-04-17T05:58:57.770931  / # /lava-340778/bin/lava-test-runner /lava=
-340778/1
    2023-04-17T05:58:57.880604  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643cde5ea6616f71082e85f7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cde5ea6616f71082e85fc
        failing since 80 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-17T05:51:02.865719  <8>[   11.185685] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3504404_1.5.2.4.1>
    2023-04-17T05:51:02.972233  / # #
    2023-04-17T05:51:03.075484  export SHELL=3D/bin/sh
    2023-04-17T05:51:03.076427  #
    2023-04-17T05:51:03.178369  / # export SHELL=3D/bin/sh. /lava-3504404/e=
nvironment
    2023-04-17T05:51:03.179126  =

    2023-04-17T05:51:03.179910  / # <3>[   11.450987] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-17T05:51:03.281620  . /lava-3504404/environment/lava-3504404/bi=
n/lava-test-runner /lava-3504404/1
    2023-04-17T05:51:03.282157  =

    2023-04-17T05:51:03.290337  / # /lava-3504404/bin/lava-test-runner /lav=
a-3504404/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cdbc7b19636fbf22e85f2

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cdbc7b19636fbf22e85f7
        failing since 17 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-17T05:40:12.469748  + set +x

    2023-04-17T05:40:12.476526  <8>[   14.772011] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10014922_1.4.2.3.1>

    2023-04-17T05:40:12.584654  / # #

    2023-04-17T05:40:12.687618  export SHELL=3D/bin/sh

    2023-04-17T05:40:12.688409  #

    2023-04-17T05:40:12.790511  / # export SHELL=3D/bin/sh. /lava-10014922/=
environment

    2023-04-17T05:40:12.791307  =


    2023-04-17T05:40:12.893319  / # . /lava-10014922/environment/lava-10014=
922/bin/lava-test-runner /lava-10014922/1

    2023-04-17T05:40:12.894542  =


    2023-04-17T05:40:12.899390  / # /lava-10014922/bin/lava-test-runner /la=
va-10014922/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643cdba1bf70f443a82e8611

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cdba1bf70f443a82e8616
        failing since 17 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-17T05:39:24.151888  <8>[   11.549817] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10014930_1.4.2.3.1>

    2023-04-17T05:39:24.154936  + set +x

    2023-04-17T05:39:24.256508  #

    2023-04-17T05:39:24.256792  =


    2023-04-17T05:39:24.357530  / # #export SHELL=3D/bin/sh

    2023-04-17T05:39:24.357768  =


    2023-04-17T05:39:24.458627  / # export SHELL=3D/bin/sh. /lava-10014930/=
environment

    2023-04-17T05:39:24.458790  =


    2023-04-17T05:39:24.559703  / # . /lava-10014930/environment/lava-10014=
930/bin/lava-test-runner /lava-10014930/1

    2023-04-17T05:39:24.560076  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643cdedfff6a2166ed2e86be

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643cdedfff6a2166ed2e86c4
        failing since 34 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-17T05:53:18.158162  /lava-10015045/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643cdedfff6a2166ed2e86c5
        failing since 34 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-17T05:53:16.097976  <8>[   59.965575] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-17T05:53:17.122483  /lava-10015045/1/../bin/lava-test-case

    2023-04-17T05:53:17.133678  <8>[   61.003517] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643cde349f09ad70492e8640

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7eea075a5aef/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643cde349f09ad70492e8645
        failing since 74 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-17T05:50:25.206019  / # #
    2023-04-17T05:50:25.308296  export SHELL=3D/bin/sh
    2023-04-17T05:50:25.308962  #
    2023-04-17T05:50:25.410512  / # export SHELL=3D/bin/sh. /lava-3504393/e=
nvironment
    2023-04-17T05:50:25.411152  =

    2023-04-17T05:50:25.512543  / # . /lava-3504393/environment/lava-350439=
3/bin/lava-test-runner /lava-3504393/1
    2023-04-17T05:50:25.513313  =

    2023-04-17T05:50:25.530928  / # /lava-3504393/bin/lava-test-runner /lav=
a-3504393/1
    2023-04-17T05:50:25.578976  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-17T05:50:25.626740  + cd /lava-3504393/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
