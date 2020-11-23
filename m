Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF242BFDDF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 01:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgKWAyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 19:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgKWAyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 19:54:38 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EF6C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 16:54:36 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id f17so4148333pge.6
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 16:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rrSPqlOcqWL+wKR1nfs4cvh1/aGNuM5ZEZhZxRzmOus=;
        b=gCQVgo2StB5814swhrwAaJy/RaBsxUkRhnbQoUIXp6qQ/Mjc8n1NtfsRTnwtPymgjg
         adJPB9W5OtFv0z2WA1OHfkgD/pWgi9/fBE/rx4Z6ih4zq1ZsbJANwqpUkoawwVHTMoSE
         +dQK4iuUoMY1EtVcel023T2y1WSoyE/AEdFsxxf45Yo3JbtI1rSvUiTSsQToVWiu7jln
         pMAKQIW1etxYR+0hS5C/TyYUNWPcI2abqu5jZhjrEts5BOcFcExL2XllgZjdfxxdpM5f
         /qjIaS9xFvh+3pjYAVzVSy0bmXa2nPhNFzs4KY/WWnn24Ied3ph6Kc3SRDsdvSi1csid
         emVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rrSPqlOcqWL+wKR1nfs4cvh1/aGNuM5ZEZhZxRzmOus=;
        b=CMZIibA0YN3L00TfAJVthbFopZ/o0EBwYlWQ2oy4hvNrDlcXtp5PDAJxpPOY5xT8rX
         gEShnA6xOgQFhecz0oFJe0gxFLqKIUf9SqSwHFaVJZiTGtoT8wn60bHTAWTRJFiX+uP3
         scmwl2MLyD0Kq96jB/bWDXoP/1CuGiegmU33e51eR3aHJ4SuherQ8kf2aBTdt95mmTOi
         BjMGcIwZQ5PRsl5M67y9n7nTDnf8UbCSj9eJDYnMxvzq1ux/goUfKPx20ZtUixGKFOrL
         1dznuDi3wmN9agOQaInGf/1aGM7eZFWQQpYA3aDU6cVMooEzLyHB56bYKBK54NHrURdz
         Y9dA==
X-Gm-Message-State: AOAM532WQCIFUDEL20lqEFSh0PSAJjzc7gVFNWqUPC/7bsS90FER8uPf
        HOWHGYdFgKX7hA3IztvYBdtnwEiZmEiXSQ==
X-Google-Smtp-Source: ABdhPJwstDuElipIeyYmJzG+grl3/8j6lvu06uk1cvDISP0IMTlD+gQ+1WPWNEEcKPV7z0ezVwy6uQ==
X-Received: by 2002:a17:90a:458e:: with SMTP id v14mr22085743pjg.40.1606092875887;
        Sun, 22 Nov 2020 16:54:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gg19sm11444752pjb.21.2020.11.22.16.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 16:54:35 -0800 (PST)
Message-ID: <5fbb084b.1c69fb81.a4008.9216@mx.google.com>
Date:   Sun, 22 Nov 2020 16:54:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.159-32-g9230dcfcb9bbb
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 179 runs,
 6 regressions (v4.19.159-32-g9230dcfcb9bbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 179 runs, 6 regressions (v4.19.159-32-g9230d=
cfcb9bbb)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.159-32-g9230dcfcb9bbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.159-32-g9230dcfcb9bbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9230dcfcb9bbb67e508ce277936263ec0ee826e9 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad576d66a85e2ddd8d91f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbad576d66a85e=
2ddd8d924
        new failure (last pass: v4.19.159-26-g0e1af0d881d4)
        2 lines

    2020-11-22 21:17:37.454000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad4007e3875e269d8d91e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad4007e3875e269d8d=
91f
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad40b8833b78c3ad8d93f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad40b8833b78c3ad8d=
940
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad3f0cff256d49ad8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad3f0cff256d49ad8d=
925
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad3b73d83aa0aa2d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad3b73d83aa0aa2d8d=
8fe
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad3be478f791166d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.159=
-32-g9230dcfcb9bbb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad3be478f791166d8d=
90c
        failing since 9 days (last pass: v4.19.157-26-gd59f3161b3a0, first =
fail: v4.19.157-27-g5543cc2c41d55) =

 =20
