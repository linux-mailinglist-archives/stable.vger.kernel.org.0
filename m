Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2D26E3129
	for <lists+stable@lfdr.de>; Sat, 15 Apr 2023 13:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjDOLrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 07:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjDOLre (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 07:47:34 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC19035BB
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 04:47:32 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id lh8so7929165plb.1
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 04:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681559252; x=1684151252;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3EFQX9ktif2jt26N1lJuN3deCc0NJznjW2BYbb4tYes=;
        b=e2M5kyI24nD8fHVie1Y4QBAduFWzL6mrPCaR79dNzLT7W4nafSuKuFo0mZDG88ghVA
         koej/lKJOZnA3An9RMho9NfOO6kCcvBgrdyhI23Pu559PrIV4uKRwHeZdZD9Vz8LhhNy
         79SpkOT9E/x9I84uv3oZWa8LR6zuxy/nSZFRuKIcPhHR+egbeH+ZC9cv3EGkCrZ16SIK
         6nqgKZS5UpapjIl1CDeuzdfcG4wgCUrMS+j8NhG2Bt8sFESVH8w5Ctf2BqkW/Yy79gu1
         PvF4aoSsADWbz2MU7CMH71wOCxwcDAINaNZfn0LCyuqlhqfsuhcCbrOYkn7zvx5bvDg1
         PG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681559252; x=1684151252;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3EFQX9ktif2jt26N1lJuN3deCc0NJznjW2BYbb4tYes=;
        b=BTjaB5n8zgWl/cwimvbNAZp5lhOTPHQtMjnWnksLZm6mvoU15Kc4ndGKvKSVpF9Z6P
         TRVgpg2athU/vZ8odOgTzuOQ3mS5/muPShw2XBs8qgd0/kR+IHKCd2K/B78FHFKK9T5l
         TmDqWxRNWdv53O8/Nho5AfGxxpio1hk3OurkxfdSbR2mCL8VmPASEYRzNvEjacbjWZqf
         I3RYoH/9OQzCBBoE/NZhpbvtaHzasiFirHL4sdfSVzZn7YBmQVlCKK8WYVUVNRKdatm1
         HiUV+WVarpsh0MEUGE/YSZORHNfO2tr9SaLc0Ukar7YAvmTD7TE8DRqlsE3XV9xoxnQI
         UhRw==
X-Gm-Message-State: AAQBX9fBYq592r85LvGvBDBq4PWV8rA2iRJIlPOo9ACNm2oUq+3+i1dy
        bO423jxV80YY+qWdC/gdQA8BvsUHXkuQbv+3fClxVrSK
X-Google-Smtp-Source: AKy350YOuxKvmKufG0OGR1cnNWAJsE8UERM/1fCZdkny5+oiYbteSqYabmVX9cHaSTCrtzYHYqkWEw==
X-Received: by 2002:a17:902:ce82:b0:1a6:494b:5b0 with SMTP id f2-20020a170902ce8200b001a6494b05b0mr7206656plg.40.1681559251995;
        Sat, 15 Apr 2023 04:47:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ji6-20020a170903324600b0019abb539cddsm4573771plb.10.2023.04.15.04.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 04:47:31 -0700 (PDT)
Message-ID: <643a8ed3.170a0220.cb2ee.ae4e@mx.google.com>
Date:   Sat, 15 Apr 2023 04:47:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-226-g911180839ec3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 188 runs,
 8 regressions (v5.10.176-226-g911180839ec3)
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

stable-rc/queue/5.10 baseline: 188 runs, 8 regressions (v5.10.176-226-g9111=
80839ec3)

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

sun50i-a64-bananapi-m64      | arm64  | lab-clabbe    | gcc-10   | defconfi=
g                    | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-226-g911180839ec3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-226-g911180839ec3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      911180839ec392521479cc76b35a2b871c9530d3 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643a5c55c4d0ab862c2e85fc

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a5c55c4d0ab862c2e8630
        failing since 60 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-15T08:11:37.374039  <8>[   16.130416] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 331911_1.5.2.4.1>
    2023-04-15T08:11:37.541075  / # #
    2023-04-15T08:11:37.662899  export SHELL=3D/bin/sh
    2023-04-15T08:11:37.669368  #
    2023-04-15T08:11:37.779140  / # export SHELL=3D/bin/sh. /lava-331911/en=
vironment
    2023-04-15T08:11:37.785494  =

    2023-04-15T08:11:37.896277  / # . /lava-331911/environment/lava-331911/=
bin/lava-test-runner /lava-331911/1
    2023-04-15T08:11:37.906023  =

    2023-04-15T08:11:37.909345  / # /lava-331911/bin/lava-test-runner /lava=
-331911/1
    2023-04-15T08:11:38.003232  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643a5e397c39e81d3b2e8606

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a5e397c39e81d3b2e860b
        failing since 78 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-15T08:19:53.165042  <8>[   11.075328] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3498059_1.5.2.4.1>
    2023-04-15T08:19:53.274530  / # #
    2023-04-15T08:19:53.377931  export SHELL=3D/bin/sh
    2023-04-15T08:19:53.379034  #
    2023-04-15T08:19:53.481120  / # export SHELL=3D/bin/sh. /lava-3498059/e=
nvironment
    2023-04-15T08:19:53.482159  =

    2023-04-15T08:19:53.584218  / # . /lava-3498059/environment/lava-349805=
9/bin/lava-test-runner /lava-3498059/1
    2023-04-15T08:19:53.585661  =

    2023-04-15T08:19:53.590730  / # /lava-3498059/bin/lava-test-runner /lav=
a-3498059/1
    2023-04-15T08:19:53.677482  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a5b464c6691a0332e85ee

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a5b464c6691a0332e85f3
        failing since 15 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-15T08:07:27.867062  + set +x

    2023-04-15T08:07:27.873827  <8>[   14.206865] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9989530_1.4.2.3.1>

    2023-04-15T08:07:27.978825  / # #

    2023-04-15T08:07:28.079927  export SHELL=3D/bin/sh

    2023-04-15T08:07:28.080141  #

    2023-04-15T08:07:28.180872  / # export SHELL=3D/bin/sh. /lava-9989530/e=
nvironment

    2023-04-15T08:07:28.181064  =


    2023-04-15T08:07:28.281998  / # . /lava-9989530/environment/lava-998953=
0/bin/lava-test-runner /lava-9989530/1

    2023-04-15T08:07:28.282296  =


    2023-04-15T08:07:28.286753  / # /lava-9989530/bin/lava-test-runner /lav=
a-9989530/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643a5b49865c3596d62e8650

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a5b49865c3596d62e8655
        failing since 15 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-15T08:07:25.250152  + set +x

    2023-04-15T08:07:25.256205  <8>[   15.346613] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9989583_1.4.2.3.1>

    2023-04-15T08:07:25.358643  =


    2023-04-15T08:07:25.459601  / # #export SHELL=3D/bin/sh

    2023-04-15T08:07:25.459799  =


    2023-04-15T08:07:25.560499  / # export SHELL=3D/bin/sh. /lava-9989583/e=
nvironment

    2023-04-15T08:07:25.560685  =


    2023-04-15T08:07:25.661586  / # . /lava-9989583/environment/lava-998958=
3/bin/lava-test-runner /lava-9989583/1

    2023-04-15T08:07:25.661846  =


    2023-04-15T08:07:25.667006  / # /lava-9989583/bin/lava-test-runner /lav=
a-9989583/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643a5cd6f1756abbad2e8616

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/643a5cd6f1756abbad2e861c
        failing since 32 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-15T08:13:56.531215  <8>[   61.075268] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-04-15T08:13:57.555537  /lava-9989703/1/../bin/lava-test-case

    2023-04-15T08:13:57.566415  <8>[   62.110514] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/643a5cd6f1756abbad2e861d
        failing since 32 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-04-15T08:13:56.519925  /lava-9989703/1/../bin/lava-test-case
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun50i-a64-bananapi-m64      | arm64  | lab-clabbe    | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643a5d1ddde37477232e85ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643a5d1ddde37477232e8=
5ed
        new failure (last pass: v5.10.176-225-gde39d686eb8d) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643a5df40955ff29b22e85fa

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-226-g911180839ec3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643a5df40955ff29b22e85ff
        failing since 72 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-15T08:18:43.948911  / # #
    2023-04-15T08:18:44.050599  export SHELL=3D/bin/sh
    2023-04-15T08:18:44.050952  #
    2023-04-15T08:18:44.152270  / # export SHELL=3D/bin/sh. /lava-3498070/e=
nvironment
    2023-04-15T08:18:44.152641  =

    2023-04-15T08:18:44.253977  / # . /lava-3498070/environment/lava-349807=
0/bin/lava-test-runner /lava-3498070/1
    2023-04-15T08:18:44.254592  =

    2023-04-15T08:18:44.260197  / # /lava-3498070/bin/lava-test-runner /lav=
a-3498070/1
    2023-04-15T08:18:44.358137  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-15T08:18:44.358622  + cd /lava-3498070/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
