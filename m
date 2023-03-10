Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE36B5595
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 00:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjCJXYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 18:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjCJXYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 18:24:35 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1382410C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:24:32 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c4so4669543pfl.0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678490672;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jnj7FQBMmlvQJdorKbD3fWKDcLLTlRP7G/m9P+/ZRBA=;
        b=yo4sDUxnH0heBAMih1mm7uqBlKH1FD8dBjaTP4mWrw5k8NXOS7ucuGmqha3UF9bGDR
         1qrtwo/MsTgWQprGv6capjo3Q36NMX+R+ImM/LuntAbXtZB6NIGf3/GNWhp2Pjd/r3US
         TgwLSe67JE3L1MlVwQXVO3mL+SCTjiLGQDUvGvKUFAO3xy/UpNKX+5h5m6AFanTctTQc
         5Qltx4V080Q5yEJpSi94todnHoi9MaHgM+mOi3sNlMm0ct6qnWjj4OuOeHpyUozRX+CV
         uAXoMMdySH8DuRWEreVrbsfb+8lwX7cqoqqblG612jchhfiHLTCkm7FOKVRa0i80QZBp
         tJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678490672;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jnj7FQBMmlvQJdorKbD3fWKDcLLTlRP7G/m9P+/ZRBA=;
        b=UNyK1xGp6GgRGPGIK1ITBhImHj7cqBFSQp2rNswVTH4Yumw/UmF2c+gsvYFl/gr9W8
         TBoC/4toIS7m6t2l5fnADQyoreH+yyrAoS0/XA6al3In3FINygGYrtQic8KQPTBKKrlP
         UmGaoWCh+GnB57n/GTaLdpstDo7eQVxfZ1bOktzZjGLAOyDAC8ThUf4gBupEkLYOA79G
         eyuQ+PPT4UgAlpbgEfBRqYO2H+w2P3r5+YHT6G9UGposhGIYjVKBmu70AEXLFYwM9TQc
         WS594s0aryW+7PA9rRtXgZFIyUjZZueYvshVOUzxF0cX0NVAM9LjM/eKtloQ+VheEf5I
         QWYA==
X-Gm-Message-State: AO0yUKXBfcLjKoY16BCpEAJvWbF30+04jvnUCIzky5EcPHI8dw25I3nh
        BKEfM5pBF46uDiOBpFGfQLfu8ez+wyc7nl3ocTK6Bswh
X-Google-Smtp-Source: AK7set+q9geGm6jaOQEt1cJekfplit9aVfeTjeEFCbd0V0h4VpkygTNCDNilnbOHIgLEH+TtPp8mhQ==
X-Received: by 2002:a62:7b0c:0:b0:61d:e8bb:1cb0 with SMTP id w12-20020a627b0c000000b0061de8bb1cb0mr7342786pfc.1.1678490671811;
        Fri, 10 Mar 2023 15:24:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15-20020aa781cf000000b0059416691b64sm347328pfn.19.2023.03.10.15.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 15:24:27 -0800 (PST)
Message-ID: <640bbc2b.a70a0220.50f7d.147e@mx.google.com>
Date:   Fri, 10 Mar 2023 15:24:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172-529-g06956b9e9396
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 162 runs,
 13 regressions (v5.10.172-529-g06956b9e9396)
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

stable-rc/queue/5.10 baseline: 162 runs, 13 regressions (v5.10.172-529-g069=
56b9e9396)

Regressions Summary
-------------------

platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
beaglebone-black             | arm    | lab-broonie  | gcc-10   | omap2plus=
_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre | gcc-10   | multi_v7_=
defconfig           | 1          =

qemu_i386-uefi               | i386   | lab-baylibre | gcc-10   | i386_defc=
onfig               | 1          =

qemu_i386-uefi               | i386   | lab-broonie  | gcc-10   | i386_defc=
onfig               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre | gcc-10   | multi_v7_=
defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.172-529-g06956b9e9396/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.172-529-g06956b9e9396
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06956b9e9396e1d0f991bfffbead80bb65c201aa =



