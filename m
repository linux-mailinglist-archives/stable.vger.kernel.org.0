Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151023732AC
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 01:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhEDXR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 19:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhEDXR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 19:17:28 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90650C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 16:16:33 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s20so94974plr.13
        for <stable@vger.kernel.org>; Tue, 04 May 2021 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xY4y+2aY1spl/jx6aK+mmoKOsBS9JfTh+6uhOkZPTeE=;
        b=RWI7ejQu6oF2FiMEUSI4wFcmEO4h34hOpVyXu+aCp7MC4ce4yB8Y4FDZEfuGd3CeaY
         uSbZPAzwFqlwPbtwv3WJORMOzA6bPQJbhJsUqt2v5BnNTyJcDf3LYKtOyPSr+kB+7Kss
         PrSt0GKoJmXHpASOiGYI1YX4EucAbb/MBDtqFeSyCovI5QKYM8oUOEaNe3lkOi7eaeXm
         oiW1+RAeEdPLVrJZfhceko0oBaiKJ2Mh3UbRz/BFALuane+kdYtls9Y3uODUMj2BJbLK
         8UGfGyIQcbC/KD3hQ1pbIuyrtHPqB1MU2ZfFqMZMZBnRZ75w0B9TAK+MplUUCxTLHgzH
         Qc4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xY4y+2aY1spl/jx6aK+mmoKOsBS9JfTh+6uhOkZPTeE=;
        b=S9WFxKZl5EwSc1uWiIgGkzj6Uugfis7diB7MzNs23okzgzFLT9KCikm387v73YOBnf
         AfKjAz3LcTPc3HGSth638PgTqtz1JcC5Wrbt2Vo4gvj5LMhvq8KitfV+T09I6YKMieQy
         RRR8PdHOHnVYA2TnGPhb3OPGnNhvsqFm2NJzgrOLYtA1DUB0UHghSpxqqxb22ZOQ4f9O
         pmgEfWEkcFrWp/TQL3HRCOmxF/NIZyjdhMaNzcH6LFRjYPPCEo6zuj5QMDWgCqCYySSJ
         M2WtTsYHbI2wW1vpyhXT+jmT4mJZo802rtwtQ8ETYV2x9cDWthK2kfC7RTKght7B6LF8
         rwlQ==
X-Gm-Message-State: AOAM530JxrP1hVkYpGNZBIgf6Nt7Gjj004q76jhy5HD4HNZCPE6sS3TW
        XTfDpA5Mdn4uuCRT0UxpnCU0AtppKMkbft1i
X-Google-Smtp-Source: ABdhPJzf0rhh6UCK1OMCNEDJfhwfd1isTi8+UlQlGbdoBZc4o2vDtWRmmwJXNShGHj420Jv7suhi7Q==
X-Received: by 2002:a17:902:dac2:b029:ec:7fcb:1088 with SMTP id q2-20020a170902dac2b02900ec7fcb1088mr28712522plx.65.1620170192770;
        Tue, 04 May 2021 16:16:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n203sm13358310pfd.31.2021.05.04.16.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 16:16:32 -0700 (PDT)
Message-ID: <6091d5d0.1c69fb81.14f8d.25d6@mx.google.com>
Date:   Tue, 04 May 2021 16:16:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.232-12-g29a7f2233e906
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 68 runs,
 5 regressions (v4.14.232-12-g29a7f2233e906)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 68 runs, 5 regressions (v4.14.232-12-g29a7f2=
233e906)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

qemu_i386-uefi       | i386  | lab-broonie  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-12-g29a7f2233e906/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-12-g29a7f2233e906
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29a7f2233e9068153eb880300c95e8781c2cf2e9 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60919f393d61735bc6843f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60919f393d61735bc6843=
f1b
        failing since 64 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60919981cd9ed561cc843f3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60919981cd9ed561cc843=
f40
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609199741c21b44eba843f2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609199741c21b44eba843=
f2c
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60919973443e791e18843f1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60919973443e791e18843=
f20
        failing since 171 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_i386-uefi       | i386  | lab-broonie  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60919bd4b2f7b957bd843f27

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-12-g29a7f2233e906/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60919bd4b2f7b957bd843=
f28
        new failure (last pass: v4.14.232-11-gbea707e12d1c) =

 =20
