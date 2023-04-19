Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB496E815A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 20:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjDSSnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 14:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDSSnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 14:43:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED3D3C1F
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 11:43:02 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q2so171667pll.7
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 11:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681929782; x=1684521782;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Y8fKnY2lNCscdOqE9syxuj8gxLkHvhweXJcDYjQea7s=;
        b=NHelTEcrMy6d9T3Odx492ONTJWwJvanNDNJHM7rAp1WvUbAF9rmMezxWDUIT6P5jI4
         kRv5eUuTOzECmqXxxgP7xT3xBCJsPhZB/7isSCzhGj8Y/FFZ7XpFYsfZdAPEAJXnmT7N
         owOyyVWeKlLoACPNJWzwJi3s9af/Gqnp80RuzPAarSao64TOjI7go/K04p3toADPumAA
         PKbU03qyYv7GBx3n8+FerRIDEK48XFi8g69cthkcZtTYwhIhNeC3e/PWqrB4md+Tc/Cn
         cGC9qj65gA8M5xs9x0xkibdOVU5rXGOEhxtETAj2aFAtejKJaKm+uG7LuHOssKqJkq+F
         Eoiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681929782; x=1684521782;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y8fKnY2lNCscdOqE9syxuj8gxLkHvhweXJcDYjQea7s=;
        b=inLp/aXTR2votKwJHC8UXIz6OvLjBUjKJw8mUccmbNI7R5Ip/SoAaSlgYmA91M4VTd
         39KSMP6B2XARP1B1iuY7Nh2kqCFDZGgQ4OX9+rASwleJZjXi6+ajTi5QZn/l6cnVzPiY
         jtFS6GN/Vu8zBtIRtycOvS9XyU0PD2/oCaW3Llq2jsqOWUotgIZSxDsfD0LdjQ1dkbph
         Vn99IGTEylWj6LgdahRIpUi2zDqpWnoYdlr2jDJyL6oZ8C+dLulYBXBfT/Gnw3p6z0mR
         6/LA6OxhkdXqHIWeGfXple+qrZ5tOlbYdoOuxyo7+On6egQjzlthNH68FWAsevup+ysk
         NWTg==
X-Gm-Message-State: AAQBX9eKVOmeXFC9uU8tP3qx/R2GzQ3qTakDicLChUz9P3j/TYxcVHK2
        brcjplEWIqL4TO3C7qllnRxIA7nflPZzaLXSHrVx53hU
X-Google-Smtp-Source: AKy350ZrMc+cA7V8rk91Sovjm63p+T1dUJ3XnZHWd3LyiRJq9TrybkfevURpOktoHOH1BBxTWcZT8g==
X-Received: by 2002:a05:6a20:2445:b0:ef:6c30:5798 with SMTP id t5-20020a056a20244500b000ef6c305798mr4992668pzc.27.1681929782035;
        Wed, 19 Apr 2023 11:43:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j10-20020a63ec0a000000b004fab4455748sm10815534pgh.75.2023.04.19.11.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 11:43:01 -0700 (PDT)
