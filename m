Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBAB2E28DA
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 22:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgLXV3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 16:29:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgLXV3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Dec 2020 16:29:11 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C772C061575
        for <stable@vger.kernel.org>; Thu, 24 Dec 2020 13:28:31 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n10so2167362pgl.10
        for <stable@vger.kernel.org>; Thu, 24 Dec 2020 13:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OwZH6xh1XviKP+YMfLE9bWtDtAHiFczh2qDqRSN7sxY=;
        b=Xf9acGbmz227wNUIpIUX3WRePWQq/nMOelsypwjVZiI+NU7Cd0JM1TL+CoFenCocx6
         2uYveOOumr2sQFN5l6lRlAdOsagIfhrBk5yS+gB39m9qHnwgmW2bpUEefWxh14rxW0C7
         mhSGuD7rHAAjtKxgmuMjEEziVeYXkXQIYd9IU2nGbUhaEYggYAaKWAAf9887aQmhSo6J
         mrGG6Mq69iwhxg00IpqPuLC3DQupDAIPpQPwjVFCBiGGCxmRF9K19fP5qw+emitPpvK+
         cxQIAXBdqaa57DMMBZp2dRPTK3x5+5cfRwB0cwsTTw0IZE44vTRsmUz9+BuWgZI8+bUl
         kzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OwZH6xh1XviKP+YMfLE9bWtDtAHiFczh2qDqRSN7sxY=;
        b=rnvTxKUY9kitImL18hgWIUFWTsN/qyUpmPzMIQ8fqIEDvIts6xwyiGCsrybqM5gbpu
         U5zfZW6DuelhuhPFS9SyY5+3fPCmPmlB06GuOi6Ig2MARRNAyUL6Pk8SpQlW1u8qai6b
         imsOLcBQ0JPen2bGe991OlJv33PbdNmYmPvwF18n8Mmp8ZcZ+plunYUHas7E3ih8sIky
         useRQ3pGMaq6aeUvonGF6xJh6GA2wPri71fagU9Gk5hN2dJ2dayG3vfegB4YGhDfJW+M
         Cm7M4Z8d7fGHp+wO3yNW/tzyf1zFP3Ex6ccbf+xdXUzuvlorOqqaBtu3nv+c7xa4oXMz
         7jlw==
X-Gm-Message-State: AOAM530y8E8wmS0HcpNwYo10eRvIa8wMtfwD4mNrvahoBtfpkHyWlXGH
        Gc6P8vaPjZ399MnMmNJIfTjMAUbY0cEeTg==
X-Google-Smtp-Source: ABdhPJzstgifKaAp9d5wletJefIshs3YTXipEdZjS2JJyshnQ6EZphA0lxXEys7Dcc2hBKp85ok2jg==
X-Received: by 2002:a62:7c01:0:b029:19e:1e23:1821 with SMTP id x1-20020a627c010000b029019e1e231821mr29445005pfc.72.1608845310777;
        Thu, 24 Dec 2020 13:28:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j17sm25763135pfh.183.2020.12.24.13.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 13:28:30 -0800 (PST)
Message-ID: <5fe507fe.1c69fb81.2166c.6f83@mx.google.com>
Date:   Thu, 24 Dec 2020 13:28:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-49-gf82b6ca166fc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 141 runs,
 6 regressions (v4.9.248-49-gf82b6ca166fc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 141 runs, 6 regressions (v4.9.248-49-gf82b6ca=
166fc)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-49-gf82b6ca166fc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-49-gf82b6ca166fc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f82b6ca166fcee8ab21187bf69821f69762f3cf1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4d5cd3a47021b9ec94cd1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fe4d5cd3a47021=
b9ec94cd6
        failing since 0 day (last pass: v4.9.248-48-g718e3a8728c0d, first f=
ail: v4.9.248-49-gb763f0168900)
        2 lines

    2020-12-24 17:54:10.429000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4d427dbb5d1ad05c94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4d427dbb5d1ad05c94=
ce1
        failing since 40 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4d423bb2f443a95c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4d423bb2f443a95c94=
cc4
        failing since 40 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4d4230d04615f68c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4d4230d04615f68c94=
cd6
        failing since 40 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4d3e61cc027336cc94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4d3e61cc027336cc94=
cd5
        failing since 40 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe4d3ded3b278d324c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-4=
9-gf82b6ca166fc/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe4d3ded3b278d324c94=
cde
        failing since 40 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
