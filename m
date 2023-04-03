Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FD46D492B
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjDCOf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbjDCOfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:22 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F39E4E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:21 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so30783142pjb.0
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 07:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680532521;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oxGsYI2QoyXkzuWq4RrJu/2bPGkvHLr5ePv0N/Bc5WI=;
        b=tUdmgyCuV0lUK7QTpDnx1MoN4ysgkWbNuEdtt+80wHDulYte1MIwHDrum+KJU/vDRJ
         rWgjdHy72/xGUUEjIXJtDtfQUryJam9n6YVG1COKDz/y9qP1VuGOdvSHnmrCM6i5scDT
         ezEniE9hEazXwwixPJKZ4XxJnooZPbeCUQPkweO6eC5y4cW5xe9VwDbCIUa9Gd7P/jpS
         LTQ42eG3zHFO7w9fsJy4+DAceI/FRAiZrat311yLu9PwKF/mpiNlm+GOyPwdYpOaQ6X2
         Uki5IXPCTcZDRCWRAk24vv1Oqt6ZvMsYkmcyOg6PC3BJJyJgkxc8fWR1pnhuddghsVAi
         28PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680532521;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oxGsYI2QoyXkzuWq4RrJu/2bPGkvHLr5ePv0N/Bc5WI=;
        b=qKzSDNyCpSZ6goyG3qsl2neVHexRCm/82Qex/ZugekyOREjMhMFZE/EHVftE7JLz2m
         D9mG3m9FqbdlQSK3hHL3WIhtfJWd17/t1uq6z5AttVOy07hZbydVZy0kszO1LtvEO4x+
         qvJ0+HTC1yf4sQSDD+ht5as4tHDfbTGIi4Q3E1dhkcszrcog1Tsq8gfCDSuQuTyhNRcF
         xZI35MR8jgmksvd/2fz6GmLxNNrzjCzqI7FAMg4gM32+xkhKdVvHOESEBGLm7F8T1oLn
         14ROoRqXC/sMBjWR2EbsAmxF8Z8byo+IHHVogfoIfs/mz1xOqzhTVHO9N/LOUagJO/dN
         HwQQ==
X-Gm-Message-State: AO0yUKVIZvqgcanwGzAMFbyALKE6vpfzMZ1RzafoodtUVk2KlZZ35WHP
        g3oxQTCjYPnN8jOBMfr5PTv9nZGDPEcxlIQRJSKbBQ==
X-Google-Smtp-Source: AK7set92E/Ttuot2wNPkRx1oq18XrFEdzuhk04d+qv07SEliDZ8Z6rlbpMi0JazbFugYphUu9DdPUQ==
X-Received: by 2002:a05:6a20:e1e:b0:da:b92c:a949 with SMTP id ej30-20020a056a200e1e00b000dab92ca949mr32071094pzb.36.1680532520798;
        Mon, 03 Apr 2023 07:35:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w16-20020aa78590000000b0062e0c39977csm2881883pfn.139.2023.04.03.07.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 07:35:20 -0700 (PDT)
Message-ID: <642ae428.a70a0220.af8de.4a34@mx.google.com>
Date:   Mon, 03 Apr 2023 07:35:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.238-99-gebef86223f292
Subject: stable-rc/queue/5.4 baseline: 115 runs,
 5 regressions (v5.4.238-99-gebef86223f292)
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

stable-rc/queue/5.4 baseline: 115 runs, 5 regressions (v5.4.238-99-gebef862=
23f292)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.238-99-gebef86223f292/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-99-gebef86223f292
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ebef86223f292ec49001ea7920721eb4768b7cd8 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab1124d00e22f3162f76e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab1124d00e22f3162f773
        failing since 62 days (last pass: v5.4.230-81-g2ad0dc06d587, first =
fail: v5.4.230-108-g761a8268d868)

    2023-04-03T10:57:04.932246  <8>[    9.769132] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3467214_1.5.2.4.1>
    2023-04-03T10:57:05.039284  / # #
    2023-04-03T10:57:05.140947  export SHELL=3D/bin/sh
    2023-04-03T10:57:05.141348  #
    2023-04-03T10:57:05.242633  / # export SHELL=3D/bin/sh. /lava-3467214/e=
