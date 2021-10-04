Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C75D4204D2
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 03:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhJDB6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 21:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhJDB6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Oct 2021 21:58:36 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C474C0613EC
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 18:56:48 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c4so10048976pls.6
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 18:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vikdYgyB9rHi0CAwwtegXiGAVmUz0cUYLLFXi6ezy2g=;
        b=2cuAThd4XzPK5VutvnMuWLN1jebDGUfkcdUbD5ls5KykLzuGEyLFyWFveESekLIKQl
         iZJlWvMiauPW1phLcOcdisQEYJGIPts2oQsZfEqY2nd7ZDoqDTe3NOJ/w4Ibxu0a+wBl
         RbTjlOJRXi4R0UEYxdn/lNq0QvOwHb0N/+4IRoC8uJjWzQX4x1P6pGoBGxNDC5Z02Ugh
         zMMbUp0UrootMCtNWMjk3BHJ7rQOjXq5iddx5ca9Nke1HMgHKoi8MYkjckHGaz50++Z0
         GECR+eto0qu5rIZ39xL2OYlMaZ28Zk5sqZuBskTMa6jHCB9BD755twuZprnm2+DP+taF
         wPkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vikdYgyB9rHi0CAwwtegXiGAVmUz0cUYLLFXi6ezy2g=;
        b=lq43XMv1y1Zp2194gsqyhxM8tAbJHqoBnxw67GVivYZ21au9Fr2ZyNYVUC9xZlSCAn
         7lARQUmz2NFFy3n6eZ7KhGcrBmlsDXseKZXK+sVdMtqaVaZjELO4mMrJzUtUDMNPj/lb
         NyTAQgjlAahnHYEAcS7TJsMxOxO0406nQzcVQmt7yZyssMY0O9y6W38oZCl/0457ALgF
         nhBfsbm4uZkL6CT5P9oCY0s4IlXO7pD3MxrhE0g2B5W9TiFsDfZgOb2bU6hP3Mr+PLep
         P1yQRPy11oR+qQ1KzxqrcKx306/oqZBhqBw8a9wAmDl/jWsfAitgTdXBQCOuO4qkAl5j
         4ZNQ==
X-Gm-Message-State: AOAM531vo8/U1N+IJ+ZcDL53f9/0JY+VvXaZbsSRIILE+t6WZRi9UZL8
        bmwNMyagTf3UQ4aUrazvRnyi9B8kgAumn9sL
X-Google-Smtp-Source: ABdhPJw8+gbKYJFPW8e+puKROt9SP0aeLBXdpznp3Xqxpbmwb0JKdTBgTIyTl95s5jdjh4Z6iMZ9Lw==
X-Received: by 2002:a17:90a:9912:: with SMTP id b18mr34859322pjp.46.1633312607716;
        Sun, 03 Oct 2021 18:56:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z24sm12796118pgu.54.2021.10.03.18.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 18:56:47 -0700 (PDT)
Message-ID: <615a5f5f.1c69fb81.de67.79ed@mx.google.com>
Date:   Sun, 03 Oct 2021 18:56:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-36-g66817f7dd335
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 104 runs,
 5 regressions (v4.9.284-36-g66817f7dd335)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 104 runs, 5 regressions (v4.9.284-36-g66817=
f7dd335)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.284-36-g66817f7dd335/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.284-36-g66817f7dd335
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66817f7dd335d30af0779d5c7a376b09d9e9f00d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615a23ee7be0cce63399a2f1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615a23ee7be0cce=
63399a2f7
        new failure (last pass: v4.9.284-32-g78f9adc6c0af)
        2 lines

    2021-10-03T21:42:53.735547  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2021-10-03T21:42:53.744327  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615a2043ee4696073d99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a2043ee4696073d99a=
2de
        failing since 323 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615a2041f1b473b8de99a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a2041f1b473b8de99a=
2ec
        failing since 323 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615a203cf1b473b8de99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a203cf1b473b8de99a=
2e8
        failing since 323 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615a1ff8e197f9b1d099a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.284=
-36-g66817f7dd335/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a1ff8e197f9b1d099a=
2ee
        failing since 323 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
