Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9636DE688
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 23:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjDKVfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 17:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDKVfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 17:35:18 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F388559A
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 14:35:12 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id y11-20020a17090a600b00b0024693e96b58so8383369pji.1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 14:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681248912; x=1683840912;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MwLidB+NPtaQ+0p96ZlxzXLajIZhk2tB9A6p05iVCYg=;
        b=6e10WREqhDt+byh+EbEoJtHo8AXNi3CsDc/w0z89BNhnkOtPlrSGDIyvA7Tu6EK6sA
         SABns+kAMN3G3PEEA3GmutNwWqtoXr2/t0NwgDxCYgHf1MnPRtvyi67/5LYvc6kStbaw
         RYTsf6BWX6IdPx5sc5Skr8cR7CEzOimyMbaekQzrxL2XOP6rXmkxtLNsN4Xy+TvkLr6/
         3GtcbnlGCLykB7grlzCLkTQtq9G1tI/eRP3zkounq8LOyV1Q2fh58uRaK+xLu2k0Vkyl
         MSsefof4Ly45a/gWny2zFghgxsfd/WGEX2x9xPa/B4poaPjfdWSMHsNag+OUAm+K2Vc+
         FTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681248912; x=1683840912;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MwLidB+NPtaQ+0p96ZlxzXLajIZhk2tB9A6p05iVCYg=;
        b=JqSuYN8c+eAntzHi7EL2KYVIyx9R+1eMWIjpzh+aSKdcElQdRq+IOdvpqHrdI2MVBz
         wIL8jPlVAdWFFgdHvxmNAC4RhgTY3NLpMjx1c8LVMpvdqWvpZ4As0D/rcfOhQebRA5cU
         n2LZMby2AX5mrTHF92ww4WTOGUbHt3clu/FbrH1t1cb2pBh+HNDi8JGbQzVjsNZRjJ2e
         KeGNrcyrL0DGRxYad/HM1zPBZc++rAG6ddv0bqIOzUMyaAtOWkpYKAWBteIqkmUxpgap
         sbkFT6ubJMAQKpqcAcZlWmJUdkhqvylve1mlrM5WAJjI+JdVW6NtNz40REj1WQ9CFvHF
         CwIw==
X-Gm-Message-State: AAQBX9dqTKQjC3LiTlQQsckgKap58KGUAIZsnpDm0r8Yde9nEEk0a8nn
        Pi2WTx2+HUkHXanTWA0dzsqRX4CMHYWX+qCLktH3PA==
X-Google-Smtp-Source: AKy350Zr0Gp82BdARILjxMWJ7YmPSVlLsCkrrUl2VfDX/yQDjJp1CgAW2rGHwEEtK31zCnKfT/uMfg==
X-Received: by 2002:a17:90a:4289:b0:246:ac68:d4e9 with SMTP id p9-20020a17090a428900b00246ac68d4e9mr609740pjg.6.1681248911632;
        Tue, 11 Apr 2023 14:35:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n15-20020a17090a2fcf00b0023f786a64ebsm24536pjm.57.2023.04.11.14.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 14:35:11 -0700 (PDT)
