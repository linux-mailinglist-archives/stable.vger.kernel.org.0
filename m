Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77EE2F7E7E
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 15:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbhAOOrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 09:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbhAOOrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 09:47:06 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8E4C061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 06:46:26 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 30so6135170pgr.6
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 06:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jbt6kBlmg31FZQIsuFJ/o/Ni6wWHLCnbKTI6XttQ+m4=;
        b=rm6T1/3k+yNkCh3kFt7Gt8kw4x/x0LLtNL/fgHph6sczYesL8B/DphXx9IWz6tXMBj
         sp1+PUnXJYZ+2/VunpFXTvC399JBHfbGVg9KAb9+sLkgNTWuTBdqLNx/+Sif/rczu40j
         zziKaSHP+77gyvZ1oWCPLYhv1FoE9udvDQYiEFmKcHx5qqOwp+VAWuDXAHagHHUqiuS9
         ARlXfX+aUsNXctZfud+N6/jJ9WUGuwvRL25k7UPohNX7RZBDi5QGuYx94/7HpQYHCelc
         70CuaWGwmoNBdVXWhfgUPtYphKyQxtHjdiVu45kyqlg63lpNfRIJF4yBuwFOySzszGes
         Ew+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jbt6kBlmg31FZQIsuFJ/o/Ni6wWHLCnbKTI6XttQ+m4=;
        b=tWXFkl8vDj9vwX8Dv82IpoX1SNzY2OJYKtbAd25S2o57hIhLf7jtRydirkA0HD2C+X
         WGkNFFH1/yCCeA+p6i28oYJWtdT8KLy60FNM6Xy8E2M2Xro8GCsHCDmXdl3daKUUT6ZB
         mIJ210ChhwPBl+m/4R4ZvkeY1sngyMGwVuJa795ep4UR7cRGmVhyG+QvROJB/DMu2Z0X
         eQs2r4GRVOhxILl0OaAfPmjrdiDF/7pymKXgB9vTaUWUsXlbv2dZPCsfoGnGA3quCAMi
         +hpOhoNokLDlD7DeiJr/dWeQGBFTHdYXIH1MtKCOuNUV6dq1ClBfk9S3CwUUcr4WkqBH
         kQ6A==
X-Gm-Message-State: AOAM530m/OuH9Bx1LVyFc0smuWvKRk0wX8uK4dlXg1F4JPNY9H6ZTbjB
        6WMK3456hSy8W/+WGFu7gTnaYqI24bAHEg==
X-Google-Smtp-Source: ABdhPJz5kXFuUYuhosRrOVwdqcRzT0Q7Yj+k7khqNzgYizJ4DvR2yNCZC/QIKdTpXUOzsEYaYHbSHw==
X-Received: by 2002:a63:5805:: with SMTP id m5mr13034590pgb.352.1610721985365;
        Fri, 15 Jan 2021 06:46:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm7923686pfd.43.2021.01.15.06.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:46:24 -0800 (PST)
Message-ID: <6001aac0.1c69fb81.d79bd.42a9@mx.google.com>
Date:   Fri, 15 Jan 2021 06:46:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.167-23-g923bed5b579c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 107 runs,
 5 regressions (v4.19.167-23-g923bed5b579c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 107 runs, 5 regressions (v4.19.167-23-g923be=
d5b579c)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.167-23-g923bed5b579c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.167-23-g923bed5b579c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      923bed5b579cba084319233e3af23750bbc2ac0b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60017213f90f2b0916c94d05

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60017213f90f2b0=
916c94d0a
        failing since 4 days (last pass: v4.19.166-9-g84297b8c2cc7a, first =
fail: v4.19.166-40-g6f3d9bf0e06e)
        2 lines

    2021-01-15 10:44:30.955000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600174e399c640cd24c94d19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600174e399c640cd24c94=
d1a
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600171643b7b37eeacc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600171643b7b37eeacc94=
cba
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001716b3b7b37eeacc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001716b3b7b37eeacc94=
cc3
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6001918bc22164b8d4c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-23-g923bed5b579c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001918bc22164b8d4c94=
cc3
        failing since 62 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
