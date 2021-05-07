Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9B7376480
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 13:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhEGLbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 07:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbhEGLbM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 07:31:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5154C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 04:30:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ge1so4948760pjb.2
        for <stable@vger.kernel.org>; Fri, 07 May 2021 04:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bMzCi1hNHdHmHLawMK+Q+qOnZc34e+E3tN1426YY8aE=;
        b=0J8r+Xz3ZgA08fQhCM9WtfrD7PE83xwHtDAqqgTiqngfgnsYn0SUKUgd6xEN8ktwB2
         klz21QWdJbVT6TWGRdaeO6zvKQH6msPEIIvIJK3Cpg9S5Ri1ocg0ACNUjP3DUOL3jhID
         vDCcbx3BEII537Xbre/CRMpX4rPz0e1rEjd58ifmwcmjkNv7uavAcTqXT1M5zM4BxnQE
         V2/eWJz3Ter/440W13OiPa+9lm4QCzAGJrP46H7ihuDK2ZUFRm3wc6tiGTHyWycGsR7O
         +Q4PAZyxGbBSQMJJnNAkhO1SkhXfPoO5B/EzWd0csV2ZkGO10r0kVv0XWleR1y9vHdK0
         dpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bMzCi1hNHdHmHLawMK+Q+qOnZc34e+E3tN1426YY8aE=;
        b=rqEdj3JazGuHXp+D9KAyszYz6PLlXMcbeRWLb/mV3pmY073ZCR6z/lojt3VfRBTPSS
         fMyAXXrfo2W/ji7VdeDs0ig0yZQT+vXGcOHLs6N7mx2D7XCQxrs6FRVOJg8EvY0N5DRe
         nV7DKFW6C/GMVnI6Q9/kKHhCLOPoQ2kwSZ3zcVZFwWjS5ZTp5K+MDnEgkpAl7J8vUt5j
         G9JUJiACkHFgFF9rgMf7A6TQ3ZC/5+nx1rRpX2XBSKSGQCHiOb6EFJM6jxJ6NOuFgPEH
         J/pbe/dfgMv3AkOL2HFI9pqLGZj6Iha+AMs6Ej656aB8GEevzMQytCdqN0QbejkCQV0i
         Janw==
X-Gm-Message-State: AOAM5334t7SoZqSGYxU1O/YYOfk1gs4UBR1a4zObUuVpDRpS0LrCAw4l
        aGVjjNzHoOuB/OLreVp/m4ZS0X3/vKaKECSX
X-Google-Smtp-Source: ABdhPJzOs6CFAj9vsmUW0BtMES9aiEDzVcegmpzXtESRmEKyei1DaxYLqE0247NeIaNE0PnuizjoIQ==
X-Received: by 2002:a17:902:e5cb:b029:ed:64d5:afee with SMTP id u11-20020a170902e5cbb02900ed64d5afeemr9348236plf.41.1620387011091;
        Fri, 07 May 2021 04:30:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm4540502pfc.170.2021.05.07.04.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 04:30:10 -0700 (PDT)
Message-ID: <609524c2.1c69fb81.926a6.d67d@mx.google.com>
Date:   Fri, 07 May 2021 04:30:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.189-13-g97b3901c14448
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 112 runs,
 5 regressions (v4.19.189-13-g97b3901c14448)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 112 runs, 5 regressions (v4.19.189-13-g97b39=
01c14448)

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

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.189-13-g97b3901c14448/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-13-g97b3901c14448
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97b3901c14448697701489f01c1cf271778ae12b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6094f10de7c395acd76f546b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6094f10de7c395a=
cd76f5470
        failing since 2 days (last pass: v4.19.189-7-ge7f760cab9781, first =
fail: v4.19.189-8-g29354ef37e26)
        2 lines

    2021-05-07 07:49:28.340000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-05-07 07:49:28.354000+00:00  <8>[   22.901306] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6094ef2e5948b2aaed6f546b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094ef2e5948b2aaed6f5=
46c
        failing since 174 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6094ef89c5740d00a16f546f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094ef89c5740d00a16f5=
470
        failing since 174 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60951bfef1331ed54c6f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60951bfef1331ed54c6f5=
469
        failing since 174 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6094eee41e9c7a4f416f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-13-g97b3901c14448/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6094eee41e9c7a4f416f5=
46b
        failing since 174 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
