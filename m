Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790EE6E3444
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 00:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjDOWKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 18:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjDOWKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 18:10:22 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB1D2738
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 15:10:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id y11-20020a17090a600b00b0024693e96b58so21274233pji.1
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 15:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681596620; x=1684188620;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=D5eqQNyPBxAyo6HAlfB4/+4pCajd4NhrEq4Fa7ljvAQ=;
        b=yd6B27ePJo//RaohLlpkw3tMCQw+eQ3WJdFVkkSGH8oC4MVNwPxaeKvTeRG41WFPZ+
         6M5O1zyGKuwellr8/jVb9Z8wXT5e8fbExIyeYF6MFDmTf+6MjQSueBIWOghrCO62Af6c
         8C3N7eBkngfWTbuXs43rFeezqbjHXzYrh59idiTFxM9V8zCABHxPS/B84Keq/4/mhlRN
         AyaVT8bML2fLUvEiJn36ciU4XqG2qHsypB+HXg4EIrLna7hKYzTK63DlSMShuxAzyufg
         RCn9p3pVz0Pl31tBx7cje7z5fyyEmPrY3QtFu5eYhvOdfdKGa3wnvq875AKH6f22V5N6
         XHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681596620; x=1684188620;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5eqQNyPBxAyo6HAlfB4/+4pCajd4NhrEq4Fa7ljvAQ=;
        b=XgcpbBu1hsu3Mr8tTEe3G8/9VVOVDpm9XhReEanKfW2qIHiMow6Ao+h5Thg8b4QYAh
         zsVDFAIYdOKZ4xoNL0dkpReOP7aAXvMqeCqhenaBJeeX/UpxgQEHBHzLV1Py7NjXhIiX
         X+eNEYo55vDZ1gVy1UFBXE/mZjYlqMsX01gtfM7hk4xex6FHyTXGmYpZdsXaTQHVkO21
         FuvGZJmAoFuKUPLHopq6q6TQM1q3bnoeOOF5svY0d9/V4x/jSJ7GRDERlQb/zg2RcU/E
         EA6+lv0206UVHNwFW0V0R+VDP+WxfftI55lZtjG/hwDXgbnHHMwyeLl0M9YvZh19LXAP
         D9/A==
X-Gm-Message-State: AAQBX9dsM7fnn29WN1A8MegKen+1jmuuniyCtCiTG0BX2zTvd45K7fVH
        an/qVtMmtrNFaPXHDuwzvZx/Awxx2s56PPoPjQBfHRRV
X-Google-Smtp-Source: AKy350YYnPpRpz0C4giggjOwuuIbfMusBmQLk25EbzZ0/AEjSxmQj+Rqz2NAUKBCE7n0L4yWb96zCw==
X-Received: by 2002:a17:902:f684:b0:19f:1871:3dcd with SMTP id l4-20020a170902f68400b0019f18713dcdmr9390774plg.5.1681596620187;
        Sat, 15 Apr 2023 15:10:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bx1-20020a17090af48100b00233ccd04a15sm6455185pjb.24.2023.04.15.15.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 15:10:19 -0700 (PDT)
Message-ID: <643b20cb.170a0220.c7a68.e96d@mx.google.com>
Date:   Sat, 15 Apr 2023 15:10:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-236-g7e22bbb6096b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 191 runs,
 7 regressions (v5.10.176-236-g7e22bbb6096b)
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

stable-rc/queue/5.10 baseline: 191 runs, 7 regressions (v5.10.176-236-g7e22=
bbb6096b)

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
nel/v5.10.176-236-g7e22bbb6096b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-236-g7e22bbb6096b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e22bbb6096bcec28a20155476681933d72b631a =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643aee1391f440a5d02e8604

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643aee1391f440a5d02e863a
        failing since 60 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-15T18:33:43.386691  <8>[   19.653381] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 333466_1.5.2.4.1>
    2023-04-15T18:33:43.496834  / # #
    2023-04-15T18:33:43.599291  export SHELL=3D/bin/sh
    2023-04-15T18:33:43.599915  #
    2023-04-15T18:33:43.701524  / # export SHELL=3D/bin/sh. /lava-333466/en=
vironment
    2023-04-15T18:33:43.702381  =

    2023-04-15T18:33:43.804548  / # . /lava-333466/environment/lava-333466/=
