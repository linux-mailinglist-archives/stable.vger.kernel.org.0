Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE2F6E3A4D
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjDPQjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 12:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDPQjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 12:39:09 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CC51BE1
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 09:39:08 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y6so22136583plp.2
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 09:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681663147; x=1684255147;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=C/LOjvIuNV3DiRbwEmZkyiWlEHXSkyidDeSde1uMWeY=;
        b=lP82jQfOuXokEq15/KyM6VKJswjtQRXtcbZhAXQiZO6kORJsQB4XkRWaeXY3b1GIdf
         HhB0+JhT2SPAwJkIK9HoEPcd+35H1lueYy2/1R13R0Ic+k+OuUbNSqluf/oN8jMmXP/d
         HwXV77mE1xHFZCmMmbIWWU5ivY2wSQPXGVvVIiymTxuqt5yK+wdQVRv+NVrJTyVlUzc3
         7CocdNn65/Wfg5EEizJedXc5yXY9M6ayyojGVuHt6whLkaKC8LAfCHgRtTEJkqf+Z8I6
         tVMBJITjxtQkF7lztZTmZGfwUrBt+dVDV5oGHxKYMT0eEW1e/AeTq5/SG7uACp0agEiu
         RRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681663147; x=1684255147;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C/LOjvIuNV3DiRbwEmZkyiWlEHXSkyidDeSde1uMWeY=;
        b=c/dKJa7Q3Wge+c6nxy2O2cGZScshnQ5mxcNZkdPJzu53LBWquDoRtH9MG1IvlsDysO
         X+stQ0RJJEIFX7t4wrmL7v2VImlcc9wvkCyW1yBxpZgIIL25pFbjlQ3hT1KQuNhQ9xYA
         YrWGkAxh+uvEor8zqRY2lwC3gjNsXpR+rKisOJESsQApIfLxeoLX9g/nagwXGkzXoUiB
         858hu+Ru4j8//FsK5gyGd+m/gv37tl37wvkqR3G9tsIBgamQNIbRHmSCLKPCjqDh+nt0
         VmmWATl0KlqdY3dC9WzT31UHUpxOtiLcNTmbrkj++IKXmNCZI5+c7F3BPub/BOfQmvNr
         9FyQ==
X-Gm-Message-State: AAQBX9fUz5+11ryX9frayKzTaI5MAvjh5mt+HVTGb0YSxL+xNYbmRjkb
        oTNirfYIA7T2rLX/ZNoqbdV4S/uJF2t9/c4VANGyr+Mi
X-Google-Smtp-Source: AKy350bhVXo61NDjbYepLHWJxB18Py1vD1H6pD997Z3YfcnVg/tHQvFpgistJAFAikTg8+JIzzalMw==
X-Received: by 2002:a05:6a20:9183:b0:ef:7d7b:4332 with SMTP id v3-20020a056a20918300b000ef7d7b4332mr2378429pzd.22.1681663147184;
        Sun, 16 Apr 2023 09:39:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i12-20020a63130c000000b004facdf070d6sm5625495pgl.39.2023.04.16.09.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 09:39:06 -0700 (PDT)
Message-ID: <643c24aa.630a0220.71917.c0bd@mx.google.com>
Date:   Sun, 16 Apr 2023 09:39:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-240-g6341d535d23c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 163 runs,
 5 regressions (v5.10.176-240-g6341d535d23c)
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

stable-rc/queue/5.10 baseline: 163 runs, 5 regressions (v5.10.176-240-g6341=
d535d23c)

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

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-240-g6341d535d23c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-240-g6341d535d23c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6341d535d23c8ce1573c943ef377e16985353ed1 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643bec9567843789822e865f

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bec9567843789822e8694
        failing since 61 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-16T12:39:28.444781  <8>[   19.672683] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 336863_1.5.2.4.1>
    2023-04-16T12:39:28.554139  / # #
    2023-04-16T12:39:28.656598  export SHELL=3D/bin/sh
    2023-04-16T12:39:28.657075  #
    2023-04-16T12:39:28.759069  / # export SHELL=3D/bin/sh. /lava-336863/en=
