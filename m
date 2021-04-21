Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F963670DB
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 19:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244575AbhDUREe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 13:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242038AbhDUREc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 13:04:32 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0264EC06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 10:03:57 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id b17so30483107pgh.7
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 10:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QfFjvUaB8YqFVmViOFF2r2b0Nt+hkfWmQE5DLnSMWB0=;
        b=n0yUWhx+OCBCuq6qOW99ANulaz2YRSeKLR1jArmc7jF5gLKrqoW8h4Rkt88jMhE4fS
         ud9BRTpjGHQeALVa+jJ1h0kigFm2HwHJXsWkxHzzn3EulxM7dcu8ahPlVgQbec5aH+/i
         CwIamv3RThxKD4zb6eIhHaB6zBOVSHXr4Wxj9Xlur1pgVm/Jq79LtsrnaMEy0UA2oByX
         ububXU2m8ApJN45gomLdmmmUkuZhQdrjTj3S2PX/LZ86EgrewwFOngf3TxdvmnPlJsGr
         uAHu1oQrejMda++4GU/NpLCYE3UvnokniAYCLgP4G7aE6k2enNrwWcU9zq4qC8ZZap1U
         t7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QfFjvUaB8YqFVmViOFF2r2b0Nt+hkfWmQE5DLnSMWB0=;
        b=XRNe05WTlxMZZRwyOr6UEpKEd+P9bpfboHd4a6T6CFrzEhjSkd1x8MuQV3vyrmVivX
         BsIujFZC4ZdtrJ32T6SzFMd1I8f6L1pVU1Ufpw5OG3XTFQBXkDdhivqv4wAROu4t9oKj
         IFQ50ahZzwG+UIGaEr6ZQSjIIklrvYJlrzY5XNaMe4iTtaQClwOqfGaRTHQX8/VJjJNm
         QiaZo9ioF/G6CicLCWHv9JM9ibEbRhhQjA2sGjKG1TQYEDA0Or7+b3u2q7d9ssNrnPew
         CgTbi4HscmZkfDQ5HscOcWqy9j9PkdWjwjLhNXHINbbQhmiEYDod8L+JBINsVNqFE9MU
         H2kw==
X-Gm-Message-State: AOAM532eJ9CgHQqIKhQKHKd3L8uFFKkQGnaemBdi2nKRrPlVG5/f3kv6
        bcmTHYMOkVCu3UWg09kS5lYuXPGMg4x/J4cH7+0=
X-Google-Smtp-Source: ABdhPJzkOkUVE+LqPh8tN5dBjiVAEMdPBVar4lPk/3ExBRQ8KF9FEK3jSmMFOc7/3rMmoP/1J4o5mg==
X-Received: by 2002:a17:90a:d707:: with SMTP id y7mr12727202pju.50.1619024636360;
        Wed, 21 Apr 2021 10:03:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm2211417pfb.174.2021.04.21.10.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 10:03:55 -0700 (PDT)
Message-ID: <60805afb.1c69fb81.bda70.64db@mx.google.com>
Date:   Wed, 21 Apr 2021 10:03:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.188-42-g07ceb11323ae
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 114 runs,
 4 regressions (v4.19.188-42-g07ceb11323ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 114 runs, 4 regressions (v4.19.188-42-g07ceb=
11323ae)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.188-42-g07ceb11323ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.188-42-g07ceb11323ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07ceb11323aeb2993444a4cffabee835447163a7 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60802631fe42dfe3f09b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60802631fe42dfe3f09b7=
796
        failing since 158 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60802639fe42dfe3f09b779b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60802639fe42dfe3f09b7=
79c
        failing since 158 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6080262b5464ba4b389b77c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6080262b5464ba4b389b7=
7c1
        failing since 158 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6080270119894e4ba99b77c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-42-g07ceb11323ae/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6080270119894e4ba99b7=
7c2
        failing since 158 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
