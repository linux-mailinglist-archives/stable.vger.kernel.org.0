Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97946BC1BD
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 00:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjCOXtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 19:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjCOXtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 19:49:45 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E23B1C5A9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:49:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso3015927pjb.3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 16:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678924171;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=coxTsk+biH3I7hQ9GAZVrbgGze3GQnTsW9wA7nJAXqM=;
        b=DmKJHYahVOLBaxoojBBraQ2jFN2jHqx4LA1makKH1InGSJGzHJslfBMuG2LHCZhIpZ
         LWJv6Om0L4cGr65Dhwu0PgN++tL8l/PBTlPWBoLnLcvKFLPoO1lJVRwmz5OvVUkaUY8m
         qZwQ4ZA/mf0QqBL6rGiyywdTUJ6kmvP6ELInnJHxLi9KoLFL1xAyj0XR4gUOZ09DYMpB
         A4C3Rqv0iktG7sQUV7NqUTxCriS1tEzpDR/4Iihx4WQJyBXBZpE7egqUm4Js8gAYx2A+
         xWK9KtODZVLKIavaPE/OH6T4QTPnydfmwMgEOneerK01q5celc2RLRkKa6mZb1SySLRg
         kDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924171;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=coxTsk+biH3I7hQ9GAZVrbgGze3GQnTsW9wA7nJAXqM=;
        b=VogH9vl0n5OxchGRx1NYOarEKKDy0eBq2gvaPUxgNejAMHJT8TArYgprGcTHKp5LdP
         +6PpeMUd57sEJ/GQPJ55iaGFIoVhCggHNY7owbPUOU79+UAxN9DTgBvXxBl1IjiQpK8X
         KQQCX1FCpYqshMnYvxEpMo/j7vhN6x+zzge/SM+0BhNY/r9LUjD2VbMcwzg9bmnWYL7u
         jhJ91EJG2Jm1tZwf5V3dMMjgPAPrT31e0Gwq/MGcR5VptXJEL6Cj11n9y6bvz/emg9Og
         1HqrAnUJeTrB+KNVZUnUWRRxCRPQm61LOXJT5g6uuMWLBneSftyW4kykXOZOCEjLhvYX
         uMaw==
X-Gm-Message-State: AO0yUKWK5e/YRlQ71a4yYiJUr6xBcF71k6yQ7zUlGm21f9WBaPcf7XWj
        bsTwc/GFVyoHxJyql+gmWz7OJdKK1nD/u9cB4+BYq1oW
X-Google-Smtp-Source: AK7set/ivwt5FhmMntfxT2DYn1T6FIeRO4o/TuoL6dfmHu4FNedRzcftHwQ82+AlNBn1ELq4UVie+Q==
X-Received: by 2002:a17:903:6c8:b0:19e:6e9d:4bd with SMTP id kj8-20020a17090306c800b0019e6e9d04bdmr1039894plb.43.1678924171539;
        Wed, 15 Mar 2023 16:49:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a6-20020a1709027e4600b00192c5327021sm4142099pln.200.2023.03.15.16.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 16:49:31 -0700 (PDT)
Message-ID: <6412598b.170a0220.28432.9aa4@mx.google.com>
Date:   Wed, 15 Mar 2023 16:49:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-107-g16db2cbd9bc8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 173 runs,
 11 regressions (v5.10.173-107-g16db2cbd9bc8)
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

