Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CF23013A7
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 08:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbhAWHDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 02:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbhAWHDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 02:03:34 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70599C06174A
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:02:54 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lw17so7381776pjb.0
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 23:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ARRJxIu5lEceCaI/JK1XLzzFWjdGXp3q0Zjp64K9GM0=;
        b=HCaM6KBCXmy/bBd4TVa+K7DO6bm0/tE7M/DosP1iGiFsis5faAYaCMgLFxsDOJC4Sw
         eesO1XXTD9CVCv8qecS5TxcCUI25NvVnX6ZMzwzUK7R9BcsG09+rP6Crzme7gdiBgMPt
         wVd50AASS+hqup1UZd2hEhGEot+Il1rQvMiIw+2QST9GMHfmsokQeu+j/pPQEEAuSTgM
         nzilQPrZ6p0Zng9+FK97g3pzAeUX2iN8pLqXEp21YTEobXEo1Z2cj7QGHwoPZreNUWep
         dUhlmYQPIzaPE8nihhFLp49lUxzl6HppEhwkrHkx6okP6PjWk7J7pD4RHPfgOIxey1Sp
         u8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ARRJxIu5lEceCaI/JK1XLzzFWjdGXp3q0Zjp64K9GM0=;
        b=pNC8z4uXtL8KBwfvip6a1m8KIfFjiq1DKtnnqbJz6aQHzInRoXkXKCAUa7xIHhDTZD
         ThTyjwP470gDIWOw8HAO8QWpFSGuQQdf0Tc4xoZM8OqcS901lZMRNfd6ChCmH0bZYcQ4
         DItUZ5MwFDC/gKInLxGi0AjwTmDe7+jMOViBYv5lXUIvDTMMGAYMvjF1yQ/uS9iCBmtW
         vBSbV3MkATKzftWJ8aSWT8nmDglKs7diUZAy0/SISmaDG7zRtk6Pj5/kZV03yV3fwpoU
         qHKPDz7DvKXDi3ODQSTTOdO7WJLoL4/Bri5yFi+pu0q1j7gQ7f7BLguYtwGbKudoISoX
         k/FQ==
X-Gm-Message-State: AOAM532IkltSWsR2L+XPmzK5twvF0JCwT5tyI/uH/JKAyCfNyLqXI0X7
        4BTg/a6p3P7khBvFnP+nOMJ8zabngM5fYO0w
X-Google-Smtp-Source: ABdhPJwuLwF6elZI2ATxoDOdSzTR2AaO3N6mUWphEYQUCW3sdg/VbgE8WhIxNHoJELxEpW+ivVc1jg==
X-Received: by 2002:a17:90a:1082:: with SMTP id c2mr1204753pja.183.1611385373581;
        Fri, 22 Jan 2021 23:02:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v9sm10593557pff.102.2021.01.22.23.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 23:02:52 -0800 (PST)
Message-ID: <600bca1c.1c69fb81.b8ef6.a502@mx.google.com>
Date:   Fri, 22 Jan 2021 23:02:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.169-22-gfcc6e0cfe4305
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 139 runs,
 5 regressions (v4.19.169-22-gfcc6e0cfe4305)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 139 runs, 5 regressions (v4.19.169-22-gfcc6e=
0cfe4305)

Regressions Summary
-------------------

platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm  | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb   | arm  | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb   | arm  | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb   | arm  | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

sun8i-a83t-bananapi-m3 | arm  | lab-clabbe      | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.169-22-gfcc6e0cfe4305/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.169-22-gfcc6e0cfe4305
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcc6e0cfe4305e032979e564b892bad3fbe1f948 =



Test Regressions
---------------- =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm  | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b96a7aa7230de5dd3dff4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b96a7aa7230de5dd3d=
ff5
        failing since 70 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm  | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b96b1f3a165b273d3e004

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b96b1f3a165b273d3e=
005
        failing since 70 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm  | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b96b13f2e566613d3dfe6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b96b13f2e566613d3d=
fe7
        failing since 70 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb   | arm  | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600b9673f3a165b273d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b9673f3a165b273d3d=
fca
        failing since 70 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform               | arch | lab             | compiler | defconfig     =
      | regressions
-----------------------+------+-----------------+----------+---------------=
------+------------
sun8i-a83t-bananapi-m3 | arm  | lab-clabbe      | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/600b99b4f8a0b705d1d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.169=
-22-gfcc6e0cfe4305/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600b99b4f8a0b705d1d3d=
fca
        new failure (last pass: v4.19.169-5-gef71eabe03a09) =

 =20
