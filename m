Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944946DC847
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 17:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDJPRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 11:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDJPRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 11:17:07 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B518D
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 08:17:05 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 20so6720911plk.10
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 08:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681139825; x=1683731825;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ch3uEttOUVXkWXhH10mgJDqcW/95qREGaj2Q3cvyQeQ=;
        b=Pwb73hKMub+Vf6jAF6ib5Yp35YtJUwLx3+P9yMTpLwZtJ6gbjWNwiKeUb3RjYVZyi/
         GdLb8x5fBCnG3f+dTXyM022hwFmn37pb4zyC9JhArsd7PREH9GwLKBUtuChXuLCVmXyV
         ybDZyc+COMurVbMETt/ATF/IvyChXd9h4Qky9pHXlkVyj42leNtShI/RapzfCOgCZG2n
         G7AddgBqHNdcW1+pl8N65OcJ14k0dI11VE709X8aL8Uf6VzE6126enopmNtfIL2B6vxL
         YgLgOjzqdMbTPm2uX+e9pD+5zH0kGdYrtUwcU4Sd3zRWeokwDt1rCMkymYDj5/pgVhfV
         qFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681139825; x=1683731825;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ch3uEttOUVXkWXhH10mgJDqcW/95qREGaj2Q3cvyQeQ=;
        b=lfPph84pkbokXgrcdjAtj31yfq9vDfdFYH1WVeVX4T9o9feVYI/9+W542mU7CIJthf
         jNYTRF7FWfzxP3ERNhxDl9mACnaUJPiKW7YoXyE85o3JcKrwnma1tmfZsBDK+ZMUG9u8
         OMUqF9EzDpufJht4NfqZfP1FUsl7VONTzvQV/wKoIZpFnm0pi2+c6DsaXCUJCVeFNqn6
         PhoubXXCijLhgrZP/QTLtvwuwxdbwj3vLLh3jjAgn6byMQm/SncTcG7NAhwUAdC2VYM6
         5au42D3WFLAGLSyW4udvfMJXjC7WZM31tDKvBbjy+4ONN/kmVEcdXv24NjMOyqoCjnyG
         FBAg==
X-Gm-Message-State: AAQBX9ef3gvqipAp4Is8dboOfkA58yAXrHJ6+W9bNJVxf1BKiWMBNafm
        mQxIFzwfuZnH0eLDTfiPBXZ4fcfln2Hmgomh1b9bug==
X-Google-Smtp-Source: AKy350YnsT9xnymvRx3zQmbQcPtdqHRkEMNLJ8wnK45mwqxrInm3f4uFCC9UDwoaId5iKnwqN2NlQg==
X-Received: by 2002:a17:90a:49:b0:23e:fa90:ba37 with SMTP id 9-20020a17090a004900b0023efa90ba37mr12216642pjb.49.1681139824872;
        Mon, 10 Apr 2023 08:17:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k60-20020a17090a4cc200b0023f5c867f82sm9336677pjh.41.2023.04.10.08.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 08:17:04 -0700 (PDT)
Message-ID: <64342870.170a0220.1f441.19cf@mx.google.com>
Date:   Mon, 10 Apr 2023 08:17:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-193-g28e6f16b3a0b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 7 regressions (v5.10.176-193-g28e6f16b3a0b)
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

stable-rc/queue/5.10 baseline: 168 runs, 7 regressions (v5.10.176-193-g28e6=
f16b3a0b)

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
nel/v5.10.176-193-g28e6f16b3a0b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-193-g28e6f16b3a0b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28e6f16b3a0bdc5fb99e677008fb5ad1aad31c9f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f62d5d540e35d479e938

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f62e5d540e35d479e972
        failing since 55 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-10T11:42:21.637078  + set +x
    2023-04-10T11:42:21.639981  <8>[   21.045744] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 305771_1.5.2.4.1>
    2023-04-10T11:42:21.749357  / # #
    2023-04-10T11:42:21.852030  export SHELL=3D/bin/sh
    2023-04-10T11:42:21.852518  #
    2023-04-10T11:42:21.954240  / # export SHELL=3D/bin/sh. /lava-305771/en=
vironment
    2023-04-10T11:42:21.954800  =

    2023-04-10T11:42:22.056463  / # . /lava-305771/environment/lava-305771/=
