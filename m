Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D866ADDF9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 12:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjCGLvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 06:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbjCGLuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 06:50:52 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776F611671
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 03:49:30 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x20-20020a17090a8a9400b00233ba727724so1150830pjn.1
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 03:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678189768;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=/bt0htk85ZLOedRHGDqa5qKatqt/beKjVJVlZpkJ2n0=;
        b=MHZdMTeq8PijPUnZoyLYbQGUkU3nMzc+ffo46Kuo3uQxfjxcnlQUwkyzg+eTJ8SWbI
         wEJ/Q7GSLU9j7JoH7R0MxKsUrMt5r4vhnSLBe4P7on+nCvJ+Stfufc+jJZhay+4HuZIW
         BNqb7XAcbxeSrWpOELFgaWELtKNpplp1fBuEt8XNcP51CqrKO3L/mbid8Y1v/ArS+ptw
         Me90IehbF8CWJqXaEzcBrrGCtX9eYKHFWziL9J3NM82ffeAP7U2GR7WbIT3OXaA+/jTR
         t6f4hjPRpoKmp2/2SXKJiFoz/9PwGarW8RLjYRq7uvT4aSBK6SJ7uYzv4MZwTCXUoH/5
         ZcdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678189768;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/bt0htk85ZLOedRHGDqa5qKatqt/beKjVJVlZpkJ2n0=;
        b=gOHn5s38/fEJS/EjcMwWjLq04gF3Olwgx9rL4o7qainfVbL8qcw3hUoXj1DEdp7Yvo
         X9pfkKEJba9CvVxsZsQ7vZIgPAIcgMrtI2wSVDHUXuaIX9sHj4Y2jciHOy/1POn14SHr
         dQENVORRBcOGSW67ql6t+qIrrRTPr5MBdk4i0ZGlIspNpx2jTEJTV/o1ravleq/luXc2
         16OlHD4MOruzZIAyGk3P5FdAvFIifwbD/KryBA7iYiZorNqEnrnc0OzC7h7PGbxIgemR
         exRmgc8sc991ogeFRudI13vpe4RiJV7dCD0wSRDyhRfkKVbj+tx8lBd1Gc6VPxxI+EZ2
         XaOw==
X-Gm-Message-State: AO0yUKUZ4ijBuOy96HxBz78/1bX5y9vg0JzLquGLhlQf7tv/oJE5YPF8
        /cY71xmdWHfTJm7X6zFs7QAFyz969rcUjWIJH+PS/g==
X-Google-Smtp-Source: AK7set/N7nOs3obJc5Rs/Co1005E3aNEOlPdhewUkbJ5qZdcOoZ41YHaH/B/xzVP+iCCtcjrpBGI+w==
X-Received: by 2002:a17:903:283:b0:19d:1871:3bfa with SMTP id j3-20020a170903028300b0019d18713bfamr18439368plr.27.1678189767963;
        Tue, 07 Mar 2023 03:49:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ko16-20020a17090307d000b0019472226769sm8285313plb.251.2023.03.07.03.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:49:27 -0800 (PST)
Message-ID: <640724c7.170a0220.3ab58.eca7@mx.google.com>
Date:   Tue, 07 Mar 2023 03:49:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.172-334-gdc54315d4ae2a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 175 runs,
 15 regressions (v5.10.172-334-gdc54315d4ae2a)
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

stable-rc/queue/5.10 baseline: 175 runs, 15 regressions (v5.10.172-334-gdc5=
4315d4ae2a)

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

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.172-334-gdc54315d4ae2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.172-334-gdc54315d4ae2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc54315d4ae2ab10c72f162b730434161ef41802 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6405cef866da8500d58c864e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6405cef866da8500d58c8657
        failing since 20 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-03-06T11:30:45.739586  <8>[   19.310864] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 106835_1.5.2.4.1>
    2023-03-06T11:30:45.850081  / # #
    2023-03-06T11:30:45.953105  export SHELL=3D/bin/sh
    2023-03-06T11:30:45.953901  #
    2023-03-06T11:30:46.056269  / # export SHELL=3D/bin/sh. /lava-106835/en=
