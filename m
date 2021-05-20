Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA53389AA7
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 02:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhETAvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 20:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhETAvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 20:51:06 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7B4C061574
        for <stable@vger.kernel.org>; Wed, 19 May 2021 17:49:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k5so8221461pjj.1
        for <stable@vger.kernel.org>; Wed, 19 May 2021 17:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QHJXWssekUPiM5L1nmVpyYKA8Pw47dyDfH39mtrKsJ4=;
        b=1Z8etJWe38ahPK+TUNyR4K4zWIhHsIXQ92oXrMoC0uKObCBf3guoEsjpqngKurYvEN
         8iARI5br9ABTRjmraI4/qKbGjouZVKmz4gKT0Z0+jgsTeXadgpbGjOK+cDPMGJSYnsqX
         BzOOHgg47q7QkJWM17rbHXI2lgaVQ0nFtB/Tt/TA8woQzo8OuBj1vApOBiUVqsSjR1ZT
         qZURG2zPYqucnM35Xct+SM+n9jy9ebhKXoxeEpznYVTa/jicSCG4HapQoqlx/7MOKuHh
         OPxsSh7gNOawCPcBQ2Ag8AkEnSTuxDAhWrsKTfBBw+KIbuFKl/C7RhHOYuwx2gtQgoJR
         B8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QHJXWssekUPiM5L1nmVpyYKA8Pw47dyDfH39mtrKsJ4=;
        b=Gna1Qjo0/L/Y5lSGhfoNyfGUV4obcnfZDZBJM9M15ay7RgGjUqjDQoyym0N6JtRxSt
         KRgkqmRZOwU5nWDqJ0I2096ZMWbNwnUaZafeo/pr8x59grIKaA9Pg3UAMAGcfRYbpTxo
         r8nRIehZZePXjPfcJdn3dDlKGp9M3LP/uwHiznewo5+D4/N8++rW9ncqqbas7jidYyod
         bR0rBKYdPzNofICvVEJxcGg/nZ1XeUm/wysQamr7dmmWGe0eiyUOQxOf2sKBrequwNKb
         hErJ9GjA55gVF23mIukw1g+IC2hxop/aFONqhaS6Tsi7d7a57xHz/ZqvPrMw5YLv0NSB
         KbUw==
X-Gm-Message-State: AOAM531JrMeh+icqS3JQcfjmpFt/MUfeAOfwlsfkTOxLKsLSoPEotRho
        uP6/Y61cqmLmLmPR33yMGdj3Gavw3pPiQaXr
X-Google-Smtp-Source: ABdhPJydLl5/1w8jmeT6aBTJn3tC2J8Zog+M4KC2i6LZag1YrR5V12G3+5e0V24N7CCkjUAzjTsLVg==
X-Received: by 2002:a17:90a:17a6:: with SMTP id q35mr2215460pja.118.1621471785331;
        Wed, 19 May 2021 17:49:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm428429pfa.172.2021.05.19.17.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 17:49:45 -0700 (PDT)
Message-ID: <60a5b229.1c69fb81.25a61.28c7@mx.google.com>
Date:   Wed, 19 May 2021 17:49:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-399-g63d22d320a77
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 4 regressions (v4.19.190-399-g63d22d320a77)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 4 regressions (v4.19.190-399-g63d2=
2d320a77)

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
nel/v4.19.190-399-g63d22d320a77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-399-g63d22d320a77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63d22d320a775c22238570d41937c35bb4e9dd9a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a57e0e912e0bad43b3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a57e0e912e0bad43b3a=
fa7
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a57e22f8510e1203b3afab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a57e22f8510e1203b3a=
fac
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a57e6d1afd820bfeb3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a57e6d1afd820bfeb3a=
fa1
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a57d709b63695ebeb3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-399-g63d22d320a77/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a57d709b63695ebeb3a=
f9e
        failing since 187 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
