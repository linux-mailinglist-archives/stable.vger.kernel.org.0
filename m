Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B3A6AEF11
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjCGSUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbjCGST0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:19:26 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D9E9BA77
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:47 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso17360474pjr.5
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 10:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678212826;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kPUGXhHf1hwPpjyK3kO/Vrf6nnse5tDbVrjl0HH12GI=;
        b=0y3QoqZFkWjz9bDpyc35Jxk0oHnfEZpUVQQQgjxkBx87E4p9yBzoGkEKyIsCvWhC4j
         rKYt3o+tUpv25e1KppK3/v6UbHXiSnBVNOef7Qe94TdQp9J1SqkYLznqBWxtnDPJAEjx
         1fgbt0bhIY/rVORopGuKwMAGu8/e3q5/m1ib1R+rhTEE9xeBXw7CTHuQimErP4YAcaor
         ZTRTktbSzXzhAF7HirEr5DXb8WQBwdqHUlWAHALD1XgaNlDmOlmS9DmvaQJrVwXaTnkJ
         qfK2sIcqwWBsB6miWIEVEcDKvfDKsmjoHU1TXDdFG/NNtRSjYbYSwdHqxXWhwp03hQ+T
         FPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678212826;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPUGXhHf1hwPpjyK3kO/Vrf6nnse5tDbVrjl0HH12GI=;
        b=oefKDv6AhQ05dna0oY1tEwR2W77gsWUDTQX2Pppllva9EVQb+FoNm0cF/AeKA1QGx9
         feWO9p9jw9Og1JZqJZfJgaOuXoPznOesFHV+QF188TSkjdGIXhQfkhbF+PUAKtB1P0FE
         mi3Gszz3iYbfO3Kp4qBksWqjuMqipl100AyXQwVl8eMaqzBZRQ1ZADTW+dEVhKvRJiSJ
         khG+KL4di4XqQRBn4NCC1P9GOU/8tt2o4qJjnc/l4kDdgVrg49obI1CUNE+prYTu/o27
         UkHF8PYQr3Jhn+X2Kan1J//b8ZKwS1SYEN17/M8zA72mI0cJ27SvdquwHCTcWpPUagbi
         FRmQ==
X-Gm-Message-State: AO0yUKUORds0wNf7eFkxHKuWbs6+CTNqzUs+xln5qmH89yZqH52qMG1G
        +AaJDguznsBcffOfFqxTwryHwYRXhlIrlOZbRDePtQ==
X-Google-Smtp-Source: AK7set/oHC0W/Q3MfC/BBNWkDWQuKTfbRjUn1j6Eo2Nkn0KHZUIsJ8v38+QVCcNHZsRH2o9O+KI3xg==
X-Received: by 2002:a17:902:ea0c:b0:19a:727e:d4f3 with SMTP id s12-20020a170902ea0c00b0019a727ed4f3mr22244554plg.5.1678212825999;
        Tue, 07 Mar 2023 10:13:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090a154600b002372107fc3dsm9279524pja.49.2023.03.07.10.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:13:45 -0800 (PST)
Message-ID: <64077ed9.170a0220.38262.1cab@mx.google.com>
Date:   Tue, 07 Mar 2023 10:13:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172-417-g889fe658be7a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 19 regressions (v5.10.172-417-g889fe658be7a)
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

stable-rc/queue/5.10 baseline: 189 runs, 19 regressions (v5.10.172-417-g889=
fe658be7a)

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

hp-14-db0003na-grunt         | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.172-417-g889fe658be7a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.172-417-g889fe658be7a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      889fe658be7af8a2cff058b683429589b851d32c =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640748e039cd9c29688c8635

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640748e039cd9c29688c863e
        failing since 21 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-07T14:23:13.975163  / # #
    2023-03-07T14:23:14.090391  export SHELL=3D/bin/sh
    2023-03-07T14:23:14.094927  #
    2023-03-07T14:23:14.203311  / # export SHELL=3D/bin/sh. /lava-115581/en=
