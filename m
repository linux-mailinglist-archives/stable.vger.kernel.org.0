Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C187D6EBC1A
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 01:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDVXlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 19:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVXlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 19:41:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4462680
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:41:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a66911f5faso28405735ad.0
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682206867; x=1684798867;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YgGWLTRxXvu6FZFE7n1d0i3a1TSTsNy6FBZKNkfNpFs=;
        b=hK5PmOAlhw4PzQ0AqTw3XWqlqZvinH0u/5TOGFH2fFElKMJVbjMaIjlKjSkr7Pj7hw
         +OFn6zWCgPcgwHKSlkXF0eVJqmELAmbjipjWerOGIqhyPu5l8iAdMAWJMTQFwDo3OcYw
         5eTcYYzWTB4f9Ld8795fPfkCVzgG1Sg7kdfxVgKDxebAGtqVejxYanWVplV2VOdX9OBl
         6dPYttFNxNRzf6LRDjg6w7cptlBDg6ohgFemf7qDL7yFR/cu4E6sBnA56nNz+DkTU7vO
         xZgtiUZdAXkSFglOQ47R2AIB3Fyvuo72Va/Pv3yGmSMgpC7RwErEcrUIe3hlZ6ZdoDc4
         ym5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682206867; x=1684798867;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YgGWLTRxXvu6FZFE7n1d0i3a1TSTsNy6FBZKNkfNpFs=;
        b=N/EYkP75kspelyKCDdVPunfXjqsv3nkF0dsB9gzTZNwUNzbQ9d5EsCIDbxQe7ctdHn
         1qyUNz1bEjIqYdvMHuQQIjeVr9z8kZ1MxlTeIg1ni0Bkhq+hAD95jVuoxb1fEV7e1HLI
         MxkXdCxcaBDOZWmTwi1XHs8O+/k97aKwL59jJkc4BzpEKCVzWdXoVnoxG3yKF+NfcMp7
         H60ZE30B4r9DgW21yAUmEzZAh//wLuuBetPBwzOzntQjInBPSrvB5xZrTltqAgNLKTzI
         GMfdRD8D2yWkzCB3J9tmXVSYeYJM+Hk4AhkHEtPbhYwC378bwkhI0pKo4usRj4BCL1KI
         KLpw==
X-Gm-Message-State: AAQBX9egkiTaXMLp12dKxpehPwS6R4q9UoQ3kIn82bCFfIYPjTzLF96r
        5YteNuO4GtE4tgOmZ6N+IUAFHix08di6/117ewn0ThG9
X-Google-Smtp-Source: AKy350bNJ55/zwOJ5VkKE0dK5yHuq0ah/qr4T6lT0qndQdNtmyIKD+YMGYPIj0Mo/xyUxrqaI0ZXMQ==
X-Received: by 2002:a17:902:e849:b0:1a9:3a8c:d590 with SMTP id t9-20020a170902e84900b001a93a8cd590mr10914768plg.16.1682206866906;
        Sat, 22 Apr 2023 16:41:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ju18-20020a170903429200b001a526805b86sm4438405plb.191.2023.04.22.16.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 16:41:06 -0700 (PDT)
Message-ID: <64447092.170a0220.48080.8abe@mx.google.com>
Date:   Sat, 22 Apr 2023 16:41:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-339-gff0db42c8b272
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 6 regressions (v5.10.176-339-gff0db42c8b272)
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

stable-rc/queue/5.10 baseline: 132 runs, 6 regressions (v5.10.176-339-gff0d=
b42c8b272)

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
nel/v5.10.176-339-gff0db42c8b272/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-339-gff0db42c8b272
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff0db42c8b2727e6bdd1a4cfa9e4ac032fa90368 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64443d9d926d27f1fb2e861c

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64443d9d926d27f1fb2e8650
        failing since 67 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-22T20:03:23.710653  <8>[   21.340797] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 371948_1.5.2.4.1>
    2023-04-22T20:03:23.821246  / # #
    2023-04-22T20:03:23.924635  export SHELL=3D/bin/sh
    2023-04-22T20:03:23.925463  #
    2023-04-22T20:03:24.027616  / # export SHELL=3D/bin/sh. /lava-371948/en=
