Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691653F2037
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 20:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhHSSyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 14:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhHSSyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 14:54:00 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE4CC061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 11:53:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 18so6363749pfh.9
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 11:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zJa2bEuT9/Bl4hMicAwGhsyzHN3Stqjr3oAKi+h9Ol8=;
        b=HVMmfbT3eqSo22zw9h9Fh0y7HmxTG1INOj1SN823ywF856SvAJpzCfZO/CLooM//NX
         JqseHkkKZcCGhL7C+FEFrEF+2PJM5ELn6yrGvepJltm/VYwngmriKCwC808+F0m+yyhB
         hteIlZs38kS+8OBhgqDYpML6aKZsaK3D/MtnG6g0hV7df6FIeXSkPZOcWTMznbqa5HLs
         4ySZISM3C0uJSxM1QAW/jfL6UgxKba1E0Z4ZC4kfa9aZ9kfTXthwlaCP+IFYvL327X3T
         bUL3eLNEQ+FeNiOf0iyR9cmnm0a6ViQNoqO9vj1q7zWaqbodi6fGyAVQm7r8TRiRWdS3
         XN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zJa2bEuT9/Bl4hMicAwGhsyzHN3Stqjr3oAKi+h9Ol8=;
        b=bj+7Wi51chJQ3eOlrOKrXzmTTc306VHA96iI7+VKzrAG6RTD2ZGFh87RmlO9And88Z
         /SSakkhbLeBDyim1q1+Nci2Uj4qL0Ggh6DifqWv33y2wqTfU8E3N+eO4mwACuhZGQARe
         +yaAo3k6+xum0x2V+FHBPhs4BuvYgQ5VQu/O0EXIYzvavqJGT2ezEQGW2Ic7MPPUiBZM
         74wm4XMmMYN3zYDKJhHCtJ5SY/v3r4aP45LI0Zmn8sbXr0/cRnHUfVkii+yDtL7KeXLk
         Y90aC+sTWHgLXnNEyf37/Bow8w/cTZk47Ybzqit1ZqyhN34RZ5NgRgsg252QrsaAGjEM
         BglQ==
X-Gm-Message-State: AOAM5312eJCgs9k+q6M6xK+2vMftOeIhFzPlOc/QrUmNN/3iO/nppOT3
        VkxC6YConRCAtTyqsApaC07IoaX2nLZiiNib
X-Google-Smtp-Source: ABdhPJyPQfMd51U0BVu8jweiqW0dOD4ROkFmFnQEVO6j3lAZ3ogm/euetoWCi756Wpu8ZEPBEiMG4Q==
X-Received: by 2002:a62:5291:0:b029:397:6587:1af6 with SMTP id g139-20020a6252910000b029039765871af6mr15693596pfb.47.1629399203125;
        Thu, 19 Aug 2021 11:53:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u6sm4796079pgr.3.2021.08.19.11.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 11:53:22 -0700 (PDT)
Message-ID: <611ea8a2.1c69fb81.f9841.f76a@mx.google.com>
Date:   Thu, 19 Aug 2021 11:53:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.204-58-g86c98aac5692
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 155 runs,
 7 regressions (v4.19.204-58-g86c98aac5692)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 155 runs, 7 regressions (v4.19.204-58-g86c98=
aac5692)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.204-58-g86c98aac5692/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.204-58-g86c98aac5692
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86c98aac569241696649f26f758039aab2c86dd4 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611e749a5ea0af862eb1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611e749a5ea0af862eb13=
670
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611e74acfec14722a3b1367f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611e74acfec14722a3b13=
680
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611e74627944c42cb8b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611e74627944c42cb8b13=
662
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611e744f5069acdb14b13686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611e744f5069acdb14b13=
687
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/611e767d6ae0eb9147b13661

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-58-g86c98aac5692/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611e767d6ae0eb9147b13679
        failing since 65 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T15:19:11.316364  /lava-4386757/1/../bin/lava-test-case
    2021-08-19T15:19:11.333483  <8>[   19.587904] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611e767d6ae0eb9147b13692
        failing since 65 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T15:19:08.873605  /lava-4386757/1/../bin/lava-test-case
    2021-08-19T15:19:08.891514  <8>[   17.144400] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611e767d6ae0eb9147b13693
        failing since 65 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T15:19:07.854417  /lava-4386757/1/../bin/lava-test-case
    2021-08-19T15:19:07.860139  <8>[   16.124879] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
