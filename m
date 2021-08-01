Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E9E3DCAE0
	for <lists+stable@lfdr.de>; Sun,  1 Aug 2021 11:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhHAJWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Aug 2021 05:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHAJWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Aug 2021 05:22:01 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5A8C06175F
        for <stable@vger.kernel.org>; Sun,  1 Aug 2021 02:21:53 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q2so16247761plr.11
        for <stable@vger.kernel.org>; Sun, 01 Aug 2021 02:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gdqmAo3HKEfka249bs8FnBinGPptDneVD6sbVCHA+eQ=;
        b=h8JU4ST00Gcnd35+SNA8DrrEqI0antfZSWI42M+tV02mWscKyLn8u3HUpLNT2mqDQU
         DCQl0vEJXTAHVmdtp/artlOEgefCmmp4Yb8nHBs3OrjAGqF0Oim2RXkkDrWCjJGxJs7Y
         DV6zTX5pHEyIJCW/rmgJQlKbpBjaIdgfctV74khlyIfdZ8WteTRTCcz5wpScSq8btfvk
         gi1dRZ2lIrf8YQuh0Yex8OlwFrX7USaAyt15YZLXOerqVflqVUGQ0m8NaaHR3IIxoS+8
         uCc3O0wGXJcQJUCTzOb/4K+K+rdgGnfhiYDFZkVAhn2PupYogvkzyCc++hm4p79Bdf9n
         IpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gdqmAo3HKEfka249bs8FnBinGPptDneVD6sbVCHA+eQ=;
        b=XvGw291HWqLYCSgTMiwt0kVSqnFNCQgkuhltU6nr6qBRsppzm5kKGYAbyk3rR9a3A3
         bYSCXC+A6GUgWQSU0hAP5JLbV5OxA5XQcrehSRr6Q9VuA6CxYMOgCgDSMuIU5+X9pv+e
         54XNhj+fFf4RqqvNA2lXbIMdCvHAnevsnM89XKlwlObWVFu37yrLMjSjnp23vB0m8DCH
         xywzA3MDMdRJV+Y4hdUeYfy7c+s1acDnqSDwHK78AlisYm/UoeDgs24pSmGpplgSuCy2
         uZj5UGHHryL/jMlcaP2SX7On5y7b0zkxB21hxyu4rDXcXLseR/wX9hVkP4SJdBrnowKS
         viQw==
X-Gm-Message-State: AOAM530eNEijeVH2cEWSM556qxHlFT4K8COwrF42LYBhCWQOuKBL2rwq
        rzeyJ41bopJx67/UJBcYz9UwTG/4DazKuzdf
X-Google-Smtp-Source: ABdhPJwrr38XJYO/yKkBCMkoCNuvebjw9a8uekbNrDI7surrFPJA2R2XfHcQ+tccT3cD809ot6Sc6w==
X-Received: by 2002:a63:171a:: with SMTP id x26mr9842163pgl.51.1627809712971;
        Sun, 01 Aug 2021 02:21:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j68sm8064505pfb.75.2021.08.01.02.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Aug 2021 02:21:52 -0700 (PDT)
Message-ID: <610667b0.1c69fb81.9031c.6e21@mx.google.com>
Date:   Sun, 01 Aug 2021 02:21:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.241-37-g57db7e340609
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 4 regressions (v4.14.241-37-g57db7e340609)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 4 regressions (v4.14.241-37-g57db7=
e340609)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.241-37-g57db7e340609/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.241-37-g57db7e340609
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      57db7e340609292e9e641c8aabfdd68197fa3f8d =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/610630548d4ce6b39985f48e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-37-g57db7e340609/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-37-g57db7e340609/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610630548d4ce6b39985f=
48f
        new failure (last pass: v4.14.240-81-g502f0bb32687) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/610661b2ba1929f3bc85f45a

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-37-g57db7e340609/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-37-g57db7e340609/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/610661b2ba1929f3bc85f46e
        failing since 47 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-01T08:56:03.790838  /lava-4298718/1/../bin/lava-test-case
    2021-08-01T08:56:03.795819  [   16.501131] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/610661b2ba1929f3bc85f487
        failing since 47 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-01T08:56:01.360130  /lava-4298718/1/../bin/lava-test-case
    2021-08-01T08:56:01.377084  [   14.069862] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/610661b2ba1929f3bc85f488
        failing since 47 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-01T08:56:00.341168  /lava-4298718/1/../bin/lava-test-case
    2021-08-01T08:56:00.346446  [   13.051061] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
