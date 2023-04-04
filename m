Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E19D6D6D6D
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 21:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbjDDTwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 15:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDDTwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 15:52:15 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A08A8
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 12:52:14 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id le6so32352650plb.12
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 12:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680637934;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fg89D9BHaVsqIHRZHX5+z8a4Ortfvcn44xFy2UdQE18=;
        b=IiUCuHjV3wKnsOKjqGzswOSe3xUuU1ypGv7R2ZrPyyoNJKv2Q+TuRohNpFPBIC1que
         g+NWijvT2rDVY3pmsP0B4uwN27s9uCMlgMPLvUjZWqB/OiKJdPipPcEhV0g7VQ+PGYDM
         6hgVFNnM1mJoXJZ/f0OjrkTIipvDGjt2KnLKKzLaqONmRzal4eYxfEr8nrsLzCxS8u7b
         0kT3GEzlbLMvu2V7Mism8qm0O7NU9orKpC8LNahV8e/l/4QvkP2TbYu/NsuhQYySWHGy
         Hx+fRoc9XfNi2FbHQ35bGO1RD/siDPgMQPtmR6Ss4yi0wge1fIRLGrisEIte6sA2QVFI
         FzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680637934;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fg89D9BHaVsqIHRZHX5+z8a4Ortfvcn44xFy2UdQE18=;
        b=UfF0R1gj5KLIbZziErDAmxyIlrF2Sv8Okx6qA847K/Qr50bCqI74TS69QlNXnJ7dJF
         kVx0oi7c53kOD252zGr0hDNIJ/2+WMfCBi5dTBOubuetUDJJ8MDz9iWhZXm9lII/+YQu
         Fvwwrho3xf0ISF9PSDuEQX2lhZtzTO4PVAMWhTES1W0Bedzfvk2hFbw9dIsgbuIRJlGV
         IIzd52C3KD8XskeaHRvUzyttGEeI3xio0XBBH4jOYwtwUX3zCcgnk+7SgTwX1D9ju3jX
         jGbJjTnYKmnzaIrGJHLEhyAM8t5yE0cdhitTx37oRWoz8yRfw42qH7keQyRkN2bdaCI2
         HonQ==
X-Gm-Message-State: AAQBX9cDMXHhjJo1YtR1fVlQb3O9RUOig2hVQTaxp84RKY0oAjyrD6Q0
        jfRLdOjWzhfi2CZqnACxygLk+p1n+CsaprHjAaASZQ==
X-Google-Smtp-Source: AKy350Y05ohWUjmqeN1GKEz9vfI6Br9bHaBtZZWkd89ZIy/GXgu69mBpmFlre3m42Ni467v1q8uACw==
X-Received: by 2002:a17:90b:3807:b0:240:883:8ff8 with SMTP id mq7-20020a17090b380700b0024008838ff8mr4319708pjb.3.1680637933646;
        Tue, 04 Apr 2023 12:52:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mr17-20020a17090b239100b002369a14d6b1sm11733339pjb.31.2023.04.04.12.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 12:52:13 -0700 (PDT)
Message-ID: <642c7fed.170a0220.eeba8.7e14@mx.google.com>
Date:   Tue, 04 Apr 2023 12:52:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-173-g289dea448dc04
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 6 regressions (v5.10.176-173-g289dea448dc04)
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

stable-rc/queue/5.10 baseline: 157 runs, 6 regressions (v5.10.176-173-g289d=
ea448dc04)

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

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-173-g289dea448dc04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-173-g289dea448dc04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      289dea448dc04aa506a320e9776764a9a9596e70 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642c4f1d881032700079e99f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c4f1d881032700079e9a4
        failing since 68 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-04T16:23:46.868884  <8>[   11.098784] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3470825_1.5.2.4.1>
    2023-04-04T16:23:46.975324  / # #
    2023-04-04T16:23:47.076878  export SHELL=3D/bin/sh
    2023-04-04T16:23:47.077266  #
    2023-04-04T16:23:47.178424  / # export SHELL=3D/bin/sh. /lava-3470825/e=
nvironment
    2023-04-04T16:23:47.178794  =

    2023-04-04T16:23:47.280007  / # . /lava-3470825/environment/lava-347082=
5/bin/lava-test-runner /lava-3470825/1
    2023-04-04T16:23:47.280522  =

    2023-04-04T16:23:47.285480  / # /lava-3470825/bin/lava-test-runner /lav=
a-3470825/1
    2023-04-04T16:23:47.371320  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c4b553bdfb4e9f679e9c1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c4b553bdfb4e9f679e9c6
        failing since 5 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-04T16:07:38.146868  + set +x

    2023-04-04T16:07:38.153298  <8>[   15.060616] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9864128_1.4.2.3.1>

    2023-04-04T16:07:38.258035  / # #

    2023-04-04T16:07:38.359040  export SHELL=3D/bin/sh

    2023-04-04T16:07:38.359231  #

    2023-04-04T16:07:38.459985  / # export SHELL=3D/bin/sh. /lava-9864128/e=
nvironment

    2023-04-04T16:07:38.460210  =


    2023-04-04T16:07:38.561188  / # . /lava-9864128/environment/lava-986412=
8/bin/lava-test-runner /lava-9864128/1

    2023-04-04T16:07:38.561460  =


    2023-04-04T16:07:38.565445  / # /lava-9864128/bin/lava-test-runner /lav=
a-9864128/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642c4b533bdfb4e9f679e99e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c4b533bdfb4e9f679e9a3
        failing since 5 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-04T16:07:32.548468  + set +x<8>[   12.941655] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9864170_1.4.2.3.1>

    2023-04-04T16:07:32.548933  =


    2023-04-04T16:07:32.656331  #

    2023-04-04T16:07:32.759259  / # #export SHELL=3D/bin/sh

    2023-04-04T16:07:32.760236  =


    2023-04-04T16:07:32.862404  / # export SHELL=3D/bin/sh. /lava-9864170/e=
nvironment

    2023-04-04T16:07:32.863113  =


    2023-04-04T16:07:32.964900  / # . /lava-9864170/environment/lava-986417=
0/bin/lava-test-runner /lava-9864170/1

    2023-04-04T16:07:32.966079  =


    2023-04-04T16:07:32.970839  / # /lava-9864170/bin/lava-test-runner /lav=
a-9864170/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642c4b49f096237bef79e955

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642c4b49f096237bef79e95b
        failing since 21 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-04T16:07:22.664727  /lava-9864080/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642c4b49f096237bef79e95c
        failing since 21 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-04T16:07:20.606071  <8>[   60.010940] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-04T16:07:21.629932  /lava-9864080/1/../bin/lava-test-case

    2023-04-04T16:07:21.641282  <8>[   61.046282] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642c4f10d955e769b779e9c5

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-173-g289dea448dc04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642c4f10d955e769b779e9ca
        failing since 61 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-04T16:23:22.163779  / # #
    2023-04-04T16:23:22.265768  export SHELL=3D/bin/sh
    2023-04-04T16:23:22.266218  #
    2023-04-04T16:23:22.367645  / # export SHELL=3D/bin/sh. /lava-3470833/e=
nvironment
    2023-04-04T16:23:22.368161  =

    2023-04-04T16:23:22.469597  / # . /lava-3470833/environment/lava-347083=
3/bin/lava-test-runner /lava-3470833/1
    2023-04-04T16:23:22.470321  =

    2023-04-04T16:23:22.474530  / # /lava-3470833/bin/lava-test-runner /lav=
a-3470833/1
    2023-04-04T16:23:22.573453  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-04T16:23:22.573738  + cd /lava-3470833/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
