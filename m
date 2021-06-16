Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20533AA5DF
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 23:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhFPVFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 17:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhFPVFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 17:05:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7927C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:03:03 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o10-20020a17090aac0ab029016e92770073so2524726pjq.5
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E3U5UKO4IdlG30lDMBbad1mBKJLLw88MnxiCDomlmtg=;
        b=plRxNuVF580G+uUqzpK7PwKfie0STIYnFaFr9Eq88KpDbcsE+OrlQ2pWKQBjkCZGkQ
         FpLl4dXoANGs+O4BwIcYC6yst0JxZd/tQh/8HL0VYHQ5HVohL+AOUz3kqOQYQnbPdHNz
         NYu5nJY30Co4zUBmDr9Tvb6aRBxB0XaClu1BHNS/xi6igJukQ6Hs8FScHOIS6Wmbw0mC
         ggkwmQoLXzshxnyS7YPU9vNJKbxkwutajOQ4uHbFNuqTRg2W3ZlmjP8lAhj1HcFMqgNG
         R/idTgp0TrBj7Da98dVRGSabwxK+0tfxhO+FQgUCstmEKECZSTmkqECN8sw1PbC6HUYJ
         Q5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E3U5UKO4IdlG30lDMBbad1mBKJLLw88MnxiCDomlmtg=;
        b=q0GUVXdAZgM3xWpfcy+nj5Nm5bC6q5e5mXKKjkQ09vJRF0YRJ49hMf1qWmjo10/f3q
         ubryCjjB28eNHEIiFWpyniZjRoAyfLwZON7VdzTsB8SN36hV5o3W4oLQ2FKASWMkgkR0
         1E5y98wM6ovMbk7/BweNCtr9RW1fq5WXVHFXDZJ7ijogH+m5ztoVaS6MhsRBDCwWem1V
         4GcwD4tSVxSE8/E2H+9bEu/SHYnQxxy0/2IYhCzFhnRaqVbKzfC/wT9mKLXYxtfeh+Za
         RRFB+TAS2PDZ8hsyN1pK5ff3IPpJHYSRNbOUu6BzGZf0By9eYpe2w+H9fDKMaMEtkaUx
         F5KA==
X-Gm-Message-State: AOAM530ywco4Pj1CVfWd2KAJhetsix3exJPDGiprO58kzFc5ty//la66
        SJ8ERMAcyY/oFdj7xdQBkrZayoaWqDZushVp
X-Google-Smtp-Source: ABdhPJwR2h6hWZE1rJkG1R+/hXAmN3djnVig+Pm79UuF7pd6POibWj9FT4vZfvlqKUsnS/kWhR5Pzg==
X-Received: by 2002:a17:90a:8804:: with SMTP id s4mr1835235pjn.200.1623877383035;
        Wed, 16 Jun 2021 14:03:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23sm3094525pgv.76.2021.06.16.14.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 14:03:02 -0700 (PDT)
Message-ID: <60ca6706.1c69fb81.1c411.8c79@mx.google.com>
Date:   Wed, 16 Jun 2021 14:03:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.126-29-g4e778e863160
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 100 runs,
 6 regressions (v5.4.126-29-g4e778e863160)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 100 runs, 6 regressions (v5.4.126-29-g4e778=
e863160)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.126-29-g4e778e863160/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.126-29-g4e778e863160
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e778e863160695fca936b0a9452e94fc9824a76 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca4548b438d155d841326d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca4548b438d155d8413=
26e
        failing since 214 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca2d860afb45adf44132ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca2d860afb45adf4413=
2ee
        failing since 214 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca3c519cde38340e413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca3c519cde38340e413=
268
        failing since 214 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ca5c0e1b900c8cf4413290

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.126=
-29-g4e778e863160/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca5c0e1b900c8cf44132ad
        failing since 1 day (last pass: v5.4.125, first fail: v5.4.125-85-g=
4a2dfe908c1e)

    2021-06-16T20:16:05.561665  /lava-4037925/1/../bin/lava-test-case
    2021-06-16T20:16:05.567470  <8>[   12.698517] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca5c0e1b900c8cf44132ae
        failing since 1 day (last pass: v5.4.125, first fail: v5.4.125-85-g=
4a2dfe908c1e)

    2021-06-16T20:16:06.582283  /lava-4037925/1/../bin/lava-test-case<8>[  =
 13.718122] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-16T20:16:06.582658     =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca5c0e1b900c8cf44132c6
        failing since 1 day (last pass: v5.4.125, first fail: v5.4.125-85-g=
4a2dfe908c1e)

    2021-06-16T20:16:08.004775  /lava-4037925/1/../bin/lava-test-case
    2021-06-16T20:16:08.021944  <8>[   15.143316] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-16T20:16:08.022196  /lava-4037925/1/../bin/lava-test-case   =

 =20
