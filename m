Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C4A33B4B6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhCONhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhCONhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 09:37:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CB4C06174A
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 06:37:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so1968687pjb.1
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 06:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LxKueKCO0lJyeoc5UBf0NRMtkIqpdNApwia93+t5By0=;
        b=jI0ntAfcRqoVQR9u2eQz2kx1VKDXWj6m7K2hrEN+bOVsIJfSvEICCJqR9CKnz7pDqM
         B0y6jRamacdL2V7+ubhIh1LvafsUNhpk9Tq85bfagOU8gE7oyuJhy0FDa/amwu0lczmB
         niwRj+TtxpVIzEv3EY1qAwUTbN6bTef+p7Sep8s8nxuMr2Ms9h+NXgDdSlFmMo76gDUD
         yMfWQhUmHM+D/73IinYr0/8ylvsRQRcDzguQauv7QCGnxKo2HUuAlapJRCsU6Z02owzZ
         ct82nRm9GeEmENTvKtpAhpSMwWJOdEDU6kDzUG01eGesoILjMc1nNmmEcX/k+rV+D5Ta
         ltZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LxKueKCO0lJyeoc5UBf0NRMtkIqpdNApwia93+t5By0=;
        b=hZNF4irV4e4s0xjjGe1yEyDK/wt6B3dYvFan9efH9nRMaVsUVScNei6PHiFYwvni67
         ibGYFUbAosd6nN/LWvVarpyAJbeApUC9xHFKsVA2+Q9N1sqQyWkNA6Ohvc2P6oJ9wz7W
         xl+pUmUkJQ2tSPbyAJ9HYCjPLqUy3Qy8TFxlzJl85Gyb0r+f1i1vVMaOmcpBuR+IgCHa
         iFaIblS5D/G11nIqQVDrX9y8TdWqvcQtJMFEZbxltjme9LSCbvOJ20/ZlrBCWRarak3V
         i46bpqHHN2GJY4lAdcS85KaL3a49XhlTHh14GbdP9/oqtJD10gJYWYIPkPDJIsrGd9CC
         wh7g==
X-Gm-Message-State: AOAM533AV7GpTjHZ2/ySbzbvOfDZTcDpzidDZSrOnfpS45IaiWbLUdjy
        vdnfqmogF7od9W/5gXBmlpMRBTsR/ukHqQ==
X-Google-Smtp-Source: ABdhPJz/v+7x+mBlddyISZS4OPjALAxBq2JaETUQut1exYE+5VS01pmuQcb0dWRW0cSNQ4ulHjxZtQ==
X-Received: by 2002:a17:90a:d991:: with SMTP id d17mr12841752pjv.229.1615815443039;
        Mon, 15 Mar 2021 06:37:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w17sm13356078pgg.41.2021.03.15.06.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 06:37:22 -0700 (PDT)
Message-ID: <604f6312.1c69fb81.93bf7.0bdb@mx.google.com>
Date:   Mon, 15 Mar 2021 06:37:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.225-89-gd504fc709f32
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 99 runs,
 4 regressions (v4.14.225-89-gd504fc709f32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 99 runs, 4 regressions (v4.14.225-89-gd504fc=
709f32)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.225-89-gd504fc709f32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.225-89-gd504fc709f32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d504fc709f32f209842b5e987bcf4b7413f03c36 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f2e71cf9be302b4addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f2e71cf9be302b4add=
cbe
        failing since 121 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f2e7c381a70476baddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f2e7c381a70476badd=
cb2
        failing since 121 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f2e0bbae30a7bc2addccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f2e0bbae30a7bc2add=
cd0
        failing since 121 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604f2e0dbae30a7bc2addcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.225=
-89-gd504fc709f32/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604f2e0dbae30a7bc2add=
cd4
        failing since 121 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
