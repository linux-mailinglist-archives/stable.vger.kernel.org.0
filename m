Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AED6E78D0
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 13:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbjDSLnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 07:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjDSLni (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 07:43:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83AD30E0
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 04:43:36 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a8097c1ccfso13665185ad.1
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 04:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681904615; x=1684496615;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qE6mojDnLhcHGsc5HKBELbb0TwvpqSQIheGfdr+P+RE=;
        b=lA5K9DcqwHyERCo35T5JiIE9ry+/LamHcYF7UEA1JDOL4Zv7n7KZJxxZMLxCa/abAe
         9Fgeq6RswmHgOOAdf4O1gBgAhF2WeJWlSCPwuM1MGGbt5qXmfcfmrfpHmth7ry7NYXdf
         u0/OWAnwPG4oD11jqiYNXIolhkgJCmgREMHSljHBuktOTuARoj0zjThH7hfXX6VR/Nlk
         w4Gj/q1xrAB35GjE5Tjpqskl9gTk50mxVcwrIs1+vVeHFejjPMgSC9hDt0IkkZuYW/W3
         WDadr22Uz99KsSDbykgpJo4VV7hFvNP2ErbtfGcizIsrg1gOc89j5hO/CC6vTcUvYDKb
         0fOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681904615; x=1684496615;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qE6mojDnLhcHGsc5HKBELbb0TwvpqSQIheGfdr+P+RE=;
        b=c5okM7LGM77jAiTqOmcHjYqsUPWaTVg/CPzZ6NGIVSrx6n8tmFfgRPciOJ8r6PhaO3
         YE/BE4C+2VzN/fxG5GJjV7/+E0rePDFL2W3a2YKA5dK/9kSTWD9Ncdwctqw0Lv1mZ42Z
         nDALlMQam+1QkMCfpwRi6YjCHBMeOUcz/4pFGpYVGJmnJj9EpQDsLnYgE/T86ciGACcE
         NTURj6mxi+1t6BHJlORIq5O6A4xsSPL54XzOliEAk+P7VaNvcQT0UVGRgLqjFSqj0o/r
         Jq3/k1ah0lfDgZaMMDyAnb0Jj/9Aa0Tri0fl3yMqJDEwlm9DUk4wfccm64vhs9nyczCS
         EIuw==
X-Gm-Message-State: AAQBX9c1L2pJCmR3/ZGF70+tMl7h5PfYdiXcBxmedgo4wp5eIu2NUP0d
        UATJMgmt+yta0YjJfTZ/IQhEjX6iYBs+RGPyjMkgOxmE
X-Google-Smtp-Source: AKy350aE1W5yX2wF65E0MXmjplRtif3/Icn+qHJCrEUfPkOeXZPLOzyBDkCdDie81oHWXGfb22e2Yw==
X-Received: by 2002:a17:902:b943:b0:1a6:6c58:d36e with SMTP id h3-20020a170902b94300b001a66c58d36emr4056574pls.66.1681904615519;
        Wed, 19 Apr 2023 04:43:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902bccb00b0019309be03e7sm11267196pls.66.2023.04.19.04.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 04:43:35 -0700 (PDT)
Message-ID: <643fd3e7.170a0220.ce19e.91ae@mx.google.com>
Date:   Wed, 19 Apr 2023 04:43:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-294-gabbd2e43cd45
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 185 runs,
 7 regressions (v5.10.176-294-gabbd2e43cd45)
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

stable-rc/linux-5.10.y baseline: 185 runs, 7 regressions (v5.10.176-294-gab=
bd2e43cd45)

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
nel/v5.10.176-294-gabbd2e43cd45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-294-gabbd2e43cd45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      abbd2e43cd4546db9d997a9c3d3cbcbd7cf727c9 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa1bb075afe5f932e8606

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa1bb075afe5f932e860b
        failing since 91 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-04-19T08:09:14.197251  <8>[   11.040737] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3510920_1.5.2.4.1>
    2023-04-19T08:09:14.304215  / # #
    2023-04-19T08:09:14.405918  export SHELL=3D/bin/sh
    2023-04-19T08:09:14.406343  #
    2023-04-19T08:09:14.507587  / # export SHELL=3D/bin/sh. /lava-3510920/e=
nvironment
    2023-04-19T08:09:14.508024  =

    2023-04-19T08:09:14.609306  / # . /lava-3510920/environment/lava-351092=
0/bin/lava-test-runner /lava-3510920/1
    2023-04-19T08:09:14.609982  =

    2023-04-19T08:09:14.610185  / # <3>[   11.370785] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-19T08:09:14.614991  /lava-3510920/bin/lava-test-runner /lava-35=
10920/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa42676dc23320c2e85fc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa42676dc23320c2e85ff
        failing since 46 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-04-19T08:19:20.339576  [   11.344058] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1203207_1.5.2.4.1>
    2023-04-19T08:19:20.445225  / # #
    2023-04-19T08:19:20.546985  export SHELL=3D/bin/sh
    2023-04-19T08:19:20.547380  #
    2023-04-19T08:19:20.648583  / # export SHELL=3D/bin/sh. /lava-1203207/e=
nvironment
    2023-04-19T08:19:20.649051  =

    2023-04-19T08:19:20.750433  / # . /lava-1203207/environment/lava-120320=
7/bin/lava-test-runner /lava-1203207/1
    2023-04-19T08:19:20.751183  =

    2023-04-19T08:19:20.753027  / # /lava-1203207/bin/lava-test-runner /lav=
a-1203207/1
    2023-04-19T08:19:20.769701  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa8635911bb0f5c2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fa8635911bb0f5c2e85eb
        failing since 21 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-19T08:37:39.951803  + <8>[   10.813677] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10041438_1.4.2.3.1>

    2023-04-19T08:37:39.951885  set +x

    2023-04-19T08:37:40.053658  #

    2023-04-19T08:37:40.054006  =


    2023-04-19T08:37:40.154972  / # #export SHELL=3D/bin/sh

    2023-04-19T08:37:40.155190  =


    2023-04-19T08:37:40.256087  / # export SHELL=3D/bin/sh. /lava-10041438/=
environment

    2023-04-19T08:37:40.256301  =


    2023-04-19T08:37:40.357242  / # . /lava-10041438/environment/lava-10041=
438/bin/lava-test-runner /lava-10041438/1

    2023-04-19T08:37:40.357649  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643f9ea08fe39b569c2e85ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-coll=
abora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643f9ea08fe39b569c2e8604
        failing since 21 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-19T07:55:56.805994  <8>[   12.611769] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10041427_1.4.2.3.1>

    2023-04-19T07:55:56.809441  + set +x

    2023-04-19T07:55:56.915654  =


    2023-04-19T07:55:57.016796  / # #export SHELL=3D/bin/sh

    2023-04-19T07:55:57.016973  =


    2023-04-19T07:55:57.118066  / # export SHELL=3D/bin/sh. /lava-10041427/=
environment

    2023-04-19T07:55:57.118797  =


    2023-04-19T07:55:57.220574  / # . /lava-10041427/environment/lava-10041=
427/bin/lava-test-runner /lava-10041427/1

    2023-04-19T07:55:57.221694  =


    2023-04-19T07:55:57.226921  / # /lava-10041427/bin/lava-test-runner /la=
va-10041427/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643fa145c94ec6fb552e8603

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fa145c94ec6fb552e8=
604
        failing since 27 days (last pass: v5.10.175-100-g1686e1df6521, firs=
t fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643fa1d4cffd8cbef32e85e7

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-294-gabbd2e43cd45/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643fa1d4cffd8cbef32e85ed
        failing since 36 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-19T08:09:41.619363  /lava-10041661/1/../bin/lava-test-case

    2023-04-19T08:09:41.630313  <8>[   62.143563] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643fa1d4cffd8cbef32e85ee
        failing since 36 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-19T08:09:40.581418  /lava-10041661/1/../bin/lava-test-case

    2023-04-19T08:09:40.592265  <8>[   61.105694] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
