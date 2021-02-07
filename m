Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB22E31275D
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 21:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhBGUM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 15:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBGUM4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 15:12:56 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9088C06174A
        for <stable@vger.kernel.org>; Sun,  7 Feb 2021 12:12:16 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y10so6703941plk.7
        for <stable@vger.kernel.org>; Sun, 07 Feb 2021 12:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pGgK/zg0zaCc+8CKhzgrAuSkG2XFWMdbYkzyoxgo82s=;
        b=g7Z0kSEG8PTI6d1SL3jpCuud43U6DJj3bRJCA447F+DjzkntPgsir/tEvw809g/vGC
         lZb/QBYaEEdEiLP2uTQkweSJKKhiPTKe6luxni2Y31UuvGT6qLHPj97EdVtmCjhQpEN5
         RPT7t7ClFP2Dfiff//Nr2qoVJmXjrSsj93E1KUhCjsKalIm3nO41o+VR7W7pWNSD4Wgm
         WJ9n2RxTCEdbrH6V2M5RrGUiUpFISd5VN2R9tBMzicI39tKs6ago6YLkQ/eJT4kzs78l
         sBGQZXwJk/yTNc4Terf1S+9R124yhHLAa7osPkzCzAunr702uJbQCewcgn/Gs2lJhfpL
         u03w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pGgK/zg0zaCc+8CKhzgrAuSkG2XFWMdbYkzyoxgo82s=;
        b=DxIiPsNWIPdqShyCkuvbR7e5Jf14+N3JYjuu1qx+s+BZSG1UiZKNmM1oTkQjz27Vma
         DYCukOpArjOvT6oKnwDjmGdAQhqFuhXigEGF3lOaeDdH/j7idIHpUn81eFaUPRbLrv3J
         0YSZlN6RyuoW23R2Pmq/A4sFVA3OeJI6mKXK1EuFFH+32nG6CK14IlXbh6P1PgmzxgwR
         E/CZEpZDQz1Dc80GFsLlTuEkMI7f/GKNJDKiCMCmWSls3Ow3wzWGb74nQBBvnqxpL2IV
         EhgNBdWtZoGaZKs9GXSBUbYLxURL1vZWeANw3G2mowV27IQiKIh4838Tjki1zb76RPaa
         Gvzg==
X-Gm-Message-State: AOAM5308aA56xWUvT5jTp1JgxrfEBy0yWjroBRFyAO5txvY15Yfsc2zd
        W3vEQUlMCGU/vpreBbEMfN7tKAzsr77Ktg==
X-Google-Smtp-Source: ABdhPJzM86fvNk9juOdmTjK5M72Ux771Um38c7hde1y06LhqLAWzAgrGOckwNuNicTSVYmlfgbQ5dg==
X-Received: by 2002:a17:90a:a111:: with SMTP id s17mr13431592pjp.43.1612728735746;
        Sun, 07 Feb 2021 12:12:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19sm16078020pfc.122.2021.02.07.12.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 12:12:15 -0800 (PST)
Message-ID: <6020499f.1c69fb81.8cac8.3660@mx.google.com>
Date:   Sun, 07 Feb 2021 12:12:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.256-21-g19887589364f
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 6 regressions (v4.9.256-21-g19887589364f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 6 regressions (v4.9.256-21-g1988758=
9364f)

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

qemu_i386            | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.256-21-g19887589364f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.256-21-g19887589364f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      19887589364fa87eed81467e4d35f138c6883442 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60201029d4c9f14f6f3abf19

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60201029d4c9f14=
f6f3abf20
        new failure (last pass: v4.9.256-18-ga090e9994044)
        2 lines

    2021-02-07 16:07:01.569000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/123
    2021-02-07 16:07:01.578000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-07 16:07:01.594000+00:00  [   20.716827] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60200f216e64a174993abe8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60200f216e64a174993ab=
e8d
        failing since 85 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60200fea51b825b30a3abe70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60200fea51b825b30a3ab=
e71
        failing since 85 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/602012950e9a6327963abe6b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602012950e9a6327963ab=
e6c
        failing since 85 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60200ecb856b53e94d3abe80

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60200ecb856b53e94d3ab=
e81
        failing since 85 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386            | i386 | lab-baylibre  | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60200e61cccf0e60d73abe92

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.256-2=
1-g19887589364f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60200e61cccf0e60d73ab=
e93
        new failure (last pass: v4.9.256-18-ga090e9994044) =

 =20
