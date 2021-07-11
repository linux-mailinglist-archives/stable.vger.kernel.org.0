Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A813C3DEB
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 18:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhGKQVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 12:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhGKQVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 12:21:48 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FE1C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 09:19:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d1so2539204plg.0
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 09:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ikTfTWArpoSrf31pn4r4dJcy/5HwHqxxjIAf7LMYWg=;
        b=h8p41lrGAeburcZMzbAgpbQE6aZdyh866RTorzQ1plbJDMXMfarlOh//M7hJDCiR5C
         fbTmpWECUXPQ0+m2dzTKhE9yPVN1ccAwxEfZxKJR/Zrej0uAL3H40171Q2XOR/+KWQbd
         QVZg4BDbES43k2MTLn5ba0FksbFpX9JFxh47CPcinBXdOKECt2DLi5UEz2zY7blTfx3d
         yRTSTuL9lbnj0OBh8QDQnqFELhL1GamB2dwvq3opEOHN0gjXyFhAvOgwuzHEG+Jgx/Nm
         FHtZDaCqk4nTp7C2JBLq//XYYgYnbT4yq7vzxT/zow5/8GwY/ZUZA/AibO/nNATdtNa1
         ow0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ikTfTWArpoSrf31pn4r4dJcy/5HwHqxxjIAf7LMYWg=;
        b=P65z8vFZQHD+SxHA5lRIhxYPscSjAwCcmAFW18J0y6NwFbK49eXhP+MM57/ec+emMI
         578JFJS0dHITJ1AuhInTIxRUzKBMaCztON+YAEeiJjNLEju24pvlvxum9YAoEogAkmO1
         ngj/vT57CW+rY2ySLES83HTNWJQoZqv905y/4yfo21QPahKptIYTz3pGo1C0qOaNfVDq
         ISo2fbG9ThkYMyarJxTm/ASvog4QnLVfu6rDJOE7KwJm17Pubclq8Rvn44D8dABn4kSz
         B1r9U8or7R8GXmKbe25NwzczQs43UOZlpYQqfzb2Pgi0qD9z/AN4zFEqRQaKk+Nl0j2P
         Ge/A==
X-Gm-Message-State: AOAM531QNDYDDX/9jGf0BzTKIBptWXs80oIzfOtz6Sxvv2ft0Z4syDup
        AEZ8lAgQsUA4SRR/dPy90kTLPKbkdIOKdtJV
X-Google-Smtp-Source: ABdhPJzrtXd8NVNGCAlZNKN0qBOfjdkNihf7azMV3Jr7sqLMOV0KMN3vNy6dtHKxF2GEpY6mmQxMCw==
X-Received: by 2002:a17:90b:314d:: with SMTP id ip13mr23175246pjb.131.1626020341281;
        Sun, 11 Jul 2021 09:19:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm6904680pfv.138.2021.07.11.09.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 09:19:00 -0700 (PDT)
Message-ID: <60eb19f4.1c69fb81.9bc0f.40e2@mx.google.com>
Date:   Sun, 11 Jul 2021 09:19:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.131
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 186 runs, 7 regressions (v5.4.131)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 186 runs, 7 regressions (v5.4.131)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.131/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.131
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e8d9b740a5503f5bd2948a51a0c3fa564c82cfe3 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae3138b37787b3e11799e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae3138b37787b3e117=
99f
        failing since 234 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae3108b37787b3e117981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae3108b37787b3e117=
982
        failing since 234 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae3158b37787b3e1179ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae3158b37787b3e117=
9ac
        failing since 234 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eae3dbcb6bfe613a117986

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eae3dbcb6bfe613a117=
987
        failing since 234 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60eae72d5ea535ed1611798d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.131/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eae72d5ea535ed161179a1
        failing since 24 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-11T12:42:04.382477  /lava-4174899/1/../bin/lava-test-case<8>[  =
 15.583949] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T12:42:04.382817  =

    2021-07-11T12:42:04.383061  /lava-4174899/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eae72d5ea535ed161179b8
        failing since 24 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-11T12:42:02.943359  /lava-4174899/1/../bin/lava-test-case
    2021-07-11T12:42:02.944467  <8>[   14.159418] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eae72d5ea535ed161179b9
        failing since 24 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-11T12:42:01.922289  /lava-4174899/1/../bin/lava-test-case
    2021-07-11T12:42:01.928838  <8>[   13.139918] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
