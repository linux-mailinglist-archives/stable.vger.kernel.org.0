Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760FF337E77
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 20:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCKTur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 14:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhCKTuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 14:50:15 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED722C061574
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:50:14 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x7so261362pfi.7
        for <stable@vger.kernel.org>; Thu, 11 Mar 2021 11:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F5FdxvuYZimbunK5m7r/YrVmhw7r6d5VhxEIo5LaiHc=;
        b=FwR28hHCUqLFd2Jp58xFdbxCeIpVe12QSZ8db9KAkUs9eiKOBjXTJyKX+v2e7yJgPa
         ChW8p8IWe0ctkSZuchDgpgSsLUmY5SjmKHz1qCvCdrB8jaVvVSZwzpkygFDl04HnSq6W
         CvUWFWKedaO/WbPN2qJEjAMWfosNdNcgAZpw2KCiHsvuMhQqPxjNjTK1JBPGrTZdGC6b
         ZACNCb14w/ntpWXcIXJ2uRrnswWaP4SdKH/B3TCRFxu5h8MMPSpYA9X5Fl2LHvp/ep9H
         U5S9YztmS/W0bb1lWhYB24Tv1w+u4vS9rGc3tGTgB2nMZPr1/bA/y0Y+Ofb+zB+GFaYo
         0hWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F5FdxvuYZimbunK5m7r/YrVmhw7r6d5VhxEIo5LaiHc=;
        b=bDvYmdwhYm493OhWNqull2NdZNQeLTmAp47rJhvP5WG0ZGgsS7K879X2hHBtQNHEvZ
         0hSRJTYwD+ssefO34Eg6KK0KvfTX8lTSR3ShNlAnx5vplJ7ROpH9YLhuFM/RBGviPP5b
         mLkLYjmkFGHwuFMhM4f8bfJQgPUcWBiJ1slqdnfxP6Jfle+GTl4vSBGFduFHTOnZ1JPi
         6RNmhwXqB4RFq7lg8yHx5c2K0ne10ocqTBQ6z3ezkHQuo72hQl5FRXJpK9v0WoLMLezw
         QJxhK/tHqp7WxcKvdvyr0ObKiRsQIBbhWZXJkPCZdMJC/t4lhS2v64VU8swWk9fhyij/
         mSfw==
X-Gm-Message-State: AOAM531oricJAtlimOMpUGBreb2xX4OuT/gT2xdZfeLnBdqbVQvtiyqh
        VYt25J7W1R2lygCWdVRZjRDsQcoL/1Hain9d
X-Google-Smtp-Source: ABdhPJyull4RUSgXNdQa94oRnZV+XU4GhzZU2SGp44pqs9O/pSFl129JKSXf/4ADTgTEH2Wl2CSFdg==
X-Received: by 2002:aa7:8b48:0:b029:1ec:a315:bdbd with SMTP id i8-20020aa78b480000b02901eca315bdbdmr9163279pfd.51.1615492214250;
        Thu, 11 Mar 2021 11:50:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1sm3011870pjm.12.2021.03.11.11.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:50:13 -0800 (PST)
Message-ID: <604a7475.1c69fb81.72396.81a6@mx.google.com>
Date:   Thu, 11 Mar 2021 11:50:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.224-20-g7af575ced3e9a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 73 runs,
 4 regressions (v4.14.224-20-g7af575ced3e9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 73 runs, 4 regressions (v4.14.224-20-g7af575=
ced3e9a)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

qemu_i386-uefi       | i386 | lab-broonie   | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.224-20-g7af575ced3e9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.224-20-g7af575ced3e9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7af575ced3e9aff622677e2c3e2d65a740d8c4e8 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a3e9baed95a29eeaddcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a3e9baed95a29eeadd=
cd3
        failing since 117 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a3e81ed6e6cff85addcdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a3e81ed6e6cff85add=
cdc
        failing since 117 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604a3e40e5c90a46c6addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a3e40e5c90a46c6add=
cbc
        failing since 117 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386-uefi       | i386 | lab-broonie   | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/604a3eb9aed95a29eeaddcec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.224=
-20-g7af575ced3e9a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604a3eb9aed95a29eeadd=
ced
        new failure (last pass: v4.14.224-20-gb94c80c18fb0) =

 =20
