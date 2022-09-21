Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36A75E562D
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 00:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiIUWSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 18:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiIUWSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 18:18:16 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7224A74FB
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:18:14 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j6-20020a17090a694600b00200bba67dadso218510pjm.5
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=fxPWx6RbbM9ebXxP0Gs/G1DyQ6koD4lIJol2i408gDQ=;
        b=0mS9zsP+A0c/9AuBrbAnvjYOTt69f7olpxuBQbLd4VP4HUiVrmXNa1ynDlcVWlqkEt
         LFLjS0et4p0Ubg4W/i3ztSxA7yBMVZbeGAeVOeOY1cbtNvXz7iWizRpPegv3HTa4Zmd2
         d6DeUlu+aoIZRa3eao3tBwYcRQZpxrF2GZqWOvMLZFZcqRIoJKBACEemnIaw0BbddV7f
         pKzBZZrh/UDoXkmEGVjVHqAiW+WCSQgxMjPHJit+npXW8BeZuH99bgEdqNjJHu7ZKE43
         EZ8AlIbYrM4HrKBilRUQ9wmvZHaA0JGNC4qqMzxn/Rv9gSQbWGcst6zxmd11e8zenlWu
         oaRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=fxPWx6RbbM9ebXxP0Gs/G1DyQ6koD4lIJol2i408gDQ=;
        b=VNs4U5apZU5HiYYUfn+5GGNnHJ2TaLhgIcH7v4xHMLAe+6QT/PUxceJ/PdmMtyO1ES
         0df95AfseToHtkEVwneDi6w9vf8yJ5b7wU6QE14OfSVkCdvkLooBxTapnTq5aBXguDLr
         aNVTDKL0X/qa6Q0bEn86Z8uIr1QK7fPftSmU+EpZbu+1IjKgSwGkhpAD5qlZr55L3jol
         KUrMd9ffqBTkvjCvAc7iltCiMXnIV9E/7Bv6BnVxop8Rso2408ZRXCoygMSolkt1NaZe
         X1aff8n/Ko0W3LKNgCWdccjq1rF2v6Fu8GpACLtvj03gYNLrglu/6+8wT/z3FHlaAL6/
         n3+g==
X-Gm-Message-State: ACrzQf2iPQ16pYN2pvek+b3eh1a0ifyPMlSnktDbuX1b7NYGe7snrobb
        L/Q6/sZO7yZChy4Opl3B7ZoSjUNXXEOQBDECaeY=
X-Google-Smtp-Source: AMsMyM7w4T6OhJDI7kWhdFvN1wRLtn+zMog2Y/9F8P73UYmuELa6FYwyennK64XNn8NsNsDfANaiSA==
X-Received: by 2002:a17:902:e891:b0:178:7b6:92db with SMTP id w17-20020a170902e89100b0017807b692dbmr294258plg.160.1663798694262;
        Wed, 21 Sep 2022 15:18:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902e84b00b001782a6fbcacsm2527480plg.101.2022.09.21.15.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 15:18:13 -0700 (PDT)
Message-ID: <632b8da5.170a0220.c8829.58bc@mx.google.com>
Date:   Wed, 21 Sep 2022 15:18:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.214-44-g9f0245ca78a0
Subject: stable-rc/linux-5.4.y baseline: 90 runs,
 10 regressions (v5.4.214-44-g9f0245ca78a0)
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

stable-rc/linux-5.4.y baseline: 90 runs, 10 regressions (v5.4.214-44-g9f024=
5ca78a0)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig |=
 2          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.214-44-g9f0245ca78a0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.214-44-g9f0245ca78a0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f0245ca78a06138c10f254c63a0633a2077d040 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
hifive-unleashed-a00       | riscv | lab-baylibre  | gcc-10   | defconfig |=
 2          =


  Details:     https://kernelci.org/test/plan/id/632b5b2599365f405c35565a

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/632b5b2599365f40=
5c35565f
        new failure (last pass: v5.4.214)
        3 lines

    2022-09-21T18:42:29.077577  / # =

    2022-09-21T18:42:29.088554  =

    2022-09-21T18:42:29.191616  / # #
    2022-09-21T18:42:29.200644  #
    2022-09-21T18:42:29.302106  / # export SHELL=3D/bin/sh
    2022-09-21T18:42:29.312536  export SHELL=3D/bin/sh
    2022-09-21T18:42:29.413792  / # . /lava-2517473/environment
    2022-09-21T18:42:29.424543  . /lava-2517473/environment
    2022-09-21T18:42:29.525960  / # /lava-2517473/bin/lava-test-runner /lav=
a-2517473/0
    2022-09-21T18:42:29.536530  /lava-2517473/bin/lava-test-runner /lava-25=
17473/0 =

    ... (10 line(s) more)  =


  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
632b5b2599365f405c355662
        new failure (last pass: v5.4.214)

    2022-09-21T18:42:31.133637  /lava-2517473/1/../bin/lava-test-case
    2022-09-21T18:42:31.149469  <8>[   11.802128] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>
    2022-09-21T18:42:31.149791  /lava-2517473/1/../bin/lava-test-case   =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5d1865841bdffe355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5d1865841bdffe355=
647
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5eb4cf00859e5c355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5eb4cf00859e5c355=
643
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5d2b65841bdffe355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5d2b65841bdffe355=
65a
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5d521b71cfac99355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5d521b71cfac99355=
679
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5d033041462bf535564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5d033041462bf5355=
64f
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5d389004d595d73556d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5d389004d595d7355=
6d6
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5d2c0a9dcdb2fd355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5d2c0a9dcdb2fd355=
676
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/632b5d6811347d7b6f355680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.214=
-44-g9f0245ca78a0/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b5d6811347d7b6f355=
681
        failing since 134 days (last pass: v5.4.191-85-ga4a4cbb41380, first=
 fail: v5.4.191-118-g7dae5fe9ddc0) =

 =20
