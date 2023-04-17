Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B56E4B37
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 16:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjDQORA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 10:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjDQOQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 10:16:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE73C5B85
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:16:35 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z11-20020a17090abd8b00b0024721c47ceaso12503063pjr.3
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681740995; x=1684332995;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8cCHubkXbBioyuyAm2NKSkUQp93/byUbNRlSe/Xvnvk=;
        b=cT8abj3ZHfqdjkTBVb+wBLCKOJSFhz7Hs9EPiiHu621iDRI1G9ZyX7oY1P5BTeZwxh
         sb33Ii1vzdR3bd2UL7gBPM6tL34Fx7phBxXoalaZGbfUIu5uCUhNdiPpyk/Zr5bVZvLD
         V7YPpCwewXTcQWPamfn/yKDqNJSoL9loK9PXEwgnGaY+aEnawPM9T6ywTvXqoMWwEtXs
         Y+0rpoXH8GQUWqJRSWFJ/dFek+RbF3C3MyCfdF+Y+qMCWSx3NpzRNYm1gVwui2uOgUWA
         D6FbEjDAkEEQRL3Ze70iij/3dq6W7v0/edlxwPc80sAl/HicldU0XCpF3De7Ta0d+Mz9
         0wXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681740995; x=1684332995;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8cCHubkXbBioyuyAm2NKSkUQp93/byUbNRlSe/Xvnvk=;
        b=SANXU4uJCZJv3hvofBu6ZKdZNNol1g15jT4e7uWtq333PppNiWniI8VAWF9wB6g9d7
         sxdSNSHJvh7e8mrSdQusBmcOK9pXJKctOaabOzkUWuzgBur6Z7XXChne6OE+SF45rBtr
         gVMHFJBX3EKEZC3j0PknLWFi2OBn1VuLSUUo3s4C0EYYNr9vVnPeVq+y/W3gcFEw+kt3
         3/FyZn9did6wAAkQUNtNDOGO9eURnE3KECd7xprdEfOnfbuKgQwTH1lmQSdxgLccRzrJ
         Seg7rskmHQiJ1tMDJDIyrHyFxgmiPsP1g6klIjNYa5pA1VMNQQRjKx74lG4IF5HnRJen
         1hOA==
X-Gm-Message-State: AAQBX9dzvgxXXcrQMKKV3dceQO8C0wmsHLNkGXEzBswPI4IeWGNtQi9H
        i5C1qrt5mT8cMrlOpyQmGEPMEkaSBJ+zCJZ7lJ5qlnpZ
X-Google-Smtp-Source: AKy350Y60hvYTdsFUsSOZEfYvogMtcYJa3P0ipH7FqPHhFeSfBcfYZissfEQnaHmh3bDD5HGvpJlpA==
X-Received: by 2002:a17:90b:4a0d:b0:246:5968:43f0 with SMTP id kk13-20020a17090b4a0d00b00246596843f0mr14661971pjb.10.1681740995044;
        Mon, 17 Apr 2023 07:16:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24-20020a17090ac25800b00246cc751c6bsm8798398pjx.46.2023.04.17.07.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 07:16:34 -0700 (PDT)
Message-ID: <643d54c2.170a0220.87839.248d@mx.google.com>
Date:   Mon, 17 Apr 2023 07:16:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-270-g3c65d7548dd9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 7 regressions (v5.10.176-270-g3c65d7548dd9)
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

stable-rc/queue/5.10 baseline: 180 runs, 7 regressions (v5.10.176-270-g3c65=
d7548dd9)

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
nel/v5.10.176-270-g3c65d7548dd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-270-g3c65d7548dd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c65d7548dd9a3cb55fb85f92c427cf7ed39fc14 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643d23ea73cbbef6da2e863f

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d23ea73cbbef6da2e8673
        failing since 62 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-17T10:47:47.330692  <8>[   20.014784] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 342266_1.5.2.4.1>
    2023-04-17T10:47:47.439782  / # #
    2023-04-17T10:47:47.541497  export SHELL=3D/bin/sh
    2023-04-17T10:47:47.541949  #
    2023-04-17T10:47:47.643411  / # export SHELL=3D/bin/sh. /lava-342266/en=
vironment
    2023-04-17T10:47:47.643900  =

    2023-04-17T10:47:47.745656  / # . /lava-342266/environment/lava-342266/=
