Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C11339FA5
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 18:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhCMRwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 12:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhCMRwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 12:52:21 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC187C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 09:52:21 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 30so8827393ple.4
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 09:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=22GtRsWSNWRJ0CfwjRWX2RZxDVFCbGoAOu8RidUDl2I=;
        b=RkNJNo2JbgiAZ+Fnr3ZWLHvFXD3ZI3Kt9ccr5JxDtM6CfPbtNryi1LciJRw4nTttJZ
         gKF4rl12PkMoXLdFm6rgRwPIYNcYZ8ZB+ipFwgE/HRg0Mz/i07xka3CwuuTP2s/3vLgH
         60liNJvgTRoPnAjahleTD5RS2Vdj9Yruhhs/zMqpjSpCV2D3CjBvwi8v4TkzbxuDdpbb
         QU5YN5kv/AXmcsHHGWzGKokeeo38lvbR8BXN2/OP3HKWhRXPAMIhfFdz3nf627fKuZxi
         95pXwN4cnMCrfCyKXAWdVMpBXzkNKi9tQ2NwGWgMtIwSmGfyK85rbDecdXTuX9TXgmT2
         LP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=22GtRsWSNWRJ0CfwjRWX2RZxDVFCbGoAOu8RidUDl2I=;
        b=RiDn0qFHI3UOnInq219kkz/Z3hMDjrGd/skeEr0hoEegBhybAHs9aQrUxiY2mu05bZ
         21xQnhYL2sj6OJn5V6ohh6OoKgoYVMKXM+n/+q3o+CvxB1zDd/i3qmcyMtInTLO1bHZy
         bi1lt48cdeVBiXl/5v9XKkQgZB4OyiWTsPGbhfJP3ZEDd8z8VcCevrNvv/ayY8gdBuIu
         jtPXBzSTSD+LnZma/0t/F22zD2pHjomVfgIF17UrtrqP6FaI2cxWEZFY2EXtwIhZ+Ypg
         oZWktASe1RTTSuUZl8lDsW+waeZWGqdzWc8QwNkjbTKc1yIjqGjX2LQbxaZrX23jzfNf
         nbWA==
X-Gm-Message-State: AOAM5303tVdTeYRVqj78+Lq3Rkqv5J1tvcLrl3h594a3lEN9I/LfVoI8
        NSj7PpZC+VDhHHiDSqNKuNkJfqKUXpaCTw==
X-Google-Smtp-Source: ABdhPJzSgLGAOTbCaQyr8N8c0ziWTDDnyOmYGFP183u+/1R+HkEWWJjbzA1fC182N3f+1zmoYiZZ3A==
X-Received: by 2002:a17:902:c009:b029:e5:d01d:5bb1 with SMTP id v9-20020a170902c009b02900e5d01d5bb1mr4121743plx.28.1615657940885;
        Sat, 13 Mar 2021 09:52:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10sm8286041pgs.44.2021.03.13.09.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 09:52:20 -0800 (PST)
Message-ID: <604cfbd4.1c69fb81.caa4.52cc@mx.google.com>
Date:   Sat, 13 Mar 2021 09:52:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-86-g21889d805d10f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 109 runs,
 5 regressions (v4.19.180-86-g21889d805d10f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 109 runs, 5 regressions (v4.19.180-86-g218=
89d805d10f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.180-86-g21889d805d10f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.180-86-g21889d805d10f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      21889d805d10fd6fc2202417881b6e909a47121e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc4f6678ce8c039addcb1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604cc4f6678ce8c=
039addcb6
        failing since 0 day (last pass: v4.19.180-13-gcf7e1fa20d452, first =
fail: v4.19.180-41-gc292b9ded226)
        2 lines

    2021-03-13 13:58:10.127000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/97
    2021-03-13 13:58:10.137000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc764df4cacbbd7addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc764df4cacbbd7add=
cc1
        failing since 115 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc75478ce48e73eaddcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc75478ce48e73eadd=
cc1
        failing since 115 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc6eeb94cb26342addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc6eeb94cb26342add=
cbe
        failing since 115 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc703fa9f6d5e18addcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
80-86-g21889d805d10f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc703fa9f6d5e18add=
cdd
        failing since 115 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