vironment
    2023-04-22T20:03:24.028361  =

    2023-04-22T20:03:24.130471  / # . /lava-371948/environment/lava-371948/=
bin/lava-test-runner /lava-371948/1
    2023-04-22T20:03:24.131971  =

    2023-04-22T20:03:24.135779  / # /lava-371948/bin/lava-test-runner /lava=
-371948/1
    2023-04-22T20:03:24.239813  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64443ed9e049df43c82e8607

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64443ed9e049df43c82e860c
        failing since 86 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-22T20:08:39.423718  <8>[   10.983202] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3522126_1.5.2.4.1>
    2023-04-22T20:08:39.532213  / # #
    2023-04-22T20:08:39.633727  export SHELL=3D/bin/sh
    2023-04-22T20:08:39.634209  #
    2023-04-22T20:08:39.735547  / # export SHELL=3D/bin/sh. /lava-3522126/e=
nvironment
    2023-04-22T20:08:39.735925  =

    2023-04-22T20:08:39.736105  / # . /lava-3522126/environment<3>[   11.29=
1320] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-22T20:08:39.837263  /lava-3522126/bin/lava-test-runner /lava-35=
22126/1
    2023-04-22T20:08:39.837844  =

    2023-04-22T20:08:39.842894  / # /lava-3522126/bin/lava-test-runner /lav=
a-3522126/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64443a769cdac5e06a2e8611

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64443a769cdac5e06a2e8616
        failing since 23 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-22T19:49:57.737955  + set +x

    2023-04-22T19:49:57.744309  <8>[   10.551415] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10086731_1.4.2.3.1>

    2023-04-22T19:49:57.853512  / # #

    2023-04-22T19:49:57.956216  export SHELL=3D/bin/sh

    2023-04-22T19:49:57.957030  #

    2023-04-22T19:49:58.059081  / # export SHELL=3D/bin/sh. /lava-10086731/=
environment

    2023-04-22T19:49:58.059824  =


    2023-04-22T19:49:58.161740  / # . /lava-10086731/environment/lava-10086=
731/bin/lava-test-runner /lava-10086731/1

    2023-04-22T19:49:58.162924  =


    2023-04-22T19:49:58.167637  / # /lava-10086731/bin/lava-test-runner /la=
va-10086731/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64443a6f075488a0e72e863e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64443a6f075488a0e72e8643
        failing since 23 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-22T19:49:46.783978  + set +x<8>[   11.593688] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10086714_1.4.2.3.1>

    2023-04-22T19:49:46.784603  =


    2023-04-22T19:49:46.893018  / # #

    2023-04-22T19:49:46.995404  export SHELL=3D/bin/sh

    2023-04-22T19:49:46.996108  #

    2023-04-22T19:49:47.097870  / # export SHELL=3D/bin/sh. /lava-10086714/=
environment

    2023-04-22T19:49:47.098229  =


    2023-04-22T19:49:47.199566  / # . /lava-10086714/environment/lava-10086=
714/bin/lava-test-runner /lava-10086714/1

    2023-04-22T19:49:47.200890  =


    2023-04-22T19:49:47.206009  / # /lava-10086714/bin/lava-test-runner /la=
va-10086714/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/64443d2309aa54b1e52e85f7

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-339-gff0db42c8b272/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/64443d2309aa54b1e52e85fd
        failing since 39 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-22T20:01:27.176973  <8>[   61.159264] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-22T20:01:28.203064  /lava-10086811/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/64443d2309aa54b1e52e85fe
        failing since 39 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-22T20:01:26.139702  <8>[   60.121421] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-04-22T20:01:27.165567  /lava-10086811/1/../bin/lava-test-case
   =

 =20
