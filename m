Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7027930BA74
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 09:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhBBI6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 03:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhBBI6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 03:58:42 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7A5C06178A
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 00:57:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id e9so1950411pjj.0
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 00:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bIEbhUaye5OCKHLZJaNf3/qdu6S3FjeqaNkL2J5Hw7Q=;
        b=lz/XqzOOxtnRnOMo/rdVDWyaFbt4TxdNrRWxG0gpvFSv2D9qATqjoPcVRwLr/zHqv+
         vyg3rOnf82b62vjXy6esjwa/QD6BrdMOMD/+g3qgaHp1OmqIQJMTgRCLJhirDl/DzBT+
         bBxJtb+B2TkhVsboH+rtglWsLjTHFJtVGpKzBFg8+cH9R5InR04I8fdKO1FtHoW3TaLr
         lH96vKwcP/Pnmlc1F8l/o7w2moCVHkvSVgL883FJlDo2Q0IQFNIyDKcAMtacUug33O+Z
         K5Zqc4O72SYHTpfuYqO0H0C7pe1n3khoCBZBKzOYj9VsaeAao2Hziq+ApT5JYI36YAk1
         ATaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bIEbhUaye5OCKHLZJaNf3/qdu6S3FjeqaNkL2J5Hw7Q=;
        b=joQz6YUJdyorZ+xCIN1CHQp16rVVPhlGLXYsZtYzT/AwWq00pKr0lV9iOK3yl21ZTH
         ZZtMpcuavtjjzYnTK5jzkXl+rrG3bDJ5+B5ks1/JgA27QCUSfYcBxljZ2LpErLoY66Bf
         Zi/PabFhyNxepqDZXE79ug22KEnhYPEhfv+Z+ZvkV77dUN6dGngj7EFvkdrgJq0jDIWj
         TQMOs32mOf4NwJYezK5JMFR9bqMABC/ja7ZhSYC0hjH/VWF6HOOl2ni2iHYjzF2QMtjs
         mpgCsahSONLdnsBC6uA+8ZzV1rTS/qPvNiQmNVZHeM6U85D08ZyUWd2UlQRk8/9HuGhi
         rUeA==
X-Gm-Message-State: AOAM532snRIgiPOnrkymohXAY3ub0ZM2TU+9NaNTOltJu/ZYYPnya2Pk
        5EiLUNzf4ppex8uLWk5g+tB34hkFRNYwag==
X-Google-Smtp-Source: ABdhPJzW58Ni37Y3czvxCJgkpR2EeFQDRPfn2xttKxTw+4kRnIAIh2xSuIzHSYoVgzbeJ9JF0As3yA==
X-Received: by 2002:a17:90a:b005:: with SMTP id x5mr3252937pjq.183.1612256278508;
        Tue, 02 Feb 2021 00:57:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e17sm2099917pjh.39.2021.02.02.00.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:57:55 -0800 (PST)
Message-ID: <60191413.1c69fb81.2d837.5192@mx.google.com>
Date:   Tue, 02 Feb 2021 00:57:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.218-17-g14278d4b38e29
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 137 runs,
 7 regressions (v4.14.218-17-g14278d4b38e29)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 137 runs, 7 regressions (v4.14.218-17-g142=
78d4b38e29)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

sun8i-h3-orangepi-pc | arm   | lab-clabbe      | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.218-17-g14278d4b38e29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.218-17-g14278d4b38e29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14278d4b38e29bf27b1229b1e28e1a1be7549d74 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6018ac2ce0886c6532d3dfe1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018ac2ce0886c6532d3d=
fe2
        failing since 307 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018ab16583b90c323d3dff0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018ab16583b90c323d3d=
ff1
        failing since 79 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018ae198ae471b332d3e003

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018ae198ae471b332d3e=
004
        failing since 79 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018ab0098b973dde5d3dfe5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018ab0098b973dde5d3d=
fe6
        failing since 79 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018aabc0c84a80f5cd3dfe5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018aabc0c84a80f5cd3d=
fe6
        failing since 79 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018b58c567f48a86dd3dfcb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018b58c567f48a86dd3d=
fcc
        failing since 79 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
sun8i-h3-orangepi-pc | arm   | lab-clabbe      | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6018ad40f08cbe255dd3dfeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i=
-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
18-17-g14278d4b38e29/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i=
-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018ad40f08cbe255dd3d=
fec
        new failure (last pass: v4.14.218-6-gd4c2cced9de43) =

 =20
