Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0306D3D20
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 08:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDCGKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 02:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDCGKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 02:10:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964EB527F
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 23:10:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so29351437pjt.5
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 23:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680502222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1lWLLJ45RvFnPQFPa1DPf8tAA5KiZhHMQMkenLbOXQ=;
        b=CNXoj7wHRMk+VTrTU9DaPVa4d31cHI7YKYI0t6PKGPet6NEsgoBQ+I2F+1dUwkMW77
         3ZGNFxKJXC+OKlDuvrVtqZeu6SU0/W+9wGI8bixERj6zhHNdGxlLs9lVQ6Lm5MISuNHG
         kfwc6rdamUHgL2O/BCocoVdfbLTxmMSagfB4Vigy5ZYU9+3nW8cN6UsnyhQj6aXuvuhq
         C43Z5hUUIALwptjNCHDPMJg1dXTZQXtb4zrqs8JuSHIsC3158xFzTBFO1AGEgZRC1Od2
         crwy7usiAzrqJMCuXoBVpBSqF7SVxYpajJZ4IZcp/d47+L4MV7BTewJURFPMkFYtrRyX
         YSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680502222;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y1lWLLJ45RvFnPQFPa1DPf8tAA5KiZhHMQMkenLbOXQ=;
        b=y03Hl1fpqVCsxLgsoAAQtxxDzYG1AZ5uTRHscBeh4cEQcKyVK4suEz6+peODwkiHui
         1hx31gd3UR7ohGX4gRA6VnrEKzvxYHhOxsBcINI+PQb3PZT+EWbI09FcfI5u6Yy3QWcH
         iiH4NkRD97WMtswm4GBGo504NvwS8sz/CMFEENZlu3LhsnbLs3ToysWSAIk0Huu7yC55
         w1WKqlofvArYrtbEGHYAvhIx+5zdB8Vk9BpVicpO1l0HbYA9Z3K5rn+wSGIsv1zs1Qoq
         jVnBgCjC+XVr6WFbOCzb4hsfB11+lmRtXkEyDO47tcB+Yy96g8uAiQ83BPa/SWaKGIOp
         SdGQ==
X-Gm-Message-State: AAQBX9deFq+S1d2xOVgXxxaixrSKXEqp4EtBf3Uumni1A2yNpwsJIP70
        5qCtB8Y1jK9kDPxj5EPlGTEHHbd3/EjbfjciUKU=
X-Google-Smtp-Source: AKy350b7c742IFKOFdFK4vC4jRdh4nLDKewELX5TDZQ127KY9Ugwp7KPoPE2xi/oHSRDxFZjiat1+w==
X-Received: by 2002:a17:90b:38c4:b0:23d:2027:c355 with SMTP id nn4-20020a17090b38c400b0023d2027c355mr40461809pjb.10.1680502221829;
        Sun, 02 Apr 2023 23:10:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090a13c300b0023d16f05dd8sm5417727pjf.36.2023.04.02.23.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 23:10:21 -0700 (PDT)
Message-ID: <642a6dcd.170a0220.51852.9e5c@mx.google.com>
Date:   Sun, 02 Apr 2023 23:10:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-144-g8e79bfa455b1d
Subject: stable-rc/queue/5.10 baseline: 175 runs,
 7 regressions (v5.10.176-144-g8e79bfa455b1d)
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

stable-rc/queue/5.10 baseline: 175 runs, 7 regressions (v5.10.176-144-g8e79=
bfa455b1d)

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

rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-144-g8e79bfa455b1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-144-g8e79bfa455b1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8e79bfa455b1dea759627ebbb5fc574421793da8 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
bcm2711-rpi-4-b              | arm64  | lab-linaro-lkft | gcc-10   | defcon=
fig                    | 1          =


  Details:     https://kernelci.org/test/plan/id/642a4edece9d81860862f76b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642a4edece9d81860862f=
