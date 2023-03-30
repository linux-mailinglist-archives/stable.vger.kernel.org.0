Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C056D0CC1
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjC3R1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 13:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjC3R1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 13:27:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5D02D55
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 10:27:04 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u38so13039253pfg.10
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 10:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680197223;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=igErxhNPSl5T48L6znCm3k1oUOWkUEYi5ShEr6Q3AWg=;
        b=NxpAeJuKhb+XrB/sLcgAmfZm4LSjIRInEbvFhpV4gdtPNSMkvxGTFucTDFMKXK2EQL
         eTN1/lSMjaJ4iFz8VbxOyefmA84zGnn05S44HUhw1MydXVUTRTMoD98SfMSj6iDRyIQr
         L5rpPttgNIb0uWuZ8bJVlO5ZXgfwe8OqHpLUzdecxWsWUwx/xCG8pHLQamIFzlQDFwjs
         AXYcUmI70h9tHLTiTxwk+c2sEzIIByWtKb+g/utSXprLP4gUtBAakEaNJEScXptfdOMm
         rILremWX/+WNeDcUwcaBLwK0tgaICXvhRW9ncZMc9SmxGyW7bERNSI0552pQjqqTmnZI
         4Sow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680197223;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=igErxhNPSl5T48L6znCm3k1oUOWkUEYi5ShEr6Q3AWg=;
        b=lV8M6Ul4TDo8vAUOUkp3OOY5LbG1IJ4lfPX3mhtW42opBeJo0LzTHTgdOd8ng6AFkw
         pA9AsYuHWsWnGBtmZ/dtYckfypvjJdjMSjMBK3a3qH6mW2DyMYl+CXMklcRNzEQfaYTy
         oZCJq2mRry75bLe/mUDmt95fAvUwsMcMPRXVTJvjCQJtnBqo7RTavYqHqmw1Z71QRZQn
         HQmZCBkWU5FrDdXLRMgYzt8yGAb4rI0GA+cX0mz47fruRSUPnG1xkS1qAUAfo44QHTEb
         z9uohQEA1anFuyN7TZPXF+yxcnPjpk9PkZGCqvrkrGIXquT/K60SNwSheFSx4K3IhPoI
         0wtw==
X-Gm-Message-State: AAQBX9ft3FMWJy7CfBlI2tD8ar/PT85lZgonUtNfRmaaB8lgcwAhbtyb
        00m4m5+oB//QeeJYshB/yamZOiFrLwyBy6uU0dcQHQ==
X-Google-Smtp-Source: AKy350ZgASNmtycxI5zAGdA7KCtYn1G0pLR2TtFlTxLPwgAr/FTsRhebNjaIELCdYYIL8olXAnYYvg==
X-Received: by 2002:a62:585:0:b0:627:fb40:7cb4 with SMTP id 127-20020a620585000000b00627fb407cb4mr21687029pff.30.1680197223266;
        Thu, 30 Mar 2023 10:27:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d22-20020aa78696000000b0062d8c855ee9sm133838pfo.149.2023.03.30.10.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 10:27:02 -0700 (PDT)
Message-ID: <6425c666.a70a0220.2b8ac.07d2@mx.google.com>
Date:   Thu, 30 Mar 2023 10:27:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176
Subject: stable-rc/linux-5.10.y baseline: 368 runs, 11 regressions (v5.10.176)
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

stable-rc/linux-5.10.y baseline: 368 runs, 11 regressions (v5.10.176)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

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

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca9787bdecfa2174b0a169a54916e22b89b0ef5b =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641b83fa9782325bc09c95bc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/641b83fa9782325bc09c95c5
        failing since 63 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-22T22:40:31.025328  <8>[   11.066555] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3435904_1.5.2.4.1>
    2023-03-22T22:40:31.137553  / # #
    2023-03-22T22:40:31.241441  export SHELL=3D/bin/sh
    2023-03-22T22:40:31.242406  #
    2023-03-22T22:40:31.344338  / # export SHELL=3D/bin/sh. /lava-3435904/e=
nvironment
    2023-03-22T22:40:31.345211  =

    2023-03-22T22:40:31.447615  / # . /lava-3435904/environment/lava-343590=
4/bin/lava-test-runner /lava-3435904/1
    2023-03-22T22:40:31.448341  =

    2023-03-22T22:40:31.448565  / # <3>[   11.451243] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-22T22:40:31.453653  /lava-3435904/bin/lava-test-runner /lava-34=
35904/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642591d9720f405eef62f771

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642591d9720f405eef62f776
        failing since 63 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-30T13:42:26.195655  <8>[   11.002430] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3455572_1.5.2.4.1>
    2023-03-30T13:42:26.302152  / # #
    2023-03-30T13:42:26.403721  export SHELL=3D/bin/sh
    2023-03-30T13:42:26.404168  #
    2023-03-30T13:42:26.505130  / # export SHELL=3D/bin/sh. /lava-3455572/e=
