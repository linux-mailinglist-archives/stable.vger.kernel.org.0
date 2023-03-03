Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B79E6AA56E
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbjCCXMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjCCXMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:12:45 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493BAEF9B
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 15:12:43 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id y2so4215544pjg.3
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 15:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677885162;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wtYtsBH/tSL81ZZHe23Wi4Hs0imyibmEW8HZUGODLGo=;
        b=BLngIeg9N3xuG75lSbvgal1gXfh0Gk1EqA1j5WrMEZMIazmXRqFZxksJ3v6O+bKngU
         JvtlOLFR7/LtGaR0oHRnnM7vaKBmcMvBk0h22Xn3Q1L/wwhOdHNJ55arOXrJuyIYUMvY
         0kOux3Re8x3RAi9XjaY/uXQo4bfaFbH2VkzrwP9IDJKiJfeOOfkIMtDN9pwVkqrS8meZ
         D2Xkflh8g2vPC2+WYxCAsxhbemDxZcjLlqG+Wnmv3OPnJr01dCmXEv0PUhFFyiC0DdNv
         T6s3PPCDAp0Swow3gctY1/hBjW9MuumfSYlMXUdkgCkqxXkRzLMYR9jjwiLlrKLmhlS3
         qAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677885162;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wtYtsBH/tSL81ZZHe23Wi4Hs0imyibmEW8HZUGODLGo=;
        b=Rj1BGlguhGSR/u7TOoWU8ngihbaSCkdmqmqMYHNYMQGubAWm7fnGSoeU+z7B+yaj4D
         ZannZsAOL+ZBzfHZQ8izzKp9IBZJ6CSvFXSxGHjRTGEUmNw7zx/OtKKmxQn7lbufM2UC
         iusK+3C+uOiZD1fSD98DqtLYM3UQ4Gy8l5sLInbASgKHQVco9fuFD2oUiG3LORiS09YK
         xaWqfRR3jtRLeJViQwchNPoyetIRA4f1GbLZlDjFeaV6yx5sT9arkkltiLi0dogPrNWg
         IiAYrEUjffeyDmcbAmsiwjkuWyGDFQIH1wHKHHb2AwURoi6AzRaT9VsrEUsdshLyhz8q
         oUQg==
X-Gm-Message-State: AO0yUKXkgo5H0LVrchjQVlXlHCfIe6j+ppZs/QBnVevEkV67hO0uNeS5
        5woXn0KBsFjMV3HPHzyrwdO6oZ4IjNA9Aref9XtoS8IO
X-Google-Smtp-Source: AK7set/+zT2gvf9sds6h58KeiSLWaNchG6BObUDc0ywrEtBXbLyHiGE1mllFtf44J4VI5BZy5HgMNQ==
X-Received: by 2002:a17:902:ec84:b0:19c:c87b:4740 with SMTP id x4-20020a170902ec8400b0019cc87b4740mr4127419plg.34.1677885162328;
        Fri, 03 Mar 2023 15:12:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090340c400b0018b025d9a40sm1968704pld.256.2023.03.03.15.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 15:12:42 -0800 (PST)
Message-ID: <64027eea.170a0220.5283e.43f1@mx.google.com>
Date:   Fri, 03 Mar 2023 15:12:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 175 runs, 15 regressions (v5.10.172)
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

stable-rc/linux-5.10.y baseline: 175 runs, 15 regressions (v5.10.172)

Regressions Summary
-------------------

platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
cubietruck             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =

fsl-lx2160a-rdb        | arm64  | lab-nxp       | gcc-10   | defconfig     =
               | 1          =

meson-g12a-sei510      | arm64  | lab-baylibre  | gcc-10   | defconfig     =
               | 1          =

qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =

qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =

r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.172/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.172
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9fd42770b50756c08f04b4070ab6572adb2d6e1b =



Test Regressions
---------------- =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
cubietruck             | arm    | lab-baylibre  | gcc-10   | multi_v7_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64024aae06e1df24128c865d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64024aae06e1df24128c8666
        failing since 44 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-03-03T19:29:12.623088  <8>[   11.045345] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3382671_1.5.2.4.1>
    2023-03-03T19:29:12.729478  / # #
    2023-03-03T19:29:12.831029  export SHELL=3D/bin/sh
    2023-03-03T19:29:12.831394  #
    2023-03-03T19:29:12.831546  / # <3>[   11.211862] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-03T19:29:12.932717  export SHELL=3D/bin/sh. /lava-3382671/envir=
