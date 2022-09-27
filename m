Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317185ECA63
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbiI0RDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiI0RDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 13:03:07 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702DEF3928
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:03:06 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso3589898pjf.5
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 10:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=izDzdXAT5bOoROwfB7662UOcXSSRHJmhIzqDS0Sd0KU=;
        b=QHx2t7abGVR6XUxQ/3BAR81bphAkmyBkJhDzRDJSG0KpBJyixzQKIfGujTCGmB69cc
         gtlH8H3IUvWNDH9deXJPnDXY2wiE+DNj9fJ11lWVIj4hbP96BayZoCJsItstqATPoHcF
         ALm+NxM08YpJd0LQztIUBFH2Nu5kHJL8e3MT1M3SgdYvsjFxju9MChD6vaVK/9djIarr
         DjLU4Jm7fn1BkVCblx0HUQZ7wY9Fm1ajuI5xsTlAnX1N2hYNpTjqcY4ZngCSpRxhp+Nf
         g6ujmDx7j3BkFUGru5pBXFw72uSKTZd1VbDTHg0cHdV7QZt7nszacpGY27Ldqjzgfv/P
         G2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=izDzdXAT5bOoROwfB7662UOcXSSRHJmhIzqDS0Sd0KU=;
        b=GYZuJ/lTuDxa9jjYxndWeMa5+HvCMd0xCwZSQLL9DEtHek/jz6zRHkF17MZFAqjoWg
         iKx4ZlHwXiwfaPNStd8lItYHA6WgSt99ZACnVy996l4G6pW1Pvvv2o7YvrNPnbkW1cIl
         DM9jpinaHjuHLh2yWX8WjBnb1uIrJs9k+dxHLqcYHMnqHomIK0bwxgVBJY4V0yVaw6Cr
         16gAGXRfi84JAORLo5q+nIA5cT2MiuBtTrtfs9owy1ZN/ifBHmGxTsua6mMejLYHu3vI
         xWhh8PcpC+IlzEXhFEQRSyhOgYHcHLbHFBHqlgmyLXBSkHrvOwsVcGsv2OqzYio2O83e
         EFHQ==
X-Gm-Message-State: ACrzQf2w8bat2qNBHt73Hl34wEhj1ykGT6tcP8ED4jOa6tpAgW2LseZv
        MKsAYGnOIMl76/n7niX0iZ4ASrqLXW7lSV5x
X-Google-Smtp-Source: AMsMyM5ylI4a8Pf6Gp3BEllH0NbGiQJd07NvcsQf5UrolCuGyaNUT7ZzdB5M2Pwvvb50IGJN8mLwMw==
X-Received: by 2002:a17:90a:4502:b0:202:7a55:558f with SMTP id u2-20020a17090a450200b002027a55558fmr5465690pjg.108.1664298185659;
        Tue, 27 Sep 2022 10:03:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2-20020a63fd42000000b00419ab8f8d2csm1832469pgj.20.2022.09.27.10.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 10:03:05 -0700 (PDT)
Message-ID: <63332cc9.630a0220.67780.3356@mx.google.com>
Date:   Tue, 27 Sep 2022 10:03:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.145-138-gc79813af804a
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 122 runs,
 7 regressions (v5.10.145-138-gc79813af804a)
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

stable-rc/queue/5.10 baseline: 122 runs, 7 regressions (v5.10.145-138-gc798=
13af804a)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =

panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig        | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.145-138-gc79813af804a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.145-138-gc79813af804a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c79813af804add709321717ba79ac86842930a56 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63330bcd2b1369feb6ec4edf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63330bcd2b1369feb6ec4=
ee0
        failing since 35 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633309d805fead2391ec4ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633309d805fead2391ec4=
ed1
        failing since 35 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6333103c2a353049c7ec4efa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6333103c2a353049c7ec4=
efb
        failing since 140 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63331078b507f7d2e5ec4ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63331078b507f7d2e5ec4=
ed3
        failing since 140 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63331064915b6be0bfec4ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63331064915b6be0bfec4=
ec2
        failing since 140 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63331169614e78718dec4eae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63331169614e78718dec4=
eaf
        failing since 140 days (last pass: v5.10.113-129-g2a88b987a070, fir=
st fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6332f8d42e8d3f4b93ec4f2a

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.145=
-138-gc79813af804a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6332f8d42e8d3f4b93ec4f50
        failing since 203 days (last pass: v5.10.103-56-ge5a40f18f4ce, firs=
t fail: v5.10.103-105-gf074cce6ae0d)

    2022-09-27T13:21:00.975606  /lava-7424191/1/../bin/lava-test-case
    2022-09-27T13:21:00.986731  <8>[   33.749311] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