Test Regressions
---------------- =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
beaglebone-black             | arm    | lab-broonie  | gcc-10   | omap2plus=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/640b85c9e0c805ea588c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b85c9e0c805ea588c864b
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-10T19:32:12.125944  <8>[   19.031772] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 138525_1.5.2.4.1>
    2023-03-10T19:32:12.236310  / # #
    2023-03-10T19:32:12.339188  export SHELL=3D/bin/sh
    2023-03-10T19:32:12.339804  #
    2023-03-10T19:32:12.441830  / # export SHELL=3D/bin/sh. /lava-138525/en=
vironment
    2023-03-10T19:32:12.442593  =

    2023-03-10T19:32:12.544782  / # . /lava-138525/environment/lava-138525/=
bin/lava-test-runner /lava-138525/1
    2023-03-10T19:32:12.545606  =

    2023-03-10T19:32:12.550571  / # /lava-138525/bin/lava-test-runner /lava=
-138525/1
    2023-03-10T19:32:12.652994  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
cubietruck                   | arm    | lab-baylibre | gcc-10   | multi_v7_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b9e246d60b18b8c8651

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b8b9e246d60b18b8c865a
        failing since 43 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-10T19:57:05.856485  <8>[   11.090703] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3403258_1.5.2.4.1>
    2023-03-10T19:57:05.967126  / # #
    2023-03-10T19:57:06.070637  export SHELL=3D/bin/sh
    2023-03-10T19:57:06.071589  #
    2023-03-10T19:57:06.173720  / # export SHELL=3D/bin/sh. /lava-3403258/e=
nvironment
    2023-03-10T19:57:06.174940  =

    2023-03-10T19:57:06.277261  / # . /lava-3403258/environment/lava-340325=
8/bin/lava-test-runner /lava-3403258/1
    2023-03-10T19:57:06.278909  =

    2023-03-10T19:57:06.283240  / # /lava-3403258/bin/lava-test-runner /lav=
a-3403258/1
    2023-03-10T19:57:06.368324  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre | gcc-10   | i386_defc=
onfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b88a251ee5afcd38c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b88a251ee5afcd38c8=
654
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_i386-uefi               | i386   | lab-broonie  | gcc-10   | i386_defc=
onfig               | 1          =


  Details:     https://kernelci.org/test/plan/id/640b88786e426afa8b8c863b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b88786e426afa8b8c8=
63c
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8763ccfeefd7bc8c8682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8763ccfeefd7bc8c8=
683
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b88caa4def699058c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b88caa4def699058c8=
64a
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b87247f242f912a8c863d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b87247f242f912a8c8=
63e
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b88dca4def699058c8730

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b88dca4def699058c8=
731
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8764f95acf81a68c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8764f95acf81a68c8=
631
        failing since 11 days (last pass: v5.10.169-26-g0fe5da78fd18, first=
 fail: v5.10.170-8-gaf2a8e58967f) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b88cba4def699058c864c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b88cba4def699058c8=
64d
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8725e7aa0850538c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b8725e7aa0850538c8=
639
        failing since 11 days (last pass: v5.10.169-26-g0fe5da78fd18, first=
 fail: v5.10.170-8-gaf2a8e58967f) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie  | gcc-10   | x86_64_de=
fcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/640b892fc22c4b9c0d8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640b892fc22c4b9c0d8c8=
636
        failing since 24 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab          | compiler | defconfig=
                    | regressions
-----------------------------+--------+--------------+----------+----------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre | gcc-10   | multi_v7_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/640b8b330bfd4424318c8634

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-529-g06956b9e9396/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230303.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640b8b330bfd4424318c863d
        failing since 37 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-10T19:55:11.132080  / # #
    2023-03-10T19:55:11.234390  export SHELL=3D/bin/sh
    2023-03-10T19:55:11.234894  #
    2023-03-10T19:55:11.336469  / # export SHELL=3D/bin/sh. /lava-3403262/e=
nvironment
    2023-03-10T19:55:11.336969  =

    2023-03-10T19:55:11.438625  / # . /lava-3403262/environment/lava-340326=
2/bin/lava-test-runner /lava-3403262/1
    2023-03-10T19:55:11.439835  =

    2023-03-10T19:55:11.456328  / # /lava-3403262/bin/lava-test-runner /lav=
a-3403262/1
    2023-03-10T19:55:11.546238  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-10T19:55:11.546867  + cd /lava-3403262/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
