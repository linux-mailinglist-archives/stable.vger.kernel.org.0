Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540A46DFC2E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 19:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjDLRDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 13:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDLRDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 13:03:32 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50109EF4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 10:02:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h24so12197670plr.1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 10:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1681318965; x=1683910965;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lBMy/ZqruXafED5kJ9QnGjWLg5YvXp2IZs949l26U3A=;
        b=P22aVPlQBnuOxPPqKyfRjR5SaBsR5RP9/pOPATVj12PvGiM6swAhWsW1mFH8vtDiZh
         8ya5AVDGpfYue6nd4G9u8laPSr7GD8d7vB/a5N4qOzjARvkPq9ip+3qO27w7vMXrJQwT
         O2oz9chsHL78UzTpmKuk+wVObsJrqz3pmZOKFhm+K/JsBFV8AxMpemqG3HAc99OlHdRS
         7wq4awVhrtTLWZN1HVleXye+HDuwU7y76KeDS1rlCuw8WWDNx5Mvws6/Mt78tEH3k6Nr
         awzsWvzQYdr2X8OSLWQVCWZa2lI4G47CbFW+xgAhK5j3VXLncQb7GSm94/mkkQ+Vc2+4
         eP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318965; x=1683910965;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lBMy/ZqruXafED5kJ9QnGjWLg5YvXp2IZs949l26U3A=;
        b=Fayy8nxKOhea+T/WoKHg9xU8aKqo+mKHgBROMrQu+uOVrAOmOcBEpWdgv3/nZoRh1O
         Bd3F2N2rkMeEfgVjm5DGmq+wdAc4UVy5f0lliaV1HhnbzponQc0+qIex+hTX0PHHeMLi
         m/7+2oHjFPgLONlsjsRq6n/M0jJv1qsrectlOltSpLvHKy2G+zwONr0nQN9SnID15BDp
         LwE+WFeau2A2JmmixVuXiOiuv5UqY1I+lC/J50606u6rd2k/bFcD50W8P/k6pH+aR/aB
         yyyVd65p1z9iWqNX6LGyuPk3o8N1pgQ5fx+NMV7vbg8zcYDNKWb+WOJjIGtAcpaADgIY
         fVxQ==
X-Gm-Message-State: AAQBX9eRnqlMWxZd4Wev1x1eDv6e7a9WwXQ9z3kP1fqYjEv1RZJL/tO1
        Myu0Qy+WZVcjwd5dJceHMt8vKtVtGSAmlFqaxBVJdA==
X-Google-Smtp-Source: AKy350Zp8D0MOB3MO81YY5JJ2dWVRakBLD2lKLt/eMr3HNm1vqUFb0aEFJX1Mrp3mK01S5eYcwr7Kg==
X-Received: by 2002:a17:902:b707:b0:19f:1c79:8b21 with SMTP id d7-20020a170902b70700b0019f1c798b21mr3092152pls.42.1681318965463;
        Wed, 12 Apr 2023 10:02:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12-20020a1709027c8c00b001a25d7d1fbcsm11831915pll.38.2023.04.12.10.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 10:02:45 -0700 (PDT)
Message-ID: <6436e435.170a0220.4e4fe.71e7@mx.google.com>
Date:   Wed, 12 Apr 2023 10:02:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-224-g3e44b403c673
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 177 runs,
 7 regressions (v5.10.176-224-g3e44b403c673)
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

stable-rc/queue/5.10 baseline: 177 runs, 7 regressions (v5.10.176-224-g3e44=
b403c673)

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
nel/v5.10.176-224-g3e44b403c673/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-224-g3e44b403c673
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e44b403c673cbf105006b2ffb5096e3f580556c =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6436b5108b0d0a5b402e85fd

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436b5108b0d0a5b402e8633
        failing since 57 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-12T13:41:19.796629  <8>[   21.371390] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 317883_1.5.2.4.1>
    2023-04-12T13:41:19.906876  / # #
    2023-04-12T13:41:20.009604  export SHELL=3D/bin/sh
    2023-04-12T13:41:20.010321  #
    2023-04-12T13:41:20.112764  / # export SHELL=3D/bin/sh. /lava-317883/en=
vironment
    2023-04-12T13:41:20.113541  =

    2023-04-12T13:41:20.215927  / # . /lava-317883/environment/lava-317883/=
