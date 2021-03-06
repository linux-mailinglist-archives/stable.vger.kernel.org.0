Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777F032FBB8
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 17:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhCFQLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 11:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhCFQLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 11:11:21 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ED7C06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 08:11:21 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d11so2891714plo.8
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 08:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fmvDIsqO2ysYq2ZrJZx6ULn0ObM7ochssZLU3dwWYYg=;
        b=xIBdilOOc9OzNaFhFzhu6UxIbhOsvIYQZF6mjhkKtpb7NKd+Gs3EuuHfXuePZK/8Sv
         qE7pVNxAmUHKx8ZvTbg0BZFFRbrBKyCr5xmA4aPcIepK9rxmXiyc7tOUKyVp5FARpxlt
         uq/n068F9o7/5ZT7C4E0uElMdsG/3N54+LxdMzJRgJsUC7ll6H+2ATCVXUY6fvLKZYU0
         HSiCDOk3kye8UvnAq5aH8xQ9dicNQhmIoD44pKaU/RGj0ohJsKDgRWjRTSVXB9k2GW/a
         XWlsvcLZuGjW9lZ/BfLutJjuxAegRrkoJiKPV8YDWKBWneKxvb0QhXZHq1sHOoFsVNgE
         1Zmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fmvDIsqO2ysYq2ZrJZx6ULn0ObM7ochssZLU3dwWYYg=;
        b=FZy7GpOW4zZn/tUuStMHbVgnuVKUulmMecFg+yoVC6KsKGOJkrO2ojCRsZBXSsHpnB
         T9acet9urbC19nFC+71toJKXvxf2wGxUr+/49lSsKuYPiLJOjHp5UvAw1G8I8hKD07jt
         bSuzqTbHUEzEp0/CXObrhIkTmNog2REH9j3z6WIG4Og0u9xzAugpJEXo5JOGv5howRfg
         Rsn6CKI2WqGfWPkQ16DgoZfwXGe118tPbHIwBMTyOsu99hzmUrfZdFUUTuKyDrhV5Esy
         mXNBhvRZkILpRBuexh/SBG0uWcxhcdVZ/Z1ApmRs1dlgXG+wjN/h3cC7z5IO7SpgSJ4Z
         UHxg==
X-Gm-Message-State: AOAM530u8yDxQItXAe4eabm2PiN5AM8TbTNCjIpg3yFNsvv3geyiQ3qi
        X4BZf/WtR0iaT37kyG8qoAzVGleZ1Scs1w==
X-Google-Smtp-Source: ABdhPJxyHuuVcMwUzS7DDvHfVh0PLnj925h88WN+XTsw6/nIjp/BK9VUBYtiV4UwJjdxNd3UuJ8PxA==
X-Received: by 2002:a17:902:ed91:b029:e6:125b:6bed with SMTP id e17-20020a170902ed91b02900e6125b6bedmr399049plj.74.1615047080682;
        Sat, 06 Mar 2021 08:11:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z68sm2275655pfz.39.2021.03.06.08.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 08:11:20 -0800 (PST)
Message-ID: <6043a9a8.1c69fb81.3af8f.44ad@mx.google.com>
Date:   Sat, 06 Mar 2021 08:11:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-52-g5082ea74d500
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 93 runs,
 4 regressions (v4.19.178-52-g5082ea74d500)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 93 runs, 4 regressions (v4.19.178-52-g5082ea=
74d500)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.178-52-g5082ea74d500/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-52-g5082ea74d500
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5082ea74d50000ded6337c433d59a48d05e86af1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043786d316d9867c6addd0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043786d316d9867c6add=
d0f
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60437e41f21a8da7abaddcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60437e41f21a8da7abadd=
cdc
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604375c1bf0e0ed9fdaddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604375c1bf0e0ed9fdadd=
cc7
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604375c5bf0e0ed9fdaddcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g5082ea74d500/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604375c5bf0e0ed9fdadd=
cd3
        failing since 112 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
