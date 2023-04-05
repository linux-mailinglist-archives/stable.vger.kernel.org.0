Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9803D6D7F88
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237096AbjDEObe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbjDEObd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:31:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007645FCF
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 07:31:20 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so39703487pjt.2
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 07:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680705080;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=snbyRyKh3z/nEQvAYjH7oklGVXXPPfTrGY9aMDARmzw=;
        b=ygmvWmkt7bvxuu+6r9g1150CDvos77d0645pHaOuPgYbWsuyjflZFQfRIXRsMyPjen
         IoQOde41Bazea5HBhrNShcLNB6VE7ST/RdCv/mZjaT2GnzcZcShQSr1IdpGgF8m/JAeR
         QKExfTZKjVO23BERAl4gcamWQanT/NoBVC6WzepUUb6HVCN4QlvIuCo+OHnZ42tfNomd
         8r2PNnUF/ie38z9m5dwBvyE4/61R+vTqOGzGn0LHQsTf4S8jjSeVx9ZX4mbOtVD5zfv8
         xVKncKcxf3luK8VsbIoj3t0ZaodUvsvIgmvbB4rdII6kff3Moym9nwPblcrvLetKI2Rj
         pYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680705080;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=snbyRyKh3z/nEQvAYjH7oklGVXXPPfTrGY9aMDARmzw=;
        b=JWV5OIZp/7/DMo8lgKQpBES6uHILrUYraklo1Kryuzd44NKlFM2z4Q0A3/GHqzZ95O
         WFDEoMPN/wj0x8Be927pv9e0JnuzBCuA5/mLKN1YSMsp95NkJuSrwgFdBxJM4OB115fE
         AMeP5mxCLuu5Ky5ZSd5Z7Zdm9M5TIZRLQg2FQ2qc81FsIKPlFdm0NzpMgT7MIRhm0QHZ
         ktOoKxHfPGDAjL4U2yYhhh/30UNC3rq/cj7gZlUI+k59Dp4TClKh0C95ep1euZIe4MCC
         47+ApSFGwNbzYuD1m9jfGsmCMxRT6mobVMGMMiRIym7JJCayERcwqqE3P8frWAO4yRz9
         FtCg==
X-Gm-Message-State: AAQBX9d0aZpDeEJWJ6rLqKj2Lo2cKWHS22k/SipsPRNG5rvcOMQaTNh1
        b+gzqC9dogaTNedByUhgr3EXn/9GPjOEGSozvqMETw==
X-Google-Smtp-Source: AKy350bf16FZ7d0pqv1wtiB14Mzdq8fqItbMnBkgtO6UJDt+C439ZTHwhXoacOTc99wI+KpKQX9dkw==
X-Received: by 2002:a17:903:1c3:b0:1a1:c3eb:af7 with SMTP id e3-20020a17090301c300b001a1c3eb0af7mr7621875plh.55.1680705080166;
        Wed, 05 Apr 2023 07:31:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23-20020a17090aab9700b0023b29b464f9sm1461889pjq.27.2023.04.05.07.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 07:31:19 -0700 (PDT)
Message-ID: <642d8637.170a0220.7e0a1.30cb@mx.google.com>
Date:   Wed, 05 Apr 2023 07:31:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.177
Subject: stable/linux-5.10.y baseline: 173 runs, 5 regressions (v5.10.177)
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

stable/linux-5.10.y baseline: 173 runs, 5 regressions (v5.10.177)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.177/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.177
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      387078f9030cf336cd9fef521540db75b61615e0 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642d521ebbebd2709979e939

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d521ebbebd2709979e93e
        failing since 76 days (last pass: v5.10.158, first fail: v5.10.164)

    2023-04-05T10:48:44.910734  <8>[   11.118677] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2023-04-05T10:48:44.910922  + set +x
    2023-04-05T10:48:44.917523  <8>[   11.130131] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3472810_1.5.2.4.1>
    2023-04-05T10:48:45.026722  =

    2023-04-05T10:48:45.131717  / # #export SHELL=3D/bin/sh
    2023-04-05T10:48:45.132320  =

    2023-04-05T10:48:45.237105  / # export SHELL=3D/bin/sh. /lava-3472810/e=
nvironment
    2023-04-05T10:48:45.237710  =

    2023-04-05T10:48:45.237975  / # <3>[   11.371460] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-04-05T10:48:45.345912  . /lava-3472810/environment/lava-3472810/bi=
n/lava-test-runner /lava-3472810/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d50a2bd4f12a1ba79e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x36=
0-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d50a2bd4f12a1ba79e927
        new failure (last pass: v5.10.176)

    2023-04-05T10:42:33.887277  + set +x

    2023-04-05T10:42:33.893881  <8>[   14.930411] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9876478_1.4.2.3.1>

    2023-04-05T10:42:33.998649  / # #

    2023-04-05T10:42:34.099603  export SHELL=3D/bin/sh

    2023-04-05T10:42:34.099756  #

    2023-04-05T10:42:34.200655  / # export SHELL=3D/bin/sh. /lava-9876478/e=
nvironment

    2023-04-05T10:42:34.200800  =


    2023-04-05T10:42:34.301723  / # . /lava-9876478/environment/lava-987647=
8/bin/lava-test-runner /lava-9876478/1

    2023-04-05T10:42:34.301948  =


    2023-04-05T10:42:34.306719  / # /lava-9876478/bin/lava-test-runner /lav=
a-9876478/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642d5c2b8e0269503179e9a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642d5c2b8e0269503179e=
9a9
        failing since 13 days (last pass: v5.10.175, first fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642d5635f1524dc0fd79e922

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.177/=
arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-k=
evin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642d5635f1524dc0fd79e928
        failing since 18 days (last pass: v5.10.174, first fail: v5.10.175)

    2023-04-05T11:06:03.894964  <8>[   33.946800] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-05T11:06:04.920329  /lava-9876930/1/../bin/lava-test-case

    2023-04-05T11:06:04.931913  <8>[   34.983908] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642d5635f1524dc0fd79e929
        failing since 18 days (last pass: v5.10.174, first fail: v5.10.175)

    2023-04-05T11:06:02.861714  <8>[   32.913112] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-05T11:06:03.883885  /lava-9876930/1/../bin/lava-test-case
   =

 =20
