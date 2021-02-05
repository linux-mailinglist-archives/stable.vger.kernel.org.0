Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87155310E5D
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhBEP2E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBEP1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:27:12 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48E9C06178A
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 08:57:40 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j11so3849152plt.11
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 08:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TQwcg5+f4W4eWeA+eOSIMXB8Jw0gpRo6ZRVyxxwU8ug=;
        b=SpPMdfeSukxj5MFyXal2xbb9E08FcTCppoP9IvQqICkSwSTvDAeoHCeXW5qHNUHoTX
         x2FLdZyVGdaIYLDWFC4xkrzBCMCFgyNDoJ1wAR1c9FzUHW2xInzvAj0BzyIfgJEDPSlH
         7H3TgVVd5ifq4IbK52OaUMUMxU0EEe65uPyZuRkPHekjf8YaAiC00IvV00NVqRXn95ca
         3bdZiCgO19I/dozCEwXbjMe/iknXmoKeE409+WjENdvKB6DR+BIuBEN3U1rLxulKnmkd
         8rYjzaxEsT+FiFFbZa7/glGN9QaQm3mzTlgNMJRqY/3ii6WQLbLVA+SjdKH5lgDIdXgk
         eH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TQwcg5+f4W4eWeA+eOSIMXB8Jw0gpRo6ZRVyxxwU8ug=;
        b=DW/Ks62MQWHt6JJjKN0NibS3qX8Hq6CohYbx1Cu2dtClIWOkhzEsKRUp+YwmXdz5UC
         MuqeEKV8w7QxyI9SC0TkUQrncrgh2+pLEzXOlmfIXDMO59MOdp8F4rh6qtpwUVOAUKEf
         mgmWwH6/mkF5j/MOuMX0195rFiu6c0fmeppTSoqHQEVs649I3pMEmW/sdOMRjlRnXZ+G
         RwVdhisP19rVghNOJTWtPHtC1Kehyc8HoJkyZHVzgQtMaj2U1Vl/O3f1TQYDRNQK6w0B
         wfW1hI/+xrxZ8UB8Fs6nSO6cb5ungJtJv21+Y+1hFOt5cGsInkZzGmppNUwUVCT5Dj8M
         cNaw==
X-Gm-Message-State: AOAM5305lFZb6AzHBMzyIEe3yK/n4mnuUxYFGkh8ZcYHZ2fZmCChz77L
        g0vkQbWnVlRAoeti32YtsI064DFbLHxtNA==
X-Google-Smtp-Source: ABdhPJzFH5qAtiJ4fUiWaQihBxC5khgATDAV9EbV5teo6fq+vsApZ8k6fl3wTL0/8ZuiXzw4uFNuVg==
X-Received: by 2002:a17:90b:2352:: with SMTP id ms18mr4856559pjb.138.1612544259998;
        Fri, 05 Feb 2021 08:57:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fh7sm8938400pjb.43.2021.02.05.08.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 08:57:39 -0800 (PST)
Message-ID: <601d7903.1c69fb81.3a954.329f@mx.google.com>
Date:   Fri, 05 Feb 2021 08:57:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.255-12-gcfd8bf18cea7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 86 runs,
 9 regressions (v4.4.255-12-gcfd8bf18cea7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 86 runs, 9 regressions (v4.4.255-12-gcfd8bf18=
cea7)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.255-12-gcfd8bf18cea7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.255-12-gcfd8bf18cea7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cfd8bf18cea79f05176827d499d0329613f7554d =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d47fa64a32051da3abe96

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d47fa64a32051da3ab=
e97
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4c76418e2ce71e3abe81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4c76418e2ce71e3ab=
e82
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4840940eca40053abf12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4840940eca40053ab=
f13
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d48c62987f4a0f63abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d48c62987f4a0f63ab=
e66
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d47abe3596225c03abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d47abe3596225c03ab=
e63
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4c3a6145fbc5dd3abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4c3a6145fbc5dd3ab=
e6c
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d47fdabac77757e3abe79

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d47fdabac77757e3ab=
e7a
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d486a7fc7a589f03abee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d486a7fc7a589f03ab=
ee4
        failing since 83 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4739b3944facbc3abecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.255-1=
2-gcfd8bf18cea7/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4739b3944facbc3ab=
ece
        new failure (last pass: v4.4.255-1-g747a76b66d28) =

 =20