76c
        new failure (last pass: v5.10.176-143-g8f8a64155b282) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beaglebone-black             | arm    | lab-broonie     | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642a374187ac962a8a62f7ff

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a374187ac962a8a62f832
        failing since 48 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-03T02:17:17.395900  <8>[   19.040611] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 267247_1.5.2.4.1>
    2023-04-03T02:17:17.506384  / # #
    2023-04-03T02:17:17.609160  export SHELL=3D/bin/sh
    2023-04-03T02:17:17.609915  #
    2023-04-03T02:17:17.712273  / # export SHELL=3D/bin/sh. /lava-267247/en=
vironment
    2023-04-03T02:17:17.713113  =

    2023-04-03T02:17:17.815497  / # . /lava-267247/environment/lava-267247/=
bin/lava-test-runner /lava-267247/1
    2023-04-03T02:17:17.816577  =

    2023-04-03T02:17:17.821802  / # /lava-267247/bin/lava-test-runner /lava=
-267247/1
    2023-04-03T02:17:17.930733  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642a36739ea0ebfd3762f778

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a36739ea0ebfd3762f77d
        failing since 66 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-03T02:13:54.475253  <8>[   11.132340] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3466109_1.5.2.4.1>
    2023-04-03T02:13:54.582977  / # #
    2023-04-03T02:13:54.684629  export SHELL=3D/bin/sh
    2023-04-03T02:13:54.685063  #
    2023-04-03T02:13:54.786309  / # export SHELL=3D/bin/sh. /lava-3466109/e=
nvironment
    2023-04-03T02:13:54.786743  =

    2023-04-03T02:13:54.887970  / # . /lava-3466109/environment/lava-346610=
9/bin/lava-test-runner /lava-3466109/1
    2023-04-03T02:13:54.888605  =

    2023-04-03T02:13:54.888792  / # /lava-3466109/bin/lava-test-runner /lav=
a-3466109/1<3>[   11.531452] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-03T02:13:54.893790   =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642a398d531aafb24162f776

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a398d531aafb24162f77b
        failing since 3 days (last pass: v5.10.176-61-g2332301f1fab4, first=
 fail: v5.10.176-104-g2b4187983740)

    2023-04-03T02:27:18.589056  + <8>[   14.871841] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9845871_1.4.2.3.1>

    2023-04-03T02:27:18.589136  set +x

    2023-04-03T02:27:18.691008  #

    2023-04-03T02:27:18.691331  =


    2023-04-03T02:27:18.792355  / # #export SHELL=3D/bin/sh

    2023-04-03T02:27:18.792535  =


    2023-04-03T02:27:18.893238  / # export SHELL=3D/bin/sh. /lava-9845871/e=
nvironment

    2023-04-03T02:27:18.893431  =


    2023-04-03T02:27:18.994389  / # . /lava-9845871/environment/lava-984587=
1/bin/lava-test-runner /lava-9845871/1

    2023-04-03T02:27:18.994668  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora   | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/642a36f1eeb7c8469062f7aa

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/642a36f1eeb7c8469062f7b0
        failing since 20 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-03T02:15:59.620834  /lava-9845770/1/../bin/lava-test-case

    2023-04-03T02:15:59.631137  <8>[   35.129513] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/642a36f1eeb7c8469062f7b1
        failing since 20 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-03T02:15:58.583237  /lava-9845770/1/../bin/lava-test-case

    2023-04-03T02:15:58.594298  <8>[   34.092677] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642a361d06645c05bb62f77d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-144-g8e79bfa455b1d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a361d06645c05bb62f782
        failing since 60 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-03T02:12:09.944656  <8>[    7.495307] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3466113_1.5.2.4.1>
    2023-04-03T02:12:10.050115  / # #
    2023-04-03T02:12:10.152147  export SHELL=3D/bin/sh
    2023-04-03T02:12:10.152693  #
    2023-04-03T02:12:10.254095  / # export SHELL=3D/bin/sh. /lava-3466113/e=
nvironment
    2023-04-03T02:12:10.254669  =

    2023-04-03T02:12:10.355841  / # . /lava-3466113/environment/lava-346611=
3/bin/lava-test-runner /lava-3466113/1
    2023-04-03T02:12:10.356623  =

    2023-04-03T02:12:10.361692  / # /lava-3466113/bin/lava-test-runner /lav=
a-3466113/1
    2023-04-03T02:12:10.459709  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
