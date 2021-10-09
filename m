Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9722427D71
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 22:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhJIUue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 16:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhJIUue (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 16:50:34 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8042C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 13:48:36 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m21so6754517pgu.13
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 13:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ah2x0b9uMlKcayrzD7IbbpCpg0ziZC0KaYiF6K9ELyo=;
        b=srHZfEdJP9+rouM/A9UlTHaDhiGpZxz+6GAmODrKhxc1Ou0WYKizTwyfDixDwzctNr
         40HP8PvhBK3FdydXzug0AL06VUcBBIKV86hOy1XNbTRGtLS9syBRgJ/5+cUZjSKj7zZh
         JQljqdVBbw16DmnkWMmLN1S4ggrXSplM6EAV6xdm9jeVFtMiL8yPML87gUQbFFGaqvmm
         1r+cP7htBfKdiCavzwkF6TwUGrdXYxI914dR0AaJFt8GWl6LYhP5mHD5UvvyYubT+he0
         3sYjX9bNiHY+075nTsmkDGOmRC6ELw+MJB7lgdjvAmbbUOFaGpVsif+JITSniDGVmIDL
         Qogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ah2x0b9uMlKcayrzD7IbbpCpg0ziZC0KaYiF6K9ELyo=;
        b=m4BZdJ9TmOyy27Ri4EKuHwr0Z2druDCI05R+UW4t7UoVEMO06E+UNh9C9XiDiW2Clj
         u0Rg9uY8Z4DTiGeu1avVqGuLAGg4dHdcP7zi5KZl3QAR0Xo4FS1fiDSO/PjF1LBDkxA0
         PikOtKOIu1ZHsakgSuZDqgP+tj2K3xntBPEgmZFwOEoUEC3Q3HTisK7WBpZuEjCUjgAL
         l+bjBEFdIlt5LM4DeB8No7uXynH3NG/bWtLOmf/phWZQ9o/TdgP2GOqJMM9t9CRKo+B3
         xb4Jrag0caCnyzSxyVY2ykYn9ocIwJLbs7vXNw+AkqHKyu9bH9/Ac4WzCCM6HuFc4HA8
         pLYQ==
X-Gm-Message-State: AOAM530enRgS+4D7hi3raXjp2K7rOGJ9rau5AMXA5kqmyaeRoDrMMeJX
        bJgagHdgLtAHeU2vMSj7slrZckgliP353kAW
X-Google-Smtp-Source: ABdhPJy9/uI7R5kot/odjo6ZhgjutHGVrWRWYtq1TEk70Tt6p4n3qJWBO14iF5bn8p4ehvP8MleDeg==
X-Received: by 2002:a63:b505:: with SMTP id y5mr11159657pge.91.1633812516036;
        Sat, 09 Oct 2021 13:48:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n1sm3013546pfo.116.2021.10.09.13.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 13:48:35 -0700 (PDT)
Message-ID: <61620023.1c69fb81.e676.88f8@mx.google.com>
Date:   Sat, 09 Oct 2021 13:48:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.288
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 106 runs, 8 regressions (v4.4.288)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 106 runs, 8 regressions (v4.4.288)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.288/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.288
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1392fe82d7fba00ba4a8e01968935f2b2085d5a4 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161c76439af4a6bb499a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161c76439af4a6bb499a=
2fc
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161cbe275fdc907ad99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161cbe275fdc907ad99a=
2db
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161c74c77db0420ba99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161c74c77db0420ba99a=
2f1
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161c73d25ea2c805399a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161c73d25ea2c805399a=
2ed
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161c71425ea2c805399a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161c71425ea2c805399a=
2e7
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161cb920c169c06b399a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161cb920c169c06b399a=
2e9
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161c71025ea2c805399a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161c71025ea2c805399a=
2e4
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6161c6fdf8f615804499a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.288/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161c6fdf8f615804499a=
2de
        failing since 321 days (last pass: v4.4.243, first fail: v4.4.245) =

 =20
