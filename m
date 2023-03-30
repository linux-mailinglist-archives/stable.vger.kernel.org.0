Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F656D0EFE
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 21:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjC3TmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 15:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjC3TmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 15:42:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0894DD53A
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:42:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id q102so18280589pjq.3
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 12:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680205340;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy4qDDsAEIh6I1EukH50yS4NN6AlvaCOdrXF1zRCbuo=;
        b=CtDSvQUCr+uVKdWqGo2usJCSFZwtgmbEU67auPE73KToRb84wBPGBzFhecNfFoJDyH
         BFoW3+EqG6tNOwrscdNvA+PibNsH+yyyNNri4FZqJqXfm3630IRntppaBgJxbhWzKm24
         exECnjb0kMJeejXP1FEEk0zj4I4iaoWnIqL4gNc1QNiwkcE+qMCx2objVMjknbHcxQKa
         pO4hj6oJjgaopLYDvGI/pxHBTcZhgpjWo8GpMS7ivwO/fFZAS+X6Xop3orKkE3+aTJjd
         n7zSYSADJmPrAd+K17va6odtSZEqvA3RHGmTETbUGJ191nd1/8xMYGTP1mWqZ2Kt8B7T
         6zMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680205340;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uy4qDDsAEIh6I1EukH50yS4NN6AlvaCOdrXF1zRCbuo=;
        b=DwQlKz0giGEzq262Kd9+yVe8qmkS9pyWOIKkLkb2dYw3sQFdjo9PBKWMWy42CiVmb6
         sdn2m5T63cNaSGA1eHPz/BJYAaCGrTW5YBOekz9jxGwn0P81HY785r/+PUQjyXnOuzye
         i8W5h7/OipMOCuFBG/rOfvtunSArg8dbqu+/ju7ipSIBpxC9O1PUn1Tem3bwCPE+IazL
         4yDY9hwpgr8x9V2NxXcWjzKgnqqYsnWyx/1K7QlJ3mAiO83SGhvHtWZFuYw9OqrByBgz
         ZFKoIfTtI64a4rlvJWUbNY5gu5sedLUDkwPG7WA5Ac5N9OMEKBKVGGASXl+DETsjeemi
         sm9A==
X-Gm-Message-State: AAQBX9cvHlWD0zl+K2Cn+Peszypqo18VS+1oLFOS+lCkY5XbC72a9SBg
        lG3kRJ/PhHA9nDg78DbVAcstJWhnvLVG6GSmhMY=
X-Google-Smtp-Source: AKy350aIx0v/DeLU15KTIpCcxCArQy1aKtJmcD3KP00gL2plObIXwOtSscarZLNjC4fA4HFn6HehjA==
X-Received: by 2002:a17:903:32d2:b0:19e:68b1:65b9 with SMTP id i18-20020a17090332d200b0019e68b165b9mr31685400plr.12.1680205340137;
        Thu, 30 Mar 2023 12:42:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9-20020a1709026a8900b001a212a93295sm91048plk.189.2023.03.30.12.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 12:42:19 -0700 (PDT)
Message-ID: <6425e61b.170a0220.4452a.07c8@mx.google.com>
Date:   Thu, 30 Mar 2023 12:42:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-124-gb73d9f9b7024
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 7 regressions (v5.10.176-124-gb73d9f9b7024)
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

stable-rc/queue/5.10 baseline: 171 runs, 7 regressions (v5.10.176-124-gb73d=
9f9b7024)

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
nel/v5.10.176-124-gb73d9f9b7024/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-124-gb73d9f9b7024
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b73d9f9b7024d8317973acc9aeaa7f315e2d13ac =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b1a15f24d411f262f7ab

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b1a15f24d411f262f7e1
        failing since 44 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-30T15:57:56.223517  + set +x
    2023-03-30T15:57:56.226574  <8>[   19.343772] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 250932_1.5.2.4.1>
    2023-03-30T15:57:56.337001  / # #
    2023-03-30T15:57:56.439910  export SHELL=3D/bin/sh
    2023-03-30T15:57:56.440472  #
    2023-03-30T15:57:56.542098  / # export SHELL=3D/bin/sh. /lava-250932/en=
vironment
    2023-03-30T15:57:56.542640  =

    2023-03-30T15:57:56.644074  / # . /lava-250932/environment/lava-250932/=
bin/lava-test-runner /lava-250932/1
    2023-03-30T15:57:56.645340  =

    2023-03-30T15:57:56.648138  / # /lava-250932/bin/lava-test-runner /lava=
