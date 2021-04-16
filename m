Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714DB36292A
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244249AbhDPUYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhDPUYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:24:30 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9160EC061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:24:05 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id z16so19940417pga.1
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 13:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RD9aJSPIxd3yZKQRQCW8DIaxOxLWxDkhaUFPYaEm1nw=;
        b=JGB5h+PLgRz+0CFYa7pIMXu00rm0mW2oyocjkf8D6jMQcPBY6/cS1osq0l7fBEkDYs
         uaoSMR5G5YxssQJGZi5F8gu247Z2rPF5gEIjzF3dg+MG2GNBxavagwXMI04dQ61SMfCF
         VbxgXyXQiWjHr8JQUlQukjOCvgbQBZSyxBzGECWeqaXtQBnw8oUwZP3/nSGngKHcnYKq
         Ly4p+k8e6MdYRNhaa7qWkAANkozq4AMaunsX6yxiJet2WM0pD+09nZDGi/CpFlBJh2bR
         bXdRod95tTi9Zj/xquPD32/iMVkKmqz3BC3jD/FYRjX7dTEe0PaCqc8//N466JwgV3qf
         x0ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RD9aJSPIxd3yZKQRQCW8DIaxOxLWxDkhaUFPYaEm1nw=;
        b=paO3xSXBssh7K5ehpMUfD+70KlUDqLvZASIJn7uoKaKl1PGcUyusl+4wpwoN4VlBhw
         sjb76Mb6jgREWllCd/xqG8aBzCu5lh2CoVt1IjBWdCosIOV2ZgTHX4OH7IJPQhpJe1BZ
         1NK5SVqDaXDdFZ1JHGB3Slf85hI4UIS3igf3XVk0ZFA5rhDbRSCCJ3OaOOw0fCiH/9oN
         T6zY9IxFZ8ptf37VXgNMVKePZCX+0QqSwWQBOmyPtBMxzAyeY6puWwkmfOvkPOuQ7EbV
         jmzKooKoW9CR7UlsXEgVVKsXFTZ/IIxs9MI1iw3xg+NoNM1t5mrHuqC9ZGl2zGMsfdle
         dxpw==
X-Gm-Message-State: AOAM531azf5JY51ngUiJkWT84b7oPQc46Vv7NzNr7UegKOlPqjQkMizx
        GmQOiPdF550QjYODAfArcDFUoboS3BfUJA==
X-Google-Smtp-Source: ABdhPJw5451gBvOMvzmR1wX7rxLoZqvtgkkdKU7kjU55V1hntT1FvY8cCkc4FmSSXpIhTSdIe305Rg==
X-Received: by 2002:a63:9d43:: with SMTP id i64mr701602pgd.357.1618604645010;
        Fri, 16 Apr 2021 13:24:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w123sm2048384pfb.109.2021.04.16.13.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:24:04 -0700 (PDT)
Message-ID: <6079f264.1c69fb81.72cc9.4bcd@mx.google.com>
Date:   Fri, 16 Apr 2021 13:24:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-68-g1c076f072a8ea
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 103 runs,
 4 regressions (v4.14.230-68-g1c076f072a8ea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 103 runs, 4 regressions (v4.14.230-68-g1c076=
f072a8ea)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-68-g1c076f072a8ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-68-g1c076f072a8ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c076f072a8ea1e7c26993127ad1cf2d39c5ef68 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079ba3657925deff2dac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079ba3657925deff2dac=
6be
        failing since 153 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079ba3ad0acb196dbdac6dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079ba3ad0acb196dbdac=
6dd
        failing since 153 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079ba2cd0acb196dbdac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079ba2cd0acb196dbdac=
6c4
        failing since 153 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079b9e12fde1fdbcadac6e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-68-g1c076f072a8ea/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079b9e12fde1fdbcadac=
6e4
        failing since 153 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