bin/lava-test-runner /lava-342266/1
    2023-04-17T10:47:47.746460  =

    2023-04-17T10:47:47.751376  / # /lava-342266/bin/lava-test-runner /lava=
-342266/1
    2023-04-17T10:47:47.859134  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643d21f8883f7150cd2e865c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d21f8883f7150cd2e8661
        failing since 80 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-17T10:39:33.518659  <8>[   10.995737] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3505525_1.5.2.4.1>
    2023-04-17T10:39:33.625742  / # #
    2023-04-17T10:39:33.727227  export SHELL=3D/bin/sh
    2023-04-17T10:39:33.727594  #
    2023-04-17T10:39:33.828651  / # export SHELL=3D/bin/sh. /lava-3505525/e=
nvironment
    2023-04-17T10:39:33.829037  =

    2023-04-17T10:39:33.930174  / # . /lava-3505525/environment/lava-350552=
5/bin/lava-test-runner /lava-3505525/1
    2023-04-17T10:39:33.930754  =

    2023-04-17T10:39:33.935752  / # /lava-3505525/bin/lava-test-runner /lav=
a-3505525/1
    2023-04-17T10:39:33.971819  <3>[   11.451124] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d214a72413bdb8d2e8657

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d214a72413bdb8d2e865c
        failing since 18 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-17T10:36:49.710682  + set +x

    2023-04-17T10:36:49.716838  <8>[   14.670511] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10018318_1.4.2.3.1>

    2023-04-17T10:36:49.821843  / # #

    2023-04-17T10:36:49.922851  export SHELL=3D/bin/sh

    2023-04-17T10:36:49.923042  #

    2023-04-17T10:36:50.023973  / # export SHELL=3D/bin/sh. /lava-10018318/=
environment

    2023-04-17T10:36:50.024166  =


    2023-04-17T10:36:50.125124  / # . /lava-10018318/environment/lava-10018=
318/bin/lava-test-runner /lava-10018318/1

    2023-04-17T10:36:50.125387  =


    2023-04-17T10:36:50.129666  / # /lava-10018318/bin/lava-test-runner /la=
va-10018318/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643d20e554b985598d2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d20e554b985598d2e85eb
        failing since 18 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-17T10:34:57.172442  <8>[   12.628995] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10018348_1.4.2.3.1>

    2023-04-17T10:34:57.176106  + set +x

    2023-04-17T10:34:57.281167  /#

    2023-04-17T10:34:57.384081   # #export SHELL=3D/bin/sh

    2023-04-17T10:34:57.384932  =


    2023-04-17T10:34:57.486774  / # export SHELL=3D/bin/sh. /lava-10018348/=
environment

    2023-04-17T10:34:57.487583  =


    2023-04-17T10:34:57.589574  / # . /lava-10018348/environment/lava-10018=
348/bin/lava-test-runner /lava-10018348/1

    2023-04-17T10:34:57.590845  =


    2023-04-17T10:34:57.596000  / # /lava-10018348/bin/lava-test-runner /la=
va-10018348/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643d23bdc802ba2c422e8615

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643d23bdc802ba2c422e861b
        failing since 34 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-17T10:47:18.588963  <8>[   34.375267] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-17T10:47:19.613492  /lava-10018500/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643d23bdc802ba2c422e861c
        failing since 34 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-17T10:47:17.551714  <8>[   33.337390] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-17T10:47:18.577859  /lava-10018500/1/../bin/lava-test-case
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643d2195206783009d2e85fd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-270-g3c65d7548dd9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643d2195206783009d2e8602
        failing since 74 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-17T10:38:02.124090  / # #
    2023-04-17T10:38:02.225968  export SHELL=3D/bin/sh
    2023-04-17T10:38:02.226657  #
    2023-04-17T10:38:02.328263  / # export SHELL=3D/bin/sh. /lava-3505523/e=
nvironment
    2023-04-17T10:38:02.328789  =

    2023-04-17T10:38:02.430122  / # . /lava-3505523/environment/lava-350552=
3/bin/lava-test-runner /lava-3505523/1
    2023-04-17T10:38:02.430775  =

    2023-04-17T10:38:02.435667  / # /lava-3505523/bin/lava-test-runner /lav=
a-3505523/1
    2023-04-17T10:38:02.500581  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-17T10:38:02.539408  + cd /lava-3505523/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
