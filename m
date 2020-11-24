Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74532C31DB
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730768AbgKXUUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730773AbgKXUUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 15:20:10 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68D2C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 12:20:09 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id j19so200228pgg.5
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 12:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9WirSxsF8bk9NWNVieyXFUuIMpkqVNo3PFCD+5KpPew=;
        b=tozUgRTmZvT9+pbiWGfDPv4sSy279YX42PIYDLckqY780Z9XnX0w8iJQ1fwkMi/bsW
         U4LteHIOqgmA7iCsqNjj455E/Mk3ukVRNak1qIc2JdDQ5YWdzuACYHn259692nOrz1uE
         u0oxoF9HCMPIW48iT2YVEtdWft2xltAQJwuYhs4lM/49cjAp8gsmEqPRT1cyBXlqbNQT
         NorF2BnwprGxE4KOeZYoUdg2bkJ3PZiZNSOLh+8u5kxab3SnGZDNkB6jVyH0UoVu7Fr1
         KtCqsKyOIr/NxIaS6FrCTPOxhk+c1kDl4ZrdCTgkbKastMLjACG9FjLqk50iiIZifEqg
         kPYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9WirSxsF8bk9NWNVieyXFUuIMpkqVNo3PFCD+5KpPew=;
        b=uBHrphlvI1002DrWE1fDks10PoyZ1hpy8bgW9DitlKp9Q4oYVy6dCld6IpKvFJtYO1
         b3pmNIihM+4EayB+kz7F+SWtHS7l9bJiIuhxzb4utg81QDAwde8zAG1kO1pmHGjmSD89
         gikgKp8grT7QTQRi8CuoOIKBB64EE0nTRej7EwsMlIndojHIm5zdGxLpR7+wzWtuo5m3
         5TDBknooVIiiNQzuAgqOccPFHXUD/l4eqAhmpl363IJmrwQ/RXrf0PxaaGS9zWSuRdk4
         jLYmS2TY0vssISsGe2FcvDQjJUPW6j2Mt10UTy0HGykSVTPvAgh8yyAqS943XQLirksa
         /XvA==
X-Gm-Message-State: AOAM532FtHS/o82PAv77OLJaMf/48N0aMCRVIUbBve12HKFSYTN+PsLV
        Jz1z2t6rwOC3qV4k/g7oBk1DlkyJc3Nzsw==
X-Google-Smtp-Source: ABdhPJzTD1w2SAKdSp24MBoeBuVaLeIq5LLMdpZOeD67EzsTBnUxb67rTrC4xFR2hzd9FXEY3QLQRg==
X-Received: by 2002:a63:4106:: with SMTP id o6mr124921pga.38.1606249209117;
        Tue, 24 Nov 2020 12:20:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11sm85809pju.23.2020.11.24.12.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 12:20:08 -0800 (PST)
Message-ID: <5fbd6af8.1c69fb81.fd37b.04d1@mx.google.com>
Date:   Tue, 24 Nov 2020 12:20:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.160
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 170 runs, 6 regressions (v4.19.160)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 170 runs, 6 regressions (v4.19.160)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.160/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.160
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c88e405c97ed1828443b67891e6d4bb6e56cd4e =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd3826be0629d0d2c94ce3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd3826be0629d0d2c94=
ce4
        failing since 161 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
panda                 | arm  | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd3a147ecdd1cd3fc94cb9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbd3a147ecdd1c=
d3fc94cbe
        failing since 13 days (last pass: v4.19.155-42-g97cf958a4cd1, first=
 fail: v4.19.157)
        2 lines =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd365cee83647ba0c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd365cee83647ba0c94=
cdb
        failing since 6 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd36694a0d2a47b7c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd36694a0d2a47b7c94=
cd8
        failing since 6 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd36644a0d2a47b7c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd36644a0d2a47b7c94=
cc9
        failing since 6 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd3604f975b6eedec94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
60/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd3604f975b6eedec94=
cc6
        failing since 6 days (last pass: v4.19.157-26-ga8e7fec1fea1, first =
fail: v4.19.157-102-g1d674327c1b7) =

 =20
