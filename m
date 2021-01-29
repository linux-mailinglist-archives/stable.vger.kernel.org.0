Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6968F3083FB
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 03:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhA2C66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 21:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhA2C66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 21:58:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09167C061573
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 18:58:18 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id md11so5026394pjb.0
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 18:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VzSihw+QP3oaaEUkOqXl9pSyysigGz4LUpms6SGNgpM=;
        b=kV68FMsmv5Zvt6QqySCG7LyttVyhUVXweysW3e7ZNDvM43+P7kZX55Hd1kg8RPr4Py
         /mLbuXnmmP8udrd38CVShGZgbr1ttSmz7WOLv7XzxK619DqjDc0xzqiJjtLkV6QBd8Re
         EaKVzfwXpfhvg87xf7Iyvhj4Z5FVAYVjvBilxnJgQzei6Y+KcIUG7A3FSWqWXoh+sWNX
         GfgllpECpgdxXqpjc81Gc85rGsCwhPgEa6O35v6DPAnaUlyLihcsjbKI3eKXj860HRxO
         3GT6uSCnH06FbtSSSgkRhsRDpJ5FRVY4IBd2rbhPVCUxZdY0Hw0JDohqaYDN5LNA8SiY
         fc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VzSihw+QP3oaaEUkOqXl9pSyysigGz4LUpms6SGNgpM=;
        b=ZMJwp+w/mUCAqc4xxJD5i9qypTjOsTFd4ps9mvYHTRvSRrpI0CMNw93oKR5T+COCkd
         pg7eJWOtR0J3GPFkorVYFgUGtyaiP6H0MxhRJxYPEFsAnakEeHB0AySQooa6HnvC7Rym
         twsq2d7KK2/ysqaJlSLZmHteK0D9NPM+uVZwKnx4o7xHiLBhz0UzeJwzDBB0sRvQkH1f
         hNPVfSltBRX9MG999j3Kuf/btb01HQKdGPjSlFhYxt5DDLMrCkqL6j6SaSsL9BqDWplH
         QMh/ui+xrk4ThizweoouC6VJ/13lhyBXcv5GHDIxZbh7aIrrNAU2qr6B9/CjpylW8SVa
         Y4+A==
X-Gm-Message-State: AOAM5307gfv6OS04qR5xw3YMZbLaSnffnUUVvfjX9kXqqWKEUvf8MDlH
        81eYdTxqIzc8/uJpFHiBfCzCGYMcWSjKwA==
X-Google-Smtp-Source: ABdhPJxcWSBHdzz7bk/BkaRH2DiE2SHP3UoX4F0iT+5Yp7RjW8L/Fk/Yitddgab+Ps4uFkiO3IHYyQ==
X-Received: by 2002:a17:90a:fc97:: with SMTP id ci23mr2441838pjb.83.1611889097195;
        Thu, 28 Jan 2021 18:58:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j198sm4620194pfd.71.2021.01.28.18.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 18:58:16 -0800 (PST)
Message-ID: <601379c8.1c69fb81.cd41c.c3bf@mx.google.com>
Date:   Thu, 28 Jan 2021 18:58:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.253-28-gdf16aa16873cb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 5 regressions (v4.9.253-28-gdf16aa16873cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 5 regressions (v4.9.253-28-gdf16aa1=
6873cb)

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
el/v4.9.253-28-gdf16aa16873cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.253-28-gdf16aa16873cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df16aa16873cb902a98bd6b8640fe92cd71749bb =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6013455c5e5c27a83bd3dfd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6013455c5e5c27a83bd3d=
fd1
        failing since 75 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60134c3237fa2e5720d3dfe5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60134c3237fa2e5720d3d=
fe6
        failing since 75 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6013456da3abd79fcbd3dfd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6013456da3abd79fcbd3d=
fd3
        failing since 75 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60134538af96e15cb9d3dfd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60134538af96e15cb9d3d=
fd4
        failing since 75 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6013451940f0de481bd3dfe7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.253-2=
8-gdf16aa16873cb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6013451940f0de481bd3d=
fe8
        failing since 75 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
