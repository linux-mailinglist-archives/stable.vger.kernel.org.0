Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D20E3670F0
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 19:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237829AbhDURJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 13:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbhDURJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 13:09:56 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09703C06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 10:09:23 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id h11so11818830pfn.0
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 10:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2sEu/4y9iex5CHA5u4ztGwd20wTMYJ17Y7bYB0sfmsk=;
        b=zkOfNYsuH61DiBb0t48vvV9H/szBkHRroEZmFsOD8OUVJXxMbiwXS06TDmfM8Mv3L/
         LXb8qGF4XcmbLZEz45FRZI7yKPppGabK6czImQrOh4LDfEUHLxZ0KumfcHebZ7QvkHEQ
         7Texv2eNA6tXA1auoI7WQuX6pjNBmZXBnrKtNYskUtdVxuiTgXDXOJ+TpgMrNuGLilxh
         GOpQc9YnrQ4/61iASI9qaFn7Ja5Qusi3SILI/MN3PSD/lsJVzK9o2ZJ6Y5lQVhv4ImFh
         QBIKLG1cz67YdAAN+26GsQI7GPQ+1DLIRoKm15rotLyLD2k3vikLDhR4A36qs25kGCfO
         bH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2sEu/4y9iex5CHA5u4ztGwd20wTMYJ17Y7bYB0sfmsk=;
        b=s+uNaFvwlERHAGhgBMBgRcvUK3W6f9RhHSt3VlCJQo8E1csJOxAWadNBjz1y/UtsS8
         DLhn9R9EF+MxMRxpj8MXOyiflyKWB/caGB/yJOh3jMALZQBSqxLbfocgD2jjsc5BEz/I
         3aWc7QH49f8VxdNEtZ8zDcRkCL93Q5RP3w2yT7Tjk4NEnrl8o9mQlIZqOyRZ+W67wNse
         8WvfwvMqPL+ONK8x5n+4ThQnMarKiHg5zV5V9LdmBmL/g36QFdN770dr47y0C7Js8s1M
         5IWtbIlGrTVADVGb+3h3qsS+u0Q4lDDsHYKwVnAzxUQ+Ce6c3NbNSclMKI+8LVjue2FA
         f17Q==
X-Gm-Message-State: AOAM530fPhLQt2b6urkxjdToV+q7uAWVmNqRLNG5AUa+MLVWYIFDbuBy
        YN6WuvAABUjjudI0Q1VD+iaViyu/84cLtp4IR3A=
X-Google-Smtp-Source: ABdhPJyoZfn0BV+xK5vfZoHl8BJrwagDd/sLASSbYuDdBrroUAsoTcho/7KP4DztTezBaHUkMqQP4A==
X-Received: by 2002:a62:1c0f:0:b029:25f:ba3c:9cc0 with SMTP id c15-20020a621c0f0000b029025fba3c9cc0mr15586597pfc.56.1619024962353;
        Wed, 21 Apr 2021 10:09:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv7sm2442693pjb.18.2021.04.21.10.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 10:09:21 -0700 (PDT)
Message-ID: <60805c41.1c69fb81.696e.7315@mx.google.com>
Date:   Wed, 21 Apr 2021 10:09:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-35-g2522ad7e29627
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 100 runs,
 4 regressions (v4.14.231-35-g2522ad7e29627)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 100 runs, 4 regressions (v4.14.231-35-g2522a=
d7e29627)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-35-g2522ad7e29627/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-35-g2522ad7e29627
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2522ad7e296272254fe2080ec62334528b7dd1e0 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608024c916014dbe759b77bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608024c916014dbe759b7=
7bd
        failing since 158 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608024b416014dbe759b77a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608024b416014dbe759b7=
7a4
        failing since 158 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608024c316014dbe759b77b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608024c316014dbe759b7=
7b4
        failing since 158 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6080245c9c26662de19b77aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-g2522ad7e29627/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6080245c9c26662de19b7=
7ab
        failing since 158 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
