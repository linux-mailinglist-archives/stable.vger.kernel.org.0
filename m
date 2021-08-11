Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FF83E87C7
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 03:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhHKBv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 21:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbhHKBv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 21:51:28 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427B5C061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 18:51:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w14so929860pjh.5
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 18:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Jl6Ut5CP6++I4gc9sfb/2hiBRAEh6Y91M8amzx93iYs=;
        b=scVlDFlIAFtdIRb8DgqDdIpgA7hzBSpsjssQjD58LPE/NtcuM7xdCWB2JVXMafR6uf
         QBNLgfuyXRAR80IejoBxJotxhdWtAHpUdpE5TuwBo5Ol3m/Det8WvYO42GYJ44fRJdK+
         KtOl/kRlwMYF0FbZ44r7+bkOdaoKg54D1n6gdeJBQg5cAva1tauL9K1pVcJwXfmzHuCr
         umIWgnjWdx9Oiwk0Y4vq5T85Zmtj01HGKzbNQ2VHc31fvlF+0uRfShGaPjkgeUivFWYM
         hMUagtCn5NtdbOCQBaqIKGbYaINwOKAzzCAY4NvkcXRNOXmN6TbL/fjSXzbTMf66BMwY
         Y2Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Jl6Ut5CP6++I4gc9sfb/2hiBRAEh6Y91M8amzx93iYs=;
        b=p67RnQL/K5/hN0KgRVoleoV0o5NY+a0ZTe9kWMb4JhNAOIDIJ0BlaFqmHkAmEkMJe9
         MHPkHZNcw9jGrIo1o/sbTEjrfuHSeqJttdkAbGb8m+DTkMcfl1UmlQPquQ3+Y1cKtL8e
         cztW1C1qs2n6B3arik/Kf3T2EJtytewDnlFGlofJLG0YLT9JE5k+EAP65qRxN9soLY68
         zK4+JnVonyWSRn/R0nk2OTx+29A3qZf6aiFpXynvvw7I7kCkbypWSNvDzGeUpeWctDMV
         cYA3Q4QNxdEtCemkP4gXJavfBSjfXl7uc+WgnLCTDX5zpc71bxm+yJfelU3OAl8mvfeJ
         1Y7w==
X-Gm-Message-State: AOAM533DVdIgO5z8D7v/jBTi3WXrTmCetDX27jkcZMOniw3l+C10C9LD
        y9tii+r9NE4+fmO/3iv0hevlAE48+za3JIPs
X-Google-Smtp-Source: ABdhPJxiEQY3XEdiBCpIpHNIK3zCvy7JdRIO7DrtIds2VNQqxnt1pmNRY47EFaV0cyZQjIzy3pcaLA==
X-Received: by 2002:a62:e211:0:b029:3c7:ed35:7463 with SMTP id a17-20020a62e2110000b02903c7ed357463mr24623130pfi.14.1628646665642;
        Tue, 10 Aug 2021 18:51:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq7sm4838686pjb.50.2021.08.10.18.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 18:51:05 -0700 (PDT)
Message-ID: <61132d09.1c69fb81.c17ce.f0da@mx.google.com>
Date:   Tue, 10 Aug 2021 18:51:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.280
X-Kernelci-Report-Type: test
Subject: stable/linux-4.4.y baseline: 87 runs, 9 regressions (v4.4.280)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 87 runs, 9 regressions (v4.4.280)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
odroid-xu3          | arm    | lab-collabora | gcc-8    | exynos_defconfig =
            | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
            | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.280/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.280
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      78806dfb3f529da96c390c04605d9d2c793f0af9 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
odroid-xu3          | arm    | lab-collabora | gcc-8    | exynos_defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/6113005ce0368b88beb1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6113005ce0368b88beb13=
66e
        new failure (last pass: v4.4.277) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6112f7807b19fd18e4b13676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112f7807b19fd18e4b13=
677
        failing since 261 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6112fe5f336dd70cf0b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112fe5f336dd70cf0b13=
662
        failing since 261 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6112f53cbfacf021e5b1368a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112f53cbfacf021e5b13=
68b
        failing since 261 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6112f7e3ae08e2ac26b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112f7e3ae08e2ac26b13=
662
        failing since 261 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6112feff63c28f6812b1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112feff63c28f6812b13=
66b
        failing since 261 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6112f5b8dc235d18b9b1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112f5b8dc235d18b9b13=
67c
        failing since 261 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/6112fce32b1d22b795b13682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/x8=
6_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/x8=
6_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112fce32b1d22b795b13=
683
        new failure (last pass: v4.4.279) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6112fd83dcf5083c61b13679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_64=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.280/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_64=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112fd83dcf5083c61b13=
67a
        new failure (last pass: v4.4.279) =

 =20
