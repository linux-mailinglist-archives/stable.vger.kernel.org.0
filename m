Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837126ED650
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 22:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbjDXUtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 16:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjDXUtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 16:49:08 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6750555A1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:49:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-63b5ce4f069so6305728b3a.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682369346; x=1684961346;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kZbOiB4WJyWp7+rL4+g1ztoz5kduwCVunLU9ipCXFzQ=;
        b=ZtjvUa5dTcpv+Ta/KnNnMyKpectK6bOBo9LR++4zgaTtgOkE530UMwCS/jvA0XS1Nl
         STdWcNp/CNIWyeDSTRJ1vyrdlWB2FOUiqGTWRGYnCm+148Oc+SpXwb/VlVwYtptbMm6x
         /10Jj+z3HYdX4Hk8S2wRclJQk+XJV6KcYqCu4qLcCYQTIOhabq47vGZ9rRsHsF6Q5vze
         MogUNc/Q7nYTvO3YMVAOZhpaNDC0mbKDAmy5hoCAHl3rteUm+UbBwAfrQwsoz3w7pCY9
         D4cBLegrZLitcEmJ6qfPok/3PFzRA6Fnv3l17o15p1yyfKeZrKoRW1AlicXTaYLiwPL7
         EyQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682369346; x=1684961346;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZbOiB4WJyWp7+rL4+g1ztoz5kduwCVunLU9ipCXFzQ=;
        b=ZOAer4MKiLuW0t2d+QQycW5E48zb5LqvLLnkuL1r1rqfHFcPtfnQJrCK8IrSvHFPtK
         VjuqLxTWb3WDBvaIUoLS/LCL3MTl7p1fOr8VhBbPs7GdX+hp+T1GfNmlGlbbnpCjakpH
         5hJMycDee7ZYsBFuHpjNnA3MzfthRiN2ZUibYKFHKcyrmeZGGzQwmj+gzwD8qicJM5+W
         VL/yvBGpyq0hCie+8MWm46IsozVgEpE6I/wH4m2iAs7ZrtcnebVTtzgEXdbBk0OebpFN
         KwcYNoZhyRzvD94rq/wvYhNnu5XG2KDaUInaLh5EkZnfX2KDJ29BQ+cvVgYCGBlUgwW+
         KeDQ==
X-Gm-Message-State: AAQBX9cdUgaJO70Mp5aqsLNSsfTGO3JythjntD0xvjvjFzF2T2L4NOZk
        TErGO5azViWbtF2dAtWr1HoD7dALU2FgvArYBxILnw==
X-Google-Smtp-Source: AKy350YW6GnueFnLCkS7596XfqLz56IIBrnsL7phFZsUgUPOeCPGOZFJIwCev9t9tY8O4DkbAqQ/YQ==
X-Received: by 2002:a05:6a00:88e:b0:63b:7fa1:f1b1 with SMTP id q14-20020a056a00088e00b0063b7fa1f1b1mr19039206pfj.26.1682369346492;
        Mon, 24 Apr 2023 13:49:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s12-20020a056a00178c00b0062e12f945adsm7820117pfg.135.2023.04.24.13.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 13:49:06 -0700 (PDT)
Message-ID: <6446eb42.050a0220.46c64.f5d1@mx.google.com>
Date:   Mon, 24 Apr 2023 13:49:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-362-gf60697021deb1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 130 runs,
 6 regressions (v5.10.176-362-gf60697021deb1)
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