stable-rc/queue/5.10 baseline: 173 runs, 11 regressions (v5.10.173-107-g16d=
b2cbd9bc8)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.173-107-g16db2cbd9bc8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.173-107-g16db2cbd9bc8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      16db2cbd9bc8535fe0e95e9b439e9844d73bf8ee =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C433TA-AJ0005-rammus    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641225bffcd8a9c3128c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C433TA-AJ0005-rammus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641225bffcd8a9c3128c8=
63c
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641225ab842e287af98c863e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641225ab842e287af98c8=
63f
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641225aa7f991bdc598c863a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641225aa7f991bdc598c8=
63b
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64122779ca1187ded68c86b3

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64122779ca1187ded68c86ed
        failing since 29 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-15T20:15:34.558675  <8>[   21.231765] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 168617_1.5.2.4.1>
    2023-03-15T20:15:34.669888  / # #
    2023-03-15T20:15:34.773019  export SHELL=3D/bin/sh
    2023-03-15T20:15:34.773635  #
    2023-03-15T20:15:34.875564  / # export SHELL=3D/bin/sh. /lava-168617/en=
vironment
    2023-03-15T20:15:34.876158  =

    2023-03-15T20:15:34.978030  / # . /lava-168617/environment/lava-168617/=
bin/lava-test-runner /lava-168617/1
    2023-03-15T20:15:34.978948  =

    2023-03-15T20:15:34.983970  / # /lava-168617/bin/lava-test-runner /lava=
-168617/1
    2023-03-15T20:15:35.077866  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6412259a3d342d17fa8c8648

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6412259a3d342d17fa8c8651
        failing since 48 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-15T20:07:26.412368  <8>[   10.970553] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3414698_1.5.2.4.1>
    2023-03-15T20:07:26.521745  / # #
    2023-03-15T20:07:26.623503  export SHELL=3D/bin/sh
    2023-03-15T20:07:26.623979  #
    2023-03-15T20:07:26.725320  / # export SHELL=3D/bin/sh. /lava-3414698/e=
nvironment
    2023-03-15T20:07:26.725783  =

    2023-03-15T20:07:26.827108  / # . /lava-3414698/environment/lava-341469=
8/bin/lava-test-runner /lava-3414698/1
    2023-03-15T20:07:26.827792  <3>[   11.291552] Bluetooth: hci0: command =
0x0c03 tx timeout
    2023-03-15T20:07:26.827997  =

    2023-03-15T20:07:26.833027  / # /lava-3414698/bin/lava-test-runner /lav=
a-3414698/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...4305U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641225bf842e287af98c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-4305U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641225bf842e287af98c8=
663
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
dell-latitude...8665U-sarien | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641225b7f0e821c9178c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-dell-latitude-5400-8665U-sarien.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641225b7f0e821c9178c8=
630
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/641226d5310fd6de228c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/641226d5310fd6de228c8=
641
        failing since 0 day (last pass: v5.10.173-89-gbb0818a7908b, first f=
ail: v5.10.173-107-gce2ebcbb3458) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6412287b1cd6f996c98c8661

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6412287b1cd6f996c98c866d
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T20:20:06.670439  <8>[   33.840204] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>

    2023-03-15T20:20:07.696504  /lava-9638101/1/../bin/lava-test-case

    2023-03-15T20:20:07.707645  <8>[   34.877311] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6412287b1cd6f996c98c866e
        failing since 1 day (last pass: v5.10.172-529-g06956b9e9396, first =
fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-15T20:20:06.658731  /lava-9638101/1/../bin/lava-test-case
   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6412256294c4dec1648c866e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.173=
-107-g16db2cbd9bc8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6412256294c4dec1648c8677
        failing since 42 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-15T20:06:35.303474  / # #
    2023-03-15T20:06:35.405520  export SHELL=3D/bin/sh
    2023-03-15T20:06:35.406032  #
    2023-03-15T20:06:35.507407  / # export SHELL=3D/bin/sh. /lava-3414704/e=
nvironment
    2023-03-15T20:06:35.507940  =

    2023-03-15T20:06:35.609356  / # . /lava-3414704/environment/lava-341470=
4/bin/lava-test-runner /lava-3414704/1
    2023-03-15T20:06:35.610148  =

    2023-03-15T20:06:35.614440  / # /lava-3414704/bin/lava-test-runner /lav=
a-3414704/1
    2023-03-15T20:06:35.713434  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-15T20:06:35.713828  + cd /lava-3414704/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
