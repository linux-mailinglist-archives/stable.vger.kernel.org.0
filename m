Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3878A2C0CB2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 15:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgKWODJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 09:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbgKWODF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 09:03:05 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E850EC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:03:03 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v21so14363353pgi.2
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B3fw4GznCvY6vwL0UWDDU8YNNkjYkmTWnlxAeLDO3fM=;
        b=RQs2NvKg+Rq8qKHvXo8u4d/9l7AWAO8cEqaYFNrDNWHPFurzdYgV4gw1fT9vOMo11U
         yVxbB9ljyCBTC2wWOpfZtCFrTLChuOIg9mu/F2VPAH6e8nn7tJQc5l4btX8rKWb7loyP
         iryhCP5vjqHOsbSaucbB6sARnxyigtBiekXot+0QrZBU/QHyMR2mbuQzx0fdEVTla51e
         xgxWVivNmx7OipVha2jMVeNrdX3n8s6zvbuNshWt+GShfS6gPevs2ilAVLXoZ/uWMQKa
         e+aKwaIqZv2uJFbfkF8u0TZ/h9P6fFgHKiAUhp7k39Lhrk9US5rtiTaDfL6MWwRUj/ks
         5q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B3fw4GznCvY6vwL0UWDDU8YNNkjYkmTWnlxAeLDO3fM=;
        b=rQ/AF0V1TGd0Bw/i9dR5yA+69oNm97Hdo5MiVLLD7gmOrW2LrSsL/k99dvdAuV3QHE
         gggioIp+GDSPR9NZWTE+gjeydzaRQxSgBZUprHXpKKHAmmM998rqlcwmcNDSkwiIkbZo
         nIP+irZhglkQoIF9Ly/NX7GUbq4kU90JfBcg1KqEr5n8NXGGoPIF9Y7B0T/z7uG2DYO4
         qus+T/aVYGDUajMIvRaCiX88cD1kWMOaONOidHQ5dae6FCLZHU4sZISLBAf+KIkVoMPo
         onRxvrcFydqaQulIUXco/bjWRx9GSCCkeWKrEIMhf+ku8+0/s5UzH0vOCjTFNbL+dYDe
         rTLg==
X-Gm-Message-State: AOAM5322hCvX/B7T7D/2QQXQbU0DsoA9uGNazntKRrvDhUsfXIbaI302
        oOORSsiSvqHMLK5p9dQubpooc5ncaJoV6A==
X-Google-Smtp-Source: ABdhPJzZTTa0ySVvceOvkeTzVqk5CHXcYARSRC4qVAyzkrDtnj+xNM/UEkLEe6sDwlaG/+tTdxEK6Q==
X-Received: by 2002:a17:90b:3696:: with SMTP id mj22mr7579904pjb.57.1606140182615;
        Mon, 23 Nov 2020 06:03:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cm20sm13829239pjb.18.2020.11.23.06.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 06:03:01 -0800 (PST)
Message-ID: <5fbbc115.1c69fb81.fd59b.e3ef@mx.google.com>
Date:   Mon, 23 Nov 2020 06:03:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.245-37-g8e3cfd776d81
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 77 runs,
 9 regressions (v4.4.245-37-g8e3cfd776d81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 77 runs, 9 regressions (v4.4.245-37-g8e3cfd77=
6d81)

Regressions Summary
-------------------

platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =

qemu_i386           | i386   | lab-baylibre | gcc-8    | i386_defconfig    =
 | 1          =

qemu_i386-uefi      | i386   | lab-baylibre | gcc-8    | i386_defconfig    =
 | 1          =

qemu_x86_64         | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig  =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.245-37-g8e3cfd776d81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.245-37-g8e3cfd776d81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8e3cfd776d81e904dedd36cd67418baa2c0eb164 =



Test Regressions
---------------- =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb904d9137a0c336d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb904d9137a0c336d8d=
905
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb9031c2a44b2c6cd8d912

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb9031c2a44b2c6cd8d=
913
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv2 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb91458ade20dd53d8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb91458ade20dd53d8d=
90d
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb90499137a0c336d8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb90499137a0c336d8d=
8ff
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb9035c2a44b2c6cd8d915

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb9035c2a44b2c6cd8d=
916
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_arm-virt-gicv3 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb90efa9cc456460d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb90efa9cc456460d8d=
8fe
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_i386           | i386   | lab-baylibre | gcc-8    | i386_defconfig    =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8ee61173d610fdd8d914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8ee61173d610fdd8d=
915
        new failure (last pass: v4.4.245-30-g28b017ddc3480) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_i386-uefi      | i386   | lab-baylibre | gcc-8    | i386_defconfig    =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8eecbcf3036e2bd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8eecbcf3036e2bd8d=
8fe
        new failure (last pass: v4.4.245-30-g28b017ddc3480) =

 =



platform            | arch   | lab          | compiler | defconfig         =
 | regressions
--------------------+--------+--------------+----------+-------------------=
-+------------
qemu_x86_64         | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb8e85b18302f8a7d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-3=
7-g8e3cfd776d81/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb8e85b18302f8a7d8d=
91c
        failing since 0 day (last pass: v4.4.245-25-gc9a47ea390ba, first fa=
il: v4.4.245-30-g28b017ddc3480) =

 =20