Message-ID: <6435d28f.170a0220.5d236.0120@mx.google.com>
Date:   Tue, 11 Apr 2023 14:35:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-223-gfbdc537713e0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 181 runs,
 8 regressions (v5.10.176-223-gfbdc537713e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 181 runs, 8 regressions (v5.10.176-223-gfbdc=
537713e0)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =

beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-223-gfbdc537713e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-223-gfbdc537713e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fbdc537713e0b33afb98fe87cbdb62e843ca2ff5 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64359fa7ac01bf2fa32e8613

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64359fa7ac01bf2fa32e8=
614
        new failure (last pass: v5.10.176-223-gb73b161a0e35) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64359f28ac07986a652e85e6

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64359f28ac07986a652e861c
        failing since 56 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-11T17:55:25.494755  <8>[   18.802610] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 312994_1.5.2.4.1>
    2023-04-11T17:55:25.602148  / # #
    2023-04-11T17:55:25.704415  export SHELL=3D/bin/sh
    2023-04-11T17:55:25.705216  #
    2023-04-11T17:55:25.807289  / # export SHELL=3D/bin/sh. /lava-312994/en=
vironment
    2023-04-11T17:55:25.808158  =

    2023-04-11T17:55:25.910395  / # . /lava-312994/environment/lava-312994/=
bin/lava-test-runner /lava-312994/1
    2023-04-11T17:55:25.911654  =

    2023-04-11T17:55:25.915327  / # /lava-312994/bin/lava-test-runner /lava=
-312994/1
    2023-04-11T17:55:26.013785  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6435a21bfa79b3a6e42e8641

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435a21bfa79b3a6e42e8646
        failing since 75 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-11T18:08:07.427430  <8>[   11.013563] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3486434_1.5.2.4.1>
    2023-04-11T18:08:07.537089  / # #
    2023-04-11T18:08:07.640090  export SHELL=3D/bin/sh
    2023-04-11T18:08:07.640882  #
    2023-04-11T18:08:07.742531  / # export SHELL=3D/bin/sh. /lava-3486434/e=
nvironment
    2023-04-11T18:08:07.743111  =

    2023-04-11T18:08:07.844854  / # . /lava-3486434/environment/lava-348643=
4/bin/lava-test-runner /lava-3486434/1
    2023-04-11T18:08:07.846148  =

    2023-04-11T18:08:07.851256  / # /lava-3486434/bin/lava-test-runner /lav=
a-3486434/1
    2023-04-11T18:08:07.895351  <3>[   11.451384] Bluetooth: hci0: command =
0xfc18 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435a53930e5929f332e8623

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435a53930e5929f332e8628
        failing since 12 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-11T18:21:29.228513  + set +x

    2023-04-11T18:21:29.235340  <8>[   10.737115] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9941495_1.4.2.3.1>

    2023-04-11T18:21:29.340077  / # #

    2023-04-11T18:21:29.441176  export SHELL=3D/bin/sh

    2023-04-11T18:21:29.441401  #

    2023-04-11T18:21:29.542296  / # export SHELL=3D/bin/sh. /lava-9941495/e=
nvironment

    2023-04-11T18:21:29.542543  =


    2023-04-11T18:21:29.643500  / # . /lava-9941495/environment/lava-994149=
5/bin/lava-test-runner /lava-9941495/1

    2023-04-11T18:21:29.643855  =


    2023-04-11T18:21:29.648123  / # /lava-9941495/bin/lava-test-runner /lav=
a-9941495/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6435a30d1ee6f6a8bf2e85f6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435a30d1ee6f6a8bf2e85fb
        failing since 12 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-11T18:12:11.384631  + set +x<8>[   12.888932] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9941535_1.4.2.3.1>

    2023-04-11T18:12:11.385065  =


    2023-04-11T18:12:11.492532  /#

    2023-04-11T18:12:11.595625   # #export SHELL=3D/bin/sh

    2023-04-11T18:12:11.596328  =


    2023-04-11T18:12:11.698287  / # export SHELL=3D/bin/sh. /lava-9941535/e=
nvironment

    2023-04-11T18:12:11.699118  =


    2023-04-11T18:12:11.801253  / # . /lava-9941535/environment/lava-994153=
5/bin/lava-test-runner /lava-9941535/1

    2023-04-11T18:12:11.802456  =


    2023-04-11T18:12:11.807581  / # /lava-9941535/bin/lava-test-runner /lav=
a-9941535/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6435a09cb150f8cbe42e8656

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6435a09cb150f8cbe42e865c
        failing since 28 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-11T18:01:48.909824  <8>[   61.042851] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-11T18:01:49.935492  /lava-9941655/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6435a09cb150f8cbe42e865d
        failing since 28 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-11T18:01:47.873525  <8>[   60.005389] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-11T18:01:48.898535  /lava-9941655/1/../bin/lava-test-case
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6435a1bb36e838891d2e8607

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-223-gfbdc537713e0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6435a1bb36e838891d2e860c
        failing since 68 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-11T18:06:30.872978  / # #
    2023-04-11T18:06:30.974889  export SHELL=3D/bin/sh
    2023-04-11T18:06:30.975647  #
    2023-04-11T18:06:31.077284  / # export SHELL=3D/bin/sh. /lava-3486427/e=
nvironment
    2023-04-11T18:06:31.078017  =

    2023-04-11T18:06:31.179776  / # . /lava-3486427/environment/lava-348642=
7/bin/lava-test-runner /lava-3486427/1
    2023-04-11T18:06:31.180700  =

    2023-04-11T18:06:31.199251  / # /lava-3486427/bin/lava-test-runner /lav=
a-3486427/1
    2023-04-11T18:06:31.304334  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-11T18:06:31.305018  + cd /lava-3486427/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
