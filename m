Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137BD373492
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 07:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhEEFOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 01:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEEFOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 01:14:49 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B95C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 22:13:53 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c21so999534pgg.3
        for <stable@vger.kernel.org>; Tue, 04 May 2021 22:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PFG/2Zh4+K95AcDWNU0w8NVWLojAjKB2byw/xhZ7Z2c=;
        b=kl6FcQw0lOsExWYPiFpzc7/q9p/xSss2hS6Y4nqMMq22oD+7ETT1INeERpzQUGerbn
         Z4q/VwgssgsdqggwvPGtXUsMR416K4K27ybZu3Gu6cSDqq8tpFSD0WQgKCh7JOTivwPO
         Cx41Y1+xcIM6TdG4RvlfyT8TTriCQ6ztiT0x+fpEEJEB6lzJV7l8pRuHkJHD09fT3IxC
         KL2JWrJ7uPIE5/FQK7Y1y/mtCnu/ybmfYudkHcNfxLKYpi2OdZVzx0KrVD563/9WD26I
         SQsxbZv/obhMdwZwNdfLgcQH+lK4JqozOyDorhv2PckdN5//gKBoZFZ1/2z4PK66lJSe
         QsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PFG/2Zh4+K95AcDWNU0w8NVWLojAjKB2byw/xhZ7Z2c=;
        b=S5UM3Yr3rjNjG4ihUjuqHprTKAh/AovrGcaRpalv/BSqyd8l5uHaoKX3USG1/TUZaX
         rDaC86MPE7vrLFn2GPM5XUQT3/Ae233bB5RS1xfhEaLDb7UT7JuP67+svWd63StUQcch
         ZIRcfY0fsJMB7dLxMPsbo9BI/xpFkEJpSirNpwWFZ7W42ahidjxs6oQXKViMfxYp0dVw
         MGLOvT7uEGvh0ZqFzoEbInB4CrJGURL2DKYrmyPUo2tQ8vLtajWwErwDty2wJAh6xC5j
         B6iqbzRLwFkAtsXN0ddxVeGjFIk+Xq/nFyBKabviiXpvPgR7z3NYrFbB5mKEwmhpTNgr
         gNcQ==
X-Gm-Message-State: AOAM532KJaemvE9mTffettxRfRZxhrC6c/IGydGJapSyL7W7hDnCN/i7
        ChuLiKvnTqfEb9FpqpJDcI8A4qFhHA85XB2q
X-Google-Smtp-Source: ABdhPJwMz3bhLEGKSeRcSgByJCB1GWjiJmio1zhxKiEaacaYya4+cNZMBK0VPd96NFmZ5QNHz1ZsiQ==
X-Received: by 2002:a63:5159:: with SMTP id r25mr25856972pgl.359.1620191633092;
        Tue, 04 May 2021 22:13:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lx15sm5639261pjb.56.2021.05.04.22.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 22:13:52 -0700 (PDT)
Message-ID: <60922990.1c69fb81.5564f.c6ff@mx.google.com>
Date:   Tue, 04 May 2021 22:13:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.232-13-g40b0c65b3af6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 66 runs,
 5 regressions (v4.14.232-13-g40b0c65b3af6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 66 runs, 5 regressions (v4.14.232-13-g40b0=
c65b3af6)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.232-13-g40b0c65b3af6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.232-13-g40b0c65b3af6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      40b0c65b3af6de8c3d973cceb43c7ce00f6222da =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6091f65e25628a2a07843f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091f65e25628a2a07843=
f1b
        failing since 399 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6091f7bdedc3e3b09d843f2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091f7bdedc3e3b09d843=
f2c
        failing since 40 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091f47723432c50c1843f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091f47723432c50c1843=
f1a
        failing since 171 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091f47b23432c50c1843f20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091f47b23432c50c1843=
f21
        failing since 171 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091f477915647e3ca843f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-13-g40b0c65b3af6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091f477915647e3ca843=
f1d
        failing since 171 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