nvironment
    2023-03-30T13:42:26.505584  =

    2023-03-30T13:42:26.505827  / # . /lava-3455572/environment<3>[   11.29=
1107] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-03-30T13:42:26.607172  /lava-3455572/bin/lava-test-runner /lava-34=
55572/1
    2023-03-30T13:42:26.607698  =

    2023-03-30T13:42:26.612699  / # /lava-3455572/bin/lava-test-runner /lav=
a-3455572/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
fsl-lx2160a-rdb              | arm64  | lab-nxp       | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/642595587dccc97b6f62f7b3

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642595587dccc97b6f62f7b6
        failing since 26 days (last pass: v5.10.155, first fail: v5.10.172)

    2023-03-30T13:57:11.309267  [   13.369916] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1190396_1.5.2.4.1>
    2023-03-30T13:57:11.414990  / # #
    2023-03-30T13:57:11.516821  export SHELL=3D/bin/sh
    2023-03-30T13:57:11.517387  #
    2023-03-30T13:57:11.618746  / # export SHELL=3D/bin/sh. /lava-1190396/e=
nvironment
    2023-03-30T13:57:11.619228  =

    2023-03-30T13:57:11.720624  / # . /lava-1190396/environment/lava-119039=
6/bin/lava-test-runner /lava-1190396/1
    2023-03-30T13:57:11.721494  =

    2023-03-30T13:57:11.723260  / # /lava-1190396/bin/lava-test-runner /lav=
a-1190396/1
    2023-03-30T13:57:11.740916  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259217963325009262f7ce

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259217963325009262f7d3
        failing since 1 day (last pass: v5.10.176, first fail: v5.10.176-10=
5-g18265b240021)

    2023-03-30T13:43:35.249687  + <8>[   10.651287] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9816556_1.4.2.3.1>

    2023-03-30T13:43:35.250147  set +x

    2023-03-30T13:43:35.355254  #

    2023-03-30T13:43:35.458380  / # #export SHELL=3D/bin/sh

    2023-03-30T13:43:35.459235  =


    2023-03-30T13:43:35.560997  / # export SHELL=3D/bin/sh. /lava-9816556/e=
nvironment

    2023-03-30T13:43:35.561238  =


    2023-03-30T13:43:35.662292  / # . /lava-9816556/environment/lava-981655=
6/bin/lava-test-runner /lava-9816556/1

    2023-03-30T13:43:35.663474  =


    2023-03-30T13:43:35.668359  / # /lava-9816556/bin/lava-test-runner /lav=
a-9816556/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64259228ec1c787d2c62f7b9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-=
x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64259228ec1c787d2c62f7be
        failing since 1 day (last pass: v5.10.176, first fail: v5.10.176-10=
5-g18265b240021)

    2023-03-30T13:43:46.788907  + set +x

    2023-03-30T13:43:46.795581  <8>[   10.323901] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9816545_1.4.2.3.1>

    2023-03-30T13:43:46.903680  =


    2023-03-30T13:43:47.004731  / # #export SHELL=3D/bin/sh

    2023-03-30T13:43:47.004966  =


    2023-03-30T13:43:47.105928  / # export SHELL=3D/bin/sh. /lava-9816545/e=
nvironment

    2023-03-30T13:43:47.106921  =


    2023-03-30T13:43:47.208767  / # . /lava-9816545/environment/lava-981654=
5/bin/lava-test-runner /lava-9816545/1

    2023-03-30T13:43:47.210208  =


    2023-03-30T13:43:47.215727  / # /lava-9816545/bin/lava-test-runner /lav=
a-9816545/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/641b825dd25284da849c9520

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641b825dd25284da849c9=
521
        new failure (last pass: v5.10.175-100-g1686e1df6521) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64258f17df9df83a6e62f799

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64258f17df9df83a6e62f=
79a
        new failure (last pass: v5.10.175-100-g1686e1df6521) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/641b83cdd402e5c97d9c9544

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/641b83cdd402e5c97d9c954e
        failing since 8 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-22T22:40:04.362801  /lava-9740005/1/../bin/lava-test-case

    2023-03-22T22:40:04.373856  <8>[   35.399329] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/641b83cdd402e5c97d9c954f
        failing since 8 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-22T22:40:03.325837  /lava-9740005/1/../bin/lava-test-case

    2023-03-22T22:40:03.336836  <8>[   34.362606] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642593c351f87dfa9362f791

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642593c351f87dfa9362f797
        failing since 8 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-30T13:50:37.752273  /lava-9816612/1/../bin/lava-test-case

    2023-03-30T13:50:37.763217  <8>[   62.044691] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642593c351f87dfa9362f798
        failing since 8 days (last pass: v5.10.173, first fail: v5.10.173-4=
-g955623617f2f)

    2023-03-30T13:50:35.694464  <8>[   59.973980] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-30T13:50:36.715030  /lava-9816612/1/../bin/lava-test-case

    2023-03-30T13:50:36.726078  <8>[   61.007243] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
