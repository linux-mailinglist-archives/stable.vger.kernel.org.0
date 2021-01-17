Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1292F954F
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 22:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbhAQVCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 16:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbhAQVB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 16:01:57 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2A5C061574
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:01:17 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p18so9655877pgm.11
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 13:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n0CRgUI65MWXCBSFhTOiUGCEVdYWui2+v+Ro0r2deEI=;
        b=PmuZM7TOWBl0WzJ3DqdI+B9e1SAu7DCZH8bBfx2zNF73gb0MZ96WZ+0QZVcS9xnWC6
         e+uDky4SvAqi9OhKWcWzd7OUy+4ejP3XDCM5spfDEbuSqxcyPJgn1Yol3QO7G1wK1+mw
         DMVrU0ILlD0hq8OO2Oe4aizjZkJcs9WoEr6CsCRePNGPWsDhzEJmxHvm7252jTx3QGi7
         M2ShCO0v9Qb0hu6v/1M5a6u54zpnf8j/5fLLsRKSJmISIS4rWadkFPCR7tx+0UxhYvkn
         xvPfKBUCOwUgph3piRW6QkHbpumHXZW4dSh3R0A6AhVzJjaOzSiSSTH/1zabtHeP9B2n
         VYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n0CRgUI65MWXCBSFhTOiUGCEVdYWui2+v+Ro0r2deEI=;
        b=X0aGMARueYFCjZLwQlaHJtlykpYV40v32UE1Gm2j6vaEXIWGrnXBV81TB/q+yI1AMS
         YCpQ00tQ5gFW0l3r50xePYKVHPQyfwtL1hD00G3CdFxbl698iUPKNaytmY66thVrM/Mt
         UNmiJVFVqyx0bAp8EQWakjwpI6c9kyjmSUHuTvxT6wFKYJuCp0CUGBNuQD40dfe+QfKR
         RO0FMVVHRyUwGxBkJQUI5y1w6IAgVO7pRcewLf+gk8rqruKZw6WyKKj8jcUbfU9LqyMV
         +yGQi0aB2nDwyo7Gt4w3MU8j1aihQCFJaa+ZGcyip9FqFMrPLWUQayx6bKRe6cWQUTty
         cHnQ==
X-Gm-Message-State: AOAM53060u7FAihYeQK3WcXDtOEbThk9DqMATIPoJ764qxrLeiDoCxVT
        eSm48IDyZe99e/2dKq/Jnf/QN/zz0wWB5Q==
X-Google-Smtp-Source: ABdhPJwzpEDn5AlRGdom4+f5lENkWsXaTOGnKhq+MrwvBEfFnecnrrqnp0f1/aG17jd8Glr1c16ztA==
X-Received: by 2002:a63:d74a:: with SMTP id w10mr23550160pgi.134.1610917276582;
        Sun, 17 Jan 2021 13:01:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mm4sm1184283pjb.1.2021.01.17.13.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 13:01:15 -0800 (PST)
Message-ID: <6004a59b.1c69fb81.612d7.2c4f@mx.google.com>
Date:   Sun, 17 Jan 2021 13:01:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.167-56-g6b5fe587037d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 159 runs,
 5 regressions (v4.19.167-56-g6b5fe587037d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 159 runs, 5 regressions (v4.19.167-56-g6b5fe=
587037d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.167-56-g6b5fe587037d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.167-56-g6b5fe587037d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b5fe587037dbf912f9bf58e29b8202da5975c6e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6004718e78d6c5e3a0c94ce9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6004718e78d6c5e=
3a0c94cee
        failing since 0 day (last pass: v4.19.167-43-g7a15ea567512, first f=
ail: v4.19.167-55-gb4942424ad93)
        2 lines

    2021-01-17 17:19:05.164000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/101
    2021-01-17 17:19:05.173000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60046edf5abf80b0f2c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046edf5abf80b0f2c94=
ccb
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/600470f916e1548ff5c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600470f916e1548ff5c94=
cba
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60046ef75e85fa0a3ac94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046ef75e85fa0a3ac94=
cf0
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60046f3849ffbf6edec94ce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.167=
-56-g6b5fe587037d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046f3849ffbf6edec94=
ce6
        failing since 64 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