stable-rc/queue/5.10 baseline: 130 runs, 6 regressions (v5.10.176-362-gf606=
97021deb1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-362-gf60697021deb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-362-gf60697021deb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f60697021deb1be84a71a74dd1066ed9c7ca32a3 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6446b5e63a14e186232e85ef

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446b5e63a14e186232e861f
        failing since 69 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-24T17:01:16.299652  <8>[   20.656349] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 380606_1.5.2.4.1>
    2023-04-24T17:01:16.407243  / # #
    2023-04-24T17:01:16.509266  export SHELL=3D/bin/sh
    2023-04-24T17:01:16.509963  #
    2023-04-24T17:01:16.611595  / # export SHELL=3D/bin/sh. /lava-380606/en=
vironment
    2023-04-24T17:01:16.611997  =

    2023-04-24T17:01:16.713277  / # . /lava-380606/environment/lava-380606/=
bin/lava-test-runner /lava-380606/1
    2023-04-24T17:01:16.714334  =

    2023-04-24T17:01:16.717828  / # /lava-380606/bin/lava-test-runner /lava=
-380606/1
    2023-04-24T17:01:16.828401  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6446b707667a750f8b2e85ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446b707667a750f8b2e85f1
        failing since 88 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-24T17:05:52.428251  + set +x<8>[   11.026341] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3527942_1.5.2.4.1>
    2023-04-24T17:05:52.428825  =

    2023-04-24T17:05:52.538471  / # #
    2023-04-24T17:05:52.641570  export SHELL=3D/bin/sh
    2023-04-24T17:05:52.642527  #
    2023-04-24T17:05:52.744386  / # export SHELL=3D/bin/sh. /lava-3527942/e=
nvironment
    2023-04-24T17:05:52.745303  =

    2023-04-24T17:05:52.847497  / # . /lava-3527942/environment/lava-352794=
2/bin/lava-test-runner /lava-3527942/1
    2023-04-24T17:05:52.849178  =

    2023-04-24T17:05:52.849600  / # <3>[   11.371148] Bluetooth: hci0: comm=
and 0x0c03 tx timeout =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446b9e67b0fab7c982e8696

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446b9e67b0fab7c982e869b
        failing since 25 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-24T17:18:14.907835  + set +x

    2023-04-24T17:18:14.914759  <8>[   10.502100] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10106713_1.4.2.3.1>

    2023-04-24T17:18:15.019148  / # #

    2023-04-24T17:18:15.119796  export SHELL=3D/bin/sh

    2023-04-24T17:18:15.120011  #

    2023-04-24T17:18:15.220537  / # export SHELL=3D/bin/sh. /lava-10106713/=
environment

    2023-04-24T17:18:15.220737  =


    2023-04-24T17:18:15.321262  / # . /lava-10106713/environment/lava-10106=
713/bin/lava-test-runner /lava-10106713/1

    2023-04-24T17:18:15.321546  =


    2023-04-24T17:18:15.326049  / # /lava-10106713/bin/lava-test-runner /la=
va-10106713/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446b9dffb721d0a422e85eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446b9dffb721d0a422e85f0
        failing since 25 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-24T17:18:03.547645  <8>[   11.962276] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10106649_1.4.2.3.1>

    2023-04-24T17:18:03.550899  + set +x

    2023-04-24T17:18:03.658947  / # #

    2023-04-24T17:18:03.761321  export SHELL=3D/bin/sh

    2023-04-24T17:18:03.762057  #

    2023-04-24T17:18:03.863323  / # export SHELL=3D/bin/sh. /lava-10106649/=
environment

    2023-04-24T17:18:03.863560  =


    2023-04-24T17:18:03.964206  / # . /lava-10106649/environment/lava-10106=
649/bin/lava-test-runner /lava-10106649/1

    2023-04-24T17:18:03.964531  =


    2023-04-24T17:18:03.970331  / # /lava-10106649/bin/lava-test-runner /la=
va-10106649/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6446bb03417e4ad20c2e8634

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-362-gf60697021deb1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6446bb03417e4ad20c2e863a
        failing since 41 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-24T17:23:10.440753  /lava-10106924/1/../bin/lava-test-case

    2023-04-24T17:23:10.452190  <8>[   35.181003] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6446bb03417e4ad20c2e863b
        failing since 41 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-24T17:23:09.403627  /lava-10106924/1/../bin/lava-test-case

    2023-04-24T17:23:09.414774  <8>[   34.143935] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
