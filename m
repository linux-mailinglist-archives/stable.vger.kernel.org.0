Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4589F33031E
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 18:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhCGRDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 12:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbhCGRCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 12:02:53 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778AEC06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 09:02:53 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id ba1so3753750plb.1
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 09:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9wcEbSqmbt9NQLvLqMtKwCI/WMZOhCmNdexc+Y0EiEE=;
        b=xd6Iz3ODFsSTXjhttZRYGAWyazTthMGVYyEc0W8oJ51RTQLXFIcDlAORqF28XoMYqj
         NSq+7pPKyvd3yuDbwHIvGGLE8LWsMilLb1wNfuiI3KolglmClbtGA7TlpwvNdIUFaVCW
         ZJXrFUAj6KRPMQ+WB6Zs3PVT1GF3jkGKUo4fdZH8dGnxbvI+nMzW2yYWmZ1xLfRk11Kg
         s7VH/G+tzQgdFhhtUJ8PYvGcCAz4sBm9GESQhxDtJ8ffhe30hLGBMjWJCYFMJSW1YfxE
         etGo01awuapadFPslJzzG85xBTWvhXY4VgphR0f8MhFmufruZ3bSGcgonUB1qI9eWexw
         VykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9wcEbSqmbt9NQLvLqMtKwCI/WMZOhCmNdexc+Y0EiEE=;
        b=ZH8v+XoEHHGzJOXXIT5UlahA9kfA5SuW+La8u65KOULwhyOLJ9JLd7shCcBcGqdei9
         TD7nFRM7PfeCrDReSyoYcAM2OYcg/vzKgBURv6Wj9nAiMnj11R/eqbsaOwDDUTkjzh1i
         P6dFCJjnSTSaO1Lf2MpHVmXSEvENPzEo8d+sPwlsPUuG0jtuyxzFGFoSYkOMn3uJ4H/P
         R4UfNAETU5e7QZ33d/jTPagIAU+XLf7AO+0MEnlXcLZd9Xu21mppd69ZIiqrINPU3hQk
         kkYjftJ9n2fMm9tCJ/SDru2el6ac9Rqp+bdi62oO8oZ/mGPHP6ZVJIShalnw3LnuuXf9
         uGCA==
X-Gm-Message-State: AOAM530Y45lfY5V7+v6Bj1qz+JcMoAHOg+biSARG5sprd/0F1Jr1N0mh
        r1PX8ZElYBXrS9LMnZbKDx54dpcGmS1gCw==
X-Google-Smtp-Source: ABdhPJw3IKXz061jYJcF966Uxd4yuTDdEvpBtLwIZDSoX2Lp4yluW20pvLGHhIUogbTt3s1IftyjyA==
X-Received: by 2002:a17:902:b28b:b029:e6:375:69b0 with SMTP id u11-20020a170902b28bb02900e6037569b0mr8745245plr.25.1615136572672;
        Sun, 07 Mar 2021 09:02:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l22sm8343713pfd.145.2021.03.07.09.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 09:02:52 -0800 (PST)
Message-ID: <6045073c.1c69fb81.5d4e8.554f@mx.google.com>
Date:   Sun, 07 Mar 2021 09:02:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.224
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 134 runs, 8 regressions (v4.14.224)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 134 runs, 8 regressions (v4.14.224)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
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

qemu_i386            | i386  | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.224/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.224
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1d177c0872ab99ac8d1fe09376a56c2911a837c0 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d6f519b239e7d0addcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d6f519b239e7d0add=
cc2
        failing since 338 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d628ff4f7f7e08addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d628ff4f7f7e08add=
cb9
        failing since 42 days (last pass: v4.14.216, first fail: v4.14.217) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044da93532b4c86f5addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044da93532b4c86f5add=
cb5
        failing since 108 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044f4c4c872328a96addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f4c4c872328a96add=
cc1
        failing since 108 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044eeb1d95e2857d4addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044eeb1d95e2857d4add=
cb2
        failing since 108 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d422577d40974daddcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d422577d40974dadd=
cdb
        failing since 108 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d42f5c9f4eee8eaddcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d42f5c9f4eee8eadd=
cbd
        failing since 108 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_i386            | i386  | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6044d9b8f1a2b89f30addcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.224/=
i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044d9b8f1a2b89f30add=
cd6
        new failure (last pass: v4.14.220) =

 =20
