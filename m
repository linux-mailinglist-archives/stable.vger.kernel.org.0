Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BAF2C3852
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 06:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgKYFKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 00:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKYFKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 00:10:36 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9AEC0613D4
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 21:10:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id t18so534831plo.0
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 21:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GbQBZFn29qAtddkPYslBfboHk0T3bpmdWSNdVKPf9T4=;
        b=D5V9+xo8veQ4Gx9jonBqX0uemx632ZJStS0op+bxOTirVp8ZXnoMaoOJemSmTkdnAy
         Aa8Y5MQcF8veWKFytZGZApprxeVhEBEQp1kJHFcyLZQLmJTk91VXbPx8W5G1z5kMuV+g
         U3b82IQnFOZeqkuY3BLbpVqIWkO4IlQOJowRvx74iTfXYC9L2I2Lt4c2FeU2106+W9Qr
         pCWX8936gEujvx1b7ewAMSbnZOi/q1crTTG2pyNkkPT7/IIjI49D7JJpB+jEvMvElA1P
         Yh/AuKerV6IVfgPj+w4ihOJeAJDRbOZqx18knp9Ex6EraICirRbyr+WZPyGlmbK78NeU
         NmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GbQBZFn29qAtddkPYslBfboHk0T3bpmdWSNdVKPf9T4=;
        b=rCFgeHii0iVxAx24bxjwr2fBxAiKezETNUKDNH3g06jAiV1rCYnRt+Q4xtR2/R1x1K
         RRfBE6rcrYmKu2lKuNAYOQ5sl5RToJeU7D9106eKIYEiMjZuqn4sWTI8HcohDuTxmr6Y
         i3DY684WuTixWp3dv91xW0XLEnB95r26f2yVr7HD+9/vvVAqlMry4qIAIanyYYXK8Ae0
         4bG7I/OaJfQNhvEeNTG72jlvyPV90b3ruQSboc1vddXYSUbKN7J2QLVI/RHYT994np7L
         r+lPMYU33mw87ahubcJGpicf9PzI7hRg0J0pe+Emom4cCJItVDD770f0EaLLX2DOo5Er
         8beg==
X-Gm-Message-State: AOAM530eQr3kdbiChxYbztt3y14h4Dirpxk7NGDfkuOXqfK6Xl+WTlfk
        jiwWUt6mXyHkSJUs6fVl9dE46E3kkKqMvA==
X-Google-Smtp-Source: ABdhPJxBkfYIbXNKeAHpP0giPOtaEuMfPbbHClrDfQs7pl2BED0etGS4cgBIW4ZIO6xnOOKITvqNXQ==
X-Received: by 2002:a17:902:7081:b029:d9:d623:68f8 with SMTP id z1-20020a1709027081b02900d9d62368f8mr1652029plk.54.1606281035295;
        Tue, 24 Nov 2020 21:10:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v8sm934072pju.32.2020.11.24.21.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 21:10:34 -0800 (PST)
Message-ID: <5fbde74a.1c69fb81.9dafa.3803@mx.google.com>
Date:   Tue, 24 Nov 2020 21:10:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.209
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 113 runs, 8 regressions (v4.14.209)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 113 runs, 8 regressions (v4.14.209)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
beagle-xm            | arm    | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =

panda                | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386-uefi       | i386   | lab-baylibre  | gcc-8    | i386_defconfig  =
    | 1          =

qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.209/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.209
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87335852c5d9ec629f80bb2257b9a9945962b719 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
beagle-xm            | arm    | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb57f9e9c8ef127c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbdb57f9e9c8ef127c94=
cc8
        new failure (last pass: v4.14.208-60-gf3bba3045f18) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
panda                | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb450d001bfef48c94cc9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbdb450d001bfe=
f48c94cce
        failing since 2 days (last pass: v4.14.207-18-g5602fbd93fec, first =
fail: v4.14.207-17-gc8bd4f3bbcaa)
        2 lines =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb34b15fdf615f1c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbdb34b15fdf615f1c94=
ccf
        failing since 11 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb34315fdf615f1c94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbdb34315fdf615f1c94=
cc0
        failing since 11 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb34515fdf615f1c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbdb34515fdf615f1c94=
cc3
        failing since 11 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb2f24a67d01984c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbdb2f24a67d01984c94=
ce4
        failing since 11 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_i386-uefi       | i386   | lab-baylibre  | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb376f2b1ee01bdc94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbdb376f2b1ee01bdc94=
ce4
        new failure (last pass: v4.14.208-60-gf3bba3045f18) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbdb38db372a268dfc94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbdb38db372a268dfc94=
cdf
        new failure (last pass: v4.14.208-60-gf3bba3045f18) =

 =20
