Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890342B83CA
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 19:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgKRS0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 13:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgKRS0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 13:26:15 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA94C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 10:26:14 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id b63so1926998pfg.12
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 10:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=njniX5y0GvGeJ6YnhoF5bkfo80yGhXG2qF9+W5y0oIs=;
        b=kK2dw9hzBeNntBgpLWHkZ3qKyJ5aRAL5lkgwgmWApj89mSmvkG69Jx9KDhWLoELPp9
         3JjIdGAts682ATa+3f0/kSFvHrO2iFxeCKM6gO6m7R4pwnY1SdACM9/RPB94BFZF2DyB
         +V6Xa9wDkzABrO1CFG6N5vjSMszDGNVKEvghR49SiN59kPE1CPcpjHW2T3WM8VJ+1vdS
         VqwhtgPpGpEWlsfr/58nH9Z/djDG/haEMduGjrQBbLdNDyeT1/l8GBilMbbQPfp6B3ZB
         wlfneus7Hybrrt0h79ELYlVpvhtccMgcr2nnB/X0XopOAP4qu/OkSZdmwzNPOJSlebII
         VIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=njniX5y0GvGeJ6YnhoF5bkfo80yGhXG2qF9+W5y0oIs=;
        b=SEuylODCP8TrmM3BAja5fYcee2pqTpCJlYsnVgLXYBE5SGABXxBav2xwWlgJ3MFHYZ
         8TJOnNt85BJupQ8yIgc9DofNFPJ6htLVwo4/W3ifpM8HzdPEmXauUwnvbRULNcR32KrT
         fpAfPzkT8gUInne/D7jCuTDOZMgGMiorjBjv09M46cbmC7tIFKhbVPqDBotH5qfgrfSa
         Yn+C8L2lTe8bxSlZ/Y6y+fL+T1zCSiXr8mbotZ81nsTsAcMtvMj6apKHX0I+URNjaHJE
         9iCp8y25UoZBDsR1+CdrSULE5wsPISFv5p4P291Vowj/dgkU1RbUNcgPcHilc0wEZuDT
         CP0g==
X-Gm-Message-State: AOAM5307PS3k2H5Dtm5hxgAB5A1MI/q7Tg/3m4+wLAOqrXU+A96wP2cn
        Xn+P6E2aK/4xNcrN/xbzzrSqBWny+Z5yWA==
X-Google-Smtp-Source: ABdhPJxxaYzmGDqyLIOfaFh1CETBXG8bBfYbpmXPIu3ulI90M+QP4HNt3Zm+x6tLVBY+phhJmt4BgQ==
X-Received: by 2002:a63:2d03:: with SMTP id t3mr9036926pgt.353.1605723973215;
        Wed, 18 Nov 2020 10:26:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2sm23465688pfp.13.2020.11.18.10.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 10:26:12 -0800 (PST)
Message-ID: <5fb56744.1c69fb81.b2664.2952@mx.google.com>
Date:   Wed, 18 Nov 2020 10:26:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.243-63-g411b313642310
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 97 runs,
 10 regressions (v4.4.243-63-g411b313642310)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 97 runs, 10 regressions (v4.4.243-63-g411b313=
642310)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =

qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.243-63-g411b313642310/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.243-63-g411b313642310
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      411b31364231026e9803aff7cd493a034278efa2 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5366b41f52f2887d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5366b41f52f2887d8d=
90c
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb536c4e9eaf4b4aed8d906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb536c4e9eaf4b4aed8d=
907
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb536a2e1636c12bcd8d91e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb536a2e1636c12bcd8d=
91f
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb53677b449dbce44d8d900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb53677b449dbce44d8d=
901
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb53658a2d0fd358dd8d939

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb53658a2d0fd358dd8d=
93a
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5369ae1636c12bcd8d918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5369ae1636c12bcd8d=
919
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb53676b449dbce44d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb53676b449dbce44d8d=
8fe
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5367641f52f2887d8d920

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5367641f52f2887d8d=
921
        failing since 4 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5336e9c44b4ec05d8d92e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5336e9c44b4ec05d8d=
92f
        failing since 0 day (last pass: v4.4.243-19-g7e30056d78a6, first fa=
il: v4.4.243-63-g756a870cb6ae) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb533ce6a0c87d080d8d926

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.243-6=
3-g411b313642310/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb533ce6a0c87d080d8d=
927
        new failure (last pass: v4.4.243-63-g756a870cb6ae) =

 =20
