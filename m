Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A9432DAA6
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 20:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhCDT4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 14:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhCDTzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 14:55:36 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEC6C061756
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 11:54:56 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id n10so19589252pgl.10
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 11:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7PknhqvGI1qlO0WlA01579x/3VYEAJMmt67C6FTbwxI=;
        b=NdOwxy2jKu5vnzPQCBTWJ8ePsANbZeyzZNx2SBI1Dnscy0iWikYnggQC7BQzOVy8a2
         NQbMDlNYuOumjCigcHrbDkJ2VXYS/4KJImXAo7kDTf9ZFoGrRNUx3HT8QgqYYuzifChw
         2P8/++c4BXx+gQYYeuKhhkaaydne47nqNs3jT7bThrdnN5TTkpJrE4cCbaFNs0Q4lout
         e9S/8AYi8DyUOPuR6YwfhiCN3kEJKz90ToN/K3LSeM22EfFamOrOdgL5XRUInh7rEuoA
         UHBe9czDiWb8nS1o2VED8Oh4OfxuvospaAPhu9BHo2QHS09iEzLs7taFECSJzhqXUFAe
         9DdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7PknhqvGI1qlO0WlA01579x/3VYEAJMmt67C6FTbwxI=;
        b=TsiwFelXO6i9zOJIG5PFecAflS2bmVpkwIJ66/5On+S4JzkW3opCCg4tbxTdG0HKoK
         j086xO/Ciz60uczlxkHh/nheVgtKsPaSyWktCGUvPthK/MqLE8xmfImM1Gvg9T6f0BcG
         yKVHEfsf0zms+VHz+MdFUgMP4mWS16Sb7X6VY851SR5PwcmELM/UVS1kMV/XPNgUV7Sf
         +LwcTEEdo2FJe2pwg16p4bc8ElPrH7DXhWDqqjpBtJpbqOtJbfL1dVTQF9Ov53lQOuP4
         Kuj9qdsLpz0xgWsgpYV0Rs177bm6XX2xgi2jHIRF5GzMy9fpNThQjX4FIiEdBzMGgiIb
         p57A==
X-Gm-Message-State: AOAM531uvFqBAfthKVYWg1d+L8n3koz4aWFbHjESY6dM3ZezVz+618Xn
        bMXf8CQo0or+GXexz8LPilzpQ2cCwQNwhHw1
X-Google-Smtp-Source: ABdhPJwW4I5fFMzIgBzJCRNc9CvmaEr+ytLznLTaAL7kYKvK11QOKbmO3fdBdqwZBmMT/ODKK/TrdA==
X-Received: by 2002:a63:e203:: with SMTP id q3mr5127155pgh.325.1614887695392;
        Thu, 04 Mar 2021 11:54:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id na8sm101094pjb.2.2021.03.04.11.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 11:54:55 -0800 (PST)
Message-ID: <60413b0f.1c69fb81.a0ae8.0706@mx.google.com>
Date:   Thu, 04 Mar 2021 11:54:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259-22-gef981795155f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 4 regressions (v4.9.259-22-gef981795155f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 93 runs, 4 regressions (v4.9.259-22-gef981795=
155f)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.259-22-gef981795155f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.259-22-gef981795155f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef981795155f75e283bf58e35b3b82a4ffac1cae =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60412e5c35fe0e12c9addcf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60412e5c35fe0e12c9add=
cf2
        failing since 110 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60410942728e3cff3eaddcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60410942728e3cff3eadd=
cbe
        failing since 110 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604108008e3f88caeaaddcfc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604108008e3f88caeaadd=
cfd
        failing since 110 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041298a3770c85f5aaddccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-2=
2-gef981795155f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041298a3770c85f5aadd=
cd0
        failing since 110 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