-250932/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b3eecae8758dee62f7e1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b3eecae8758dee62f7e6
        failing since 63 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-30T16:07:45.982879  <8>[   11.135963] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3456274_1.5.2.4.1>
    2023-03-30T16:07:46.093992  / # #
    2023-03-30T16:07:46.196573  export SHELL=3D/bin/sh
    2023-03-30T16:07:46.197524  #
    2023-03-30T16:07:46.299611  / # export SHELL=3D/bin/sh. /lava-3456274/e=
nvironment
    2023-03-30T16:07:46.300524  =

    2023-03-30T16:07:46.402588  / # . /lava-3456274/environment/lava-345627=
4/bin/lava-test-runner /lava-3456274/1
    2023-03-30T16:07:46.404237  =

    2023-03-30T16:07:46.404781  / # /lava-3456274/bin/lava-test-runner /lav=
a-3456274/1<3>[   11.530814] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-03-30T16:07:46.408623   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b53f3a691fd8c362f78b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b53f3a691fd8c362f790
        failing since 0 day (last pass: v5.10.176-61-g2332301f1fab4, first =
fail: v5.10.176-104-g2b4187983740)

    2023-03-30T16:13:33.063848  + set +x

    2023-03-30T16:13:33.070564  <8>[   10.413363] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9818982_1.4.2.3.1>

    2023-03-30T16:13:33.175271  / # #

    2023-03-30T16:13:33.276308  export SHELL=3D/bin/sh

    2023-03-30T16:13:33.276570  #

    2023-03-30T16:13:33.377544  / # export SHELL=3D/bin/sh. /lava-9818982/e=
nvironment

    2023-03-30T16:13:33.377782  =


    2023-03-30T16:13:33.478750  / # . /lava-9818982/environment/lava-981898=
2/bin/lava-test-runner /lava-9818982/1

    2023-03-30T16:13:33.479064  =


    2023-03-30T16:13:33.483897  / # /lava-9818982/bin/lava-test-runner /lav=
a-9818982/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b52212a184470e62f7a7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b52312a184470e62f7ac
        failing since 0 day (last pass: v5.10.176-61-g2332301f1fab4, first =
fail: v5.10.176-104-g2b4187983740)

    2023-03-30T16:13:14.769640  + set +x

    2023-03-30T16:13:14.775634  <8>[   10.286901] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9819008_1.4.2.3.1>

    2023-03-30T16:13:14.877855  =


    2023-03-30T16:13:14.978893  / # #export SHELL=3D/bin/sh

    2023-03-30T16:13:14.979153  =


    2023-03-30T16:13:15.080142  / # export SHELL=3D/bin/sh. /lava-9819008/e=
nvironment

    2023-03-30T16:13:15.080457  =


    2023-03-30T16:13:15.181552  / # . /lava-9819008/environment/lava-981900=
8/bin/lava-test-runner /lava-9819008/1

    2023-03-30T16:13:15.181919  =


    2023-03-30T16:13:15.186948  / # /lava-9819008/bin/lava-test-runner /lav=
a-9819008/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6425b36c07b2c1f77a62f782

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6425b36c07b2c1f77a62f788
        failing since 16 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-30T16:05:58.830612  /lava-9818658/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6425b36c07b2c1f77a62f789
        failing since 16 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-30T16:05:56.767943  <8>[   59.929293] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-30T16:05:57.794294  /lava-9818658/1/../bin/lava-test-case

    2023-03-30T16:05:57.805894  <8>[   60.967668] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6425b3bc9704860d0f62f794

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-124-gb73d9f9b7024/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425b3bc9704860d0f62f799
        failing since 56 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-30T16:07:03.531750  / # #
    2023-03-30T16:07:03.633727  export SHELL=3D/bin/sh
    2023-03-30T16:07:03.634263  #
    2023-03-30T16:07:03.735669  / # export SHELL=3D/bin/sh. /lava-3456279/e=
nvironment
    2023-03-30T16:07:03.736196  =

    2023-03-30T16:07:03.837595  / # . /lava-3456279/environment/lava-345627=
9/bin/lava-test-runner /lava-3456279/1
    2023-03-30T16:07:03.838407  =

    2023-03-30T16:07:03.843861  / # /lava-3456279/bin/lava-test-runner /lav=
a-3456279/1
    2023-03-30T16:07:03.946932  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-30T16:07:03.947342  + cd /lava-3456279/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
