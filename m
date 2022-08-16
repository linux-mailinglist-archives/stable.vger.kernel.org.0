Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308DE594F37
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 05:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiHPD6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 23:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiHPD6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 23:58:18 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A1C3412DF
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:24:01 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x23so7774617pll.7
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 17:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=+iI2QEO91E6MCBFwCbAYlt1s8pP89JbzLEoGFIRxLRw=;
        b=eqxSClUgVC4ZsxEdtdA6jAGuxbBWI9WPO3P/377/RmfUL5rgjaN2McHNvo9KwOsPEW
         ECilReim8rehdkTTF6ig0/+IuONA/Z+IERVcR/bXfSAi//YNlbG/k7unCG05fGSlyeGY
         CZMzz04Fdu8UMK6vS4X2L4xOoNK3en3CQzR2LKVZBFP9dOa22QS2B+mHpeTpwomtwM7/
         KzI1Ld4GeOjqrbE+Onx6/PXoZ/xxVVmYpGH4GHW+eARY7u0EcXHHDD1RFds06tjqtMrT
         FvDPCUK5nz0wS8gaHrCxdfi/e9YTyWwrgi1Vr2b2lk/gCFdYtrE08Jmxvr/NRlD0RvlC
         AkFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=+iI2QEO91E6MCBFwCbAYlt1s8pP89JbzLEoGFIRxLRw=;
        b=HR505u69mObqqx1MnWiOdPDtprWpZU2krFvPFZm+4VoPECSswvPIjyeW8h3EGveFGh
         J4WqdelXYmhD8clZDog1Aa3JEmOrvqJtOFKDYMXvJp0Bzf9Obq0ySxMqZwywbc7/dpbN
         ftkqK0mg1MW5oUjdXAmrFjfdc8j2bHCcd/BYgfgmbQxTsQl4/qtyjlK+9afcRgE1sttQ
         yrNjrnK2biLCSCFy8CiRD7ZAexEZ6sduLVJZNYR39t3hlMkRAEAO2QdkBse0SBEJ3u1h
         wN3MZ0k0O9qwUBWwcvj23PFWdZyT7Ov9HvEDtxnWHRCg7K2M8psdspGAZBDMcMX/Ou7r
         Gi9A==
X-Gm-Message-State: ACgBeo01LtHfBVECDoDIWZSMXLF+IDTFAtiui5R0fowhCAMajwR1O4Y8
        UOcDb/quD66ugTNdYbBn060xVb6bAT+dc84H
X-Google-Smtp-Source: AA6agR62qf/TChOXSkY5XtM65fCg7sjPHj2xKjGEWT54McNdKvfZvxbCDkKu5L/WSTEJhrLywkFOfA==
X-Received: by 2002:a17:902:e38b:b0:172:7170:529d with SMTP id g11-20020a170902e38b00b001727170529dmr6046054ple.152.1660609440155;
        Mon, 15 Aug 2022 17:24:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17-20020a63dc51000000b0042988a04bfdsm1028535pgj.9.2022.08.15.17.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 17:23:59 -0700 (PDT)
Message-ID: <62fae39f.630a0220.a58b4.200b@mx.google.com>
Date:   Mon, 15 Aug 2022 17:23:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.1-1157-g133ae52c0a31a
Subject: stable-rc/queue/5.19 baseline: 145 runs,
 4 regressions (v5.19.1-1157-g133ae52c0a31a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.19 baseline: 145 runs, 4 regressions (v5.19.1-1157-g133ae=
52c0a31a)

Regressions Summary
-------------------

platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit      | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_de=
fconfig | 1          =

kontron-pitx-imx8m      | arm64 | lab-kontron     | gcc-10   | defconfig   =
        | 1          =

r8a77950-salvator-x     | arm64 | lab-baylibre    | gcc-10   | defconfig   =
        | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-10   | defconfig   =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.1-1157-g133ae52c0a31a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.1-1157-g133ae52c0a31a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      133ae52c0a31af5b66775919462d7823dbfc31c3 =



Test Regressions
---------------- =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit      | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62fac1ed43fd63be3c355679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fac1ed43fd63be3c355=
67a
        new failure (last pass: v5.19.1-45-gee0f76071c2b9) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
kontron-pitx-imx8m      | arm64 | lab-kontron     | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62faab3ed3a6cf62a4355703

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/62f=
aab3fd3a6cf62a4355716
        new failure (last pass: v5.19.1-62-gbac914bd6e705)

    2022-08-15T20:23:06.845234  /lava-154866/1/../bin/lava-test-case
    2022-08-15T20:23:06.845683  <8>[   22.753110] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-08-15T20:23:06.845960  /lava-154866/1/../bin/lava-test-case
    2022-08-15T20:23:06.846239  <8>[   22.773119] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-08-15T20:23:06.846559  /lava-154866/1/../bin/lava-test-case
    2022-08-15T20:23:06.846820  <8>[   22.794337] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-08-15T20:23:06.847169  /lava-154866/1/../bin/lava-test-case   =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
r8a77950-salvator-x     | arm64 | lab-baylibre    | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62faab47853f539ab035564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faab47853f539ab0355=
650
        new failure (last pass: v5.19.1-62-gbac914bd6e705) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-10   | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/62faac2d9d64c862963556bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.1-1=
157-g133ae52c0a31a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62faac2d9d64c86296355=
6be
        new failure (last pass: v5.19.1-62-gbac914bd6e705) =

 =20
