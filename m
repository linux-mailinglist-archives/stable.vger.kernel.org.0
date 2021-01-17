Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D4E2F94CF
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 20:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbhAQTLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 14:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbhAQTJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 14:09:29 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FABCC061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 11:08:35 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id t6so7436226plq.1
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 11:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q6St7OigjWXSjAw8IbK+FqgJRxqiC+l/LIQIsE+KwmE=;
        b=iwFZusOtDhS0yCrAGrr36OlC9W8cnISwPKCSsm1MZ6c2/a8kWpbVYz1nLb+kRQMZ4p
         bUqODsjv0knRW8iXc/CIrIjwRITsh2vG23C00BGYEr1jpWYf/NcnOfYUaMR1CMpuxskG
         7V6jL4Au3jsab7aXAP6BUEQzG1n+zC/rcqIvk1ec/2gEntw4a/rPXoiXbNOFUGXZ95/X
         BFryIHmFry9aDZCEAepC5LOPQE64gzQH4IYL9hwCZmegS7gF8K+e6xtcLrYN0u8/fYxF
         /07FEnDcgl6M8HfM19aNdQUFEWhIi71Bgfh9kpXaMySQ0xI0DexHT8DG1SmF9sOMhc8e
         LLKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q6St7OigjWXSjAw8IbK+FqgJRxqiC+l/LIQIsE+KwmE=;
        b=bHoJchWZTz2ClvqjftBjtHwEYArs0qUd613JYz5iPT+dRzogmXHf7G14f9+f/Hm2Cf
         jftxfAyHvQ1WOPRHV6AZstFUFOmaSlo8fs0fEsXmFdGpbnNvzLnjoYWG1i3rc+lBhdtj
         Q+duEBg5AwobCzLc5+VCQW9M0154dBM2atPXYp+XB7HxWha4JksDyVyvMSw28v3tTZzn
         bc+PrtRgW7eVI1rARwNyeMIMdrgwalZ/GVoaZZJ4y/d3yAUyRyBx5dZjOhFYuoySmYVT
         Z9It5zdB5QcmPYEv3CD6yej24EcofEHnFfAdYbzNuswuzU4qt9vONQcaPCNvxTyTEv3G
         5V5g==
X-Gm-Message-State: AOAM533fqdJvqdCg9GGkHs4lHI4x1GdL7RGKLT2oDb87vW7zlkVDA2WP
        Z8KY6MWDh0Cyr8srFYG7GnP7sFsDfzop3Q==
X-Google-Smtp-Source: ABdhPJyHVGWqDAUT+1RDiqG5xK0mIBBVGrR8jw5Xp8Kq6z3VsL6utt92BH+d83Vh0o6QYdmCF7oLYg==
X-Received: by 2002:a17:902:b717:b029:dc:3e69:80e8 with SMTP id d23-20020a170902b717b02900dc3e6980e8mr22760649pls.40.1610910514661;
        Sun, 17 Jan 2021 11:08:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm14179181pgr.44.2021.01.17.11.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 11:08:33 -0800 (PST)
Message-ID: <60048b31.1c69fb81.12a8c.2804@mx.google.com>
Date:   Sun, 17 Jan 2021 11:08:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.168
X-Kernelci-Report-Type: test
Subject: stable/linux-4.19.y baseline: 176 runs, 7 regressions (v4.19.168)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 176 runs, 7 regressions (v4.19.168)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.168/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.168
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c110fed0e606ff922d5cad8ab74ba9410ca41694 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 2          =


  Details:     https://kernelci.org/test/plan/id/600457aaec65ba15ccc94ccf

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/600457aaec65ba1=
5ccc94cd3
        new failure (last pass: v4.19.167)
        11 lines

    2021-01-17 15:28:36.908000+00:00  kern  :alert :   ESR =3D 0x96000006
    2021-01-17 15:28:36.908000+00:00  kern  :alert :   Exception class =3D =
DABT (current EL), IL =3D 32 bits
    2021-01-17 15:28:36.908000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-01-17 15:28:36.908000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-01-17 15:28:36.908000+00:00  kern  :alert : Data abort info:<8>[  =
 16.424521] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D3>
    2021-01-17 15:28:36.908000+00:00  =

    2021-01-17 15:28:36.909000+00:00  kern  :aler<8>[   16.434006] <LAVA_SI=
GNAL_ENDRUN 0_dmesg 599444_1.5.2.4.1>
    2021-01-17 15:28:36.909000+00:00  t :   ISV =3D 0, ISS =3D 0x00000006   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600457aaec65ba1=
5ccc94cd4
        new failure (last pass: v4.19.167)
        3 lines =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004588080e6bdf57ac94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004588080e6bdf57ac94=
cd1
        failing since 59 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600458bc0ac1297219c94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600458bc0ac1297219c94=
cbd
        failing since 59 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045b7fef59b98f9bc94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045b7fef59b98f9bc94=
cd7
        failing since 59 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045a6ba6f07e9666c94cf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045a6ba6f07e9666c94=
cf4
        failing since 59 days (last pass: v4.19.157, first fail: v4.19.158) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60045855644ad00dddc94d0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.168/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60045855644ad00dddc94=
d0f
        failing since 59 days (last pass: v4.19.157, first fail: v4.19.158) =

 =20
