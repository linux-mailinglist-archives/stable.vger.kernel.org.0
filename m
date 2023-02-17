Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D1969B61C
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 00:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBQXCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 18:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBQXCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 18:02:44 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF31126
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 15:02:41 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id o1so1503649pgm.7
        for <stable@vger.kernel.org>; Fri, 17 Feb 2023 15:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BVjIpmF5/pcAivUf06PkfmIssdtDbNf6jldkPlP5oHQ=;
        b=q3pLRHLDIj95s+AjgovKN2/1a84gkIKOeNeUME8GpRk637nNlqMiUmUG+T5hVr50PG
         BC8G7r4LFbXRopKKYJact8fXWq+MMfaM3XQv5cy2ymnPNTlmRnuHilJ+zLwPh8sTEEUz
         TkGICzX2BrpeAkHIXClH6zc2S+NFhkPTvD7DlAbMyASM8sXQmNWZ5dM1aiEFeU03pH5k
         QUxEA/9PGYELzDMbH3A0rJBuKpVYJZvuyDXu53wKc08n3iKqbAbofe5Jif3gvixiFUnc
         o8JFOQ50ZLj3IKnd3YWmsMpo7Xna8h7/s4zGLo7Y6Xj04f2EtsPaaQQOPfRIV0s4a4tV
         c9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BVjIpmF5/pcAivUf06PkfmIssdtDbNf6jldkPlP5oHQ=;
        b=ahb/MhgoZMlZFUuQOIeyiHvHGjWMXWuFQJ0EbtaOMlGFHmKt/F9y8y6ol7turApzRL
         EjVAtEik9YtSqY+GtZA/uCCY6j5kISh0egcVyrA5VKNqMXmtDOouGphofcL77x1kZrg3
         YMCFxfFMXcRBiSzrR4s4f3zj/z+0fajPE7sPgzwN9yNF23NVLZdypKtNxl1TxMaq3FtO
         FgXXEVBKla8Lk60WeE0L41BBwVU7+XUfRTuJlTIssLu1isaGGfP/Ma+h4AXvp0qPti2o
         /8BXIXh+JZuDH2aG8GDL0g+Vmcxhuda7TS6IWuH1loc3ZnrBu31GzzDqG5BKbWbFmAjC
         Kvng==
X-Gm-Message-State: AO0yUKXUlcbRiVFp+8uYGdYEqQLwc4FzefFpDESDUjoMAZV8y1UwFN4q
        urz3MJVIpfcvoU9vb+zh4wYGa5Av7YzNJCQpdsA=
X-Google-Smtp-Source: AK7set+p2E0lnUPFMmMW/Ap4/hqGy62s8dGu+6WA97Oed8CiO21Trzvlom/Ph9WtYY4SyuIr/dYXLQ==
X-Received: by 2002:a62:1552:0:b0:5a8:ae6b:bdb0 with SMTP id 79-20020a621552000000b005a8ae6bbdb0mr2632310pfv.33.1676674960143;
        Fri, 17 Feb 2023 15:02:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q21-20020a62ae15000000b005a9131b6668sm3561741pff.2.2023.02.17.15.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 15:02:39 -0800 (PST)
Message-ID: <63f0078f.620a0220.a5322.7437@mx.google.com>
Date:   Fri, 17 Feb 2023 15:02:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.168-20-g097ab9f1d70c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 14 regressions (v5.10.168-20-g097ab9f1d70c)
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

stable-rc/queue/5.10 baseline: 161 runs, 14 regressions (v5.10.168-20-g097a=
b9f1d70c)

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

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.168-20-g097ab9f1d70c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.168-20-g097ab9f1d70c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      097ab9f1d70c10e25884d73332558d77e0f1e454 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd73fd7572389c38c8661

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63efd73fd7572389c38c866a
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701)

    2023-02-17T19:36:10.320459  + set +x
    2023-02-17T19:36:10.329510  <8>[   20.885712] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 30593_1.5.2.4.1>
    2023-02-17T19:36:10.432643  / # #
    2023-02-17T19:36:10.534903  export SHELL=3D/bin/sh
    2023-02-17T19:36:10.535523  #
    2023-02-17T19:36:10.637268  / # export SHELL=3D/bin/sh. /lava-30593/env=
ironment
    2023-02-17T19:36:10.637881  =

    2023-02-17T19:36:10.739890  / # . /lava-30593/environment/lava-30593/bi=
n/lava-test-runner /lava-30593/1
    2023-02-17T19:36:10.741046  =

    2023-02-17T19:36:10.745337  / # /lava-30593/bin/lava-test-runner /lava-=
30593/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd4704599f609458c8668

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63efd4704599f609458c8671
        failing since 22 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-02-17T19:24:21.648106  <8>[   11.059318] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3348188_1.5.2.4.1>
    2023-02-17T19:24:21.759954  / # #
    2023-02-17T19:24:21.863304  export SHELL=3D/bin/sh
    2023-02-17T19:24:21.864363  #
    2023-02-17T19:24:21.966553  / # export SHELL=3D/bin/sh. /lava-3348188/e=
nvironment
    2023-02-17T19:24:21.967063  =

    2023-02-17T19:24:22.068428  / # . /lava-3348188/environment/lava-334818=
8/bin/lava-test-runner /lava-3348188/1
    2023-02-17T19:24:22.069752  =

    2023-02-17T19:24:22.075303  / # /lava-3348188/bin/lava-test-runner /lav=
a-3348188/1
    2023-02-17T19:24:22.158984  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd2e1db0a5e3ad88c865a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63efd2e1db0a5e3ad88c8=
65b
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/63f005f7ab3a72afcc8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f005f7ab3a72afcc8c8=
631
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd2e5db0a5e3ad88c8660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63efd2e5db0a5e3ad88c8=
661
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd332145f11e53f8c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63efd332145f11e53f8c8=
637
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f00683dfa74519c68c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f00683dfa74519c68c8=
634
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f006d301dcad318b8c8677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f006d301dcad318b8c8=
678
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd2e4818e9894848c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63efd2e4818e9894848c8=
645
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd331145f11e53f8c8633

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63efd331145f11e53f8c8=
634
        failing since 3 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63f006476f3d12e4da8c8688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f006476f3d12e4da8c8=
689
        failing since 3 days (last pass: v5.10.167-127-g921934d621e4, first=
 fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63f00684dfa74519c68c8636

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63f00684dfa74519c68c8=
637
        failing since 3 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd32c9d987b37188c86a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63efd32c9d987b37188c8=
6a3
        failing since 3 days (last pass: v5.10.167-123-g60f1e5752ec8, first=
 fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63efd3e962ca139e428c865c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.168=
-20-g097ab9f1d70c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63efd3e962ca139e428c8665
        failing since 15 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-02-17T19:22:01.208219  / # #
    2023-02-17T19:22:01.310074  export SHELL=3D/bin/sh
    2023-02-17T19:22:01.310597  #
    2023-02-17T19:22:01.411950  / # export SHELL=3D/bin/sh. /lava-3348199/e=
nvironment
    2023-02-17T19:22:01.412508  =

    2023-02-17T19:22:01.513863  / # . /lava-3348199/environment/lava-334819=
9/bin/lava-test-runner /lava-3348199/1
    2023-02-17T19:22:01.514699  =

    2023-02-17T19:22:01.519688  / # /lava-3348199/bin/lava-test-runner /lav=
a-3348199/1
    2023-02-17T19:22:01.583723  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-17T19:22:01.631418  + cd /lava-3348199/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
