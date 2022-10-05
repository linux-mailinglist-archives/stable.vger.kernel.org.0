Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB395F5A12
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 20:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiJESrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 14:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiJESrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 14:47:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E79639A
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 11:47:10 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id 10so12540731pli.0
        for <stable@vger.kernel.org>; Wed, 05 Oct 2022 11:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=6dgqCDHbScXkHLLlemA2C2W6fIdgrDzAgFAM4PEjTGg=;
        b=bpYUlzVmI1kw1fJnTgOd48MHFokalCtIflXoGcl6eIzz5FD3RtZn8buzmxCQr3IJ2n
         NUkRS39MXCFFo3e/euIQNA7QVRvPtKEk4w9hZxPgIFUNMe1e4q/y9DmxEgad5kkXl0nb
         O3SCkFzEm8c6bQGXk+5uVji5ZvcXAs3zvdS8qBh3nKGbE3n8cC3cPAtKTcyUJTLHRE7n
         Molc3mIgWmGVRBMesjNSiPkWbBlH7UDhDScHgRr2z3yKSS54c5OQckyect3qO43lruXj
         tI7bOoe0oZhjDftE9uK2cpaNnYW5kDEGAUA9HL8PCxqzmEpr3s4rr8JBdB0tPbJYt6uc
         I4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=6dgqCDHbScXkHLLlemA2C2W6fIdgrDzAgFAM4PEjTGg=;
        b=d0Eo/K31U3U/UwAUEsGpBnAVpxhzeXQl/oiN8BhQi+MCCgAmpjs/7bWcirmEa0VDWD
         waqIQRhd4MuFxzDwexe5RAvg62EhB4CM6aYrULUDf2ZVQE5z0aJyR7Y6wwo5w+PDFbmO
         EvJXa8+bc3eep7oUcbuuozMdDGtAUvm4UPASdVejQPBuvbIx/QOXi2qIEX3yAeEoR7q1
         y7lWcUdQMWOuAnqbHaFbH7pZbLlOoD/RZJn0ibrL/UGyFvjY1for06tj1cpKuxcd6pbU
         Ee6bunm2f+Z0ZQtWf0xqHZjhY1vZ+QwZ4BzkgZa5SZR0mHUkwNK24K9R5g7MeDn5qOCI
         vqMg==
X-Gm-Message-State: ACrzQf1VvOFKH2vjr+f4u1jooFUTzRnEoYjbJsoR3IrV8RX1DAF/whY0
        PCubeqU/dRug9ZClSIckfAO2VwhWAofGSAdcryQ=
X-Google-Smtp-Source: AMsMyM5hi02H50NfI2N1euPMM3UuAeZ2H9v6AIrmvezcn50lhXaP54+UIOwEydKHqWAlsfSIdVfjQQ==
X-Received: by 2002:a17:902:ea0e:b0:178:3d49:45ad with SMTP id s14-20020a170902ea0e00b001783d4945admr721057plg.103.1664995629941;
        Wed, 05 Oct 2022 11:47:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902714a00b001755f43bc22sm10747707plm.175.2022.10.05.11.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 11:47:09 -0700 (PDT)
Message-ID: <633dd12d.170a0220.7f592.2743@mx.google.com>
Date:   Wed, 05 Oct 2022 11:47:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.146-54-g7f3de029fd2fe
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 129 runs,
 6 regressions (v5.10.146-54-g7f3de029fd2fe)
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

stable-rc/queue/5.10 baseline: 129 runs, 6 regressions (v5.10.146-54-g7f3de=
029fd2fe)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =

panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.146-54-g7f3de029fd2fe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.146-54-g7f3de029fd2fe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f3de029fd2fec34371a67d56fd97058758765b9 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/633da8de5e655b5d53cab60e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633da8de5e655b5d53cab=
60f
        failing since 43 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/633da63390c165084dcab5fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633da63390c165084dcab=
5ff
        failing since 43 days (last pass: v5.10.136-539-g2b0d128e38cdb, fir=
st fail: v5.10.137-150-g8b56d7183e67) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633db2bcbef837e428cab5fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633db2bcbef837e428cab=
5fb
        failing since 71 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633db17c84c6cbda73cab609

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633db17c84c6cbda73cab=
60a
        failing since 71 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633db18dafce991d3acab605

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633db18dafce991d3acab=
606
        failing since 71 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/633db179fa5fb04f6ccab5f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.146=
-54-g7f3de029fd2fe/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633db179fa5fb04f6ccab=
5f5
        failing since 71 days (last pass: v5.10.101-110-ge437828b3a54, firs=
t fail: v5.10.133-85-g4c4562ba4bd5) =

 =20
