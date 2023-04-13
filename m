Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524866E1735
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 00:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjDMWLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 18:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjDMWLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 18:11:33 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42E55B94
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 15:11:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-5191796a483so948898a12.0
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 15:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681423891; x=1684015891;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=GqjpFi8nnCvPd0HuGEipWoCRKEkbhMUU8SlNyNK6g04=;
        b=MIt03GtD+TWuTSxY7nNN1v9SribR8ZBRH+1AUwh5V6JAQikq3Zw+te7DYkqbTQ5zPZ
         A7XTS5OASEuivtnO95b76kUloIwsrdpzkvkQEGIgBX7TRoLnOXGEv6Yk3lheiRDse9dS
         DAb1PrT5kqR2wd3MDMvw3uiP0kNyoYsc+zZztT0lSpZIgbgeiwQdwJh/aOknNnVr1R0T
         tkcd+Fhv4/r5j6OuXh3NFUYtoOW2eFCNWAFGJ5GmlWDgo0PrzwwxEwgig/0dYXFl69gd
         EIBnz6v2SQ6n37VnB+KjQosXKNVtLempPjjXZNI0Nxek/uExxdf0UE+DvzIMiFW6790n
         IWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681423891; x=1684015891;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GqjpFi8nnCvPd0HuGEipWoCRKEkbhMUU8SlNyNK6g04=;
        b=JIN7ZO2lEGa8r4eCHFTufbPkxGraQeRpZkQfelOtn9BQX3cNCJ23YU2PMbZZbVwiXj
         40ILss/zF7AN3/1+QLOCcimL2+kqq/EqauRpPgE5O+wOzI8EMmx/rFY0ZCtTTIFdhs7y
         GXwxghvD1LW4sVHmMoxykxfVKVwCnwTU7UA0VferTQpOkxdWWtcIR+5jZvU3E8T0lVRx
         rSEPCZsueD/g5nowKzRQqAbA0ra61JxES2NOkG+7MPx+pF8Alo6BOljG/Q5mDyGb5R/W
         aXhMZkE/joRGrIsMlUBf51F5z+3XAiwNXtxva8VSBOV/sLRuExdww16JHU5CZsetNbZN
         4XCw==
X-Gm-Message-State: AAQBX9cD1y+VE2hEpLBY6qDHT5L902XjnNsuV8plSv6c6q6T67UPOGkt
        FdFkRGpmuE3gmsX/m18QpZqrOrALGNPZDKzuNzFT/eTJ
X-Google-Smtp-Source: AKy350Y74TMM3sN7u2HC2wUd3pL/3iGlIocauXR6bkhrO/zbhVwwfgkM5KMdUng14QW0EfgNKwuPFg==
X-Received: by 2002:a05:6a00:188c:b0:63a:ea04:4966 with SMTP id x12-20020a056a00188c00b0063aea044966mr6045248pfh.8.1681423890811;
        Thu, 13 Apr 2023 15:11:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18-20020aa78692000000b0063aed005623sm1826820pfo.154.2023.04.13.15.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 15:11:30 -0700 (PDT)
