Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E18418D04
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 01:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbhIZXMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 19:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbhIZXMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 19:12:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E90C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 16:10:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so11869733pjb.5
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 16:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FESNqoAAMG5fhHjPgNsBhe7bXWRTwG40kBBI9MMapsE=;
        b=avmgisjOO5wR1vmeaaB/nHFa3XfZQlvgRIMO3lmhTn99rTcLwsph1eIV1mZShlFVZk
         qQgHDylboK5guX657AEggYQEeCmUk3umOOiKzpeWUMpONmTgk++fAG7cj1tm4WbhTX29
         PwiEqiNzj2LG9NCIMLgG9EVZlvjAhABZeNIKXM/0i2uky4CmYPpyFx7/iiGCtlP+X/J+
         EngweQspA0cxSw8gNYepz0L3UzCgNDNs6nprV9puif1j3aaS2Zr5f0A0vDZ8sQaYJE4k
         PJTpzmeNsFigyy3E3bUXMv7Ny/hBwtW1Og7PN4HaRGwV7W6DIhm6jFM4xFUHsyPa6ISE
         jhMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FESNqoAAMG5fhHjPgNsBhe7bXWRTwG40kBBI9MMapsE=;
        b=fLCGpcNTZB4V20jPLcujPO7bRlHjtysBwqlRJP3n3MY2MwL6Q9toWXTFlfrTeyNdeh
         BtMCUDuZfjND6VUjn3yMmQ7/gH2ZWWNOwoYx7gg9ToGOQNJR1H85j0p2b1V4U5rJdocU
         KMdAtO/XznC8U9b6XAbgpcM1R+Iu+477ATnChtS3djkGAsRWSg0L5jt/7AkksNw16F8h
         7xOT74Pbn5z+oQZxTZ40m9pop2wnXXyiH93SPwmedfKcC73UpiOhzK/kTbLvYNmP9eIW
         5NzIEhMtuq/I3Y7nAEQ5ggKJQlSN4JSeIIhYsjfOHPuYkfUiaJbyz74oy5EmKadFgqtB
         45VQ==
X-Gm-Message-State: AOAM531O+7Vso12sgyXywaUACBrIqIUOnjhCDSQEPLixQMynwlWptt6B
        hHDSbz9sTPGAJvNi9tsQB+AwLL2dt46E8Dvt
X-Google-Smtp-Source: ABdhPJxF2yWFZoIhDIsH2wY9KGgVXFTCm5546U3N/R9Cxw4lSgabcxX3sI8Ec/28fb4rbVC41Ubhsw==
X-Received: by 2002:a17:90b:3a8f:: with SMTP id om15mr16210432pjb.51.1632697857342;
        Sun, 26 Sep 2021 16:10:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k127sm15159500pfd.1.2021.09.26.16.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 16:10:56 -0700 (PDT)
Message-ID: <6150fe00.1c69fb81.b4713.1808@mx.google.com>
Date:   Sun, 26 Sep 2021 16:10:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.149
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 94 runs, 7 regressions (v5.4.149)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 94 runs, 7 regressions (v5.4.149)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.149/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.149
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e74e2950a0d6f800858e54860d7124c86e494f62 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150bc08eccf863b3099a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150bc08eccf863b3099a=
2e0
        failing since 311 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150bc0505fe1163e299a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150bc0505fe1163e299a=
2f5
        failing since 311 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150bbb2cdc4cea2ef99a2fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150bbb2cdc4cea2ef99a=
2fd
        failing since 311 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150e1002da079c1f699a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150e1002da079c1f699a=
303
        failing since 311 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6150c511d89984f29b99a3a5

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.149/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6150c511d89984f29b99a3b9
        failing since 102 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-09-26T19:07:46.231544  /lava-4586103/1/../bin/lava-test-case
    2021-09-26T19:07:46.248847  <8>[   14.746736] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-26T19:07:46.249074  /lava-4586103/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6150c511d89984f29b99a3d1
        failing since 102 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-09-26T19:07:44.806588  /lava-4586103/1/../bin/lava-test-case
    2021-09-26T19:07:44.823533  <8>[   13.321411] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6150c511d89984f29b99a3d2
        failing since 102 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-09-26T19:07:43.786625  /lava-4586103/1/../bin/lava-test-case
    2021-09-26T19:07:43.792015  <8>[   12.301817] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