onment
    2023-03-03T19:29:12.933088  =

    2023-03-03T19:29:13.034830  / # . /lava-3382671/environment/lava-338267=
1/bin/lava-test-runner /lava-3382671/1
    2023-03-03T19:29:13.035697  =

    2023-03-03T19:29:13.039853  / # /lava-3382671/bin/lava-test-runner /lav=
a-3382671/1 =

    ... (12 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
fsl-lx2160a-rdb        | arm64  | lab-nxp       | gcc-10   | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/64024eb49580c7d3128c8652

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-lx2160a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64024eb49580c7d3128c8659
        new failure (last pass: v5.10.155)

    2023-03-03T19:46:52.042503  [   15.845514] <LAVA_SIGNAL_ENDRUN 0_dmesg =
1163633_1.5.2.4.1>
    2023-03-03T19:46:52.148045  / # #
    2023-03-03T19:46:52.249867  export SHELL=3D/bin/sh
    2023-03-03T19:46:52.250312  #
    2023-03-03T19:46:52.351701  / # export SHELL=3D/bin/sh. /lava-1163633/e=
nvironment
    2023-03-03T19:46:52.352144  =

    2023-03-03T19:46:52.453505  / # . /lava-1163633/environment/lava-116363=
3/bin/lava-test-runner /lava-1163633/1
    2023-03-03T19:46:52.454235  =

    2023-03-03T19:46:52.456121  / # /lava-1163633/bin/lava-test-runner /lav=
a-1163633/1
    2023-03-03T19:46:52.472538  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
meson-g12a-sei510      | arm64  | lab-baylibre  | gcc-10   | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/64024df43d12bc0ec78c8671

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64024df43d12bc0ec78c867a
        new failure (last pass: v5.10.170)

    2023-03-03T19:43:37.272852  <8>[   23.378065] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3382713_1.5.2.4.1>
    2023-03-03T19:43:37.376947  / # #
    2023-03-03T19:43:37.479580  export SHELL=3D/bin/sh
    2023-03-03T19:43:37.480224  #
    2023-03-03T19:43:37.582003  / # export SHELL=3D/bin/sh. /lava-3382713/e=
nvironment
    2023-03-03T19:43:37.582728  =

    2023-03-03T19:43:37.684672  / # . /lava-3382713/environment/lava-338271=
3/bin/lava-test-runner /lava-3382713/1
    2023-03-03T19:43:37.685886  =

    2023-03-03T19:43:37.704223  / # /lava-3382713/bin/lava-test-runner /lav=
a-3382713/1
    2023-03-03T19:43:37.760187  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (13 line(s) more)  =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-baylibre  | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/64024a9d06e1df24128c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024a9d06e1df24128c8=
630
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_i386-uefi         | i386   | lab-broonie   | gcc-10   | i386_defconfig=
               | 1          =


  Details:     https://kernelci.org/test/plan/id/64024ab506e1df24128c8698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024ab506e1df24128c8=
699
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64024a4f0278f0e1a88c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024a4f0278f0e1a88c8=
64a
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64024aee34415a46268c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024aee34415a46268c8=
632
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64024a510278f0e1a88c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024a510278f0e1a88c8=
652
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi       | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64024b91f37735afa68c8677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024b91f37735afa68c8=
678
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64024a500ad221b6be8c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mi=
xed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu_x86_64-uefi-mi=
xed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024a500ad221b6be8c8=
630
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre  | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64024aedc9caba07098c8653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024aedc9caba07098c8=
654
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/64024a520ad221b6be8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mix=
ed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_x86_64-uefi-mix=
ed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024a520ad221b6be8c8=
636
        failing since 18 days (last pass: v5.10.167, first fail: v5.10.167-=
140-g65fa84413c15) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64024b7db4ada8f32e8c8635

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024b7db4ada8f32e8c8=
636
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-collabora | gcc-10   | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64024ad9acb16b16078c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024ad9acb16b16078c8=
64a
        failing since 17 days (last pass: v5.10.167, first fail: v5.10.167-=
135-gd76a8be7803e) =

 =



platform               | arch   | lab           | compiler | defconfig     =
               | regressions
-----------------------+--------+---------------+----------+---------------=
---------------+------------
r8a7743-iwg20d-q7      | arm    | lab-cip       | gcc-10   | shmobile_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64024a3dac06a6d7e68c8676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
72/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64024a3dac06a6d7e68c8=
677
        new failure (last pass: v5.10.170) =

 =20
