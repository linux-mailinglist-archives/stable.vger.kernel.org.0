Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA92538DEFC
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 03:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhEXBzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 May 2021 21:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhEXBzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 May 2021 21:55:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCBCC061574
        for <stable@vger.kernel.org>; Sun, 23 May 2021 18:53:50 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e22so3204152pgv.10
        for <stable@vger.kernel.org>; Sun, 23 May 2021 18:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qKs0LMMw6kR3hyAKWkIiq3Gidczr8Ib/waaSLbeQiO0=;
        b=K5axgqCVXnMz2QqFgNNBz+o29OEYSKUoH1E7X7WteaLdVLTFaGLx812/85/5xD/GbV
         37oxZ1tRKSyPE0Wzrhrh2k+C7S3X6/9AT8RPfxHywAKa4pMabxX/mnkgEesIvMNuJWJv
         qrJOCTJB8+DQnbXGJh66nkelZMLHuFW6jfPEgHZsWEkXp2fhelwYqW6DvbA7kmZaVOB/
         IVV4m41uzHgORjceUZZvgEM6S0jPyRmOSX/X6a0b4JAt2BbvTJLU1wbo3iCxp0AnO4L6
         +fOKQPpYimL4IJkvULsL+SkTYIjT4KmvzDG5NjWuDfQdT4dhYOMTtTPBODahUKX1QuLZ
         JZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qKs0LMMw6kR3hyAKWkIiq3Gidczr8Ib/waaSLbeQiO0=;
        b=U8O3snmfTuGhKkrLcMQ0TMI1a336H7FX0WHUsqF1y65RkVlBYN4Hug2sBjoyz6iJoD
         qrf7SZc5YS4OjYoC1QWcOlOiN2L4AoyA0fjDMrm8kpHt1uQbpWmOaxsy1pIUFsebv0he
         Dd81aMuJEu0S/+BMC7slEBj3eWi9cwCF+BfZbUg0h/5DThjP5EAh5O61vCSm11IsOROI
         4LAnOvq3tOkGsZrO0pu+lOq3x9FWGhlUvYG/MuTbq6C8rtKpcYvV9hyPkEOAcjEsUlCJ
         RbHQvcpvscEbwoi9GbtYrg4TdN3rTxkjXDr45MRtTudYQ+vvs3KJEdPHqeJV84x2AAid
         tX3w==
X-Gm-Message-State: AOAM5317t979/hM2KPZUojyg0JP5YwvaejC6ZNtrd3d/bYABiA2KK+JQ
        2MbDcwmPCMDoMlH5ezKI4QTbNP37xvJ3prmn
X-Google-Smtp-Source: ABdhPJxfFhYLTseLxZj1Tf3QOTkyw0tuJr56joG25lXCxn4Ez6pwYhnJJMpigPuYQXe8VARj16r85w==
X-Received: by 2002:a63:ba1d:: with SMTP id k29mr11176209pgf.222.1621821228709;
        Sun, 23 May 2021 18:53:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8sm9104504pfw.165.2021.05.23.18.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 18:53:48 -0700 (PDT)
Message-ID: <60ab072c.1c69fb81.47e69.ee6c@mx.google.com>
Date:   Sun, 23 May 2021 18:53:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-327-gfb7d6b9671b0
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 102 runs,
 5 regressions (v4.14.232-327-gfb7d6b9671b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 102 runs, 5 regressions (v4.14.232-327-gfb7d=
6b9671b0)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
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
nel/v4.14.232-327-gfb7d6b9671b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-327-gfb7d6b9671b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb7d6b9671b0c29b83dce88ad92f6abbff62aff5 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aad5294c406ecfdab3af99

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60aad5294c406ec=
fdab3afa0
        failing since 1 day (last pass: v4.14.232-322-g8121654b9945, first =
fail: v4.14.232-322-gbbfb776a55b6)
        2 lines

    2021-05-23 22:20:22.169000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-05-23 22:20:22.177000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aad48848b81bc1d4b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aad48848b81bc1d4b3a=
f98
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aad4451db617f697b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aad4451db617f697b3a=
f9d
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aad43b1db617f697b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aad43b1db617f697b3a=
f98
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60aad30555381b0dd6b3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-327-gfb7d6b9671b0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60aad30555381b0dd6b3a=
fa5
        failing since 191 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
