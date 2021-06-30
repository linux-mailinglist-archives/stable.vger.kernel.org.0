Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E221A3B88AD
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 20:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhF3Sq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 14:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbhF3Sq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 14:46:56 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9318AC061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 11:44:26 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id i13so1964907plb.10
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 11:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uDVdkSU/xiNnFuMyj8/nmb/3s4tAai6xj5E29JS9OJA=;
        b=NWQcB+v7xwl46uR2EgcLroeAQ+lJewdiQqmuE4YDBqQgSgtMaskojSEqW4mIJhpWsg
         IgwOHr8CvXi8ZBn5i+51BYS1lh9cvi30PVktmCyewiNwcjm26rV4PjOTUC8a0ZeurJ/w
         ZyBZRrANCCAICnunTrusKui8YJAVUEXUXlmCCqt/WGdNXUYBmUylOf9bUSxmvXpiUp3X
         Wvf3NY2lds9zE83mX9ixTYaju3RqHm4hJ1rxZcsiGxgAgYLAB4feDT1IcvoqmxoCJKNN
         6zZ3hwelI45sEIlJw0F+y2Drnb8rRVplULBx/wcptQbBXSXBG3sxItxtBUxH1mQPLpKk
         8NMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uDVdkSU/xiNnFuMyj8/nmb/3s4tAai6xj5E29JS9OJA=;
        b=Y2Z1+9GHWQkvlYo2nMuRy439Gye9ugYczhNJ2J6Vu2XgaNgUFWG0zx1zsL1aqRgmYT
         GmINKway2J+Ups8X43AYR0Ptlqffl8lF8eRwtXG7b/cFuu5dirtexH1DgoaBG8pAR70g
         9gKk10Pu+gQBScm62mlUcHpw7iTwFG4pZuLbv0lh+AZUqyFGuZKD5r2wgKglAh5yykk+
         mtUUCflaJ8B12vNTiVTbQ30cT3Ui1mAPVbVPylFUokxB7gj1osVDOl/GbbqzndVytfdD
         M/zV9PX/Lwusj45JZKPqvQaLLqSp/joOVRMM74M/VcrqQa0J018yLWrZmu0KkLesxudh
         4iYA==
X-Gm-Message-State: AOAM532n2PhJi8+L1yWbe3InhBiK7JXQpG0rry71rTGjMgeXg3716iuP
        N748aU67aLhZ8+6I+neqvmaj6UtvNRFpWI5K
X-Google-Smtp-Source: ABdhPJxoLT1A3aA955bgTNy/pdDjdCM91GpFcvBZRQto+plJuKzy4LlBGOLWzxVOC5lJ480XWZhsAw==
X-Received: by 2002:a17:902:d890:b029:129:1282:fd3b with SMTP id b16-20020a170902d890b02901291282fd3bmr4817598plz.84.1625078666031;
        Wed, 30 Jun 2021 11:44:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h76sm4297213pfe.77.2021.06.30.11.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 11:44:25 -0700 (PDT)
Message-ID: <60dcbb89.1c69fb81.d92b.c935@mx.google.com>
Date:   Wed, 30 Jun 2021 11:44:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.196
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 147 runs, 5 regressions (v4.19.196)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 147 runs, 5 regressions (v4.19.196)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.196/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.196
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9f84340f012ee60c12aacc03662bcdd67419a31a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc88681d4d90d0d323bbc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc88681d4d90d0d323b=
bc4
        failing since 223 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc891e0c85797c6e23bbe8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc891e0c85797c6e23b=
be9
        failing since 223 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc8f8de904ec10fe23bc42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc8f8de904ec10fe23b=
c43
        failing since 223 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc9478c1797d0ecd23bbe8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc9478c1797d0ecd23b=
be9
        failing since 223 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dc8772ffbd0492ed23bbbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.196/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dc8772ffbd0492ed23b=
bbe
        failing since 223 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
