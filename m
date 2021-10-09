Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818E9427DBF
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 23:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhJIVln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 17:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhJIVlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 17:41:42 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E8CC061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 14:39:45 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v20so1426099plo.7
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 14:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=siqERUsRk+bZdO2Jx8/EpcAXoq3KeiRC+dYp6Sj0Pw8=;
        b=FEhwBDsgdOmNQuzCsb+8u1pfhPoTCoaSSuhdiNYy0oFVHbjOAdpDKzEO6RnK/4X+DS
         9ZzkG9id/1i06ZsrENrWqUsS3L/U5grpAW9vLY/Q9zjQhxZT4dyZofFrMAZN9rK/rVyh
         ekSSIBm/x0XQrIcs3cDd33NqI3eLQoz1y+VuiSBsZdR2EY3KAvvwgHT99owKiUpHhJH3
         bLWV6SaEC4UMnEyAK54N+sRgk6ctNz+LKzRD3tk15FJloKxZ7sRhJt7Fj7+aqJtZswwk
         Df9V+aBCUp/VmgDgOg4jLbC6HsatUdUaXhiABVigWGqe8h2IoytFKvWqnGuq/lRV8n4f
         QAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=siqERUsRk+bZdO2Jx8/EpcAXoq3KeiRC+dYp6Sj0Pw8=;
        b=l2hOvmlB+PBSr9Ec0CXZieqvtMlw5JdyZdCodO4fByNhuZoks6sQ7pmod9baiY2SCO
         LPmlFurWAafyKCUwx9V6sZ7PaG/uM5wmmEqbVjuB0BYNwa+HFIl7GiEpmcFcSBCNC1M3
         u5rNSNE8nRnaU4O/pNIgslx2E/ZPw/CwacW9HzS1RI/f2XpKwiodLn01m5Jt0Th9s73h
         wLz7LYcGJ0EmBhHfeIt4LZJGfxIxtE3mxQGSpOwV9Kj0GVlBdjZ6U5ip5D2/s9aZQxoW
         w+pI3ieYM8GmUyU9SIJL5L/mBZ/QlgoZ1e+CYHc0G0Avn4Xd+PwesoagnZMRU5yEwy9e
         LIiA==
X-Gm-Message-State: AOAM5334E/kX8O1v/SPDiPmP/r1hkeoA18f14yyDKs+XgExF5Uz0TRAI
        +RtTVq49atGCl8IKdxTXhQJktPcf1LKYrbMH
X-Google-Smtp-Source: ABdhPJxh4RW9uYC5TZs2zEwfUPUlWCd0LGcz2pq4ud7aqKHMSPhPep4l32qY/O+DsYwSPZe0NZWsQA==
X-Received: by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP id s2-20020a17090302c2b02901019c88d928mr16438910plk.62.1633815584526;
        Sat, 09 Oct 2021 14:39:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22sm3190543pfg.137.2021.10.09.14.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 14:39:44 -0700 (PDT)
Message-ID: <61620c20.1c69fb81.12462.8e54@mx.google.com>
Date:   Sat, 09 Oct 2021 14:39:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.250
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 126 runs, 7 regressions (v4.14.250)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 126 runs, 7 regressions (v4.14.250)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.250/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.250
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ed99bf0e81b558df39f7db2fa96d0228be4198c6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161cf22206b2372d399a356

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161cf22206b2372d399a=
357
        failing since 324 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161d41751f142fae799a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161d41751f142fae799a=
2dc
        failing since 324 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161cf44282f5662e399a31f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161cf44282f5662e399a=
320
        failing since 324 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161cef0364462c4be99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161cef0364462c4be99a=
2db
        failing since 324 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/6161f01b3882a9c14399a2e4

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.250/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6161f01b3882a9c14399a2f8
        failing since 115 days (last pass: v4.14.236, first fail: v4.14.237=
) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6161f01b3882a9c14399a30f
        failing since 115 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-10-09T19:39:58.341163  /lava-4685824/1/../bin/lava-test-case
    2021-10-09T19:39:58.347089  [   12.614713] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6161f01b3882a9c14399a328
        failing since 115 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-10-09T19:39:59.361545  /lava-4685824/1/../bin/lava-test-case[   13=
.633502] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probed R=
ESULT=3Dfail>
    2021-10-09T19:39:59.362089     =

 =20
