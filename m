Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C5D3C3EBC
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhGKSZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 14:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbhGKSZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 14:25:06 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1731CC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:22:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h1so7860217plf.6
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=h0qaDvp/GVVtnmMqJSNk8ZSylUF0OCAGulKIKuRhQzY=;
        b=nXR5MXW3lmimDVCMDE+CHMcB/CkSJbCdbHWsatlZqRr9MGgqQbx0aCnC8OGjJspZJq
         2R5GCbjujBTclQO0LT9OLHPd9z1ElFDH/855nVVVtvwxVGAI8Va7CwU3mEYDuUAGECkg
         wlAMTyfRzTfod709v9onQmZYrq9Suchc1TSsi9ZOL8U2z5UPuaiyp2aOZNnxKAwODRhK
         2R0jDSTAiOfkBO9/pA2eL6D/24Rh45dU4ThP3sKioQQ3Jl1o2XtXXUa6BIIMixGT0/3S
         P3f6vhn0mSveAWnOvartjqXctWDcpAPyAYWM2Spe9x/d5DGwsHs/AvoLN750BPhxj8J6
         VNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=h0qaDvp/GVVtnmMqJSNk8ZSylUF0OCAGulKIKuRhQzY=;
        b=VTCXOWr15PyS4Vn8DuYoZUVP7mgIDWE9xQIue1S6jmYOL+JRYZUx3aOoibzeUkiw+g
         O8kijsGUs03Wge8UrA8n+SeFFv6DEA+/A9UNsYFcTZQ/95/Lmgtmhbj9kVbnHrmcwMPA
         Mg80ns62uL0HRd82EBjbM0dXLcw0UkMBIjr6CkEzGNyTaK8ELK3Pio7AF5O+QkCJObar
         ooATQqo/r1R9Ur1A31uJNMpmbtwy6MXxO3mh1zURHaR2dIXeH0w60gS0K09jjB7IvrUc
         IcA0MX3kwfdbczUU/JSC7CoOb2gQpb5l84PzZChfUI3tLgKr3Gt3lEw+4n9NhZYTxPbi
         Za1A==
X-Gm-Message-State: AOAM530vq+TpdJ2aZ+g+XR6SEnrrVLYJuFqYzrXhqTOa7TG8JCdRA/fd
        8Az5jag9N0ARIy+f/qq81nMyhb2EpPqO3gC/
X-Google-Smtp-Source: ABdhPJzjtJbtRktfJvtWixttLJZlEgEkmpTqkFdCAVFBcTsYKVt+V3gh6xtOqIv2kGu6McpCdT7hJw==
X-Received: by 2002:a17:902:bd04:b029:11f:d602:56f3 with SMTP id p4-20020a170902bd04b029011fd60256f3mr40353150pls.33.1626027738356;
        Sun, 11 Jul 2021 11:22:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s9sm9730806pgv.37.2021.07.11.11.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 11:22:17 -0700 (PDT)
Message-ID: <60eb36d9.1c69fb81.55cc.cbab@mx.google.com>
Date:   Sun, 11 Jul 2021 11:22:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.197
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 168 runs, 10 regressions (v4.19.197)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 168 runs, 10 regressions (v4.19.197)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =

meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =

meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

rk3288-veyron-jaq    | arm    | lab-collabora | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.197/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.197
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcfbdfe9626edd5bf00c732e093eed249ecdbfa1 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb038b41763b76d11179a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb038b41763b76d1117=
9a8
        new failure (last pass: v4.19.196) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb059327a2d8d9f01179c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb059327a2d8d9f0117=
9ca
        new failure (last pass: v4.19.196-35-gdf520a4397b2) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb02d3cb9a3fff701179ca

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60eb02d3cb9a3ff=
f701179d2
        new failure (last pass: v4.19.196-35-gdf520a4397b2)
        3 lines

    2021-07-11T14:40:00.320508  kern  :emerg : Process kworker/1:1 (pid: 78=
, stack limi<8>[   16.405024] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RE=
SULT=3Dfail UNITS=3Dlines MEASUREMENT=3D3>
    2021-07-11T14:40:00.320754  t =3D 0x(____pt<8>[   16.414305] <LAVA_SIGN=
AL_ENDRUN 0_dmesg 545753_1.5.2.4.1>
    2021-07-11T14:40:00.320941  rval____))
    2021-07-11T14:40:00.321098  kern  :emerg : Code: bad PC value
    2021-07-11T14:40:00.321250  + set +x   =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb01070a9e23805b11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb01070a9e23805b117=
96b
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0116c7188b922b11798f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0116c7188b922b117=
990
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb01012cbb2cd62211796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb01012cbb2cd622117=
96b
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb00db3327f61bb7117987

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb00db3327f61bb7117=
988
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
rk3288-veyron-jaq    | arm    | lab-collabora | gcc-8    | multi_v7_defconf=
ig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb1359d0bb3dba5a117988

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb1359d0bb3dba5a11799c
        failing since 26 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-11T15:50:41.091109  /lava-4175946/1/../bin/lava-test-case<8>[  =
 19.078123] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-11T15:50:41.091447  =

    2021-07-11T15:50:41.091636  /lava-4175946/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb1359d0bb3dba5a1179b5
        failing since 26 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-11T15:50:38.632679  /lava-4175946/1/../bin/lava-test-case
    2021-07-11T15:50:38.650648  <8>[   16.636512] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-11T15:50:38.650875  /lava-4175946/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb1359d0bb3dba5a1179b6
        failing since 26 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-11T15:50:37.613366  /lava-4175946/1/../bin/lava-test-case
    2021-07-11T15:50:37.619151  <8>[   15.617083] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
