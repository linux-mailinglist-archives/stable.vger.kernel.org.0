Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593DC3398D9
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 22:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhCLVGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 16:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbhCLVG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 16:06:29 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE95C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 13:06:29 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t37so5857747pga.11
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 13:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oT4seAE9HErH/zbKb6nGK01nGvKRqJuwiHTkchjX7EQ=;
        b=g0+0xf1DBC/yzw2vMbodmD1Fbx/OIZCY5/ZWSPz+jAoyGIwvbp/vcBK1vj3T3TOqTQ
         G6RNK/VfW2DXokvj24CZeheMWqYm9uU88M370Uul8oK4c0PziIaf7LAEVJG4lMDlypaw
         FGcAnQYi+YSDbi2oQ7GDX2HedJON6ZqMBRxqPd6ybFekukNaDXM2ugv9X2dbm0Tdyqgu
         HMsowFnwv97Pybrhvk8VJHOAx2xG3nnf3hh9btwkhFZ22akUN4R+XXRablH+zmCnJCWD
         i9rxlRN1zjuFsVABZPrNB8Q9OXx/fyALh/8ojedCExt51HHyAF1IHS03dI1FxDUq2Qed
         NtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oT4seAE9HErH/zbKb6nGK01nGvKRqJuwiHTkchjX7EQ=;
        b=IkjvDIRw3KJ4C6COMGPgwoNh8vvN7opby4s870jF9bfn2aS/x7Px1vWyxO8l3CKtsY
         /S8JA66MytcqVoXqYVDWm5SXTO26w7meEcuk12dNCYUz+37M94LO7URYSMV1rnSnhMOW
         jbRtZAukuC+Av/XTdPJrnP6EAXdBbuW+qKRJmRuDz1KIOk+PEYu0kEJ45KoPMuzKIv96
         hRuJ5VNHAEyikg82bpDt+628re9PLf9MOXTk2TvYniuw7M+I7nbXxQSPoLJcbqtyC+le
         ze9a2vylkvWsL8dWPbmr4TrpaEPkOAXOX9YgwGfxqe1TD73W9nfCAfv98Jfb0YZceu1O
         8ClQ==
X-Gm-Message-State: AOAM530wBijsohro73ZL3JjcauXg1IMX+WBbov+Nq5dVRnoX1MfgbCg6
        +vuELryklKrz7VahoQKNpqvOOIYQ0kkLvw==
X-Google-Smtp-Source: ABdhPJwYsA6TJ/uQVY6LEvcuZxJ12FYBc4F0GPYhGxIYVK569rzsjtstyU0Z1b6iVLFabQVijmZ7qQ==
X-Received: by 2002:a62:928f:0:b029:1ef:2370:2600 with SMTP id o137-20020a62928f0000b02901ef23702600mr51447pfd.9.1615583188569;
        Fri, 12 Mar 2021 13:06:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24sm2856748pjw.37.2021.03.12.13.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:06:28 -0800 (PST)
Message-ID: <604bd7d4.1c69fb81.65bee.75c6@mx.google.com>
Date:   Fri, 12 Mar 2021 13:06:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-41-gc292b9ded226
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 92 runs,
 4 regressions (v4.19.180-41-gc292b9ded226)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 92 runs, 4 regressions (v4.19.180-41-gc292=
b9ded226)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.180-41-gc292b9ded226/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.180-41-gc292b9ded226
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c292b9ded226bc1afca7093e3714798129cdce3b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604ba40cc25987d7f2addcbb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604ba40cc25987d=
7f2addcc0
        new failure (last pass: v4.19.180-13-gcf7e1fa20d452)
        2 lines

    2021-03-12 17:25:27.647000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604ba223ec8d90fb71addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ba223ec8d90fb71add=
cb2
        failing since 114 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604ba21590852ebf89addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ba21590852ebf89add=
cc7
        failing since 114 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604ba1d1aaa706a237adde21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-41-gc292b9ded226/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ba1d1aaa706a237add=
e22
        failing since 114 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
