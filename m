Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B650409E5A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbhIMUuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242743AbhIMUuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 16:50:12 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD42EC061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:48:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w7so10560187pgk.13
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iZalYSPGte7s0Hk8kkeySk17KqLYlelepbuCplNAAkY=;
        b=P5aP1vs/TNfDCMe8HXWnLWZbQFcS2qi5qQRwR5E8LWHRT1wVbsEwFKs91edxjVU1ON
         tiGdLf+kHn5nxjQACaPd0sRsbp9oubQ9D0pCjka8D4hAUFk0mqBEQrn3M59lw/YOkBKJ
         F5vSiBwgty2Xxc60S2U7I5a9drSOFZSivfe4Ayzxk1LGM3Q2pm035BJXQhHL4OBv3buK
         LX/Kp6w+2zZJs1lHJD4p56Bn7VGrjBNM3xbNopOdStQywU5jWu8AXGYAjPBqYpys7Cjc
         MyjlGC8QaVE7byCQCNdjly6sKxM4v93bwlv4Vhl9VG8Jg/auXtfIEuMPGhNg+dzPxWKn
         hpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iZalYSPGte7s0Hk8kkeySk17KqLYlelepbuCplNAAkY=;
        b=3Jie3iBhSxnDSLBKyhSysApC64gFTlMUqCNvxoB5fraIQWjEetoeEsTqkPmHxPdn8p
         6g26wREFBlgATH7a5xtPOmB5GB1/wvw+SxWuIt2/nIT/ZADvRVgtFnQGwdX2f5sgL3n7
         V7ZipBQtjhNyCz6Mu/hnVWRe8BmWC3blqrf1aB5xb8J76ii3JEbHGGEGGbWNDSZJ1Yok
         ANPXEP2RvjVvk2xuLlPaSJNMaOS/Ze1D2xvZM4CKrdBSagNFDPyo4C8xWsaFhbUyeumo
         oKPObvt/koyyLY2QlF+6SacwyXn8SsBv4vNlIlWmhmxomEPVjN6NkwKX2FPDwJF/NlMx
         rntg==
X-Gm-Message-State: AOAM532Nk0xgCz+h4Ba+9V5BcVb4O5GRO1FthYKpudBXfs4dOzyKQb00
        +HSOuq4ZARnzCOWCS0wk0xE9IJJgF35tCvoU
X-Google-Smtp-Source: ABdhPJw5GHwYL5LGOuyV5c/pUmmItXJegBw+pKUhYy1n/q9BHB3T9oT0+t62yNW93sup91NRHiDM4A==
X-Received: by 2002:a05:6a00:d60:b0:43d:f987:66be with SMTP id n32-20020a056a000d6000b0043df98766bemr827201pfv.37.1631566135428;
        Mon, 13 Sep 2021 13:48:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q22sm8999524pgn.67.2021.09.13.13.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 13:48:55 -0700 (PDT)
Message-ID: <613fb937.1c69fb81.7258c.9bf4@mx.google.com>
Date:   Mon, 13 Sep 2021 13:48:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.145-145-gd4596c5864b2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 169 runs,
 7 regressions (v5.4.145-145-gd4596c5864b2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 169 runs, 7 regressions (v5.4.145-145-gd459=
6c5864b2)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.145-145-gd4596c5864b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.145-145-gd4596c5864b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4596c5864b2b967c1c1019d51b2c221d27e2f3b =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/613f81e2cc5c02c2a899a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f81e2cc5c02c2a899a=
2e0
        failing since 297 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613f807e1c74708a4899a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f807e1c74708a4899a=
2f0
        failing since 303 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613f80fd84f56959ef99a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f80fd84f56959ef99a=
2f6
        failing since 303 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613f91a5f62cafa9db99a345

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f91a5f62cafa9db99a=
346
        failing since 303 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/613facae50620101d999a2ea

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.145=
-145-gd4596c5864b2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613facae50620101d999a2fe
        failing since 90 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-09-13T19:55:07.449027  /lava-4511659/1/../bin/lava-test-case
    2021-09-13T19:55:07.465757  <8>[   15.288124] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613facae50620101d999a316
        failing since 90 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-09-13T19:55:06.023036  /lava-4511659/1/../bin/lava-test-case
    2021-09-13T19:55:06.040971  <8>[   13.862942] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-13T19:55:06.041457  /lava-4511659/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613facae50620101d999a317
        failing since 90 days (last pass: v5.4.125, first fail: v5.4.125-85=
-g4a2dfe908c1e)

    2021-09-13T19:55:05.005148  /lava-4511659/1/../bin/lava-test-case
    2021-09-13T19:55:05.005656  <8>[   12.843229] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
