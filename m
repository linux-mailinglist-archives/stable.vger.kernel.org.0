Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C226E603C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 13:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjDRLqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 07:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjDRLqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 07:46:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1EF8A61
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 04:46:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a8097c1ccfso2435705ad.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 04:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681818365; x=1684410365;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wQqlwyUTZXZL9Ycm0hv+LPteqk7Qf9v0SCGla/6zVm4=;
        b=n1up1WlVASzu6AaJR5cs+jhV8ul8jAA4U2Un0e6xqeOz3XyrsOCXNg0kBa5ym9D4wr
         BfndDAF8AVLPYUDNv8IwgzDmXXu2TgbsMP/EHmVRf25tHo44iK3PwFOfAZBT0u4ox9fP
         4Xs6i9J+NXPiV0Bnk0qJ0w8hUBvhOhaumH6gFcOsFlgwJINebgpOOKneXPaAXxccvTnF
         koGs5u32aPoGkhdsLnsVr7FN4DT7m3r+cYl17FaaPJuSZ6uVHzFWGIUncOxnV0+rKGON
         Y3/kcoiyq0dJsPB2qCNo+Fl1PRVKJhzaKZ3KjuZfVgUdo64DE5x7S6dsbFLtCPVQR+X6
         tHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681818365; x=1684410365;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wQqlwyUTZXZL9Ycm0hv+LPteqk7Qf9v0SCGla/6zVm4=;
        b=D1DWQKxrjyN98QHo6V31ns9tEiycJY/2z6TIU6vWipYbxxue5imGVQQYiBkAbg4D35
         o/dz5GfNw3Ty5Jp66xCEQlJFoJ6wKhNheaZWW6dwCq277rQzVmvStfTfsSp15obIOWw7
         YKCaS1rah/cXV4u+Bcy7tLRSA5VwicZdlldkmmSLRkYuUGhpMEFAwj+fW7aaaQAfILjR
         EKWngVMjzYRO8qq1lBcFhdLxgMAjuPghaIrX1acmzxAuOiNW2X2VUsdTu7WEzYCzv8XP
         XTxxcG89XIfqJVJLH0Qw0V8BqPtVvqCd+4i8MPL3ONkRG1s6oqLQG1zRecCEZisz7yFf
         CSlA==
X-Gm-Message-State: AAQBX9dsBXhkr044phgAioGhJtqmaBoVsHbySpMd/cTwr+Tj1v3vjWcV
        kR5migYgL66Xr8LA4IAeMKckI0Y2i0hwY6e3dXEyoVzJ
X-Google-Smtp-Source: AKy350aRMogGaM+IEjGUPURmZ2NvNFZw7xUjyZBv0Mwus4+C2n22Xfp6bZNfugfXTqI1c4egimBVng==
X-Received: by 2002:a17:903:2446:b0:1a6:aebc:75de with SMTP id l6-20020a170903244600b001a6aebc75demr1759098pls.38.1681818364772;
        Tue, 18 Apr 2023 04:46:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23-20020a170902969700b001a27e5ee634sm7439953plp.33.2023.04.18.04.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:46:04 -0700 (PDT)
Message-ID: <643e82fc.170a0220.ca0e8.f6bd@mx.google.com>
Date:   Tue, 18 Apr 2023 04:46:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-283-gedfdf527333f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 176 runs,
 7 regressions (v5.10.176-283-gedfdf527333f)
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

stable-rc/queue/5.10 baseline: 176 runs, 7 regressions (v5.10.176-283-gedfd=
f527333f)

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
nel/v5.10.176-283-gedfdf527333f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-283-gedfdf527333f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      edfdf527333f1d1444466081ceab97992aacfd15 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643e4ffa079f90b7f72e860d

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e4ffa079f90b7f72e863f
        failing since 63 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-18T08:08:07.406569  <8>[   19.866748] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 343771_1.5.2.4.1>
    2023-04-18T08:08:07.517226  / # #
    2023-04-18T08:08:07.619609  export SHELL=3D/bin/sh
    2023-04-18T08:08:07.620208  #
    2023-04-18T08:08:07.722316  / # export SHELL=3D/bin/sh. /lava-343771/en=
vironment
    2023-04-18T08:08:07.722917  =

    2023-04-18T08:08:07.824974  / # . /lava-343771/environment/lava-343771/=