nvironment
    2023-04-03T10:57:05.243064  =

    2023-04-03T10:57:05.243280  / # . /lava-3467214/environment<3>[   10.08=
0312] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-04-03T10:57:05.344500  /lava-3467214/bin/lava-test-runner /lava-34=
67214/1
    2023-04-03T10:57:05.345143  =

    2023-04-03T10:57:05.350297  / # /lava-3467214/bin/lava-test-runner /lav=
a-3467214/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab1f079b471037762f7b4

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/642ab1f079b47103=
7762f7bd
        failing since 166 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-04-03T11:00:27.719041  / # =

    2023-04-03T11:00:27.720340  =

    2023-04-03T11:00:29.782508  / # #
    2023-04-03T11:00:29.783244  #
    2023-04-03T11:00:31.796489  / # export SHELL=3D/bin/sh
    2023-04-03T11:00:31.796900  export SHELL=3D/bin/sh
    2023-04-03T11:00:33.812311  / # . /lava-3467232/environment
    2023-04-03T11:00:33.813021  . /lava-3467232/environment
    2023-04-03T11:00:35.828369  / # /lava-3467232/bin/lava-test-runner /lav=
a-3467232/0
    2023-04-03T11:00:35.829624  /lava-3467232/bin/lava-test-runner /lava-34=
67232/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab1c8a63e973d7962f779

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab1c8a63e973d7962f77e
        failing since 5 days (last pass: v5.4.238-29-g39c31e43e3b2b, first =
fail: v5.4.238-60-gcf51829325af)

    2023-04-03T11:00:11.387294  + set +x<8>[   10.200545] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9849228_1.4.2.3.1>

    2023-04-03T11:00:11.387402  =


    2023-04-03T11:00:11.490245  #

    2023-04-03T11:00:11.491505  =


    2023-04-03T11:00:11.594143  / # #export SHELL=3D/bin/sh

    2023-04-03T11:00:11.594926  =


    2023-04-03T11:00:11.697104  / # export SHELL=3D/bin/sh. /lava-9849228/e=
nvironment

    2023-04-03T11:00:11.697880  =


    2023-04-03T11:00:11.799754  / # . /lava-9849228/environment/lava-984922=
8/bin/lava-test-runner /lava-9849228/1

    2023-04-03T11:00:11.800081  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab1d1a63e973d7962f80e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab1d1a63e973d7962f813
        failing since 5 days (last pass: v5.4.238-29-g39c31e43e3b2b, first =
fail: v5.4.238-60-gcf51829325af)

    2023-04-03T11:00:13.727114  <8>[   12.502210] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9849253_1.4.2.3.1>

    2023-04-03T11:00:13.730117  + set +x

    2023-04-03T11:00:13.835939  #

    2023-04-03T11:00:13.837007  =


    2023-04-03T11:00:13.939018  / # #export SHELL=3D/bin/sh

    2023-04-03T11:00:13.939641  =


    2023-04-03T11:00:14.041396  / # export SHELL=3D/bin/sh. /lava-9849253/e=
nvironment

    2023-04-03T11:00:14.042080  =


    2023-04-03T11:00:14.143847  / # . /lava-9849253/environment/lava-984925=
3/bin/lava-test-runner /lava-9849253/1

    2023-04-03T11:00:14.144953  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642ab0f9f6669bf5fb62f779

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-9=
9-gebef86223f292/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642ab0f9f6669bf5fb62f77e
        failing since 61 days (last pass: v5.4.230-108-g761a8268d868, first=
 fail: v5.4.230-109-g0a6085bff265)

    2023-04-03T10:56:34.861962  / # #
    2023-04-03T10:56:34.963775  export SHELL=3D/bin/sh
    2023-04-03T10:56:34.964190  #
    2023-04-03T10:56:35.065521  / # export SHELL=3D/bin/sh. /lava-3467217/e=
nvironment
    2023-04-03T10:56:35.065888  =

    2023-04-03T10:56:35.167245  / # . /lava-3467217/environment/lava-346721=
7/bin/lava-test-runner /lava-3467217/1
    2023-04-03T10:56:35.167941  =

    2023-04-03T10:56:35.173206  / # /lava-3467217/bin/lava-test-runner /lav=
a-3467217/1
    2023-04-03T10:56:35.271046  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-03T10:56:35.271545  + cd /lava-3467217/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
