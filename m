Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E115B418B2C
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 23:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhIZVNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 17:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhIZVNi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 17:13:38 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3439AC061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 14:12:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a7so10382190plm.1
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 14:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2w0FgXFsSAq2bSNPnvo6EFAExWubkNRzzbbVrrEPuew=;
        b=jWY5KgzMDLKnC5Dv9MZI4WF1BV/ctvRldi8vnDcsrmOdvtpFYNBge1W9qbHqSN+IsL
         9ISRfYSV4K8cZmTfxoK0f7zpqGCW37FiLLFWhhO3T6vEfqK+mB+sZCp7+mYu7DilCg2b
         hwU0hvlJiB7LYj0/7WKDWsy6uONckPzk2L3vzj3qzkY0LScPDBMZH8eBHsoHsQHJJeoT
         q1HbX6glKDcYv2ZMpXtEAxaLHV6qKPkkb1HxCmpu1lXUVl9LboSCRMlrfVw+xB68uI5w
         dPsw2koPktZvUw8rq8tAuY423y2NpwLwYv4XZISYid1SdC/WggSai15z5YVvjCuFFIxi
         7BoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2w0FgXFsSAq2bSNPnvo6EFAExWubkNRzzbbVrrEPuew=;
        b=fN6kdc2g0Oiyit4EkZIH67mqwc6i63lgP5ShKWQor5No05/Ug4p9dlgSO3uOwz8FVX
         nZcnAqlRat2vhndinYf1Ai7qBV3J8jn8m9/0H+8nR1Ebk3fkzNKO6rO8ij8pi/m0wapX
         U60CPkTzzA/2B2EaL0CTqDS48LGrCYnVAh+FNyu1u6yT5tH7VYBeSoCs9g6+b4fp7pCY
         N4tFBS2CuSlZHOv6FzvsqHHshWu2ud2pjmsm25aE+xofNTAYjH3dgKqip3eBgCc6K3aY
         in/bt3ioCllKGbctNzwwnM9r1BP9/HcO1QD8XJJkp9HL8fUnYqpk1sSWJ9EvRv1ZxhuW
         68yw==
X-Gm-Message-State: AOAM530elQprpdxLfJpg/1GAyLtKsFc9+lrlyZ9/pkwY44bHLCT4Tk91
        cnuHyy9HZLq8NK9mLIWBSR5ahWVQIIAB6QgF
X-Google-Smtp-Source: ABdhPJxcZ5c55+y5ikGDjKJ/HQdt2CJ5j7eRBriKhpySL77WoaMZRah+fNqXMCwMXYQ+6TlL5we7/g==
X-Received: by 2002:a17:903:10a:b0:13e:28f8:9e6d with SMTP id y10-20020a170903010a00b0013e28f89e6dmr2220940plc.30.1632690721470;
        Sun, 26 Sep 2021 14:12:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b129sm14622055pfg.157.2021.09.26.14.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 14:12:01 -0700 (PDT)
Message-ID: <6150e221.1c69fb81.721b6.ffcb@mx.google.com>
Date:   Sun, 26 Sep 2021 14:12:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 79 runs, 7 regressions (v4.19.208)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 79 runs, 7 regressions (v4.19.208)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.208/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.208
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c2276d585654e8d573366c29c565043ec36adf63 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150a5bf1789b4406b99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150a5bf1789b4406b99a=
2e0
        failing since 311 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150a5bbb2693f6ce499a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150a5bbb2693f6ce499a=
2eb
        failing since 311 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150a609713b3149f399a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150a609713b3149f399a=
2ea
        failing since 311 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6150df35ff01c0241e99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150df35ff01c0241e99a=
2db
        failing since 311 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/6150a612192eb1e2da99a2db

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.208/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6150a612192eb1e2da99a2ef
        failing since 101 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-09-26T16:55:38.363992  /lava-4585811/1/../bin/lava-test-case
    2021-09-26T16:55:38.381028  <8>[   18.910842] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6150a612192eb1e2da99a308
        failing since 101 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-09-26T16:55:35.923039  /lava-4585811/1/../bin/lava-test-case
    2021-09-26T16:55:35.941455  <8>[   16.470121] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-26T16:55:35.941914  /lava-4585811/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6150a612192eb1e2da99a309
        failing since 101 days (last pass: v4.19.194, first fail: v4.19.195)

    2021-09-26T16:55:34.910164  /lava-4585811/1/../bin/lava-test-case<8>[  =
 15.451040] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-26T16:55:34.910629     =

 =20
