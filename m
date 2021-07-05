Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E7D3BBD98
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 15:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhGENnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 09:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhGENnE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 09:43:04 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B4AC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 06:40:26 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x16so16665330pfa.13
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 06:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uaDiIX43bpcssecwrvMkG14EwDS9AkJZvA8tjhoXv3s=;
        b=LTHQGG8K8mFHxPogPHg7We/fEiPmaycvKOd3q3TsOYJsY/r4v4WnptV5oyCfXjjcEf
         6f7mmYcS6tJgizU19Vdk9VPk91iRq7bD8Qt0ZA2LJeeH6T/h8pzoxa3AcgUjV9+WbzTb
         ky9SH5F9a+IpARDZlydtpPXBPHVHJCTsya86hw/pIok2QDdsei4my4xkrBw6M9bYItdJ
         it9l9YUzvaU5jv0QIW/AQ1CjpNnWN7MOduLKXAcBBRX3dJ0JqUaT/TRno3AK4EG2/2Tv
         v4Ca8iido5z8cUaPd0ymJF1ZE1eHdMW01Yj4+Vkqlf7vsU2rD8f8431gDcExsjfUMXen
         vYxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uaDiIX43bpcssecwrvMkG14EwDS9AkJZvA8tjhoXv3s=;
        b=hJk0UylLkZZTYU5xEwH9ve8xkZdHo6C9YQJw/S7Bnd3p5rpSdftv5dGydS4Zg2l4VU
         rSkUu5jtWMFMQ8aOsH6cVOvqxEsINPn7BmwNhsaL59JBic07vFD9oaCtkawMoWCNkgov
         yYxdVyP+lHz387o0uuGoMiyqQLuYiMwRqMX48Qrlm2vmje1heG+pinFIDJ6qb3q0sjc6
         zhLvVi4jei5NWP++JAjGvxot/ukibwD4XAwePyCDZUa4SOZ/CpQALO0Tadxxuypiax1U
         68dm6VpVTtTfQVPtrCMsaAJQt6w3M7NcnmnZtID2n0UUAvoy4niB5hEV5mvz2Gynjhdt
         zY9g==
X-Gm-Message-State: AOAM533GcyXSETHk42zpi0wuN9yDb6ETxPTQfNThhg3z82VOBhjfbUOq
        SHbhOb6ow5Jmp8n+dLsIY2zH8B+a7orKxxeE
X-Google-Smtp-Source: ABdhPJzetbyvgZLIfKtH8Xo5wvTlyoDYRYUtE4a1C5jKd6s/QYXkXvkiWAGzU9ex2DMLoy8smRAYEg==
X-Received: by 2002:aa7:820d:0:b029:2f1:d22d:f21d with SMTP id k13-20020aa7820d0000b02902f1d22df21dmr15282542pfi.7.1625492425937;
        Mon, 05 Jul 2021 06:40:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r14sm14910468pgm.28.2021.07.05.06.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 06:40:25 -0700 (PDT)
Message-ID: <60e30bc9.1c69fb81.9ed1b.b84c@mx.google.com>
Date:   Mon, 05 Jul 2021 06:40:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.274-6-g7c1fb590a1a1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 4 regressions (v4.9.274-6-g7c1fb590a1a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 4 regressions (v4.9.274-6-g7c1fb590=
a1a1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.274-6-g7c1fb590a1a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.274-6-g7c1fb590a1a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7c1fb590a1a1c4a57ddbc93f0c5caa4f119fa69d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2d93026a872df45117976

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2d93026a872df45117=
977
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2db424ef1fab59611796d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2db424ef1fab596117=
96e
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2d92826a872df4511796f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2d92826a872df45117=
970
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2d8fa12a619945711799b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-6=
-g7c1fb590a1a1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2d8fa12a6199457117=
99c
        failing since 233 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
