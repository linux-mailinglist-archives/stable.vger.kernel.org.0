Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2C342EAA
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 18:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhCTRrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 13:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCTRrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 13:47:23 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EE7C061574
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 10:47:23 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id m3so5854899pga.1
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 10:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/ryAVAGjIuObsyjRSPNlIWtQasdTDlbdiDwhtL5hYUU=;
        b=oVn8eP2hu2mvVPuh+c+kiqgV9qnZ/gaD2Wjy3RrBH+zLxCP+7uX2MoiLfxZ7/SFvZl
         D+Tt2np5kK0yNLI/nOJCwha11uBbvc+12lMPCrdFu3/gYL7jh5Cd107Jgkz3pCle2wS3
         2XaoCqrJUQRHYtHYyEBvhaOd4mVW5lOeHk9a0fIPWSXYBAL4QJKcxr3x0UZCucvRCD6u
         LGl8oOkfimyajdWuKWCOJLPsx/GZN4lobNHL0r47Bv9Pdr4v0+s3JyZjIuy6G/mVAmmU
         1lXUVK8qg6X99NFQZpQDFfXmcx/4tO742IibSOEpjxAqQJ7eJTjWe4kS0SAKwjSiXoH0
         n7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/ryAVAGjIuObsyjRSPNlIWtQasdTDlbdiDwhtL5hYUU=;
        b=tIT7bff6bGpqWQqApuOjvh0lopTY7VMQHKun3fJ0n/d5lPSuDW+8bTi0r+CaUrpKB2
         A9YlymvxtKIsEz+CqmHdZs7wGzz0dKCpDIRFz3rWtDNhCCIsr1p48167mDjHzecDfoa7
         nV6+5j8bR3dZP6hVFz6cKwYYXU9z5IfKf9DtBvHo3COTZLDLIdU3dLpQKlpj/xPwplYg
         spxr1JJ/a4bZQf23BbgWrGZT/grDCqMOmB/QspaOp04PYXG9HCzIpULLg8kd1OHbTbsn
         114sCik+bjyNgJjFhuomHM3DJ7kK9ZHoPQGGphxmtGPfch8Ik+0AYvd2U1ZbeiO6Hr4U
         i26A==
X-Gm-Message-State: AOAM531iNYl5MjqBHscHVMFOVS3dChqEbRHJmdB/iz5LWJoUPfN6sBYI
        nIMZZ8EKOUHoJGw/nXt0mgLs7fimysnk4A==
X-Google-Smtp-Source: ABdhPJw4El1wCzO9h1PrQRHJHgS1n7wBLsBEcsyNi+Q0V5/VIJpjZUvak/84DfgW7y4B3KpfBQ4nag==
X-Received: by 2002:aa7:9081:0:b029:1f9:26c9:1609 with SMTP id i1-20020aa790810000b02901f926c91609mr14313541pfa.54.1616262442798;
        Sat, 20 Mar 2021 10:47:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t19sm8605940pgj.8.2021.03.20.10.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 10:47:22 -0700 (PDT)
Message-ID: <6056352a.1c69fb81.bf01d.4b5e@mx.google.com>
Date:   Sat, 20 Mar 2021 10:47:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.107
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 164 runs, 5 regressions (v5.4.107)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 164 runs, 5 regressions (v5.4.107)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.107/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.107
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a65e788634437d7cdaf402930acdf210000f3957 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6055fe653d0d5cd3c3addcd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055fe653d0d5cd3c3add=
cd8
        failing since 120 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6055fed2a3cd6b1557addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055fed2a3cd6b1557add=
cb9
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6055fec53059f03e44addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055fec53059f03e44add=
cb2
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6055fecec1b247b2d5addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055fecec1b247b2d5add=
cc1
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6055fe613d0d5cd3c3addccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.107=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055fe613d0d5cd3c3add=
ccc
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