Message-ID: <64387e12.a70a0220.3a5e9.4263@mx.google.com>
Date:   Thu, 13 Apr 2023 15:11:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-225-gde39d686eb8d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 184 runs,
 7 regressions (v5.10.176-225-gde39d686eb8d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 184 runs, 7 regressions (v5.10.176-225-gde39=
d686eb8d)

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
nel/v5.10.176-225-gde39d686eb8d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-225-gde39d686eb8d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de39d686eb8d71007608644ea3f1b6cff8e1a374 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64384dd67ec6390e152e8653

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64384dd67ec6390e152e8689
        failing since 58 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-13T18:45:20.567169  <8>[   19.185906] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 324584_1.5.2.4.1>
    2023-04-13T18:45:20.729412  / # #
    2023-04-13T18:45:20.846928  export SHELL=3D/bin/sh
    2023-04-13T18:45:20.852092  #
    2023-04-13T18:45:20.961729  / # export SHELL=3D/bin/sh. /lava-324584/en=
vironment
    2023-04-13T18:45:20.966590  =

    2023-04-13T18:45:21.076479  / # . /lava-324584/environment/lava-324584/=
bin/lava-test-runner /lava-324584/1
    2023-04-13T18:45:21.084959  =

    2023-04-13T18:45:21.089264  / # /lava-324584/bin/lava-test-runner /lava=
-324584/1
    2023-04-13T18:45:21.194641  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64384937c6dbe2a84e2e8619

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64384937c6dbe2a84e2e861e
        failing since 77 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-13T18:25:27.625359  <8>[   11.144823] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3492531_1.5.2.4.1>
    2023-04-13T18:25:27.732892  / # #
    2023-04-13T18:25:27.834527  export SHELL=3D/bin/sh
    2023-04-13T18:25:27.834947  #
    2023-04-13T18:25:27.936473  / # export SHELL=3D/bin/sh. /lava-3492531/e=
nvironment
    2023-04-13T18:25:27.936819  =

    2023-04-13T18:25:28.038112  / # . /lava-3492531/environment/lava-349253=
1/bin/lava-test-runner /lava-3492531/1
    2023-04-13T18:25:28.039036  =

    2023-04-13T18:25:28.043760  / # /lava-3492531/bin/lava-test-runner /lav=
a-3492531/1
    2023-04-13T18:25:28.122373  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64384c9df850c268e62e860e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64384c9df850c268e62e8613
        failing since 14 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-13T18:40:16.389243  + set +x

    2023-04-13T18:40:16.395665  <8>[   14.474835] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9964053_1.4.2.3.1>

    2023-04-13T18:40:16.500597  / # #

    2023-04-13T18:40:16.601692  export SHELL=3D/bin/sh

    2023-04-13T18:40:16.601930  #

    2023-04-13T18:40:16.702897  / # export SHELL=3D/bin/sh. /lava-9964053/e=
nvironment

    2023-04-13T18:40:16.703139  =


    2023-04-13T18:40:16.804110  / # . /lava-9964053/environment/lava-996405=
3/bin/lava-test-runner /lava-9964053/1

    2023-04-13T18:40:16.804486  =


    2023-04-13T18:40:16.809353  / # /lava-9964053/bin/lava-test-runner /lav=
a-9964053/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64384649f226140fa32e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64384649f226140fa32e85eb
        failing since 14 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-13T18:13:08.166929  <8>[   13.085352] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9964046_1.4.2.3.1>

    2023-04-13T18:13:08.170202  + set +x

    2023-04-13T18:13:08.272216  =


    2023-04-13T18:13:08.373213  / # #export SHELL=3D/bin/sh

    2023-04-13T18:13:08.373441  =


    2023-04-13T18:13:08.474275  / # export SHELL=3D/bin/sh. /lava-9964046/e=
nvironment

    2023-04-13T18:13:08.474503  =


    2023-04-13T18:13:08.575416  / # . /lava-9964046/environment/lava-996404=
6/bin/lava-test-runner /lava-9964046/1

    2023-04-13T18:13:08.575715  =


    2023-04-13T18:13:08.580795  / # /lava-9964046/bin/lava-test-runner /lav=
a-9964046/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64384b8531654805212e85f2

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64384b8531654805212e85f8
        failing since 30 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-13T18:35:37.410874  /lava-9964430/1/../bin/lava-test-case

    2023-04-13T18:35:37.421562  <8>[   62.008527] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64384b8531654805212e85f9
        failing since 30 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-13T18:35:36.374727  /lava-9964430/1/../bin/lava-test-case

    2023-04-13T18:35:36.385587  <8>[   60.972479] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6438491578b2c86e512e87d2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-225-gde39d686eb8d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6438491578b2c86e512e87d7
        failing since 70 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-13T18:25:12.990886  / # #
    2023-04-13T18:25:13.092547  export SHELL=3D/bin/sh
    2023-04-13T18:25:13.093085  #
    2023-04-13T18:25:13.194467  / # export SHELL=3D/bin/sh. /lava-3492533/e=
nvironment
    2023-04-13T18:25:13.195010  =

    2023-04-13T18:25:13.296386  / # . /lava-3492533/environment/lava-349253=
3/bin/lava-test-runner /lava-3492533/1
    2023-04-13T18:25:13.297059  =

    2023-04-13T18:25:13.302176  / # /lava-3492533/bin/lava-test-runner /lav=
a-3492533/1
    2023-04-13T18:25:13.401085  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-13T18:25:13.401596  + cd /lava-3492533/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
