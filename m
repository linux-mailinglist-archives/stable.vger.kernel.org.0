Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8342EA3FB
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 04:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbhAEDju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 22:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbhAEDju (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 22:39:50 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489D5C061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 19:39:10 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id w1so658277pjc.0
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 19:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ixM4WwGYefTK9LOeP3tT4zJJmZMU9G3pG5/Udl8svY8=;
        b=sOGFNKr+SIuq6ajwg/c/gTBafs+3Ns0+MoUylDhmfe539J8ujGFXFKVZA34rkcNy2E
         QpsCooBERR2ycrlh2wXSz+AnwZHqSj+3W3GSKdt9JHp9k8QziAML3FHns21diLHMEzgs
         qXRvz89LSPdUTwOWB+KSFVfW+jZ4WCUJFgpkVqcF1v8mdqOhsMRi/nQvD/i/UVgxBD0u
         AkGSc4CtLv7ZXa9lQxaAI8TY/3eoTXKNpy868fFUxwW7iEQcZ9g8jMcv8TP229tSRO5G
         mcb3R00JwWwUQIknhfG6y6dNkVuNZUXQJjbCImWBpjM9Z98kGyMmO0C21X77YOFu/UkC
         rkWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ixM4WwGYefTK9LOeP3tT4zJJmZMU9G3pG5/Udl8svY8=;
        b=n39cpAyI9xieMt8KAbkxeD26OVrWGT9M8D5q3rlNqqzWzTTx/AAXZqIPtojWXIajNv
         kzWN27kDxUKwZTQYuc5+Vw6h8p383eys5ux0W6gL5snU1RG9eYEQCGrrXxzUJnTNiRsh
         1KCbx5GoYNxEaXalsrrU9N9cQWC3MOUCJQQqAsCXmTTMXEdZoe2tdQoQb+bD44wmtY3V
         Kc9MRicYmYJ6ubzOL+Q+AHccOuyA6Yq5N0WLvsniWV5U2aGnKksHF71f/qGNXHgGS4xQ
         FfjNOarjK85pNxdMRwMCc1PvZ9u5JhBj6uLYlaSd6EYHbz5/1piaR3Gyq+FhNw9wH2j4
         IT+A==
X-Gm-Message-State: AOAM533et9NQRKfekBlyUKu7/Md8E2ghp4ozse7GRSYLsoqH4fbOBMOA
        Mdp2CEbOocXQ7dwwMo6rLj9wmWOqA3B2OA==
X-Google-Smtp-Source: ABdhPJycN+6tDbqG93SZ91UxmcuHZr2MfS5FBFBIbgw8q+ZYJQWuklpBoqDosk+XmBvpe830tOPxAA==
X-Received: by 2002:a17:90a:5405:: with SMTP id z5mr2137387pjh.13.1609817948545;
        Mon, 04 Jan 2021 19:39:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d1sm19928661pgb.13.2021.01.04.19.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 19:39:07 -0800 (PST)
Message-ID: <5ff3df5b.1c69fb81.aa77e.cd50@mx.google.com>
Date:   Mon, 04 Jan 2021 19:39:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.213-25-g3ae46324bf865
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 135 runs,
 9 regressions (v4.14.213-25-g3ae46324bf865)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 135 runs, 9 regressions (v4.14.213-25-g3ae46=
324bf865)

Regressions Summary
-------------------

platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
meson-gxl-s905x-khadas-vim | arm64  | lab-baylibre  | gcc-8    | defconfig =
          | 1          =

meson-gxm-q200             | arm64  | lab-baylibre  | gcc-8    | defconfig =
          | 1          =

panda                      | arm    | lab-collabora | gcc-8    | omap2plus_=
defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-baylibre  | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-broonie   | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-cip       | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-collabora | gcc-8    | versatile_=
defconfig | 1          =

qemu_i386                  | i386   | lab-baylibre  | gcc-8    | i386_defco=
nfig      | 1          =

qemu_x86_64-uefi           | x86_64 | lab-baylibre  | gcc-8    | x86_64_def=
config    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.213-25-g3ae46324bf865/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.213-25-g3ae46324bf865
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ae46324bf86594e4d1c965024002247084f7d2b =



Test Regressions
---------------- =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
meson-gxl-s905x-khadas-vim | arm64  | lab-baylibre  | gcc-8    | defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3ac1dc43030cdafc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3ac1dc43030cdafc94=
cc9
        failing since 9 days (last pass: v4.14.212-64-gcedad771847f, first =
fail: v4.14.212-64-gd1d766b4bd93) =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
meson-gxm-q200             | arm64  | lab-baylibre  | gcc-8    | defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3acda578182d889c94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3acda578182d889c94=
ce0
        failing since 27 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
panda                      | arm    | lab-collabora | gcc-8    | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3ad04ae3003419cc94cbe

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff3ad04ae30034=
19cc94cc3
        failing since 12 days (last pass: v4.14.212-63-g127b6f13142d, first=
 fail: v4.14.212-64-g95f3ecbc0c1f)
        2 lines

    2021-01-05 00:04:17.006000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm    | lab-baylibre  | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3aba9fecba696b9c94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3aba9fecba696b9c94=
ce7
        failing since 52 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm    | lab-broonie   | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3aba28ad40c3f78c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3aba28ad40c3f78c94=
ccf
        failing since 52 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm    | lab-cip       | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3abae8ad40c3f78c94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3abae8ad40c3f78c94=
cd4
        failing since 52 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm    | lab-collabora | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3ab683b01dd11b1c94d0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3ab683b01dd11b1c94=
d0b
        failing since 52 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
qemu_i386                  | i386   | lab-baylibre  | gcc-8    | i386_defco=
nfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3aae02d2d54e3eac94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3aae02d2d54e3eac94=
cc3
        new failure (last pass: v4.14.212-64-gd1d766b4bd93) =

 =



platform                   | arch   | lab           | compiler | defconfig =
          | regressions
---------------------------+--------+---------------+----------+-----------=
----------+------------
qemu_x86_64-uefi           | x86_64 | lab-baylibre  | gcc-8    | x86_64_def=
config    | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3aa2da947f8d559c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.213=
-25-g3ae46324bf865/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3aa2da947f8d559c94=
ccc
        new failure (last pass: v4.14.212-64-gd1d766b4bd93) =

 =20
