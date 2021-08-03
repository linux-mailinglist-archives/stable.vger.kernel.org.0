Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575DB3DF29E
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 18:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhHCQgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 12:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhHCQgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 12:36:06 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E9CC06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 09:35:54 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so5501261pjb.2
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 09:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2+WgoWLYg/Li5EuQMWFqsBTp/v6YxaH2tIbACk1cnxQ=;
        b=Fjgx4WKiFac5NZ8V+kdP5JDTe5orl6BfSKRBMkL3B/sU9Tw+BDDSdmtFuGpn8gVnXb
         OJuB6OE1eJZLsS0u8EJjjwdzcvnrYePJZKugvLw+Bsr/iFVnn6lMF/KrXhrfpGTjBXqA
         PcGEgMPJH1X3zrUKhQBAwFbYcidFlh5G3JwjQW0qe8kfVYj4ed3n2rZixHbmz8+jJoxR
         hNH3Ywu+Y9xRV/4KN+oT1i6zPPrRSPnq/ciNdA83Pk5cOsVfmvhZoIaLNRjRJSV8O1y0
         oddZVTBkm/qZ2/xHn6WF5ttNmgJKdDpS3Y+CCfvB7Cup2R7lhGVeI6XAzY8mCfOVlcmF
         r4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2+WgoWLYg/Li5EuQMWFqsBTp/v6YxaH2tIbACk1cnxQ=;
        b=FHln2g2JxzDASZURztv0ZYKrPUBRdkZkVRAXe1ARtClgy7tphZRwLoG6M6HszvfarP
         WiKLIOHchfjJDzEo1YvDRoxvE07tfmxhE15GPx/1izdKofjXoFG215iqtRTO4DgDWrnd
         w66zWEldcG5DBCgEzj7gCaB5grvRzkd8tOIVEsHSsGW7a4mRRzCjuY5HsyAteGxY0fZz
         eaMzL+eh+kqe1zZXlM12CCVx9d1+Xg/nqmmVUC6AoEvDVcYUw2lVW92uK/YK9VOq53nm
         683kMa6uqwQgcIlO5Y+QGqLOUhLyinm91YlP8kEsSO4Y3Wl9B4jTgxhO+RovHFKHKr69
         etrA==
X-Gm-Message-State: AOAM532psXdk2fIHwVCgmFbG1Fm5SgeowAu+kPpzRaO6XRd88q6ipeHx
        OfgVCfAAawAY6pV4mcJuc3hI+05nIykY7dMO
X-Google-Smtp-Source: ABdhPJyaWBs8Hb3VWKiGMHMc78afx0mIWzzhCWxp0Vztzf89PzmNYcuJbLugwuLdIJBHYRXF+agKKg==
X-Received: by 2002:a17:90b:4f8d:: with SMTP id qe13mr5240414pjb.204.1628008554264;
        Tue, 03 Aug 2021 09:35:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm17985853pgd.50.2021.08.03.09.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:35:53 -0700 (PDT)
Message-ID: <61097069.1c69fb81.f8b51.321a@mx.google.com>
Date:   Tue, 03 Aug 2021 09:35:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.277-1-gd18cfe467e81
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 135 runs,
 5 regressions (v4.9.277-1-gd18cfe467e81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 135 runs, 5 regressions (v4.9.277-1-gd18cfe46=
7e81)

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
el/v4.9.277-1-gd18cfe467e81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-1-gd18cfe467e81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d18cfe467e8136e5fccfb45a93bbac51eeca6f92 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61093ae68995596c3ab13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61093ae68995596c3ab13=
688
        failing since 262 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61094219e2d8a43409b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61094219e2d8a43409b13=
662
        failing since 262 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610933e7463dd5a7dcb1366c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610933e7463dd5a7dcb13=
66d
        failing since 262 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610934403befb57dc9b136a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610934403befb57dc9b13=
6a5
        failing since 262 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610933c626f10f241ab13674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
-gd18cfe467e81/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610933c626f10f241ab13=
675
        failing since 262 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
