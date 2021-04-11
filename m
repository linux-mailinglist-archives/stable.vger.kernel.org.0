Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C6235B480
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 15:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhDKNGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 09:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDKNGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 09:06:45 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22399C061574
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 06:06:29 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso7264191pji.3
        for <stable@vger.kernel.org>; Sun, 11 Apr 2021 06:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JIMU7afMT5Sgf8WDStM7lYyB3eDo6ayAOjp7UUkSllk=;
        b=2MCyL6/VS8/Qj2xvHLgXWM+k1FsSNopfZODAdC0S3FEj3O6voRTkDjn5c+PUdchKJo
         zOdtLXqPHIJvFr0Qs3jgL5HMeOlX6YB3+SbznqSZcB1Og3y31iy9dqVO1TKK5vyvaBUy
         0NiOie8yIiAHhqWTCBveN2WElT5mgBWUJouSR7uB9wOoN8FtwfAgJtRV2DOzDBGkxmEa
         QfNmXUkldWpXJsesF2vCatoyrlTnmOehP3nmgT69xX6/hjJZLlwfR/3uFC+pCl5qCuO/
         f12yDz4SOhd6fS8TklI3AC4pmqT7dEUSxNFOp7/Kz6BU1SXgrC+RtxWO8Jey7IOHcQ8c
         viTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JIMU7afMT5Sgf8WDStM7lYyB3eDo6ayAOjp7UUkSllk=;
        b=Z41AjJagJWR6BoonAw+VuVwprEa8zg/jr62hIcCpIDR5ibnUnVBPzocBU1F4dtngfD
         39ob2UhDt6wTesiDbJhbxLux0piInQh93JpZEewXmMHMFzUQg5Bv4QjwXWZDqTKLvvFs
         o7aJYR4IMA7kyIvRGq7OEV4v7uGI0zo0EAV1zhoGppjT1TofBrseIRsI/FXettzfdZFg
         EjkIAkxYb069Maa+cob6iTwd3NLCYmJ1KW5c2cljnOKireb6CZo7tTgxY6jM9J79Xvgz
         JqEAsVNQ40aR8EPEIopMuQQaQAOHLfGPsTYaBtVMw2NUrt0yt1HmBDF2jumTnFq4IjWV
         4eUg==
X-Gm-Message-State: AOAM530HIV/lOlE5QpdAL4eqZxtbUgf5KPweWEsImgPAAKrOdSYSq6pv
        SMeXengXgqPC5j+Ozzg7fb/ukgOJPgpJew==
X-Google-Smtp-Source: ABdhPJyAPAj0wemFxFF70b/2Y27xVEoeVf7uyhu/+bfWfdA34GQ+Eh72WJczWBIh4se3/VmdgU6f4Q==
X-Received: by 2002:a17:902:9008:b029:e6:f37a:2183 with SMTP id a8-20020a1709029008b02900e6f37a2183mr21818864plp.49.1618146388404;
        Sun, 11 Apr 2021 06:06:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s6sm7292584pfw.96.2021.04.11.06.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 06:06:28 -0700 (PDT)
Message-ID: <6072f454.1c69fb81.fbf4f.1f10@mx.google.com>
Date:   Sun, 11 Apr 2021 06:06:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-21-g1eb27eb19a3d
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 140 runs,
 6 regressions (v4.14.230-21-g1eb27eb19a3d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 140 runs, 6 regressions (v4.14.230-21-g1eb27=
eb19a3d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-21-g1eb27eb19a3d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-21-g1eb27eb19a3d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1eb27eb19a3d4bc77cb9cd19af0f92d861c3b039 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072c04b9139781112dac6e1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6072c04b9139781=
112dac6e8
        failing since 0 day (last pass: v4.14.230-14-g6c412903bfb3c, first =
fail: v4.14.230-17-gc57ce7bb4982e)
        2 lines

    2021-04-11 09:24:23.953000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/105
    2021-04-11 09:24:23.962000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072bdeb44b04ca6fedac6b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072bdeb44b04ca6fedac=
6b8
        failing since 148 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072bdd9fe37b1a295dac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072bdd9fe37b1a295dac=
6cf
        failing since 148 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072bde344b04ca6fedac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072bde344b04ca6fedac=
6b2
        failing since 148 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072bd93bd60f2a81fdac6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072bd93bd60f2a81fdac=
6b6
        failing since 148 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6072bd9abd60f2a81fdac6be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-21-g1eb27eb19a3d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6072bd9abd60f2a81fdac=
6bf
        failing since 148 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
