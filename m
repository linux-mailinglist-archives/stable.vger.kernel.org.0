Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2186C2F38D2
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 19:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406495AbhALS01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 13:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406492AbhALS00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 13:26:26 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC120C061786
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 10:25:46 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id n10so1966229pgl.10
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 10:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QvHfbfz86sF/olJj3/f6kEEAINZo3LzQ8E/4iJpvAiI=;
        b=qKfjeXgWrXJ5WmLwcPCJ1lF0vvFWTn+zZIMIQrrSly/v5X4vxYzgEZjf2QUbvqaiCa
         2K+7nTD2vdWeJJMZPr2zC3j3qU3jRNLKo3ktJzjAAXT8K8se7jL2ORnBHqejPQGnffcl
         tnUe9y0aSB4UrdriO5InlwbhdEPEJN7mLBEJeO5wqteygkpcAn8jKw7gpe4W8DtXgoWf
         9sc1ayUqXOhOV6VKDPfUyI8h+m51iow5t25+6RrFJ8kzPZH4WCl+CMmVT+9CF/pm/Ifc
         Mb4INSTHWfZM4OVq8AZqgFq7IdGkEnS+epx0sKnoMOUoPI8BgnRACGqtdQ6jV7ADf9NG
         /Ong==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QvHfbfz86sF/olJj3/f6kEEAINZo3LzQ8E/4iJpvAiI=;
        b=E37pIvbF7QPJDN09BOzaev/ldcmV2tcTn6jNawK66I9w00ZyRTrRSNUiJDAtIrHSkP
         7t3pcr8PWt/FcfJoxI2NuDiMQHC5O4kBUIWwjCZ+eGR070q2e55VlwfSafawc5uZM7Iu
         sWujZXP6bzHRg7L2afxSy5pk55hiEOzH2320jozIaOqFMQPg66/2ekITx/4mEdJ+uj1V
         cZp4wOuQgqVIQxYMTG3zBIKAFs6PLCL1uzERvKrALhKFeCC6xEZm+avh/1Yw0HC7RkXY
         Kpf0Drknorfw1y/mbPN2hoWvTsjCPrApubX50CP/6MVXujjOd15mXm0rmzOY42EqtLOS
         Hpiw==
X-Gm-Message-State: AOAM5326UsHl31dbiLsmQLzcXS3ieE5lyTFoGk5C46OM4/C5F6GDlTgy
        qpLXyHgL9eBLjUUTKn/FF0ZB+cS/4XO0mQ==
X-Google-Smtp-Source: ABdhPJxlGZrMR1RzFMUXsAU1W5CbNl3xgvO5gRO6E60A8gy/2UtKszk3GAiGzX21JwzQ/pSjcX6SRw==
X-Received: by 2002:a62:64d2:0:b029:19e:662e:5e99 with SMTP id y201-20020a6264d20000b029019e662e5e99mr513305pfb.17.1610475945817;
        Tue, 12 Jan 2021 10:25:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm3822026pfd.43.2021.01.12.10.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 10:25:45 -0800 (PST)
Message-ID: <5ffde9a9.1c69fb81.48e3b.8789@mx.google.com>
Date:   Tue, 12 Jan 2021 10:25:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.214-58-ge3be7c59d3c1e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 120 runs,
 7 regressions (v4.14.214-58-ge3be7c59d3c1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 120 runs, 7 regressions (v4.14.214-58-ge3b=
e7c59d3c1e)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.214-58-ge3be7c59d3c1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.214-58-ge3be7c59d3c1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3be7c59d3c1eb71d34a1927c0fbc89052ce93ca =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb802e0c42b636ec94ccf

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffdb802e0c42b6=
36ec94cd4
        failing since 1 day (last pass: v4.14.214, first fail: v4.14.214-54=
-gec361fb28cca)
        2 lines

    2021-01-12 14:53:50.766000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/93
    2021-01-12 14:53:50.775000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb5d7876768d122c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb5d7876768d122c94=
ccd
        failing since 59 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb5cd58d23a011fc94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb5cd58d23a011fc94=
cbd
        failing since 59 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb5e1040de796d9c94cbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb5e1040de796d9c94=
cbc
        failing since 59 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb589c58204f909c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb589c58204f909c94=
cca
        failing since 59 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb58bbc5f3016bdc94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb58bbc5f3016bdc94=
cd9
        failing since 59 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffdb5aabc5f3016bdc94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
14-58-ge3be7c59d3c1e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffdb5aabc5f3016bdc94=
ce9
        new failure (last pass: v4.14.214-54-gec361fb28cca) =

 =20