bin/lava-test-runner /lava-333466/1
    2023-04-15T18:33:43.805576  =

    2023-04-15T18:33:43.810153  / # /lava-333466/bin/lava-test-runner /lava=
-333466/1
    2023-04-15T18:33:43.918208  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643aedd804e611548a2e85f1

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643aedd804e611548a2e85f6
        failing since 79 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-15T18:32:28.881757  <8>[   11.065439] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3498986_1.5.2.4.1>
    2023-04-15T18:32:28.991164  / # #
    2023-04-15T18:32:29.094440  export SHELL=3D/bin/sh
    2023-04-15T18:32:29.095575  #
    2023-04-15T18:32:29.197709  / # export SHELL=3D/bin/sh. /lava-3498986/e=
nvironment
    2023-04-15T18:32:29.198836  =

    2023-04-15T18:32:29.199365  / # . /lava-3498986/environment<3>[   11.37=
1142] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-15T18:32:29.301423  /lava-3498986/bin/lava-test-runner /lava-34=
98986/1
    2023-04-15T18:32:29.302899  =

    2023-04-15T18:32:29.307608  / # /lava-3498986/bin/lava-test-runner /lav=
a-3498986/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643aed9799273149502e8633

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643aed9799273149502e8638
        failing since 16 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-15T18:31:39.446187  + <8>[   14.365892] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9994980_1.4.2.3.1>

    2023-04-15T18:31:39.446288  set +x

    2023-04-15T18:31:39.547988  #

    2023-04-15T18:31:39.548362  =


    2023-04-15T18:31:39.649437  / # #export SHELL=3D/bin/sh

    2023-04-15T18:31:39.649719  =


    2023-04-15T18:31:39.750571  / # export SHELL=3D/bin/sh. /lava-9994980/e=
nvironment

    2023-04-15T18:31:39.750840  =


    2023-04-15T18:31:39.851861  / # . /lava-9994980/environment/lava-999498=
0/bin/lava-test-runner /lava-9994980/1

    2023-04-15T18:31:39.852260  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643aebdf1f026d126a2e865a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643aebdf1f026d126a2e865f
        failing since 16 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-15T18:24:16.233395  <8>[   12.412567] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9995022_1.4.2.3.1>

    2023-04-15T18:24:16.236578  + set +x

    2023-04-15T18:24:16.338563  =


    2023-04-15T18:24:16.439506  / # #export SHELL=3D/bin/sh

    2023-04-15T18:24:16.439746  =


    2023-04-15T18:24:16.540662  / # export SHELL=3D/bin/sh. /lava-9995022/e=
nvironment

    2023-04-15T18:24:16.540890  =


    2023-04-15T18:24:16.641853  / # . /lava-9995022/environment/lava-999502=
2/bin/lava-test-runner /lava-9995022/1

    2023-04-15T18:24:16.642243  =


    2023-04-15T18:24:16.646773  / # /lava-9995022/bin/lava-test-runner /lav=
a-9995022/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643aed458b7c9fd88b2e864f

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643aed458b7c9fd88b2e8655
        failing since 32 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-15T18:30:23.800471  /lava-9995103/1/../bin/lava-test-case

    2023-04-15T18:30:23.811615  <8>[   62.099023] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643aed458b7c9fd88b2e8656
        failing since 32 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-15T18:30:21.739243  <8>[   60.025536] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-15T18:30:22.763851  /lava-9995103/1/../bin/lava-test-case

    2023-04-15T18:30:22.774534  <8>[   61.062096] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643aeda33d05ddd8da2e86c7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-236-g7e22bbb6096b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643aeda33d05ddd8da2e86cc
        failing since 72 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-15T18:31:50.071670  / # #
    2023-04-15T18:31:50.173706  export SHELL=3D/bin/sh
    2023-04-15T18:31:50.174135  #
    2023-04-15T18:31:50.275476  / # export SHELL=3D/bin/sh. /lava-3498988/e=
nvironment
    2023-04-15T18:31:50.275974  =

    2023-04-15T18:31:50.377363  / # . /lava-3498988/environment/lava-349898=
8/bin/lava-test-runner /lava-3498988/1
    2023-04-15T18:31:50.378330  =

    2023-04-15T18:31:50.383998  / # /lava-3498988/bin/lava-test-runner /lav=
a-3498988/1
    2023-04-15T18:31:50.481014  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-15T18:31:50.481374  + cd /lava-3498988/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
