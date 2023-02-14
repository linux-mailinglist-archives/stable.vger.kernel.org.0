Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FD3696E2B
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 20:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbjBNTyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 14:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBNTyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 14:54:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596062BF15
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 11:54:45 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id kk7-20020a17090b4a0700b00234463de251so1609474pjb.3
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 11:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=d9tjnw+iCH1LIt7Rr558YwK//SxWeHsNJ0dMCiRWnSs=;
        b=wbiesKUN/fwnJk8n2HAVf14OwS1mTpcnXWmBuy0j0DXNPR2KjnfaQ0NakdlVMc92Ob
         KdwlJ+s35NPabRfZ+2+/ae62sJKsFaEpIGpE/EF0/zd7L2qy9XGJIrz6QU40DaRT1EOQ
         7WKIs5fi3eaXoPgaGuaeurqWODfzJsOQ/JA5qs+d+S/8khDtbUSj2ZqffF4r7ta2QlQf
         SSZv9/xY8BO13oNPCHl9CIsUqIDg8PKkk/b6gQbbbWsIO5Pkpv2lU4iAV8ww3MKs8Y3R
         O4lwiXbccsh4I/ONfVCj4yuB68c1KVjgxZKnVJn/odIs+cPKuhuZsqzR8tp7LX4vE6yk
         puuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d9tjnw+iCH1LIt7Rr558YwK//SxWeHsNJ0dMCiRWnSs=;
        b=ol7gVu7JNLMDHw9CA7VL1J2wFRXYjUBnnETqr+rPsuWu9AyXZlx6ZX5Io9qgsEa7PE
         c7ipmSnQn67UORM6XnBxD4pYzd8B6H96NSQtxG4VBdaCdNmIQqPUxeARYVGPBepcPg2H
         ildFxvQq9K9Mvm6JyvxqORTX1DoQnIwohNMVqXj9o760+GzPB3PkxM3X7ZSQeI29rAGG
         AtFzVi5lGANqmVCVHAlemtYe6Mzijtv4Ib+Fb6fgIB8In+EJ4754XnvJKZwVa75sRGAs
         C5henwQTJU3bLhyhAvFkO5EapIvHI58lZQ3A3pY7h3srBlPfsM+05GrCMFfoqyvCrDuf
         JdMA==
X-Gm-Message-State: AO0yUKX/LH6oOICF1mrI7bmaTc3cKF4bcDw6waV64hDsNt61P9NVGu3T
        WqyT2V5tDZg6pIiDVfVyha7cqZnn9n505mjF8KE=
X-Google-Smtp-Source: AK7set80q+h7NDWY2gA8d0VFJ3BCDS59tJwUULF55WfzdZdd9lpXgLGEuycm69eJrMNmbXjxj1/fUg==
X-Received: by 2002:a05:6a20:734c:b0:b9:5fda:cd71 with SMTP id v12-20020a056a20734c00b000b95fdacd71mr3556067pzc.6.1676404484373;
        Tue, 14 Feb 2023 11:54:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d17-20020a170902b71100b001990028c0c9sm10558311pls.68.2023.02.14.11.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 11:54:44 -0800 (PST)
Message-ID: <63ebe704.170a0220.f7ff7.34b1@mx.google.com>
Date:   Tue, 14 Feb 2023 11:54:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167-134-g8d59a82738db
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 14 regressions (v5.10.167-134-g8d59a82738db)
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

stable-rc/queue/5.10 baseline: 159 runs, 14 regressions (v5.10.167-134-g8d5=
9a82738db)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =

qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
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
efconfig             | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.167-134-g8d59a82738db/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.167-134-g8d59a82738db
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d59a82738db4406dfce004a65857c3167d8ec4a =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb147e44959c53c8c863a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ebb147e44959c53c8c8643
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-gf9519a5a1701)

    2023-02-14T16:05:08.110994  <8>[   20.912466] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 13945_1.5.2.4.1>
    2023-02-14T16:05:08.220989  / # #
    2023-02-14T16:05:08.323305  export SHELL=3D/bin/sh
    2023-02-14T16:05:08.323873  #
    2023-02-14T16:05:08.425654  / # export SHELL=3D/bin/sh. /lava-13945/env=
ironment
    2023-02-14T16:05:08.426189  =

    2023-02-14T16:05:08.527996  / # . /lava-13945/environment/lava-13945/bi=
n/lava-test-runner /lava-13945/1
    2023-02-14T16:05:08.528850  =

    2023-02-14T16:05:08.533006  / # /lava-13945/bin/lava-test-runner /lava-=
13945/1
    2023-02-14T16:05:08.627222  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-baylibre  | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb16970ead8bf348c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/i386/i386_defconfig/gcc-10/lab-baylibre/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb16970ead8bf348c8=
633
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_i386-uefi               | i386   | lab-broonie   | gcc-10   | i386_def=
config               | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb1b41d7c362a448c8676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/i386/i386_defconfig/gcc-10/lab-broonie/baseline-qemu_i38=
6-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb1b41d7c362a448c8=
677
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb19ffc7938b2c68c8654

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb19ffc7938b2c68c8=
655
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb1c810f6738f008c862f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb1c810f6738f008c8=
630
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb30705bcd8141d8c8631

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb30705bcd8141d8c8=
632
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb5758b09ca37e28c8638

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb5758b09ca37e28c8=
639
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi             | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb19dfd125afd748c8662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb19dfd125afd748c8=
663
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb1a11d7c362a448c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylib=
re/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb1a11d7c362a448c8=
633
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-baylibre  | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb1e1a36e191adb8c8703

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qem=
u_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb1e1a36e191adb8c8=
704
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb34484f608f98d8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb34484f608f98d8c8=
631
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-gf9519a5a1701) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-broonie   | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb5748b09ca37e28c8632

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb5748b09ca37e28c8=
633
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_x86_64-uefi-mixed       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efconfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb19c0d56f86cf58c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ebb19c0d56f86cf58c8=
656
        failing since 0 day (last pass: v5.10.167-127-g921934d621e4, first =
fail: v5.10.167-139-g8b1e92c42811) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63ebb2e66c9ae88cef8c8649

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.167=
-134-g8d59a82738db/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230211.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ebb2e66c9ae88cef8c8652
        failing since 12 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-02-14T16:12:07.059351  / # #
    2023-02-14T16:12:07.161197  export SHELL=3D/bin/sh
    2023-02-14T16:12:07.161664  #
    2023-02-14T16:12:07.262999  / # export SHELL=3D/bin/sh. /lava-3339275/e=
nvironment
    2023-02-14T16:12:07.263428  =

    2023-02-14T16:12:07.364787  / # . /lava-3339275/environment/lava-333927=
5/bin/lava-test-runner /lava-3339275/1
    2023-02-14T16:12:07.365449  =

    2023-02-14T16:12:07.371697  / # /lava-3339275/bin/lava-test-runner /lav=
a-3339275/1
    2023-02-14T16:12:07.468684  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-14T16:12:07.468983  + cd /lava-3339275/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