vironment
    2023-03-07T14:23:14.208143  =

    2023-03-07T14:23:14.316475  / # . /lava-115581/environment/lava-115581/=
bin/lava-test-runner /lava-115581/1
    2023-03-07T14:23:14.325141  =

    2023-03-07T14:23:14.329530  / # /lava-115581/bin/lava-test-runner /lava=
-115581/1
    2023-03-07T14:23:14.432215  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-07T14:23:14.438993  + cd /lava-115581/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64074e0ac7b9498b858c8675

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64074e0ac7b9498b858c867e
        failing since 40 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-07T14:45:16.594133  <8>[   11.085506] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3391826_1.5.2.4.1>
    2023-03-07T14:45:16.702815  / # #
    2023-03-07T14:45:16.804451  export SHELL=3D/bin/sh
    2023-03-07T14:45:16.804839  #
    2023-03-07T14:45:16.906068  / # export SHELL=3D/bin/sh. /lava-3391826/e=
nvironment
    2023-03-07T14:45:16.906465  =

    2023-03-07T14:45:17.007932  / # . /lava-3391826/environment/lava-339182=
6/bin/lava-test-runner /lava-3391826/1
    2023-03-07T14:45:17.009255  =

    2023-03-07T14:45:17.009565  / # <3>[   11.451583] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-07T14:45:17.013751  /lava-3391826/bin/lava-test-runner /lava-33=
91826/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-14-db0003na-grunt         | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640747af1b7908bf848c8665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-14-db0003na-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-14-db0003na-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640747af1b7908bf848c8=
666
        new failure (last pass: v5.10.172-334-gdc54315d4ae2a) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/6407462388592367418c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6407462388592367418c8=
652
        failing since 21 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/6407461a88592367418c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6407461a88592367418c8=
639
        failing since 21 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/64074608a27245a2068c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64074608a27245a2068c8=
656
        failing since 21 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640747b31b7908bf848c866b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640747b31b7908bf848c8=
66c
        failing since 21 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6407487ccc54beeeeb8c8646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6407487ccc54beeeeb8c8=
647
        failing since 21 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640747e6e0ebc610288c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640747e6e0ebc610288c8=
655
        failing since 21 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64074ec82f77a965608c867b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64074ec82f77a965608c8=
67c
        failing since 21 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64074798b917a02ca68c8640

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64074798b917a02ca68c8=
641
        failing since 21 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640748609fb873c7688c864a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640748609fb873c7688c8=
64b
        failing since 21 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640747b5d72bf781e48c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640747b5d72bf781e48c8=
638
        failing since 21 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6407487dcc54beeeeb8c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6407487dcc54beeeeb8c8=
64a
        failing since 21 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6407484b9fb873c7688c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6407484b9fb873c7688c8=
640
        failing since 21 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640751498b047b06e58c8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640751498b047b06e58c8=
646
        failing since 21 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640747b01b7908bf848c8668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640747b01b7908bf848c8=
669
        failing since 21 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64074874cb752790528c8663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64074874cb752790528c8=
664
        failing since 21 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64074dfcc7b9498b858c862f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-417-g889fe658be7a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64074dfcc7b9498b858c8638
        failing since 33 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-07T14:44:47.995278  / # #
    2023-03-07T14:44:48.096966  export SHELL=3D/bin/sh
    2023-03-07T14:44:48.097346  #
    2023-03-07T14:44:48.198691  / # export SHELL=3D/bin/sh. /lava-3391838/e=
nvironment
    2023-03-07T14:44:48.199052  =

    2023-03-07T14:44:48.300384  / # . /lava-3391838/environment/lava-339183=
8/bin/lava-test-runner /lava-3391838/1
    2023-03-07T14:44:48.301287  =

    2023-03-07T14:44:48.307674  / # /lava-3391838/bin/lava-test-runner /lav=
a-3391838/1
    2023-03-07T14:44:48.371798  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-07T14:44:48.418591  + cd /lava-3391838/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
