Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D06232F283
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 19:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhCES17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 13:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhCES1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 13:27:39 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC1AC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 10:27:38 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id jx13so2361298pjb.1
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 10:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ALLU/QFqv7O6zhpSOhY85NjfdgeJgL7MCFA2yX23lsE=;
        b=zTZArUv4BWS0g0NB3qBkmCUbt0Ls5GY6NjNzx3Kr/tpxJrIfKqJCiqvPkB31G4Wluj
         ftGQ2No+ijL9CIEGZ8/kLNgYyGzhMINCSYEnSfwUwYXv+tCNiOS+xeHmNIJqxR3wiijw
         +d7AjJUr6tSFrbg9e4qX1gpNH1UV2f+FhSdnfcSkygIJEY+ek+PbUjUoBfqK1CeLFQN1
         afnXcq6RLE0FbTyY1fuu9gD1mJ4cwZ+ifyCvO2dZIQgWaprgahfqKZpHE/gUz6mYCWgM
         IWpaGKzyRFnO/OMBSpLCkRXIAZd77WvSf8KLiFesAmArfExKnX46qSmpeUfXrgF03emn
         W3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ALLU/QFqv7O6zhpSOhY85NjfdgeJgL7MCFA2yX23lsE=;
        b=ZEmDo6oFJZWzlqXM7pm36ln9nLBu1L73uc5LDF48qbonz+S/KKGuBthbUe3gcZPwsn
         o3IHocHCKWQNUsxzq2132bZkMHPi8oOGKTvbTfnak1VnmwPPKZ/23aQvyTY/OlHUJTJ0
         7kjaZmBV8DRjnvscOQs4Y92TIV62xJ6nBzRuNFupEb+77RJmDQ7iZ0bCWp033J6HKxC9
         lCKPsSgMC9AUjSR96W1RAt6UkdnUWsol2G/WJdjttf2l81T0cyB3M4QWH1ifGTUIN2DZ
         k9VxyJZwqKgPfGmGJ0zE7J2cfpGZwEv78yhrH6kIil6+/i8mBvWC+7ob6PK1H2TQb3ZR
         oFWA==
X-Gm-Message-State: AOAM5326/lyioj1CiMnX1tEGiePCZe0ntZATJPC+PZ+AGnjykLkofEWX
        XXO4TvJWH32ijwesBwozAfXZFiVijh5T1xHV
X-Google-Smtp-Source: ABdhPJxuuJR5X/rqA2d5IAVONp0DP+5jEdQMI8e6RgRuxWzvMb9qPk0LrLIW6t6EF/wRaAHza0z+Zg==
X-Received: by 2002:a17:90a:4598:: with SMTP id v24mr11683545pjg.102.1614968858269;
        Fri, 05 Mar 2021 10:27:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f207sm3329663pfa.179.2021.03.05.10.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 10:27:38 -0800 (PST)
Message-ID: <6042781a.1c69fb81.1f7b8.8ee3@mx.google.com>
Date:   Fri, 05 Mar 2021 10:27:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-52-g833e4aafea3d3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 147 runs,
 4 regressions (v4.19.178-52-g833e4aafea3d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 147 runs, 4 regressions (v4.19.178-52-g833e4=
aafea3d3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.178-52-g833e4aafea3d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-52-g833e4aafea3d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      833e4aafea3d3a4b50784a192f01d75a0bf333f7 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042440f3761c44768addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042440f3761c44768add=
cb3
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60425d2522e483be1faddcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60425d2522e483be1fadd=
cc1
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6042697fc04d0dcf90addcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6042697fc04d0dcf90add=
cb6
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/604243ae92392197c1addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-52-g833e4aafea3d3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604243ae92392197c1add=
cc1
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
