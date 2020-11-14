Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D6E2B30B1
	for <lists+stable@lfdr.de>; Sat, 14 Nov 2020 21:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgKNUsI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 15:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKNUsI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 15:48:08 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE914C0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 12:48:07 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d17so4669215plr.5
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 12:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jJFfvDdj82HuJLkOukQfo7AFpLRneAvsiUKPSaWgdB0=;
        b=SlW6g6D9/sHecmPeGj1MhvyAAKSs8APBI/9QSnVkTNn0ikb+WOkcuNL3fe2Z6Ze5m/
         O1TFN3CTxtBHugZx0zXZ/BhZ0wDOFVCWsOmswB7HT4acjn9qUpa5r6zcQCTST3veaZRg
         i91WqFMYsQyECVeGv446vjr75UeD0dl+Eh3J9tdeAGnA23TyRt4vkdcsvAgxfyNirRHI
         zcBYd7qbc2XRrHe/ki1PKEoExrF7iulalvnaRbJ8+NAq+DFx38K13blje7QGPH2xdCXD
         8HoMpEfgbGu/uyIalSZnp/ai8sIgk5DsE8Je59tm4bnfqywq0mjj+jgViswtZdQqY/2+
         1g1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jJFfvDdj82HuJLkOukQfo7AFpLRneAvsiUKPSaWgdB0=;
        b=e9lFhX4UvtKXzJKOf5EjLvY76xFP81KNvTLH0ZO2QRhQFDiLRe+mXmVMSSUxXNETH+
         5xutfrVwcsD2q+Ups2SbvVuFzs29pqfKbeHbv3eVdBjdsLfEDpnvThqhdfMpawIx6fkL
         PLzEJiIdQDi35q6lj556fN4FFlmm4SWchM03jI6tLrU0ntA/KLUhX+p0zQvPOMCRHYhS
         +Q/N5u0ORV3mFtKwnWYjkNPHlwswy6UIVLhFUKXU/QXT0TkYdW6jSmh8W/KrMPYmmO8y
         nNMvFk9mCLHf3MAvCJEEZKmyOJYhEsyZc3ZQxu6IJ0gRRUwmZrayE8SVhp4BgNlmVu40
         eY4w==
X-Gm-Message-State: AOAM533yuXBaeGCynBf7E4H5tmmFZQlu0G6E2xUshQFEvnu0Pg9uZmJ9
        kdswn5sLw0VC0VeCWVE54hrzEe/8Ou3QNA==
X-Google-Smtp-Source: ABdhPJxkZC9o2UHgxp6qRVzxmQZTG35OYfXTc83YODQugWoSXT/kuLjYO7FSWB90JI5lz5TLg836TA==
X-Received: by 2002:a17:90a:9316:: with SMTP id p22mr8876465pjo.218.1605386886456;
        Sat, 14 Nov 2020 12:48:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v196sm13645659pfc.34.2020.11.14.12.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 12:48:05 -0800 (PST)
Message-ID: <5fb04285.1c69fb81.3cdb5.d2f6@mx.google.com>
Date:   Sat, 14 Nov 2020 12:48:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.77-46-ga3e34830d912
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 62 runs,
 5 regressions (v5.4.77-46-ga3e34830d912)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 62 runs, 5 regressions (v5.4.77-46-ga3e3483=
0d912)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.77-46-ga3e34830d912/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.77-46-ga3e34830d912
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3e34830d91255b6038c86c49a880c59a1aba945 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faffe8534792e18c679b8ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faffe8534792e18c679b=
8ad
        new failure (last pass: v5.4.77-44-g28fe0e171c204) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faffe9116ec8d4e8c79b899

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faffe9116ec8d4e8c79b=
89a
        new failure (last pass: v5.4.77-44-g28fe0e171c204) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faffe86977481c4a679b8b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faffe86977481c4a679b=
8b6
        new failure (last pass: v5.4.77-44-g28fe0e171c204) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faffe45eb3cbaef8879b8c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faffe45eb3cbaef8879b=
8c6
        new failure (last pass: v5.4.77-44-g28fe0e171c204) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faffec0dca9ddaceb79b8a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
46-ga3e34830d912/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faffec0dca9ddaceb79b=
8a2
        new failure (last pass: v5.4.77-44-g28fe0e171c204) =

 =20
