Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBDE6E34AA
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 03:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjDPB31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 21:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjDPB31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 21:29:27 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66153A98
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 18:29:25 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b4dfead1bso813743b3a.3
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 18:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681608565; x=1684200565;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=G8nluba7nJw2numKGyrad6SKFReNHTo+/8LkKjRFQpQ=;
        b=f8mYLIEHmQdUgxNeVmOsfvCARmfmb+gx7hcn5ZsS9zKEmbUMa5SC8FsxHVNT7s++8b
         Fjr/4TwiJ+5o1FhzBLvczKTpRBDHgpBKBzEmiyMmEwFH4it55i5I/YuUk9R1s+ZP9nvq
         44ZPePqIuXvnWFvHM9s9U2FK3x8WdSPZJQQ4h9aPkIMo9/FM5LA4RB/EF7xDuAb8M65G
         b0oX4AhV6n+feCCTN16pvNX6nf7qopEebBvGukQ1LGtuqiZ5bR4zm6YNJcq3OqCwHO78
         PILRK5QqwoZOsI9Qbo2GJQl7jVvIG45limNLnRot/Yc8hgV5S+rJF/uKG9ahsvGjy/O8
         M6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681608565; x=1684200565;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G8nluba7nJw2numKGyrad6SKFReNHTo+/8LkKjRFQpQ=;
        b=f1PjLJBFk0TamEujJFzccXcY6rfqGXZb6ab16VBqBGHDFWt3L6B9fUPrMffDW1nc85
         nkDjgbQzJBILWO+3I+VcfQzDASBBTcv7xWFXnCQKCGtOQSWK/qJ+jEOCvZnoF+jDuCm4
         NFKznI7FOGAorRrmwqtYK7faDiFTXklHZrHeaS6WBSBw3JclXlV4qIx/JgwSdABaqS8z
         eHKfpUpt/z75a4wIuD1YB0xAFYir0Hq1qTZvwqILD7SkQgAmg1oHh3WiN3r6vrjiVj2X
         wtLtAjaGeNsG/9TSywgcCuCZxpt9OkhsO1NjIU4RM7+8yZbmkgQc2c/TyIPHqPujTm2t
         XRmQ==
X-Gm-Message-State: AAQBX9fs/FqjuoX4JGb2Py3nCJz/RZsQ5JGGgXGZdBay1wvGrT3H00qs
        pvdOdWhVcU0AeYpPZ5QrmpSIiJE/aVnC4oglCwZPYQ==
X-Google-Smtp-Source: AKy350aZDunbY34eOqjkD7QYzgaCUYHYFJAh9u0ERnMavvPleGiyWzDU+lvVT0blQV4Lknd0J/yTrA==
X-Received: by 2002:a05:6a00:2d1e:b0:63b:57c3:dfc5 with SMTP id fa30-20020a056a002d1e00b0063b57c3dfc5mr15195332pfb.14.1681608565146;
        Sat, 15 Apr 2023 18:29:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4-20020aa78504000000b0063b675526eesm3344284pfn.46.2023.04.15.18.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 18:29:24 -0700 (PDT)
Message-ID: <643b4f74.a70a0220.7638b.758d@mx.google.com>
Date:   Sat, 15 Apr 2023 18:29:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-241-ga0049fd9c865
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 133 runs,
 3 regressions (v5.10.176-241-ga0049fd9c865)
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

stable-rc/queue/5.10 baseline: 133 runs, 3 regressions (v5.10.176-241-ga004=
9fd9c865)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
beaglebone-black             | arm  | lab-broonie  | gcc-10   | omap2plus_d=
efconfig | 1          =

cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-241-ga0049fd9c865/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-241-ga0049fd9c865
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0049fd9c865939ea0cf399d2440d1f5fc1c72c0 =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
beaglebone-black             | arm  | lab-broonie  | gcc-10   | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/643b189cba5ba469c22e85e7

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-241-ga0049fd9c865/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-241-ga0049fd9c865/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b189cba5ba469c22e861c
        failing since 60 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-15T21:35:05.059328  <8>[   19.794654] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 334902_1.5.2.4.1>
    2023-04-15T21:35:05.169342  / # #
    2023-04-15T21:35:05.271779  export SHELL=3D/bin/sh
    2023-04-15T21:35:05.272333  #
    2023-04-15T21:35:05.373958  / # export SHELL=3D/bin/sh. /lava-334902/en=
vironment
    2023-04-15T21:35:05.374518  =

    2023-04-15T21:35:05.476216  / # . /lava-334902/environment/lava-334902/=
bin/lava-test-runner /lava-334902/1
    2023-04-15T21:35:05.477128  =

    2023-04-15T21:35:05.481347  / # /lava-334902/bin/lava-test-runner /lava=
-334902/1
    2023-04-15T21:35:05.587309  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/643b1b348163cc69c22e8600

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-241-ga0049fd9c865/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-241-ga0049fd9c865/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b1b348163cc69c22e8605
        failing since 79 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-15T21:46:11.076980  + set +x<8>[   11.155205] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3500399_1.5.2.4.1>
    2023-04-15T21:46:11.077716  =

    2023-04-15T21:46:11.186592  / # #
    2023-04-15T21:46:11.289863  export SHELL=3D/bin/sh
    2023-04-15T21:46:11.290798  #
    2023-04-15T21:46:11.392765  / # export SHELL=3D/bin/sh. /lava-3500399/e=
nvironment
    2023-04-15T21:46:11.393631  =

    2023-04-15T21:46:11.394056  / # . /lava-3500399/environment<3>[   11.45=
1297] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-04-15T21:46:11.496507  /lava-3500399/bin/lava-test-runner /lava-35=
00399/1
    2023-04-15T21:46:11.498266   =

    ... (13 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
         | regressions
-----------------------------+------+--------------+----------+------------=
---------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/643b1a1a0df421df862e85f7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-241-ga0049fd9c865/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-241-ga0049fd9c865/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643b1a1a0df421df862e85fc
        failing since 73 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-15T21:41:20.757634  <8>[    8.558297] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3500387_1.5.2.4.1>
    2023-04-15T21:41:20.863069  / # #
    2023-04-15T21:41:20.965063  export SHELL=3D/bin/sh
    2023-04-15T21:41:20.965642  #
    2023-04-15T21:41:21.067007  / # export SHELL=3D/bin/sh. /lava-3500387/e=
nvironment
    2023-04-15T21:41:21.067539  =

    2023-04-15T21:41:21.168958  / # . /lava-3500387/environment/lava-350038=
7/bin/lava-test-runner /lava-3500387/1
    2023-04-15T21:41:21.169792  =

    2023-04-15T21:41:21.173944  / # /lava-3500387/bin/lava-test-runner /lav=
a-3500387/1
    2023-04-15T21:41:21.272895  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
