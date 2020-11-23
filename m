Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C892E2C08B1
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388070AbgKWM6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388073AbgKWM5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 07:57:48 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B5CC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 04:57:46 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 62so14172720pgg.12
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 04:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JhJ3Ys/u6FrsiJOs0YWy9SKcfFFqQbEoY00WyeDbWB4=;
        b=sc2yOIIQxdipJSAmrAYh+tC3hJW6vD5R3ea76MTmlBab4+2AmUnyG+AtrhTQ8juXZs
         4wprdX2po+FH4hrTeAF4lcKmlqsGPE14F6fjLOKHwD0Ez5xPM29DqHa86+bZEVMV42Uj
         zMZbshBL6PuorIdAXn4AedznBdf6HUaPBLK/SE/iXCSP5+/dzxUqMGXzXez4nMUDzgDA
         Ci244FgtdR6xwpYsjquUdXyLg766AtrvThEiJknTlRiug+dqfDaVfviIDoQNFQ8imGrR
         TWjdxffbGv1z4tSuSCrkdpaiWgWf5F5WPDO1iUCq2qJ6eZqYeK6tbTkNbsOWya0eRhej
         9+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JhJ3Ys/u6FrsiJOs0YWy9SKcfFFqQbEoY00WyeDbWB4=;
        b=oPXbNZH8XZQ1QAHKV8C6nIsQu9NRtUnIXtisZhIk1BxRG3Z5g7witTQOg2O1sL4YgT
         xMHGYE2wLdQS0iimqlT+AG3OmvooTaEXWg/nywuVjkU8IHwf0ie3zMjfhvVyFE1YqVJH
         BLnusMEpVkU8DTkq2O1THP2mperDZ8oz2ZrUOtv5UM32nge+mLKGKsXaUNW/M+GD4BBw
         Jzj+hql++IiQODyg9I1C/pvc14hjs9SiVN1V/BcMI4h8mAPmR5x+wwUPQYWFq66zAts+
         QklD2bkOSjrgWYXf0QEPiALy4ynOLKmFZErbSX2CLMTBH6oQa9+YgOMS6edHUAJCdO+I
         92vw==
X-Gm-Message-State: AOAM531VSQVnTG/DG8DJ67GGV9BpcO9w/0a/xap5x9ESL8g6C1zCRSGE
        g1LSQTK8om/CCiKh2gLUyK5Nyr33nzG89Q==
X-Google-Smtp-Source: ABdhPJxCGFYSKLnx2ZAg6sVaYjhNHpC+i4/2vdhcR/q1Dmx3pibA8lYokGFEkzE5nNueK+29G4bGIQ==
X-Received: by 2002:a17:90a:ead2:: with SMTP id ev18mr24526781pjb.91.1606136266067;
        Mon, 23 Nov 2020 04:57:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm3076111pfo.198.2020.11.23.04.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 04:57:45 -0800 (PST)
Message-ID: <5fbbb1c9.1c69fb81.25855.7503@mx.google.com>
Date:   Mon, 23 Nov 2020 04:57:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.245-30-g28b017ddc3480
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 119 runs,
 12 regressions (v4.4.245-30-g28b017ddc3480)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 119 runs, 12 regressions (v4.4.245-30-g28b017=
ddc3480)

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

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =

qemu_x86_64-uefi    | x86_64 | lab-cip         | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.245-30-g28b017ddc3480/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.245-30-g28b017ddc3480
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      28b017ddc348054a364d08d190228ed2fcf45ace =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7e631e5e6feb42d8d91f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7e631e5e6feb42d8d=
920
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7e840867100964d8d90f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7e840867100964d8d=
910
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7ee044deb4f647d8da05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7ee044deb4f647d8d=
a06
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7f412550995465d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7f412550995465d8d=
905
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7e8b3e253baa10d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7e8b3e253baa10d8d=
8fe
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7e61e69502b10dd8d8ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7e61e69502b10dd8d=
900
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7e881b688e4dccd8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7e881b688e4dccd8d=
925
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7e741b688e4dccd8d900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7e741b688e4dccd8d=
901
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7f472550995465d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7f472550995465d8d=
90c
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7e8a1b688e4dccd8d928

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7e8a1b688e4dccd8d=
929
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7ee668b6268899d8d90e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7ee668b6268899d8d=
90f
        new failure (last pass: v4.4.245-25-gc9a47ea390ba) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64-uefi    | x86_64 | lab-cip         | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb7f0ed2974d2d15d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
0-g28b017ddc3480/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb7f0ed2974d2d15d8d=
905
        new failure (last pass: v4.4.245-25-gc9a47ea390ba) =

 =20