bin/lava-test-runner /lava-317883/1
    2023-04-12T13:41:20.217171  =

    2023-04-12T13:41:20.221939  / # /lava-317883/bin/lava-test-runner /lava=
-317883/1
    2023-04-12T13:41:20.319084  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6436b2044367ff7d072e8615

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436b2054367ff7d072e861a
        failing since 76 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-12T13:28:04.671685  + set +x<8>[   11.063048] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3489548_1.5.2.4.1>
    2023-04-12T13:28:04.671943  =

    2023-04-12T13:28:04.779027  / # #
    2023-04-12T13:28:04.880980  export SHELL=3D/bin/sh
    2023-04-12T13:28:04.881500  #
    2023-04-12T13:28:04.982899  / # export SHELL=3D/bin/sh. /lava-3489548/e=
nvironment
    2023-04-12T13:28:04.983320  =

    2023-04-12T13:28:04.983564  / # <3>[   11.291313] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-12T13:28:05.084619  . /lava-3489548/environment/lava-3489548/bi=
n/lava-test-runner /lava-3489548/1
    2023-04-12T13:28:05.085366   =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436b0eba44c05cb952e8611

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436b0eba44c05cb952e8616
        failing since 13 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-12T13:23:43.074596  + <8>[   14.996459] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9949365_1.4.2.3.1>

    2023-04-12T13:23:43.074682  set +x

    2023-04-12T13:23:43.176267  #

    2023-04-12T13:23:43.277438  / # #export SHELL=3D/bin/sh

    2023-04-12T13:23:43.277618  =


    2023-04-12T13:23:43.378596  / # export SHELL=3D/bin/sh. /lava-9949365/e=
nvironment

    2023-04-12T13:23:43.378781  =


    2023-04-12T13:23:43.479724  / # . /lava-9949365/environment/lava-994936=
5/bin/lava-test-runner /lava-9949365/1

    2023-04-12T13:23:43.480011  =


    2023-04-12T13:23:43.484570  / # /lava-9949365/bin/lava-test-runner /lav=
a-9949365/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6436b011d3c88ab1a92e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436b011d3c88ab1a92e8610
        failing since 13 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-12T13:19:58.237106  + set +x<8>[   12.487001] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9949320_1.4.2.3.1>

    2023-04-12T13:19:58.237725  =


    2023-04-12T13:19:58.345137  #

    2023-04-12T13:19:58.448084  / # #export SHELL=3D/bin/sh

    2023-04-12T13:19:58.448845  =


    2023-04-12T13:19:58.550891  / # export SHELL=3D/bin/sh. /lava-9949320/e=
nvironment

    2023-04-12T13:19:58.551655  =


    2023-04-12T13:19:58.653705  / # . /lava-9949320/environment/lava-994932=
0/bin/lava-test-runner /lava-9949320/1

    2023-04-12T13:19:58.654986  =


    2023-04-12T13:19:58.660481  / # /lava-9949320/bin/lava-test-runner /lav=
a-9949320/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6436b36b03f89f57e62e861a

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6436b36b03f89f57e62e8620
        failing since 29 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-12T13:34:29.295868  /lava-9949738/1/../bin/lava-test-case

    2023-04-12T13:34:29.306857  <8>[   35.443472] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6436b36b03f89f57e62e8621
        failing since 29 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-12T13:34:28.259008  /lava-9949738/1/../bin/lava-test-case

    2023-04-12T13:34:28.269577  <8>[   34.406446] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6436b1ca7a82d2c4802e85ef

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-224-g3e44b403c673/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6436b1ca7a82d2c4802e85f4
        failing since 69 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-12T13:27:16.141140  / # #
    2023-04-12T13:27:16.242898  export SHELL=3D/bin/sh
    2023-04-12T13:27:16.243392  #
    2023-04-12T13:27:16.344766  / # export SHELL=3D/bin/sh. /lava-3489542/e=
nvironment
    2023-04-12T13:27:16.345449  =

    2023-04-12T13:27:16.447146  / # . /lava-3489542/environment/lava-348954=
2/bin/lava-test-runner /lava-3489542/1
    2023-04-12T13:27:16.447925  =

    2023-04-12T13:27:16.452389  / # /lava-3489542/bin/lava-test-runner /lav=
a-3489542/1
    2023-04-12T13:27:16.516632  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-12T13:27:16.564313  + cd /lava-3489542/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
