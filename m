Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3247B2DF115
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 19:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgLSSnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 13:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLSSni (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 13:43:38 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92B5C0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:42:56 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 11so3594887pfu.4
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/s/lcTrqsPAoXr/KRuj3n5P4+MrBALV00ZGArs/VLqo=;
        b=KPGJzDMHTu8Vf0K9D3gMpqo8T9rhgjhbPuL7hNj2W1fnPEo8nxG+Cx7OyEriYdYKaL
         YFxIrT+Iby1C+MgC6JXPFcCtCxYbgUUAbwUHd8h7K1ofa49xIsqeQrz8Vwcen6GBrpDf
         JbYyT45n+jff1/1hIHcQtzqBKeH2MHIhcqzd5V9T4DR3av9E3gQaybPtW1oovx+ytWNL
         qp3C22Xs7mouzI+aDDyP3Ge8ubb0rPaT/V4sIv35mWZXTn0dUwZenFvY6fK4X7x3nJbn
         4voOYit3MdfE3DZK3zgldALoR2R3DXiLWAA+3f8gous7P7iJPtFkNtEW+V393ug5Pnfb
         RwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/s/lcTrqsPAoXr/KRuj3n5P4+MrBALV00ZGArs/VLqo=;
        b=InyqlOlWdx7NO9kLZ9i01wthMvKwAAlz1W3WUagkj6NjCZWZFLll+WMGDFdOxLKjxh
         9yJeXUtbYbhKkLThNGVsH296/Xmx/GymLlVDeYQmmJ6r7e1kTdVH9sCYL+kXIpVLqQps
         QSfNspLfIMTgFHYQKgfruQgpyQA0KsnZvA/3nfR3H/tc/E9RyyDyBmBWfdmSSMIJueig
         1jVNQDw0KOEaK3KhfH3m0vfXqdaQbRVwVmqiTf9a2MS6+KA5Etocfyf5PJDObIMUgFJo
         GHzIiiJg85kc85Hu+ShI52vh5HnnjNMcVYAOBzTWiu6apuNwtKmycqEOIxkjksgHRUa2
         FNcQ==
X-Gm-Message-State: AOAM533wKwE87bfobdM5gQPrIcEPyVkUmAxHS0yq5hXWropYxQC7Gw97
        tvRwAUlxLV9QnV+fN/bi6ZzJiHF/a6x6lQ==
X-Google-Smtp-Source: ABdhPJy2+ZEK5m0J3/y4GDb/TTg5UNAEToR9ElSnA+lsVeVgMUXxz+jARlbt8+SkdpuhOeSbbT1LCA==
X-Received: by 2002:aa7:9af4:0:b029:19d:975a:3ef2 with SMTP id y20-20020aa79af40000b029019d975a3ef2mr9366740pfp.5.1608403375995;
        Sat, 19 Dec 2020 10:42:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bf3sm11438362pjb.45.2020.12.19.10.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 10:42:55 -0800 (PST)
Message-ID: <5fde49af.1c69fb81.f924e.f633@mx.google.com>
Date:   Sat, 19 Dec 2020 10:42:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-34-gf9a3a712c0d7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 112 runs,
 6 regressions (v4.14.212-34-gf9a3a712c0d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 112 runs, 6 regressions (v4.14.212-34-gf9a3a=
712c0d7)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

meson-gxm-q200             | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-34-gf9a3a712c0d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-34-gf9a3a712c0d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9a3a712c0d7580631577fa3438bdb6767c6dcb7 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde143eb923ca5344c94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde143eb923ca5344c94=
ced
        new failure (last pass: v4.14.212-33-gf6029879256d) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxm-q200             | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde1f6ec76f3f9b8ec94d06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde1f6ec76f3f9b8ec94=
d07
        failing since 11 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde1829400751aab8c94ccb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fde1829400751a=
ab8c94cd0
        failing since 5 days (last pass: v4.14.212-2-ga950f1bfe7736, first =
fail: v4.14.212-9-g0472cccb2d80)
        2 lines =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde15f36060ae84d4c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde15f36060ae84d4c94=
cce
        failing since 35 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde15e6d6099c2c89c94cf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde15e6d6099c2c89c94=
cf4
        failing since 35 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde15bd0153ac477cc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-34-gf9a3a712c0d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde15bd0153ac477cc94=
ccf
        failing since 35 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
