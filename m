Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10085415567
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 04:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238904AbhIWCWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 22:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238859AbhIWCWx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 22:22:53 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0601AC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 19:21:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id bb10so3046542plb.2
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 19:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xDUt6Ol0m/GBZ3ZuFHQlYutrs6YER25eML5ly1gPeY4=;
        b=76tykdvx7hAU2EIddpv4VvNoj71qV5VqP/YLDguCEp2mePsZluJUxoLH3drPf3s74a
         nvth3L6edG3xf4L0ao5WK3tFulo9jHDj/D6+Of++nE+ZepZga6vVCCC+1cJV0tj7nIFz
         8v4CdHPO48XKUvXLsqCg+k+2cTDINj0k9ujMtO4RvYuIw/sQd/9BVyW2fHeVM6PWAGNj
         gXLO1UnqiLWyi/LMWOpH1/O1dV/YNWKBpVfE4w0B/KULOnBaCowSbZ3GuWdeIAH7O8qL
         4hjXBx/9UtfbYaWU2tDiwY4bG2TeBI+0ttXkYor4xg2A6ohboYtjCnRog3zkdNeaS0Rg
         wf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xDUt6Ol0m/GBZ3ZuFHQlYutrs6YER25eML5ly1gPeY4=;
        b=oy5gCzo7672FRt5EGLk/XduMhMZ9SWJKl6E2ndaszFxvWj9MTdTjgT1/jLm1C03q9Z
         Vwisq1AHty2sRITO+CzWwtxvuy7MznLN49SLD3/g59UE0uc/pZ3mYzDg/X3YycWZr1Y2
         ptoYWoWUXIwtwSglqC6PZDCDiVpUEmUrE3GiBdJM/YihrvkdfXXOkSnDinh4OxKl/v5e
         Iio1TclxhMTOBZ1d8pHil1hWG+UXeFVLtx8l+k2xd3LuHqyYOfSuiKiGBsfbiYRnkJe3
         gSCGPkneZ+Qco8yv5Mu0NSx+zAsRM+X4oMoBOdNqbaofDAtK4T2qZJbpZcN4NpWTwlo9
         lpgw==
X-Gm-Message-State: AOAM530ynzY6nyrL/8X0p9FazQuftAr3MhMuQK3yCtBeQaJuHFEKFKch
        Jq/xhNz7Bw4wj1S56GxpkDRY1wUo2AbUbwIq
X-Google-Smtp-Source: ABdhPJxSGu0a/XDITUY3f9DQquZeCodBAm9Rz3pQq/ZP7gon7seZjW05BRGl8oLMMRYm6tReDZIwLQ==
X-Received: by 2002:a17:902:d492:b0:13b:7935:d990 with SMTP id c18-20020a170902d49200b0013b7935d990mr1756202plg.7.1632363682243;
        Wed, 22 Sep 2021 19:21:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w67sm3931066pfb.99.2021.09.22.19.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 19:21:21 -0700 (PDT)
Message-ID: <614be4a1.1c69fb81.76469.bee4@mx.google.com>
Date:   Wed, 22 Sep 2021 19:21:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-296-g74b0d584f697
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 129 runs,
 4 regressions (v4.19.206-296-g74b0d584f697)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 129 runs, 4 regressions (v4.19.206-296-g74b0=
d584f697)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-296-g74b0d584f697/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-296-g74b0d584f697
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74b0d584f697ac055b47d9f873f133c88bec9829 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614baddc14a9fce31399a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614baddc14a9fce31399a=
2e0
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614bacf1abca819c7f99a317

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614bacf1abca819c7f99a=
318
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614bae3940d924619f99a30f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614bae3940d924619f99a=
310
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614bbbac2da442c46d99a31d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-g74b0d584f697/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614bbbac2da442c46d99a=
31e
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
