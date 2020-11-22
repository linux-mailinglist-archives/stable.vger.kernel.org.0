Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DAD2BC60E
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 15:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKVOfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 09:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbgKVOfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 09:35:38 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAED0C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 06:35:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v5so8394307pff.10
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 06:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F3TDTQqLI78/nFDAUOjD2qh+J58engaW+J23EYH7pOs=;
        b=ThPBJlnPoJbZHZ56d8s2YG+75ntuxsovtt/6dLHrLPQZ8jp5bIGJwJIyT8zS5B2g4Z
         ZUbSRSfedQo0vd9ayHt9IyW4oMedPazN0PbTI7B63kDPCeGOXSK5HI728IWXAfDFWSDt
         q4ICiezI5GtugZv+SDh3yOpglt2TjcBmfE4PpIyf6SzlnUY+Ef91m/YwYCqC07eCJ6pr
         BWrx4B2Feor8JYQ7JjTkEfwpIrcYNaWc4qVv3LP69QgXRkVQ7Zx2a4ahvtICKpbIStrO
         FxcnYWVBaXDm/bOcHdAWVnQb9JL8db0pKpKYwmH7DytcXHy6Q1SFzhZiDRadsG9aj/yt
         haqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F3TDTQqLI78/nFDAUOjD2qh+J58engaW+J23EYH7pOs=;
        b=A1Pgl8w36WOrm1pY8qQoD2W0+VUtxM45ctgBdyIzIXsEdTwU9Zwx2zYeciTPXDllvG
         MlmFb6vBVJQvulNJcHF4YoKm+hDH3LKIxiQC1S9l/SSmi2NnZhAx3bD29K6ci2yXVOXP
         E3AZgcpXfn2nb8dC+oKFPelfK1oo0CvNm10orn2at0upXdAajZE36B84cBXMcICgC1rq
         Ln8X57Tg6E7LwvcwKuTH2kZ5wVdrFuNQGHGLYCXPpdCgdwFEzBWK3zd7DOLbBmQFyfP5
         Z4Ugj8ax2QYFdLnweembt7JqN7tWCozmAv0v2YlSPgQGcuExT9iRAj29POJvn4e1Hc7y
         4I8g==
X-Gm-Message-State: AOAM532cGoN6S4vhfXu72elztJ5cxB18DRZ3STTFF6FoN4L5J35sWI54
        F2rRIjwJSJJyRkjKW0MjThdD7v9D4iSxAw==
X-Google-Smtp-Source: ABdhPJxvArhFWAN2E6nUZEnAVR2HoNeVEC3Oc/ewbB3e4MQK3rux4dRsEsEYitrbDq+aZnYMk2vsgg==
X-Received: by 2002:a63:ed01:: with SMTP id d1mr23605735pgi.361.1606055735666;
        Sun, 22 Nov 2020 06:35:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm10965639pjq.46.2020.11.22.06.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 06:35:34 -0800 (PST)
Message-ID: <5fba7736.1c69fb81.922b0.6e38@mx.google.com>
Date:   Sun, 22 Nov 2020 06:35:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.244-15-g83f2d7d5a61c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 128 runs,
 12 regressions (v4.4.244-15-g83f2d7d5a61c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 128 runs, 12 regressions (v4.4.244-15-g83f2d7=
d5a61c)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =

qemu_i386-uefi      | i386 | lab-cip         | gcc-8    | i386_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.244-15-g83f2d7d5a61c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.244-15-g83f2d7d5a61c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83f2d7d5a61c4d11997b049c8989f83eb7099bcb =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4623d8d52f203dd8d918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4623d8d52f203dd8d=
919
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba46390526f3e519d8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba46390526f3e519d8d=
912
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4dbfcd0e9f04c2d8d933

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4dbfcd0e9f04c2d8d=
934
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba463392bd0f7b49d8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba463392bd0f7b49d8d=
902
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba463f0526f3e519d8d918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba463f0526f3e519d8d=
919
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba46430526f3e519d8d927

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba46430526f3e519d8d=
928
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba46331c71ecb840d8d903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba46331c71ecb840d8d=
904
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4e1557d5eeabfbd8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4e1557d5eeabfbd8d=
902
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4693e5a7d683c3d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4693e5a7d683c3d8d=
8fe
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba46400526f3e519d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba46400526f3e519d8d=
91c
        failing since 8 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba44a2ed894a0952d8d92e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba44a2ed894a0952d8d=
92f
        new failure (last pass: v4.4.244-15-g944231f27c48) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_i386-uefi      | i386 | lab-cip         | gcc-8    | i386_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4cce692b2a0b50d8d925

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g83f2d7d5a61c/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4cce692b2a0b50d8d=
926
        new failure (last pass: v4.4.244-15-g944231f27c48) =

 =20
