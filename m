Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D7339A388
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhFCOo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 10:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhFCOo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 10:44:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB0AC06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 07:42:29 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso4033440pji.0
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 07:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mEaHMfNYT70T4CM8Pe4jh/MYovI3KLT7rFjjUw1sFtk=;
        b=ZM7ePkCpCs+/sfb1YF0xU77VnWuvN+XRopp85lkm3S2BVrUFoiPCXZBGWsBZSPI+Oq
         DcseHpdUIF6O/WA3cxhpGN7XsQBOKFpxN0FWXgzlbWUyb5m6Klm4bAqiPAOeCC60mQ/F
         kqWGF2XEBkR9bslVq9At6I5AZRw8jnUx8Y1v0qZ0z0eDEp58jY6SyMaLjN370AW9tRQ3
         hf6RbqlKL0mx+2CmmflT3bZF/Bnp+FJk6okcaFGu4mQKJ0BkJk36w0gPLbDPXGVVMaTp
         VmQlChXPLEV/Ky/XCJORCo67445CGUby/vgozt59FU+Ql3BCUH+juuYJhBR0BVDp3pQS
         PHMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mEaHMfNYT70T4CM8Pe4jh/MYovI3KLT7rFjjUw1sFtk=;
        b=E79/MWISWemzZrEisO5f3fnECAHJMbV6TXVtUxuBEl/wLYRCqii1300msADRzHdSSG
         3p9kk4n+qonvT2DNEGUh/r3rRWCKt/McTAXF6gFy/KKUUos71AscaAdwK69IPbFcp2TS
         EuVj4Lbl4k4MiydzkVw8IK4bvJXWLkErH9Fg0jFOShxwZw43qsTJX49mCyAkFn3bNGpn
         fpRWMiIOSUceJxG8IuqGAqxahzOgUvnQbvHdVdSbYohWDh+iMgcR2q0tNh6JPLk9+rQ8
         nPBvV5UWw4hElb8Y08iMD609V7zmxUbuFD0v+hq94j4JGYPZVRKLiIxd7d2JYCxw4N+l
         JFKw==
X-Gm-Message-State: AOAM530nddFPOXYaZXyIA+22yXSyhWGDGDXZiSUIYO9WK8Ayvbj2Nigo
        7iufqkczeIXSyAQj0+Ok6mP8rZ2t/5D/gg==
X-Google-Smtp-Source: ABdhPJwTviH51hzS1g/cZFb0DteGU0xZeDZniPZ7e4iKE11nXUiV2OYiMKh4rl/kYvg4Etmd/8kRMQ==
X-Received: by 2002:a17:902:b498:b029:10c:eb2d:8d38 with SMTP id y24-20020a170902b498b029010ceb2d8d38mr259732plr.69.1622731348375;
        Thu, 03 Jun 2021 07:42:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c62sm2572687pfa.12.2021.06.03.07.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 07:42:28 -0700 (PDT)
Message-ID: <60b8ea54.1c69fb81.bf715.7e39@mx.google.com>
Date:   Thu, 03 Jun 2021 07:42:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.235
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 136 runs, 9 regressions (v4.14.235)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 136 runs, 9 regressions (v4.14.235)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

odroid-xu3           | arm    | lab-collabora | gcc-8    | exynos_defconfig=
    | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386            | i386   | lab-collabora | gcc-8    | i386_defconfig  =
    | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.235/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.235
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a6b2dae3ee3a3f9f4db3fab5b4b9e493fecf4acd =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
meson-gxbb-p200      | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b49f8ecfd5fa62b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b49f8ecfd5fa62b3a=
fc8
        failing since 426 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
meson-gxm-q200       | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b57cff1f8e0d8db3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b57cff1f8e0d8db3a=
f9d
        failing since 130 days (last pass: v4.14.216, first fail: v4.14.217=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
odroid-xu3           | arm    | lab-collabora | gcc-8    | exynos_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8c310bebc3b7a59b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8c310bebc3b7a59b3a=
fa6
        new failure (last pass: v4.14.233) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b5ecb863870033b3afae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b5ecb863870033b3a=
faf
        failing since 196 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8ba5df0787a45c9b3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8ba5df0787a45c9b3a=
f9f
        failing since 196 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b5df1e64013c81b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b5df1e64013c81b3a=
fa9
        failing since 196 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b58cff1f8e0d8db3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b58cff1f8e0d8db3a=
fa8
        failing since 196 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_i386            | i386   | lab-collabora | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b1f29b2fca5db7b3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b1f29b2fca5db7b3a=
fc1
        new failure (last pass: v4.14.234) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60b8b818bf904b00e2b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.235/=
x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8b818bf904b00e2b3a=
fb2
        new failure (last pass: v4.14.234) =

 =20
