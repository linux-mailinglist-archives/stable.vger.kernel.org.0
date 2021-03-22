Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494A8344AD5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 17:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhCVQPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 12:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhCVQOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 12:14:46 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDE5C061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 09:14:46 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v3so8935287pgq.2
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 09:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ww/Ix3lVZV/DcyHGZUp0dbUc2GPlVP6Eaw87F/JKw1Y=;
        b=EZ6i6lfCLQ8ozQSemTaaYE4dZBXj3YQSDKyNJI6OnGPLGfPk8D1U5Jf2GtImy2y+lr
         42rdRxYGok2PhQyNxS0I8s7Xi0l32SFtrPJ+lahjZcnhhQSBWe5s6oXAim9g1RLBQG6c
         twwbxMxmoZ+q9SVexbQbU9Q0KByghawkTUCLXqUzfJmeciuIL2x3Fl6QjNr9H4LEfAXw
         T9rsgonEBBo+c1UAIiRlxw3ySTpBqiF4gvZADtm/bzp9w+rB5LOylWrI7AutiHbZr3Z5
         gevj60DSyW5xW6bDIIvQZu/YWslqsXbsNew1eppWtsaWS4LNKupo1YxWx3IitmNg0gik
         AMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ww/Ix3lVZV/DcyHGZUp0dbUc2GPlVP6Eaw87F/JKw1Y=;
        b=t66Qxbvbp+Vd/cc/MRZpxxj6qyrTCjEjMC/wfDgwa7Pz3qzz3iNwHs3x45K34zEmmQ
         1LUQY5DPBMxTrOskp2R+esDh0HKRgI+dz+LCzKkfLZb5gmCPy2X7boWrInZ+8QGhfjSt
         qo2Zz6zzlvcUPwrNLxDAwKN0USrYBWx/gsPJgvT0NwKHdTmEo9yJoX3QkgbrsttmD4wR
         bwMJ19zYnx0gXjZwpXRJfXa4g8C5P108cECO5tNpAwmY7WzGOwmzb6eyr/kGBa4RLBht
         gFeY+4lyvsAUXMSt6i0FeRxKC+HLMqelcafKM6qxulHTgN9imk+dJmjuVhk3Cac78/Y1
         5EEg==
X-Gm-Message-State: AOAM532Jk3jTeVOZqoUIfmmtyR0P4I7ND1yhOHmxsWmOPRZRl3Xm81hI
        2B6Eek7Z8IcBHiIWcNrqbU/JhpKhkHxV+w==
X-Google-Smtp-Source: ABdhPJytkyFAnU0ivYyLNwkIqwE3OGXYR2MNzylz113quBt8ku+mkctiG+B2H7uwnQEANJI+cgJ+Vg==
X-Received: by 2002:a63:d848:: with SMTP id k8mr323487pgj.72.1616429685327;
        Mon, 22 Mar 2021 09:14:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v14sm14710601pju.19.2021.03.22.09.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 09:14:45 -0700 (PDT)
Message-ID: <6058c275.1c69fb81.61141.3283@mx.google.com>
Date:   Mon, 22 Mar 2021 09:14:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.262-25-gc60fab8f2bcfb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 5 regressions (v4.9.262-25-gc60fab8f2bcfb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 5 regressions (v4.9.262-25-gc60fab8=
f2bcfb)

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
el/v4.9.262-25-gc60fab8f2bcfb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.262-25-gc60fab8f2bcfb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c60fab8f2bcfbc6875e2cb2e43c6e013b4eae702 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60588d53d7ee02cf51addcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60588d53d7ee02cf51add=
cbd
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60588d6a526f97bd9faddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60588d6a526f97bd9fadd=
cb3
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60588d6bbc841e731faddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60588d6bbc841e731fadd=
cb2
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058b7d67497af8719addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058b7d67497af8719add=
cc6
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60588d11e2da9660d1addcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-2=
5-gc60fab8f2bcfb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60588d11e2da9660d1add=
cb7
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
