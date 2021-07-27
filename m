Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A893D6DC8
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 07:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhG0FDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 01:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbhG0FDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 01:03:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2226AC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 22:03:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ca5so3745821pjb.5
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 22:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dWA/HluyD4iI5fAm8tE9Za62CdOJgfBl0s60djZY05E=;
        b=DpmZpjzwKYak7vOb2VP5MmGGxRHLYTNNsnfGLxRxSgxefacH4uhV7HDWCRLRapQx2X
         1pFwIBIR071pnI8ePCgb5z4Y1kHlFsz1hHPAtXomqgAXgYifi95V/0VJv/dfTbPaqanA
         R7ubWfyQ7Lgi8NLD8GfmzxiRMO6QCj6Yeca5eBANiNSPPP0j+zX2YLjlg2cPQL7/Tdfi
         XV49mDs/BTvacg5PIS7pzmYHvnVf2qbOpjMChZE9nt4D/zQv0/SrOnMpeCQ1VyNv8qik
         U2OrYGZ3jzScukuZSKxLP1zhuvll4gnP5O59joB8cFFOyT0OIUVvNpzDqMZp+sJbgi4/
         7HCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dWA/HluyD4iI5fAm8tE9Za62CdOJgfBl0s60djZY05E=;
        b=LSnbLF3BaWbMjyR5Jrd7ZKx6OxrVRKJ7n3y/v/47VDO9KYf1AMf0F8ryJHcLEvCWMs
         Y77GGEdWKmyCvD2K0SLs1Ohjwbl6oLU2NQyK5VtktuKiMpRMQz7nKU1Me21qwLozp4/8
         JqvBimwHIhAUgwXBkHGW6rZ5PNea24nIpnyRSg3roOjoTXhW3qTli7wipDc3YEUMHLpT
         VsUVw+gOOgI9JnVQ47cAv6HrarPAGb/AkYHrkv6VpkLKPUOsB3IoDnv5cN2CmFt0bhYO
         k+D3FBlY7vbBac0It085C/zjrkpz+hZKBO2ZGWSc0997yrhONEvkR2ZShHG522UpLdcx
         BjIA==
X-Gm-Message-State: AOAM533nfCxoZ/pvzDgfmNv952EOheSLDBFYBgH/evAGlf+2nkoFFCwy
        oaEE74UvHWMXdnV2vwSPyZiT6f1WhGweuHu4
X-Google-Smtp-Source: ABdhPJyYnvBouLsCIqTDdD3L2rKkijT8XBrGDSPwU9RpERlF2ScQSm5aocJ2kN9nX+RiyWMTklqo+w==
X-Received: by 2002:a17:90a:4bcf:: with SMTP id u15mr9610382pjl.62.1627362232493;
        Mon, 26 Jul 2021 22:03:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e30sm1733750pga.63.2021.07.26.22.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 22:03:52 -0700 (PDT)
Message-ID: <60ff93b8.1c69fb81.dfe6f.71c2@mx.google.com>
Date:   Mon, 26 Jul 2021 22:03:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.276-61-gb71d57957527
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 130 runs,
 4 regressions (v4.9.276-61-gb71d57957527)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 130 runs, 4 regressions (v4.9.276-61-gb71d5=
7957527)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.276-61-gb71d57957527/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.276-61-gb71d57957527
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b71d5795752782ed5d70d191bb79d1e18377017a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff5be322eab6393e3a2f2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff5be322eab6393e3a2=
f30
        failing since 254 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff77dfe4e66783723a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff77dfe4e66783723a2=
f23
        failing since 254 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff5cd568e7bbfd483a2f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff5cd568e7bbfd483a2=
f23
        failing since 254 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff5f7b8e17bacd153a2f39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.276=
-61-gb71d57957527/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff5f7b8e17bacd153a2=
f3a
        failing since 254 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