bin/lava-test-runner /lava-305771/1
    2023-04-10T11:42:22.057463  =

    2023-04-10T11:42:22.061742  / # /lava-305771/bin/lava-test-runner /lava=
-305771/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f41261bf5e459a79e945

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f41261bf5e459a79e94e
        failing since 73 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-10T11:33:07.920595  <8>[   11.045850] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3482681_1.5.2.4.1>
    2023-04-10T11:33:08.027714  / # #
    2023-04-10T11:33:08.129340  export SHELL=3D/bin/sh
    2023-04-10T11:33:08.129897  #
    2023-04-10T11:33:08.231294  / # export SHELL=3D/bin/sh. /lava-3482681/e=
nvironment
    2023-04-10T11:33:08.231921  =

    2023-04-10T11:33:08.333290  / # . /lava-3482681/environment/lava-348268=
1/bin/lava-test-runner /lava-3482681/1
    2023-04-10T11:33:08.334127  =

    2023-04-10T11:33:08.334380  / # /lava-3482681/bin/lava-test-runner /lav=
a-3482681/1<3>[   11.450930] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-10T11:33:08.338580   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f44fce7e11455479e922

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f44fce7e11455479e92b
        failing since 11 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-10T11:34:27.442925  + set +x

    2023-04-10T11:34:27.449129  <8>[   10.226902] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925936_1.4.2.3.1>

    2023-04-10T11:34:27.554259  / # #

    2023-04-10T11:34:27.655230  export SHELL=3D/bin/sh

    2023-04-10T11:34:27.655428  #

    2023-04-10T11:34:27.756360  / # export SHELL=3D/bin/sh. /lava-9925936/e=
nvironment

    2023-04-10T11:34:27.756559  =


    2023-04-10T11:34:27.857471  / # . /lava-9925936/environment/lava-992593=
6/bin/lava-test-runner /lava-9925936/1

    2023-04-10T11:34:27.857765  =


    2023-04-10T11:34:27.862201  / # /lava-9925936/bin/lava-test-runner /lav=
a-9925936/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f45b186ad755e479e927

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f45b186ad755e479e930
        failing since 11 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-10T11:34:36.414529  <8>[   12.430519] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9925975_1.4.2.3.1>

    2023-04-10T11:34:36.418097  + set +x

    2023-04-10T11:34:36.524546  =


    2023-04-10T11:34:36.626510  / # #export SHELL=3D/bin/sh

    2023-04-10T11:34:36.627290  =


    2023-04-10T11:34:36.729211  / # export SHELL=3D/bin/sh. /lava-9925975/e=
nvironment

    2023-04-10T11:34:36.729923  =


    2023-04-10T11:34:36.831734  / # . /lava-9925975/environment/lava-992597=
5/bin/lava-test-runner /lava-9925975/1

    2023-04-10T11:34:36.833120  =


    2023-04-10T11:34:36.838078  / # /lava-9925975/bin/lava-test-runner /lav=
a-9925975/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6433f4f80953ba9b2279e97c

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6433f4f80953ba9b2279e986
        failing since 27 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-10T11:37:20.930172  /lava-9926024/1/../bin/lava-test-case

    2023-04-10T11:37:20.941265  <8>[   35.344868] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6433f4f90953ba9b2279e987
        failing since 27 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-10T11:37:19.892985  /lava-9926024/1/../bin/lava-test-case

    2023-04-10T11:37:19.903830  <8>[   34.307871] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6433f3e2e2cc799deb79e980

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-193-g28e6f16b3a0b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6433f3e2e2cc799deb79e989
        failing since 67 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-10T11:32:25.949667  / # #
    2023-04-10T11:32:26.051499  export SHELL=3D/bin/sh
    2023-04-10T11:32:26.052005  #
    2023-04-10T11:32:26.153363  / # export SHELL=3D/bin/sh. /lava-3482686/e=
nvironment
    2023-04-10T11:32:26.153808  =

    2023-04-10T11:32:26.255151  / # . /lava-3482686/environment/lava-348268=
6/bin/lava-test-runner /lava-3482686/1
    2023-04-10T11:32:26.255874  =

    2023-04-10T11:32:26.273935  / # /lava-3482686/bin/lava-test-runner /lav=
a-3482686/1
    2023-04-10T11:32:26.322022  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-10T11:32:26.361807  + cd /lava-3482686/1/tests/1_bootrr =

    ... (9 line(s) more)  =

 =20