Message-ID: <64403635.630a0220.59994.9163@mx.google.com>
Date:   Wed, 19 Apr 2023 11:43:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-293-g84f1eb059696e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 171 runs,
 8 regressions (v5.10.176-293-g84f1eb059696e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 171 runs, 8 regressions (v5.10.176-293-g84f1=
eb059696e)

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

odroid-xu3                   | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-293-g84f1eb059696e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-293-g84f1eb059696e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84f1eb059696e2778500c0c881eb62c82877af78 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/644001eeebc7a0a8ad2e85f6

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644001eeebc7a0a8ad2e862b
        failing since 64 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-19T14:59:37.501045  <8>[   21.373279] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 354778_1.5.2.4.1>
    2023-04-19T14:59:37.610500  / # #
    2023-04-19T14:59:37.712593  export SHELL=3D/bin/sh
    2023-04-19T14:59:37.713200  #
    2023-04-19T14:59:37.815117  / # export SHELL=3D/bin/sh. /lava-354778/en=
vironment
    2023-04-19T14:59:37.815717  =

    2023-04-19T14:59:37.917581  / # . /lava-354778/environment/lava-354778/=
bin/lava-test-runner /lava-354778/1
    2023-04-19T14:59:37.918309  =

    2023-04-19T14:59:37.922946  / # /lava-354778/bin/lava-test-runner /lava=
-354778/1
    2023-04-19T14:59:38.031559  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64400335ec132478ef2e85f6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400335ec132478ef2e85fb
        failing since 83 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-19T15:05:02.196155  <8>[   11.026048] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3512668_1.5.2.4.1>
    2023-04-19T15:05:02.302807  / # #
    2023-04-19T15:05:02.404287  export SHELL=3D/bin/sh
    2023-04-19T15:05:02.404648  #
    2023-04-19T15:05:02.505813  / # export SHELL=3D/bin/sh. /lava-3512668/e=
nvironment
    2023-04-19T15:05:02.506188  =

    2023-04-19T15:05:02.607455  / # . /lava-3512668/environment/lava-351266=
8/bin/lava-test-runner /lava-3512668/1
    2023-04-19T15:05:02.608058  =

    2023-04-19T15:05:02.612923  / # /lava-3512668/bin/lava-test-runner /lav=
a-3512668/1
    2023-04-19T15:05:02.691862  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400530ba3b542dfa2e85f0

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400530ba3b542dfa2e85f5
        failing since 20 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-19T15:13:39.945813  + set +x

    2023-04-19T15:13:39.952355  <8>[   10.467369] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10048706_1.4.2.3.1>

    2023-04-19T15:13:40.060567  / # #

    2023-04-19T15:13:40.163529  export SHELL=3D/bin/sh

    2023-04-19T15:13:40.164296  #

    2023-04-19T15:13:40.266297  / # export SHELL=3D/bin/sh. /lava-10048706/=
environment

    2023-04-19T15:13:40.267052  =


    2023-04-19T15:13:40.369228  / # . /lava-10048706/environment/lava-10048=
706/bin/lava-test-runner /lava-10048706/1

    2023-04-19T15:13:40.370483  =


    2023-04-19T15:13:40.375142  / # /lava-10048706/bin/lava-test-runner /la=
va-10048706/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64400530ba3b542dfa2e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64400530ba3b542dfa2e8600
        failing since 20 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-19T15:13:41.106509  <8>[   12.978300] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10048726_1.4.2.3.1>

    2023-04-19T15:13:41.109982  + set +x

    2023-04-19T15:13:41.214333  / # #

    2023-04-19T15:13:41.315485  export SHELL=3D/bin/sh

    2023-04-19T15:13:41.315696  #

    2023-04-19T15:13:41.416673  / # export SHELL=3D/bin/sh. /lava-10048726/=
environment

    2023-04-19T15:13:41.416887  =


    2023-04-19T15:13:41.517880  / # . /lava-10048726/environment/lava-10048=
726/bin/lava-test-runner /lava-10048726/1

    2023-04-19T15:13:41.518211  =


    2023-04-19T15:13:41.523764  / # /lava-10048726/bin/lava-test-runner /la=
va-10048726/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
odroid-xu3                   | arm    | lab-collabora | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6440084b270d711b512e85e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6440084b270d711b512e8=
5e7
        new failure (last pass: v5.10.176-293-gbda27f73d6bb8) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64400131db6d3dcbf22e8608

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64400131db6d3dcbf22e860e
        failing since 36 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-19T14:56:28.512111  /lava-10048292/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64400131db6d3dcbf22e860f
        failing since 36 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-19T14:56:26.453385  <8>[   60.065973] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-19T14:56:27.476685  /lava-10048292/1/../bin/lava-test-case

    2023-04-19T14:56:27.487404  <8>[   61.101211] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6440030c79d01d1ab42e85f4

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-293-g84f1eb059696e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6440030c79d01d1ab42e85f9
        failing since 76 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-19T15:04:26.245714  / # #
    2023-04-19T15:04:26.347379  export SHELL=3D/bin/sh
    2023-04-19T15:04:26.347727  #
    2023-04-19T15:04:26.449037  / # export SHELL=3D/bin/sh. /lava-3512663/e=
nvironment
    2023-04-19T15:04:26.449386  =

    2023-04-19T15:04:26.550710  / # . /lava-3512663/environment/lava-351266=
3/bin/lava-test-runner /lava-3512663/1
    2023-04-19T15:04:26.551308  =

    2023-04-19T15:04:26.557095  / # /lava-3512663/bin/lava-test-runner /lav=
a-3512663/1
    2023-04-19T15:04:26.621151  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-19T15:04:26.669876  + cd /lava-3512663/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
