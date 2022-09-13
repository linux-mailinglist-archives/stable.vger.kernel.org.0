Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D652B5B7CC3
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 23:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiIMViN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 17:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIMViM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 17:38:12 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944E261B10
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 14:38:11 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id iw17so13187871plb.0
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 14:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=RI85eOs/f5x3kLZjxL7TlYu01ixUszpyP0DvrF1Eok0=;
        b=zKcXGQRNlZywD5E7JkwPZokPzEFxuvtE/3p9EYXp2m6HFMz5SgQRIXNNaPtz7xRvnJ
         TZpxk6I5nDtELU2VnSxlSoqAL39tRcqTL+TIDyULafMOi+RDyoYqNJKeeVv5KhNG6oq9
         t9Dok0sMLBHOqMrOcroFS8OCBUiD/dCc9X8f2Jnzxrdws9QypeOUW2zGBe06D+R4bke5
         pYRX3KePnfd24yMwIfyVAWplIhbAIupUn7J8Mlf+F2ZWSEWUFQD+SF5qSpvVkNbeBH4w
         6Sex5PZVnT5gACWNefVHdA2jHMUDKESWf8RFIZnqW4PI2UFXGHuY8pRQj4xjqfcG+Kce
         OQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=RI85eOs/f5x3kLZjxL7TlYu01ixUszpyP0DvrF1Eok0=;
        b=wZj6w9LeAsttscWjXD+aHjCn+/t1z68DPNi7rJ1IA6ODVkXwJhiLSh0T5f/lng/yO2
         IbY6/ulEP8g0F8i01efq3XWgM0NxTSEJP72G5P8qq6axR6EUiMx63I1nRPbta1NEY+a2
         s516toGNxOgc5AGUn/y/R7xX61UibdoeTq0/sknPEBEg4osRdV6IUVa/19YUDCh9sBif
         CZZFSV26JaOIeS9/vCEtF+ZhYjRB5fygvRawGU5G44mDvCuAWVrsAGC8BnXYlRRpoAAd
         LJ3OzkN0HhHQ/6+nDORl5DRaG/5oP4w9WhuNfwE9JEpZmPuQZYmyIJUz5R0MR6kc2Eb8
         wiiQ==
X-Gm-Message-State: ACgBeo1wF2hDOPQ493Vs5xTcN0BhuGjTN7qpSJbewKmU4Xoq6RSCPtB8
        yJ/2A4T22BJeGcwO0YotqVmB8pyPo+uwNKHD2bI=
X-Google-Smtp-Source: AA6agR4kQ2XN/0s6zoIh/Yb6RpchbOQbSLo6Qsl4OVwQc8fpxmOIm0ZlRrp1oqndJzDQEPW5NCusbQ==
X-Received: by 2002:a17:902:6943:b0:178:4751:a76b with SMTP id k3-20020a170902694300b001784751a76bmr5000255plt.37.1663105090799;
        Tue, 13 Sep 2022 14:38:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902f68600b00176b3d7db49sm9109489plg.0.2022.09.13.14.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 14:38:10 -0700 (PDT)
Message-ID: <6320f842.170a0220.9b2d3.ff0f@mx.google.com>
Date:   Tue, 13 Sep 2022 14:38:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.67-122-gdbbecf1f4a70f
Subject: stable-rc/linux-5.15.y baseline: 171 runs,
 3 regressions (v5.15.67-122-gdbbecf1f4a70f)
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

stable-rc/linux-5.15.y baseline: 171 runs, 3 regressions (v5.15.67-122-gdbb=
ecf1f4a70f)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.67-122-gdbbecf1f4a70f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.67-122-gdbbecf1f4a70f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbbecf1f4a70fc81ce87ab06e01ebfb7b0e2de03 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6320c82c0a6983ffab355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-122-gdbbecf1f4a70f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-122-gdbbecf1f4a70f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320c82c0a6983ffab355=
643
        failing since 124 days (last pass: v5.15.37-259-gab77581473a3, firs=
t fail: v5.15.39) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6320ebb7560a6d1f77355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-122-gdbbecf1f4a70f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-122-gdbbecf1f4a70f/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12=
b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320ebb7560a6d1f77355=
643
        failing since 1 day (last pass: v5.15.67, first fail: v5.15.67-119-=
gabdca1a68c773) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6320c905e2aed58ad235564a

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-122-gdbbecf1f4a70f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.6=
7-122-gdbbecf1f4a70f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6320c905e2aed58ad2355670
        failing since 189 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-09-13T18:16:10.147934  <8>[   32.479645] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-09-13T18:16:11.171654  /lava-7263675/1/../bin/lava-test-case
    2022-09-13T18:16:11.183075  <8>[   33.514686] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
