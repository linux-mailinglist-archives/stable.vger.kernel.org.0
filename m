Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64E343B6E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCVINg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhCVINa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:13:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8DFC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 01:13:29 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q11so6133590pld.11
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 01:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c5laRZm2F9P/e5AKaruf73n9+5n8bGYwh9KM8hYioRM=;
        b=YXAXeNuhnsiuusddpzbsvKx/s5s2LMTLFAsYprw1WrDK5kKfaeOm9Df4HQZffpGGcA
         C0YgX1gT6avcY9Tgu6sWeaS1Y50EZt0BAcPBvLHorCQ8B7FHzuMk1MfPO7WnHZv2WM0B
         7sQN+BFDwiwpzOCKrPV4nZfdLZh8Eknw+NROaaLmYzyKTjLPk/oNd07Pyw+obnBl70Y5
         AgdpGtEbIP130qxzXbNNSJmE/GMtun+OqJ2qnDFqieadC56UqCDXONhbsJ8tBxZ0XXJk
         OGpcmjZXYzgkZvWoXybjQkQLiaJFcBKbAuFMEib5Xg4Y49nP9wXzO/up+QFCJmxNkErC
         RGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c5laRZm2F9P/e5AKaruf73n9+5n8bGYwh9KM8hYioRM=;
        b=KxsM/3RUU8ecsIdqfuBYwPbTgy5vXdTki3pHW7CKOzktvbh/F3T/vFpWx3twW4kHy4
         Jc5CiH4gac+LGRQEiFgvq2Dxae8hU3yTiFdE0WtBgpUoWUo6meMmdZD0bxO9z7kfOTQc
         zseV3Q+L1FoFiJKhuZEB3LzywTyEE/Lq7Pg3LpDbbmfFaeglRIFDbSgMeVAxXv+8AVZj
         QU5xgS5MiFfsKYdNSChKfxZTjaiYtiSkSN5VdhXEXcPYOgM9srJi35vT14zRSbQwK46F
         eH0CeMRHqRCmIezhDSZSleYjOBRCpE9D3aeinNNFNfVUw9sxLrAaPSsmx1vUwY0CqsDs
         c1MQ==
X-Gm-Message-State: AOAM533kBBI8ciFHyGD5JEEAK7FTLhKrOiUcTb51GYRTET5LecqPxynM
        CyaQ++LiP85c3LlHHSTaxDjtpX5hZbV6Hw==
X-Google-Smtp-Source: ABdhPJx7ZObk0KhbwYS25bw/i79L77pds7s2qCBXr96i4D3e6aEIst4DAMz30zFItigEQnj/is7Beg==
X-Received: by 2002:a17:90a:ea96:: with SMTP id h22mr12027230pjz.24.1616400809376;
        Mon, 22 Mar 2021 01:13:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gf20sm13030401pjb.39.2021.03.22.01.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 01:13:29 -0700 (PDT)
Message-ID: <605851a9.1c69fb81.920ef.f8a0@mx.google.com>
Date:   Mon, 22 Mar 2021 01:13:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.182-20-g01f6445e09a2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 5 regressions (v4.19.182-20-g01f6445e09a2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 5 regressions (v4.19.182-20-g01f64=
45e09a2)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.182-20-g01f6445e09a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.182-20-g01f6445e09a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01f6445e09a2a1ec4e1a5a571f814171c771ada6 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60581f0e4974210ae9addd02

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60581f0e4974210=
ae9addd07
        new failure (last pass: v4.19.182-19-g97f9b43ac5a71)
        2 lines

    2021-03-22 04:37:29.356000+00:00  <6>[   22.628234] smsc95xx 3-1.1:1.0 =
eth0: register 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethern=
et, 32:b8:82:b3:07:26
    2021-03-22 04:37:29.363000+00:00  <6>[   22.641418] usbcore: registered=
 new interface driver smsc95xx
    2021-03-22 04:37:29.370000+00:00  <6>[   22.650512] [drm] Cannot find a=
ny crtc or sizes
    2021-03-22 04:37:29.410000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/111
    2021-03-22 04:37:29.420000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60581c024db9b89b93addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60581c024db9b89b93add=
cc3
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60581c09a373e9819eaddcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60581c09a373e9819eadd=
cd6
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60581c04a373e9819eaddccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60581c04a373e9819eadd=
ccc
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60581bba331b4ac23daddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.182=
-20-g01f6445e09a2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60581bba331b4ac23dadd=
cb2
        failing since 128 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
