Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2C236C256E
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCTXHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCTXHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:07:13 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C028B35EC4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:06:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id ix20so14155334plb.3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679353598;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xcXm0Lwyn5u7Tlf45WcySao4A5ih31R1CyZoUGac8/8=;
        b=FTQUPiyorwZGNb5n0WvhjWalsH5E58HWqeNsd8/tJb36vK1AOZHDDqtLPjsaOWnnAs
         4URAqt7QOj7Sibh0QA591sK2X4rgMcUnUNgiOC2bcL1r7QTpX5u2wIRCHgt0oYLxlRbR
         rNaNsl/VWoAFGDcQCtj5TqzRHuqWZWLKw/V9OiEUbNv3f/AJMRc5E3WCOom+/IMQDESC
         Vt06aO31ECyjnY8gBv0j9FeGyGxRh6vCpdGaJAg0bFURzO9W15ez22vAUbe1fcQ6qprJ
         mD64vJnPkrISs40fZDTt4GZ2eNknh7BMkWcpipVA0rppPyhyINPrDVsh0OAJfCzJ2UR2
         8i4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353598;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xcXm0Lwyn5u7Tlf45WcySao4A5ih31R1CyZoUGac8/8=;
        b=BnxQV4DXyc9CU+e2+97/dZyS/4ws+/FXDKlWoJrOujp15esdESu1xzxagX60lrxRSJ
         r0cLo2LQVnxTenyiAO7NAuYptaexajtdEUnDfs+exzoccuvKpE/cRExlTpJQ0Aw2aflp
         DTLW89FliUcvLpzYK7ox9jnG0piAbH4Z6U+sCCpfQtTsJuk2aausURBqTdaI4EsA8l2U
         NbvnT5CHopHv0FjerLgt8Dz0mlCUD0r/CDNzdRok0b/Az26h3J1vqOza5+1lUsw/wFPv
         w4LK4Fd+zFEiTGvRWLl8Pc+/P5cp4DQEX+M51cHyZXv9NN1uSZMmJRf5NAolkwIC0Zf6
         CKKg==
X-Gm-Message-State: AO0yUKUrJ1DPSUV224sl+ZtsLcjYkIaF5rJlZg1qQ6kMkZlUDGflwWOR
        XQMU0DS1SbtwDVlQdhnHNouq3qKdP3vAnpoo/pc2Gg==
X-Google-Smtp-Source: AK7set9ObuLdCQ0yhxtdjrNh2gzVhdC2wbfNYLemO+l5KHpaT5Jz/XJwigSVKg+0VFTDhLagmpdW1A==
X-Received: by 2002:a05:6a20:a794:b0:d7:8ad3:bc66 with SMTP id bx20-20020a056a20a79400b000d78ad3bc66mr202600pzb.11.1679353597910;
        Mon, 20 Mar 2023 16:06:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e25-20020a62aa19000000b00627ed3e9c10sm3597228pff.137.2023.03.20.16.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 16:06:37 -0700 (PDT)
Message-ID: <6418e6fd.620a0220.6863b.6794@mx.google.com>
Date:   Mon, 20 Mar 2023 16:06:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.175-99-g398ed5c503bc
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 5 regressions (v5.10.175-99-g398ed5c503bc)
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

stable-rc/queue/5.10 baseline: 168 runs, 5 regressions (v5.10.175-99-g398ed=
5c503bc)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =

cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.175-99-g398ed5c503bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.175-99-g398ed5c503bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      398ed5c503bccbdd03efd6c936a3cc75f7266f78 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beaglebone-black             | arm   | lab-broonie   | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6418b4f975f77b7c938c8635

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418b4f975f77b7c938c866e
        failing since 34 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-20T19:32:55.474411  <8>[   19.872191] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 196689_1.5.2.4.1>
    2023-03-20T19:32:55.582690  / # #
    2023-03-20T19:32:55.684854  export SHELL=3D/bin/sh
    2023-03-20T19:32:55.685414  #
    2023-03-20T19:32:55.786962  / # export SHELL=3D/bin/sh. /lava-196689/en=
vironment
    2023-03-20T19:32:55.787435  =

    2023-03-20T19:32:55.888769  / # . /lava-196689/environment/lava-196689/=
bin/lava-test-runner /lava-196689/1
    2023-03-20T19:32:55.889632  =

    2023-03-20T19:32:55.893993  / # /lava-196689/bin/lava-test-runner /lava=
-196689/1
    2023-03-20T19:32:56.002662  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6418b548f245bd676d8c865f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418b549f245bd676d8c8668
        failing since 53 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-20T19:34:19.412211  <8>[   10.979475] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3430219_1.5.2.4.1>
    2023-03-20T19:34:19.518716  / # #
    2023-03-20T19:34:19.620131  export SHELL=3D/bin/sh
    2023-03-20T19:34:19.620516  #
    2023-03-20T19:34:19.721687  / # export SHELL=3D/bin/sh. /lava-3430219/e=
nvironment
    2023-03-20T19:34:19.722089  =

    2023-03-20T19:34:19.722249  / # <3>[   11.221144] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-20T19:34:19.823421  . /lava-3430219/environment/lava-3430219/bi=
n/lava-test-runner /lava-3430219/1
    2023-03-20T19:34:19.823994  =

    2023-03-20T19:34:19.829121  / # /lava-3430219/bin/lava-test-runner /lav=
a-3430219/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/6418b72c3b567772428c8721

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6418b72c3b567772428c872b
        failing since 6 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-20T19:42:19.305550  /lava-9705075/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6418b72c3b567772428c872c
        failing since 6 days (last pass: v5.10.172-529-g06956b9e9396, first=
 fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-20T19:42:18.268886  /lava-9705075/1/../bin/lava-test-case

    2023-03-20T19:42:18.280293  <8>[   61.015382] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6418b423d92f9408748c8670

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.175=
-99-g398ed5c503bc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418b423d92f9408748c8679
        failing since 46 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-20T19:29:11.538355  / # #
    2023-03-20T19:29:11.640055  export SHELL=3D/bin/sh
    2023-03-20T19:29:11.640484  #
    2023-03-20T19:29:11.741793  / # export SHELL=3D/bin/sh. /lava-3430225/e=
nvironment
    2023-03-20T19:29:11.742148  =

    2023-03-20T19:29:11.843484  / # . /lava-3430225/environment/lava-343022=
5/bin/lava-test-runner /lava-3430225/1
    2023-03-20T19:29:11.844090  =

    2023-03-20T19:29:11.849594  / # /lava-3430225/bin/lava-test-runner /lav=
a-3430225/1
    2023-03-20T19:29:11.913658  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-20T19:29:11.962411  + cd /lava-3430225/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
