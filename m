Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06E82BABCB
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 15:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgKTOZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 09:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbgKTOZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 09:25:16 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F059C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:25:14 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d17so4924984plr.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 06:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bMjz3rjwMwZGCTIB6SlNJT2VOXYXeFeWRktJCW3Ng64=;
        b=Mn+ZdWFfPzSHsPW0Ha87fBZuSxAsty2XJEWVfFXWJA5xxjn3SUNRXC8QECdkE36auP
         OyFUl9B1qqsDP+0dQsaDAsCKy59Va6XWV7+DhYD4wZ1UuCRjM5xLM6B8rqAT/z7mAzEv
         n4DjlCy53jxGjcZXCkk+lXc2FffKRvDwKJWs5ipILl3HHj+7ORCuaLh/dedfFAGTFNfH
         XWNRzLheKGkysZeHAc4nT2lAgoiTn2aTXZfRpajss8MCCC9PqMwUZCIz+YRnb11/NwjM
         DJ1XiW/aWfOCbqE1cJSpc1HVdbabfyS38M4Sr3HQMH7VVR/QvikeUy6+7Dg2uECl4qTx
         vB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bMjz3rjwMwZGCTIB6SlNJT2VOXYXeFeWRktJCW3Ng64=;
        b=Y6jaP/zW57GC49DUFbZ1yXkiz2QZmwVuM5VmdIBQUoJjLbl4maAIOJSOhgMJ6WMVbZ
         X+Y4+ONuHkM1BXRQHtB4eECQfXZTz0MBy/zPiMOzguRijS4rkS334BwORJTz8CkHl1mX
         RTj8Izd56qjKF9MmcYLJJLBIV5iQkKGOufaInbTd6KwoeXaRLNFjOwVHyGiknmDVFloT
         20TTtZh+qUWLR4IVX+/k5QX/7vg+imNzolac7wVC4Jpe0pzJSTboz9NtRrvrYW8YBGzn
         Zckw8DgQitDnu/c/VkoG8s3gZds0DtbeAOxx765hU6Z+RI6RGwGrwpZPVonDgHvwvaKJ
         JNlA==
X-Gm-Message-State: AOAM5324OSEdnU/pbO6OC34dDkntOiZvCP6iHetQZfdQHYWl9fKIKwVX
        EbVizSebXaMXFcdk8HtnqCbBNStq9pkHig==
X-Google-Smtp-Source: ABdhPJyZXNdNvEJ4qswJT6LEDQOc4Z2PJjC9fMALGQMkHDl59JIPRjg5gOd9vxt/x4KjkLY7ywhcnw==
X-Received: by 2002:a17:902:d395:b029:d9:e173:3b05 with SMTP id e21-20020a170902d395b02900d9e1733b05mr6035383pld.19.1605882313490;
        Fri, 20 Nov 2020 06:25:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k26sm3821904pfg.8.2020.11.20.06.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 06:25:12 -0800 (PST)
Message-ID: <5fb7d1c8.1c69fb81.263b.7148@mx.google.com>
Date:   Fri, 20 Nov 2020 06:25:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.244-13-gd19a0e464e02
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 97 runs,
 8 regressions (v4.4.244-13-gd19a0e464e02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 97 runs, 8 regressions (v4.4.244-13-gd19a0e46=
4e02)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_i386-uefi      | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.244-13-gd19a0e464e02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.244-13-gd19a0e464e02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d19a0e464e02c7ae70d10a402144e4ac9f277a6b =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79af01cac2854aad8d915

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fb79af01cac285=
4aad8d91a
        failing since 0 day (last pass: v4.4.243-63-g756a870cb6ae, first fa=
il: v4.4.244-13-g89541f1e617df)
        2 lines =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79aabd7382dbb9dd8d939

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79aabd7382dbb9dd8d=
93a
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb799e43b715aec84d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb799e43b715aec84d8d=
8fe
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb799f20b40791192d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb799f20b40791192d8d=
905
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79af5a45b315360d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79af5a45b315360d8d=
922
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79a5ced261c7d26d8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79a5ced261c7d26d8d=
912
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb79a073b715aec84d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb79a073b715aec84d8d=
90c
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_i386-uefi      | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7996336fa855a6ed8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
3-gd19a0e464e02/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7996336fa855a6ed8d=
925
        new failure (last pass: v4.4.244-13-g89541f1e617df) =

 =20
