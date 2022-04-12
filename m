Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C971B4FDEB6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 13:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345227AbiDLL5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 07:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233482AbiDLL5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 07:57:00 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6DA60D8F
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:42:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q3so5182729plg.3
        for <stable@vger.kernel.org>; Tue, 12 Apr 2022 03:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=twmBKkCFQJI6foF8Ii8lnQp/HTuWa1riKpOCc4W+Feo=;
        b=Dr10zHMNukcTCr2DcABSITcxv48nDGP2NLe5qSFZHDHKAXlGWtwG6vR/O/dtHNYSps
         HUrVvqXsUbDt+Osqvwbg2e+fSwlCooOA3F8MX3ljN6yS98RgnVYYjAxBEqAstk4z/Sh1
         9S46jHGzipO/yuZF+YZykQ6yVdTlY6+jlbRRyRAbn3B35MlRKxsscra1rAz+AWsRH1T+
         P9Di6ouTctS7Smj4hpwRXk7bF8pqS8qlnqIUjUrWNzkS5E9fEoHO6jYtwNWWODVg4bli
         ZpPMqImo1sIDgZX0xWRwH081bsXYZHf+KasKeOtUSW1HCEieJw/UlwBaNTO5YQS82jwI
         JYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=twmBKkCFQJI6foF8Ii8lnQp/HTuWa1riKpOCc4W+Feo=;
        b=beFOPYKz0PWfKx0h5CGEfC/fTayxRBjLFjxl4GW39i0OffAOlNaqQMOZGsHtDLjeTo
         GD5b60iGE3QI643HaIKQwINd9MhGQIxCbZaNl0V1aEorxeI5nJAa1aLMmDmjRzi0QSms
         L8SCdjhR/aV5Us1uUltZt5202nA3twXZ6GKjvW8WIrDE2K6br6giCXT2ToJs70/L651w
         nxoFYAqCyzcSc+NBIitXM7HbVbFrnsY72DZ+LO+qMQOVR2uZAW9NIiseAJ/i/cokko/9
         DQ+ALW+b/2rq8kDUSnx0Kyj7IWvWOG6RdtNIKbhV3W38sw99YrwlCDUvEkoBYCOVwaVm
         ckBA==
X-Gm-Message-State: AOAM5303AVD4+5nvtvA/f2rLJQ4pGYR3Wczg9HSFOPuzVyW9bp4Beq/Z
        FpZAQNKql1m1Mrrh77fHwvjM78uUoZShnaun
X-Google-Smtp-Source: ABdhPJzFbdzmTl/LeU9pepIBweemrUx/YK7NBQ46CVX3Z9pt9CdfwOgR8mNYLY1l9hHPcLDJAq0j8w==
X-Received: by 2002:a17:902:7088:b0:156:1aa9:79eb with SMTP id z8-20020a170902708800b001561aa979ebmr36550485plk.71.1649760150406;
        Tue, 12 Apr 2022 03:42:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f30-20020a63755e000000b00381f6b7ef30sm2419826pgn.54.2022.04.12.03.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:42:30 -0700 (PDT)
Message-ID: <62555796.1c69fb81.d2af7.6dd7@mx.google.com>
Date:   Tue, 12 Apr 2022 03:42:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.33-277-g0ad89ff00683
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 103 runs,
 2 regressions (v5.15.33-277-g0ad89ff00683)
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

stable-rc/queue/5.15 baseline: 103 runs, 2 regressions (v5.15.33-277-g0ad89=
ff00683)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.33-277-g0ad89ff00683/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.33-277-g0ad89ff00683
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ad89ff0068339b9ed27f2521d445d109ed0eb92 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62552679f51ed431dbae06ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g0ad89ff00683/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g0ad89ff00683/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62552679f51ed431dbae0=
6ae
        failing since 12 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625527520dfc00b9a7ae0690

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g0ad89ff00683/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.33-=
277-g0ad89ff00683/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625527520dfc00b9a7ae06b2
        failing since 35 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-12T07:16:16.990211  /lava-6070883/1/../bin/lava-test-case
    2022-04-12T07:16:17.001432  <8>[   33.595173] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
