Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7323429D90
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 08:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhJLGTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 02:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbhJLGTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 02:19:18 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D130AC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 23:17:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so1739561pjb.3
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 23:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WtJP6WSlOi095Kz07vYeTS1XdBJUx0wVdBesytVcu+M=;
        b=x6mx8d7ca8nMAap8QWyWCBjaV5XpPuIvGSlKJ5k38+dEjsFRLsMAHRtCtLWTfdUxVc
         g9ZI81MreDoZN0GqIDA0K5Qnixh34CjTRNqcR0eHK5qpOR2zJ1foKuXY37Tlboxu8qkM
         AsbG9l13mtaBr3Ag/zFBP4jXuU+Kf9wKl+RXr0OrF4IRlUGhAABE9EYSfjmz25D0ZIRq
         xVjVGqHh/cLBsX5RTOjYIhS6nTLf8+3E/r9BVViKVOLZ6ZEN4K8WxMPrPPPvdLQobpEX
         ywftShLjEKDjDeCBsMBx9PNZvvK9RBrn6aYJntjQoM43X/czOO3QBU6cBIbF4V6NTzHg
         VoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WtJP6WSlOi095Kz07vYeTS1XdBJUx0wVdBesytVcu+M=;
        b=Qf/9FrSEjfqi3YdMN7nZTdX1BhNTB+U9J6pIW+DVl1Rl1SfpjnvgKWSB8XwYu39PRY
         4PQ9fzP24Zi51JZOKHD+dBoXo94H4dEpBaprJMsg/0K5Ms7qKIm+fnrbVUoogbyWGxnT
         +lfO/ghtJ05qAlN05gdXQ24sKwEA+A6h60maOu2G0i8bd/ahzgK0U4ONN3djXGAqMZdJ
         dn6uycZT5DDP7V151IHOZ7ZsNXtQujMmguElsXBpmsP+hhXlWAIMwdclcF28JwRmhBgZ
         Oqit37msnDkHvSgcRq7uVJr4golB/rFKmsheCdEx23lIX7ZYC3TNDvKNIs2FuRVfxAH+
         1OJA==
X-Gm-Message-State: AOAM532YskJFZtq5RezcC38BgXNoZi4ZpWRpyz6ARTXAvpQ8QZWJbgKs
        gOkREMFl87Ty1aXbo76ckvbkksauwU4VPt/D
X-Google-Smtp-Source: ABdhPJw/8WzvUpy0Jy+NalMoEKfNjx2kGiS1kzTfqHEAy20sWrRGID4d4jlkobjxzi+3TmV+aH5D1g==
X-Received: by 2002:a17:90a:9406:: with SMTP id r6mr3938747pjo.206.1634019437034;
        Mon, 11 Oct 2021 23:17:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u65sm1888902pfb.208.2021.10.11.23.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 23:17:16 -0700 (PDT)
Message-ID: <6165286c.1c69fb81.abb03.6d9f@mx.google.com>
Date:   Mon, 11 Oct 2021 23:17:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.152-53-g2a225aa681c5
Subject: stable-rc/linux-5.4.y baseline: 114 runs,
 8 regressions (v5.4.152-53-g2a225aa681c5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 114 runs, 8 regressions (v5.4.152-53-g2a225=
aa681c5)

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

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.152-53-g2a225aa681c5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.152-53-g2a225aa681c5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a225aa681c5c16b5283fb381b5326b94179fe6d =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6164ef224298e22ce008fab6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164ef224298e22ce008f=
ab7
        failing since 325 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6164eb0330bbd7d37e08fad5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164eb0330bbd7d37e08f=
ad6
        failing since 331 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6164eaf030bbd7d37e08fabc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164eaf030bbd7d37e08f=
abd
        failing since 331 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6164eaf921dda73f9f08fac2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164eaf921dda73f9f08f=
ac3
        failing since 331 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6164eab9c970bf264508facd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164eab9c970bf264508f=
ace
        failing since 331 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/6164ffb6b2d2817e7208faff

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.152=
-53-g2a225aa681c5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6164ffb6b2d2817e7208fb17
        failing since 118 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-12T03:23:17.557171  /lava-4698279/1/../bin/lava-test-case
    2021-10-12T03:23:17.574546  <8>[   14.686909] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-12T03:23:17.574992  /lava-4698279/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6164ffb6b2d2817e7208fb2f
        failing since 118 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-12T03:23:16.149981  /lava-4698279/1/../bin/lava-test-case<8>[  =
 13.262148] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-10-12T03:23:16.150614  =

    2021-10-12T03:23:16.151023  /lava-4698279/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6164ffb6b2d2817e7208fb30
        failing since 118 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-10-12T03:23:15.113096  /lava-4698279/1/../bin/lava-test-case
    2021-10-12T03:23:15.118660  <8>[   12.242471] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