bin/lava-test-runner /lava-343771/1
    2023-04-18T08:08:07.826390  =

    2023-04-18T08:08:07.830983  / # /lava-343771/bin/lava-test-runner /lava=
-343771/1
    2023-04-18T08:08:07.932665  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643e4ebaafab7c328a2e860e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e4ebaafab7c328a2e8613
        failing since 81 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-18T08:02:39.320232  <8>[   11.035466] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3505716_1.5.2.4.1>
    2023-04-18T08:02:39.430144  / # #
    2023-04-18T08:02:39.533232  export SHELL=3D/bin/sh
    2023-04-18T08:02:39.534118  #
    2023-04-18T08:02:39.636115  / # export SHELL=3D/bin/sh. /lava-3505716/e=
nvironment
    2023-04-18T08:02:39.637003  =

    2023-04-18T08:02:39.739129  / # . /lava-3505716/environment/lava-350571=
6/bin/lava-test-runner /lava-3505716/1
    2023-04-18T08:02:39.740949  =

    2023-04-18T08:02:39.741602  / # /lava-3505716/bin/lava-test-runner /lav=
a-3505716/1<3>[   11.450840] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-18T08:02:39.744544   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e4fdfd446b63f772e8637

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e4fdfd446b63f772e863b
        failing since 18 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-18T08:07:46.210362  + <8>[   10.307737] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10024182_1.4.2.3.1>

    2023-04-18T08:07:46.210741  set +x

    2023-04-18T08:07:46.316201  #

    2023-04-18T08:07:46.317770  =


    2023-04-18T08:07:46.420069  / # #export SHELL=3D/bin/sh

    2023-04-18T08:07:46.420771  =


    2023-04-18T08:07:46.522420  / # export SHELL=3D/bin/sh. /lava-10024182/=
environment

    2023-04-18T08:07:46.523202  =


    2023-04-18T08:07:46.625179  / # . /lava-10024182/environment/lava-10024=
182/bin/lava-test-runner /lava-10024182/1

    2023-04-18T08:07:46.626305  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643e4fded446b63f772e8625

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e4fded446b63f772e862a
        failing since 18 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-18T08:07:44.153717  <8>[   13.082235] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10024177_1.4.2.3.1>

    2023-04-18T08:07:44.157104  + set +x

    2023-04-18T08:07:44.258712  #

    2023-04-18T08:07:44.361449  / # #export SHELL=3D/bin/sh

    2023-04-18T08:07:44.361625  =


    2023-04-18T08:07:44.462673  / # export SHELL=3D/bin/sh. /lava-10024177/=
environment

    2023-04-18T08:07:44.463335  =


    2023-04-18T08:07:44.565117  / # . /lava-10024177/environment/lava-10024=
177/bin/lava-test-runner /lava-10024177/1

    2023-04-18T08:07:44.566268  =


    2023-04-18T08:07:44.571474  / # /lava-10024177/bin/lava-test-runner /la=
va-10024177/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643e4ecaafab7c328a2e863e

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643e4ecaafab7c328a2e8644
        failing since 35 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-18T08:03:13.138580  <8>[   34.319302] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-18T08:03:14.162270  /lava-10024124/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643e4ecaafab7c328a2e8645
        failing since 35 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-18T08:03:13.126613  /lava-10024124/1/../bin/lava-test-case
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643e4e82514ac460b72e8660

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-283-gedfdf527333f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643e4e82514ac460b72e8665
        failing since 75 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-18T08:01:45.830950  <8>[    7.400508] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3505709_1.5.2.4.1>
    2023-04-18T08:01:45.936769  / # #
    2023-04-18T08:01:46.038605  export SHELL=3D/bin/sh
    2023-04-18T08:01:46.039006  #
    2023-04-18T08:01:46.140425  / # export SHELL=3D/bin/sh. /lava-3505709/e=
nvironment
    2023-04-18T08:01:46.140845  =

    2023-04-18T08:01:46.242427  / # . /lava-3505709/environment/lava-350570=
9/bin/lava-test-runner /lava-3505709/1
    2023-04-18T08:01:46.243124  =

    2023-04-18T08:01:46.261723  / # /lava-3505709/bin/lava-test-runner /lav=
a-3505709/1
    2023-04-18T08:01:46.349525  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
