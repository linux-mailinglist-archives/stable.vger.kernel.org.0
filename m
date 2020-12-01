Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA11C2CA72D
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391829AbgLAPfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391825AbgLAPfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 10:35:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05DC0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 07:34:57 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ms7so1432381pjb.4
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 07:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jADuMLygzcMw2q/TduDeMoXJKCmy5tU0Og0oyoDzwOk=;
        b=GlAmYMtNroXirUpu4WjjS052lBfGOtDNczdkxmqWG9UKMcbcCogY7VzuuFvfx/1H0/
         r3mYzSSe8j8rYVhG+NCFHZjOUCRBGsFnHOiy6QgoYQW71I4jcveIw9hq2VivbfAVx5IB
         OswtK5zwARtdphnlkijrRlzCL7pWk4XxQ45rBIFehtttpbz2tsrtoTQ9GMZU8tm96jp6
         o7RLlAmKS7k3pT7kf0MN1RSWwp0tm8W4IfMxSRRk+XNJlv1ptC4NCiXFSrorBeBEGv4f
         tcBg0WMwa/0HADPSjvfQILY/oNFpZBalUUmAxg5O3O92zqIDS1GbG0WiD6isUaF2rRBC
         HqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jADuMLygzcMw2q/TduDeMoXJKCmy5tU0Og0oyoDzwOk=;
        b=h7h8n0UbP6jN6rVYa3G4ceo1XFIFgD87KppObjHnCuJ0Vb/V1AM/XOyyPrEITZLfKQ
         46A2G+OkbbUDHHUNcbZ8vcPp/NC0x5b555pPE2r6rWlJfrtrlWSTOlwgImr/KU3sQRk8
         68vkObm74P41ty398cmkEOweibpPqJH6CidOJHpcaW7QTDZY3smA8CrF7LSmm6v2Mivs
         z+9uU5XD5/C8XvHEcVRPP47TgQm8iz6mlfjL6GrhyA6XrVbOwIORRPMZXCPXx0WNiLLw
         infM6cXRljFkbidPXPIR75VYVzVe+6ZaZZgMV1RQ770TodT+CZrh/cFOFxE1Wx5npRRH
         KT4A==
X-Gm-Message-State: AOAM531hRwdFR1r04i+NLoGOAFAtQU/p/h+traLNFlNa5n/a4XvfedDj
        PxNv7SV8ZlNEi/0r7ssKULH4cUmVW/gMbw==
X-Google-Smtp-Source: ABdhPJxgqotafzNcAdgGN1f+wdndBtH5+loZ2rZXGd1VyuJGKbzAZjaR+eyYYMVijYnZH6O9QSYRjA==
X-Received: by 2002:a17:90a:fc8e:: with SMTP id ci14mr3258256pjb.181.1606836896169;
        Tue, 01 Dec 2020 07:34:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p1sm93520pfb.208.2020.12.01.07.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 07:34:55 -0800 (PST)
Message-ID: <5fc6629f.1c69fb81.f343.02c1@mx.google.com>
Date:   Tue, 01 Dec 2020 07:34:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.246-43-gc2b4ff37ba1a5
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 125 runs,
 6 regressions (v4.9.246-43-gc2b4ff37ba1a5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 125 runs, 6 regressions (v4.9.246-43-gc2b4f=
f37ba1a5)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
odroid-xu3           | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.246-43-gc2b4ff37ba1a5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.246-43-gc2b4ff37ba1a5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2b4ff37ba1a5a9bbb5160e311d472b8185fb347 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
odroid-xu3           | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc638325a8893c821c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc638325a8893c821c94=
cd6
        new failure (last pass: v4.9.246) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc62ed5560c50abb6c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc62ed5560c50abb6c94=
ccc
        failing since 16 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc62ed7560c50abb6c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc62ed8560c50abb6c94=
cd8
        failing since 16 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc62ec5ce98faca00c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc62ec5ce98faca00c94=
ccc
        failing since 16 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc6314146921b4156c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc6314146921b4156c94=
cbb
        failing since 16 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc62c4ee9d54968e4c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.246=
-43-gc2b4ff37ba1a5/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc62c4ee9d54968e4c94=
cbe
        failing since 13 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
