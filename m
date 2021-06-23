Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63793B2224
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 23:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhFWVCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 17:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWVCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 17:02:19 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9594C061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 14:00:00 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id i6so3348043pfq.1
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 14:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=My40glldUrqjg1hBEsBiuKNK03MjAljFrt57MZOUUaU=;
        b=nJLpC6SxSv47hY8ZcKiE+mNbnHggtoowqCw90aEve1Wo6EVT//8Fz/6Qp/iyvPKeWx
         8kA9J0J9WxKkcFr+Q1l357Do41gt8ZHel0eEoY/HGz00JpS3CAGVqVYN8Er+F43ILWvw
         6xFU7rONMDltCayxu0YGt9AtK8cs7iU/+jV+pZojhIUxDx00A6mXRNv9soRg8Z4U0NLO
         qRM21M7oM+Z84fCXGFEEBPswZDLz0yELI5XR2AG8XgEmGY0A9TtHKa53XanS5OqFKSSw
         jq4JlsdkEbH14/CzZsI5+Id/lvJmrYKx41YBVNgw0XabmI+Wp5y4Gdy1AyxO94Z3GqQe
         wiaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=My40glldUrqjg1hBEsBiuKNK03MjAljFrt57MZOUUaU=;
        b=Qztm3eIk6zXU5mP+YXh9t4n3j0KhI8IqWxFzYOWXRy8mpWsYkLUbKDwcu800lZZ9xb
         FIfNZaSziafJSM9D4GmauuD0G0AkVOFc/dOm0i9BiyjvievlOrU2pK4PnHxAT+2R5029
         zEsIsgnbkaqrp7QfgzCbK5L3YZgc0eN/vMbZ460NTq/Qyc0TGPbxnksaXE6cre9JyMDv
         BSqp4FNadPS9eGdWxuPrIwjJcZTdWIDqE/Bi7jjnz1Aig6SRcQo1FcOyypBIRmxNEPHZ
         lON3k3V9pgBf7Idd8Hp7MDFthVLwboBHTlWSP9l8kC/8E5d8FaRYX7pdxyu67Iz0Q7Ky
         pFLQ==
X-Gm-Message-State: AOAM531dK1wY32PTG84gEHzv0ZApjfdO31GtJ516Hw1qkGCFGqSFqeMu
        BRTkxoVy+d1DDkHLopqkAfvW+S9DLfk0hXbp
X-Google-Smtp-Source: ABdhPJz/i4B5/LTFN4kcelWEGLFy1+u3LYA0tcGPJcF8o+7splqUkuXl9L7TXVNqBg0+1n2lb6lN/A==
X-Received: by 2002:a05:6a00:1586:b029:304:6d51:c0f0 with SMTP id u6-20020a056a001586b02903046d51c0f0mr1602762pfk.0.1624481999953;
        Wed, 23 Jun 2021 13:59:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm18606pgq.88.2021.06.23.13.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 13:59:59 -0700 (PDT)
Message-ID: <60d3a0cf.1c69fb81.421fe.0142@mx.google.com>
Date:   Wed, 23 Jun 2021 13:59:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.273-42-g51fa7d647cb5
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 116 runs,
 12 regressions (v4.4.273-42-g51fa7d647cb5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 116 runs, 12 regressions (v4.4.273-42-g51fa7d=
647cb5)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defconfi=
g             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.273-42-g51fa7d647cb5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.273-42-g51fa7d647cb5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      51fa7d647cb5c4cc7cfe5e6eb779d508fc8cc2a0 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d37677434c2e2450413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d37677434c2e2450413=
268
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d37b5c665ac65f3d413298

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d37b5c665ac65f3d413=
299
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d373488cbe68d31841328a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d373488cbe68d318413=
28b
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d389ccd4b9b26ccb413284

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d389ccd4b9b26ccb413=
285
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d36e70152ec8df8f413278

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d36e70152ec8df8f413=
279
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d37628b07942226a41326d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d37628b07942226a413=
26e
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d37b4993a36357ff413273

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d37b4993a36357ff413=
274
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d3733c0e8f34581141326e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d3733c0e8f345811413=
26f
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d38978574d38c26b413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d38978574d38c26b413=
268
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60d36e6e152ec8df8f413275

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d36e6e152ec8df8f413=
276
        failing since 221 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60d37990ecd6718c35413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d37990ecd6718c35413=
26a
        new failure (last pass: v4.4.273-42-g2baf6f9bd224) =

 =



platform            | arch   | lab             | compiler | defconfig      =
              | regressions
--------------------+--------+-----------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie     | gcc-8    | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/60d37a08edd9b41244413295

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.273-4=
2-g51fa7d647cb5/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d37a08edd9b41244413=
296
        new failure (last pass: v4.4.273-42-g2baf6f9bd224) =

 =20
