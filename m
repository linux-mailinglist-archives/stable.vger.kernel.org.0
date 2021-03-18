Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD6333FC25
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 01:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhCRARU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 20:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhCRAQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 20:16:50 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806E2C06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 17:16:50 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v186so280977pgv.7
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 17:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=65ar3XrzA0tkV2QqOqW9ucrGtYdCk75p85aWGbEAXbg=;
        b=J7VYJyd/ZTvCxeF0AlPaDo4Cq3NWAUmlA8AxMlDqAU/h35ptNA2j43ElxLNyxgHd6E
         pAGnzEp44XHKN2QDMvXZCw7zsM8+teiWY28F28Lah4itHPDEWUbvnOUX1+n+q8TFgnom
         HpGpu+yhRg3RIi9W3CGkbv/A/WreFlKXkJE33b+pgOFi029yI68AxnX5mQilWHfqAkbp
         pIvU6rxfoVgGrOvg7suevulqPnwy7a9U0wNlm8Wc4CBKhyE5OqP3Z0RcFmvPNR+plkEI
         oYhprkenbmjpSvRkm4Ub9cUfR729fqbUlPaBCO/7U7oLZ+PHkUJ94DrSKYIjqtCuglts
         0D8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=65ar3XrzA0tkV2QqOqW9ucrGtYdCk75p85aWGbEAXbg=;
        b=e75Ff9gH3/wspCHYFT+zOw8moZKQNZafIRJ6m/OwrhYdfBH4ItEZy9uocWhzzLQdKf
         sbKtb42C5t8kuvXpOQqOJ6VWY7346lbfWRMK69CZCyMZeYREmgm6eRMfOQswJ9jokrC4
         /E6TBQWIOXfaZQZ6n1AspcEPFJ0mpPZS4bXkntk+8rYhdhPJDfvBlQoko8B0+kXOljuu
         3+bkFi89dv0HFfNS3dKuWxUwhc1CbWcBrhqUpfJCf8WzuwhW68yTyIwyqOnfTtC7WanO
         I/Ew/phELbH0Wgh1SAW9zSyEs2fYydwYXj/6NKLwGE+t0wJ8AU2Ddk5HgGC9R/223JXe
         Fn1Q==
X-Gm-Message-State: AOAM531ZFjPSx/SLBlqPUUYa8Ab1z6RrAgxpkA9uOAJ7+w+HbKABkHs1
        Sayw4lCqY9sh65G90+jKsJolJPsnE0MazA==
X-Google-Smtp-Source: ABdhPJxADJiYuJ+wkR4S6yYh5i/Y3qDwGUZFYBnFPmT1YN1AjZVPjpnsr9bVQK2PvaHMIZRLhzXUNQ==
X-Received: by 2002:a63:904b:: with SMTP id a72mr4573922pge.77.1616026609807;
        Wed, 17 Mar 2021 17:16:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f11sm189245pga.34.2021.03.17.17.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 17:16:49 -0700 (PDT)
Message-ID: <60529bf1.1c69fb81.1dcc4.0deb@mx.google.com>
Date:   Wed, 17 Mar 2021 17:16:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.261-81-g0c81ed5ea3e49
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 97 runs,
 5 regressions (v4.9.261-81-g0c81ed5ea3e49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 97 runs, 5 regressions (v4.9.261-81-g0c81ed5e=
a3e49)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.261-81-g0c81ed5ea3e49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.261-81-g0c81ed5ea3e49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c81ed5ea3e491461a6264ceee1b1d899c0a17af =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60526af668f1b25e8aaddcbe

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60526af668f1b25=
e8aaddcc3
        failing since 2 days (last pass: v4.9.261-64-gad97aba1f3798, first =
fail: v4.9.261-72-g9a97181c50fb8)
        2 lines

    2021-03-17 20:47:46.691000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/126
    2021-03-17 20:47:46.700000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60526a1383c1bad383addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60526a1383c1bad383add=
cb2
        failing since 123 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60526a4faa37f8318daddcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60526a4faa37f8318dadd=
cc1
        failing since 123 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60526969d28770967daddcf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60526969d28770967dadd=
cf3
        failing since 123 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052693bd4be8f0455addcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.261-8=
1-g0c81ed5ea3e49/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052693bd4be8f0455add=
cbb
        failing since 123 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