vironment
    2023-03-06T11:30:46.057271  =

    2023-03-06T11:30:46.159231  / # . /lava-106835/environment/lava-106835/=
bin/lava-test-runner /lava-106835/1
    2023-03-06T11:30:46.160233  =

    2023-03-06T11:30:46.164675  / # /lava-106835/bin/lava-test-runner /lava=
-106835/1
    2023-03-06T11:30:46.267772  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d35a43dc5625c18c866f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6405d35a43dc5625c18c8678
        failing since 38 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-06T11:49:22.888850  <8>[   11.021310] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3390194_1.5.2.4.1>
    2023-03-06T11:49:23.005152  / # #
    2023-03-06T11:49:23.108710  export SHELL=3D/bin/sh
    2023-03-06T11:49:23.109462  #
    2023-03-06T11:49:23.211063  / # export SHELL=3D/bin/sh. /lava-3390194/e=
nvironment
    2023-03-06T11:49:23.211439  =

    2023-03-06T11:49:23.312629  / # . /lava-3390194/environment/lava-339019=
4/bin/lava-test-runner /lava-3390194/1
    2023-03-06T11:49:23.313152  =

    2023-03-06T11:49:23.315028  / # /lava-3390194/bin/lava-test-runner /lav=
a-3390194/1<3>[   11.451910] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-03-06T11:49:23.315238   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d32753eaef32aa8c8677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i=
386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i=
386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d32753eaef32aa8c8=
678
        failing since 20 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d3548a3a2d49398c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d3548a3a2d49398c8=
630
        failing since 20 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-collabora | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d319266abbe6018c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_=
i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_=
i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d319266abbe6018c8=
640
        failing since 20 days (last pass: v5.10.167-105-g33398e62147f, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d212a6bd638de58c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d212a6bd638de58c8=
640
        new failure (last pass: v5.10.172-330-g033c500a02a0) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d3c7d2c0b1d58a8c8649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayli=
bre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayli=
bre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d3c7d2c0b1d58a8c8=
64a
        failing since 20 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d2a0d1cd801a4b8c8637

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d2a0d1cd801a4b8c8=
638
        new failure (last pass: v5.10.172-330-g033c500a02a0) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d3baab23b566648c8657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d3baab23b566648c8=
658
        failing since 20 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d3a5ab23b566648c863f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d3a5ab23b566648c8=
640
        failing since 20 days (last pass: v5.10.167-123-g60f1e5752ec8, firs=
t fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d213a6bd638de58c8642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d213a6bd638de58c8=
643
        failing since 20 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d3c8d2c0b1d58a8c864f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayli=
bre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayli=
bre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d3c8d2c0b1d58a8c8=
650
        failing since 20 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d2b4f3bd0290a38c8664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d2b4f3bd0290a38c8=
665
        failing since 20 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d40869c6b863cf8c8648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broon=
ie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6405d40869c6b863cf8c8=
649
        failing since 20 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6405d341ef448c03a88c86ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.172=
-334-gdc54315d4ae2a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6405d341ef448c03a88c86f5
        failing since 32 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-06T11:48:55.030748  / # #
    2023-03-06T11:48:55.132556  export SHELL=3D/bin/sh
    2023-03-06T11:48:55.133125  #
    2023-03-06T11:48:55.234478  / # export SHELL=3D/bin/sh. /lava-3390191/e=
nvironment
    2023-03-06T11:48:55.234931  =

    2023-03-06T11:48:55.336303  / # . /lava-3390191/environment/lava-339019=
1/bin/lava-test-runner /lava-3390191/1
    2023-03-06T11:48:55.337026  =

    2023-03-06T11:48:55.341869  / # /lava-3390191/bin/lava-test-runner /lav=
a-3390191/1
    2023-03-06T11:48:55.405966  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-06T11:48:55.440751  + cd /lava-3390191/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
