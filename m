Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690762C00A1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 08:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgKWH0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 02:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbgKWH0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 02:26:16 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED2CC0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 23:26:16 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 10so14099101pfp.5
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 23:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8yIx6BbJQgaPJeXWHNpKmVKi0j283z/UoHKSQc6YNNk=;
        b=arjX0AaYIEBpcq9AoKJtUoKUUKuFDsuOPplQ7Gez5ZSQm8LIXHV8+pCk21j8zIV/aO
         JK+vXWUVAWKVTacN5MoED+vpXdLJrthb2EIRxDx4yOt6XpOXD6cCV973lyWtT8C+hQb1
         2gHHlNoklyKxYugEZgH9Ve7csLz9qpXn4zkwDvR8xvc1d9hgH6uprOrd4hJ/wo7loOmi
         mNrODNABeYBMmhvqemulBEt0k8Y3h9wQEldRsL0MTQz5qI+jWGt0gUjfa3TOE737EnfG
         uN6njCWxYA57UaCMLmZNps0rjyiHGH6zjO9USp7cHcqB1WxJYYuo8gyEDAxSgLNpdjo6
         AMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8yIx6BbJQgaPJeXWHNpKmVKi0j283z/UoHKSQc6YNNk=;
        b=oseACYNklbSbtqT0WQi3HyRj5wddzaNULS5BEgE43WJZz0ewOJ+hAApD4aV/YuLulV
         kIxf2X91YxMwUkzZHBzMqE4FVyuFzHTtobes4k1SjmUN7GHWnwvOn6oWZryR300aQWnt
         r/4EbtIWQDwCE4WX1tcMLjWrz3gRBBe2z7MKWl669yRMCGmwEaIA0oaKPExtqdQSATBI
         G8AUo8UUdCZeY9JFqCkT45KdzX12p/TG9aFMSuyCyBeuKEQDwV1fKIMHq/Tvrpa3Rnhw
         /7EyeQgXPKA+ooTaNuExndzhHaBQkvldi8roAgS7XueuOnQzjXcwjjiP7E9qlM6mErhx
         VBRQ==
X-Gm-Message-State: AOAM532aRvl1/iTScAQb9YBxRiJmH0N6b+AGQ7uj7aTjkTp6i00uDD8+
        38OKiQV0bllIp8XSKM72UawwTtXTlWVuRg==
X-Google-Smtp-Source: ABdhPJxKi7UeW10CPwNKgokHHaOKCFH9egX8mLDZ0Mx0Vjsb21y8Z5FE4aQfvUm79m08ptpmMXDWrw==
X-Received: by 2002:a63:d157:: with SMTP id c23mr26158500pgj.196.1606116375358;
        Sun, 22 Nov 2020 23:26:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14sm6383163pfo.142.2020.11.22.23.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 23:26:14 -0800 (PST)
Message-ID: <5fbb6416.1c69fb81.7350d.f98f@mx.google.com>
Date:   Sun, 22 Nov 2020 23:26:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.245-25-gc9a47ea390ba
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 94 runs,
 13 regressions (v4.4.245-25-gc9a47ea390ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 94 runs, 13 regressions (v4.4.245-25-gc9a47ea=
390ba)

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

qemu_i386           | i386   | lab-cip         | gcc-8    | i386_defconfig =
    | 1          =

qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =

qemu_x86_64         | x86_64 | lab-cip         | gcc-8    | x86_64_defconfi=
g   | 1          =

qemu_x86_64-uefi    | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.245-25-gc9a47ea390ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.245-25-gc9a47ea390ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9a47ea390badea6fddee65cf4fe428dedf96178 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb331950d98918edd8d916

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb331950d98918edd8d=
917
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb32f0ab16a17fe4d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb32f0ab16a17fe4d8d=
91c
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb337c266d0d07d1d8d932

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb337c266d0d07d1d8d=
933
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb32fcab16a17fe4d8d92f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb32fcab16a17fe4d8d=
930
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb331150d98918edd8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb331150d98918edd8d=
914
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb330a134fee2c85d8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb330a134fee2c85d8d=
902
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb332150d98918edd8d922

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb332150d98918edd8d=
923
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb32fb7b740fdfa8d8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb32fb7b740fdfa8d8d=
914
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb30ade7a52742e3d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb30ade7a52742e3d8d=
8fe
        failing since 0 day (last pass: v4.4.244-15-g83f2d7d5a61c, first fa=
il: v4.4.245-12-g8a61cf9912489) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_i386           | i386   | lab-cip         | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb31390f874155a5d8d914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb31390f874155a5d8d=
915
        failing since 0 day (last pass: v4.4.244-15-g83f2d7d5a61c, first fa=
il: v4.4.245-12-g8a61cf9912489) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb3073dcfa639cf9d8d92d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb3073dcfa639cf9d8d=
92e
        failing since 0 day (last pass: v4.4.244-15-g944231f27c48, first fa=
il: v4.4.244-15-g83f2d7d5a61c) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64         | x86_64 | lab-cip         | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb31651a29516a5fd8d902

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb31651a29516a5fd8d=
903
        new failure (last pass: v4.4.245-15-g0aeeacb1b87e) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64-uefi    | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb30f25dfd5bfc90d8d91e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-2=
5-gc9a47ea390ba/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb30f25dfd5bfc90d8d=
91f
        failing since 0 day (last pass: v4.4.244-15-g83f2d7d5a61c, first fa=
il: v4.4.245-12-g8a61cf9912489) =

 =20