vironment
    2023-04-16T12:39:28.759560  =

    2023-04-16T12:39:28.861017  / # . /lava-336863/environment/lava-336863/=
bin/lava-test-runner /lava-336863/1
    2023-04-16T12:39:28.861972  =

    2023-04-16T12:39:28.867085  / # /lava-336863/bin/lava-test-runner /lava=
-336863/1
    2023-04-16T12:39:28.973296  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643bef2094a99b31f92e8650

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bef2094a99b31f92e8655
        failing since 80 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-16T12:50:24.534491  + set +x<8>[   10.977761] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3502199_1.5.2.4.1>
    2023-04-16T12:50:24.534781  =

    2023-04-16T12:50:24.641567  / # #
    2023-04-16T12:50:24.743266  export SHELL=3D/bin/sh
    2023-04-16T12:50:24.743639  #
    2023-04-16T12:50:24.844631  / # export SHELL=3D/bin/sh. /lava-3502199/e=
nvironment
    2023-04-16T12:50:24.845016  =

    2023-04-16T12:50:24.946127  / # . /lava-3502199/environment/lava-350219=
9/bin/lava-test-runner /lava-3502199/1
    2023-04-16T12:50:24.946701  =

    2023-04-16T12:50:24.951476  / # /lava-3502199/bin/lava-test-runner /lav=
a-3502199/1 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bebcd3ffa38ef702e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bebcd3ffa38ef702e860b
        failing since 17 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-16T12:36:16.863205  + set +x

    2023-04-16T12:36:16.869633  <8>[   14.739011] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10004804_1.4.2.3.1>

    2023-04-16T12:36:16.974715  / # #

    2023-04-16T12:36:17.075736  export SHELL=3D/bin/sh

    2023-04-16T12:36:17.075917  #

    2023-04-16T12:36:17.176915  / # export SHELL=3D/bin/sh. /lava-10004804/=
environment

    2023-04-16T12:36:17.177173  =


    2023-04-16T12:36:17.278462  / # . /lava-10004804/environment/lava-10004=
804/bin/lava-test-runner /lava-10004804/1

    2023-04-16T12:36:17.280122  =


    2023-04-16T12:36:17.284840  / # /lava-10004804/bin/lava-test-runner /la=
va-10004804/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643beba77b454a9ff32e8600

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643beba77b454a9ff32e8605
        failing since 17 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-16T12:35:34.109519  + set +x<8>[    9.278140] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10004775_1.4.2.3.1>

    2023-04-16T12:35:34.109618  =


    2023-04-16T12:35:34.211753  #

    2023-04-16T12:35:34.313058  / # #export SHELL=3D/bin/sh

    2023-04-16T12:35:34.313241  =


    2023-04-16T12:35:34.414180  / # export SHELL=3D/bin/sh. /lava-10004775/=
environment

    2023-04-16T12:35:34.414372  =


    2023-04-16T12:35:34.515372  / # . /lava-10004775/environment/lava-10004=
775/bin/lava-test-runner /lava-10004775/1

    2023-04-16T12:35:34.515693  =


    2023-04-16T12:35:34.520973  / # /lava-10004775/bin/lava-test-runner /la=
va-10004775/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643bef1c94a99b31f92e8629

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-240-g6341d535d23c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bef1c94a99b31f92e862e
        failing since 73 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-16T12:50:11.258481  / # #
    2023-04-16T12:50:11.360142  export SHELL=3D/bin/sh
    2023-04-16T12:50:11.360507  #
    2023-04-16T12:50:11.461816  / # export SHELL=3D/bin/sh. /lava-3502194/e=
nvironment
    2023-04-16T12:50:11.462170  =

    2023-04-16T12:50:11.563497  / # . /lava-3502194/environment/lava-350219=
4/bin/lava-test-runner /lava-3502194/1
    2023-04-16T12:50:11.564091  =

    2023-04-16T12:50:11.571011  / # /lava-3502194/bin/lava-test-runner /lav=
a-3502194/1
    2023-04-16T12:50:11.667922  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-16T12:50:11.668176  + cd /lava-3502194/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
