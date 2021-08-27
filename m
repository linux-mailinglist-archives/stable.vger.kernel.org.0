Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246283F92FE
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 05:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhH0DmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 23:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbhH0DmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Aug 2021 23:42:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABE1C061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:41:29 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id t1so4901075pgv.3
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 20:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RoNfhK5Lz8nqQV8vCMwEnCSsL3i19HIVHd8suu9Htt4=;
        b=ele0CuhlEmvr8D1xbP1I3D6sLJ3xTyqE5FvH4uxcUA9rQhOrF0mtg7M1YMPiuFG9S7
         z9jKeVHMPCXsWIObJp+VsyXY2azjQ/ufCZ1vzzk3JOLNQzrsklFsPyr8Mk1PsZzcvrDV
         ntoYWcUzQpC85LUzplSK+dt1bIY+ZPXQ0ljrFxmnR5HXbGtAGb+Av2+tE5+IBmWgtj/s
         rj//PWxSS8/tC+pxi8qWFKXfUwREc1RasuHfZcVOYnTQzxoXHqeZK8s9KhtQkdhPNtLh
         L1IHUCNEa3HYkeyfPIC+dDqE4QD1RxgGuua/ee+hMeAmXFIT/pE1QbClOF51og+ljFZy
         2tLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RoNfhK5Lz8nqQV8vCMwEnCSsL3i19HIVHd8suu9Htt4=;
        b=EcP0fGoE0DKAWQurVtFB35vMFM4FoVrowZn7WRZZumqKblOhlZfYxF7cEOsKjg2PDx
         0e4SvI3bzv4E6yr/24Yso8kFrSYZ18PdMOSyy4H0rnOqtXUxMw7EwEZ3CjdbcEbcfO/0
         yECVz/8N7MTpa/yl7+GI+xdIIIM55zZMiH33C6qmVMsol1kTuOun1U9K/MaS+iv7avxt
         cK57Io0kOqdCJ5Y96Bh+N99VEITilwaixtRcKn3oMzQvSEk912zP/ZfmNtxyCi54wPUC
         3jPfwvATvxxVkr5+jxD5KXSR7qSIqARLIT7gZ4Qb6vNY1expDX/vufeeD0mNOGhCQTmA
         czXA==
X-Gm-Message-State: AOAM531LwDZwPwwLsiCS5UQzU6HWJnxeyKPABoyYVeuXK2+YBGGkN/cL
        PMzwgDUd/lKpsI3WOnkbSZMtIv8LQfw9+OiY
X-Google-Smtp-Source: ABdhPJz1E7hhWaJvHug8NbtmFchOkw5tvSD6T94zMn1UfMkKwOeHTcCyfn4VTzCq03WhH705Qbd44g==
X-Received: by 2002:a63:4f0d:: with SMTP id d13mr6150989pgb.169.1630035688778;
        Thu, 26 Aug 2021 20:41:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j128sm4668324pfd.38.2021.08.26.20.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 20:41:28 -0700 (PDT)
Message-ID: <61285ee8.1c69fb81.3926a.d34d@mx.google.com>
Date:   Thu, 26 Aug 2021 20:41:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.245
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 104 runs, 4 regressions (v4.14.245)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 104 runs, 4 regressions (v4.14.245)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.245/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.245
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      35c4ba160ab6133e548468bd0bd1109990dc7736 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61282caea5041079198e2cb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61282caea5041079198e2=
cb7
        failing since 511 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612828862c37d2dc9b8e2c92

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612828862c37d2dc9b8e2=
c93
        failing since 281 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61285d4d85f836185b8e2c84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61285d4d85f836185b8e2=
c85
        failing since 281 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612828902c37d2dc9b8e2c9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.245/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612828902c37d2dc9b8e2=
c9e
        failing since 281 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =20
