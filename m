Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E62D3A86EB
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 18:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhFOQ4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 12:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhFOQ4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 12:56:33 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C0EC061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 09:54:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so2217872pjn.1
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 09:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7gs1OAalS1AZTVozr912FErSkxiz+V4me4DESQqzyoY=;
        b=VQtSm3MB10IQkIAjAJsm6jBaUhz0CPKYCjhXGsrlEYrjEKEBHhL25J+975lRuSQYX5
         iXtjPDqt7vaBFDPnl2kX97Ss+PAMkIuRJCK5QquKZhVeN6aJfe7XToTfWyHE/tHEpw9/
         qHKPrM2ZId7/kDgQO6iNm6MP+jgO4Tuk8Zw9iqv/z9d6JxqXxRaD5+QvL7BU/IGdIEFd
         ezpoQRSGIiRMDDUxS6mXwoqDkneSq84L2MmkZtRxl2oOoopo7f2kYk5PLEjKGSe6Djmi
         NZvRf0fFNvDxQ//XAXfFeyAsPX3306NjJpIEsOKHJ858k3tYDdlRwzvewkcH4/j0RF5s
         asmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7gs1OAalS1AZTVozr912FErSkxiz+V4me4DESQqzyoY=;
        b=mIodx4n7cUqcj56wwflVlZj8R9LH+yX4Zy57aeA0iFATv26b8n1nikVlQge/Qo9vNr
         0a4ZFihNPNbHNd0tZPUFsUuQAwZFc+nNBg4kD6skJCVoK1KTKVe3tI9UWLTiX49L4qeO
         sJYA75dOQRoJtMSqKHyB3YLZ86ZhhbyqZmg3VGHpC6bozlazBSa4LC6ipUsHZihsvr2m
         9f8u7igD1Nfxn7rE8gs6dlLxVdkiQYXFc6nAKVSJHq85t8GoqaOpzc/qvBAEkpBQdS/z
         zcfi1vWf5jz/EojMy7ga12oalMw9a8VqyB2BVkWMc485Hgqb4KxIhi2Qb8Rik5vaJN78
         gy8g==
X-Gm-Message-State: AOAM530naxyUqHhL9ytpYRJe5YtunVHx+WnqTymP62Lvoi/95J+LacNe
        ohwMX1p6f8fe1UHD7BFPSZ7fRVN7Dk8jvw==
X-Google-Smtp-Source: ABdhPJwkpgtyJv/IR7CMi1pKGUbhXXtQGvyrM6xO5cLPD/587sHrOS4eQKNjrMR0cEC5sFyFq2g+ww==
X-Received: by 2002:a17:902:9a85:b029:10f:45c4:b40f with SMTP id w5-20020a1709029a85b029010f45c4b40fmr3664480plp.32.1623776068228;
        Tue, 15 Jun 2021 09:54:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bo14sm3007668pjb.40.2021.06.15.09.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 09:54:27 -0700 (PDT)
Message-ID: <60c8db43.1c69fb81.9b3e4.8dbb@mx.google.com>
Date:   Tue, 15 Jun 2021 09:54:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.272-41-gb9c5f6869483
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 133 runs,
 5 regressions (v4.9.272-41-gb9c5f6869483)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 133 runs, 5 regressions (v4.9.272-41-gb9c5f68=
69483)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.272-41-gb9c5f6869483/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.272-41-gb9c5f6869483
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9c5f68694839b4aec6abd8fe83a693f78c3287a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a0ee71b848f4a9413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a0ee71b848f4a9413=
26a
        failing since 213 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a10f71b848f4a9413281

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a10f71b848f4a9413=
282
        failing since 213 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a108a0c755a406413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a108a0c755a406413=
267
        failing since 213 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a648a5154a8615413271

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a648a5154a8615413=
272
        failing since 213 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8a4fcae5a3a5591413370

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
1-gb9c5f6869483/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8a4fcae5a3a5591413=
371
        failing since 213 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
