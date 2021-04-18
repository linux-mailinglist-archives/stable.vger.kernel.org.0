Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCA13637F4
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 23:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhDRV4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 17:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhDRV4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 17:56:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D4CC06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 14:56:04 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cu16so14795065pjb.4
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 14:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mrn7pGJ6EA8j7TPEPTpjeMOC61dKsbmC3/U7h4kPcEs=;
        b=NamFXn5OWYLuern/8oi5IQdOAREHsJyjLI0i3g3rdxfnSsYVWZSS4Egr5aaNFiJe5H
         NM+bD3Jn3Qyd9MQk+U9BWpXl/oGqH/fSYcBtqyBuqWBa8XLyTS1PH4FoUx7+mGP3aSRu
         einGFxNNBDSBUPqMRoXpb8trv7+bS7DA9n7RoYFdSOXADgBDYYCdx5khXcOsPyHPWoWp
         nThJCeyjQ1r0h4WtOC1hgaApzTcifpQJHNQRpKzg5iyQ2Uiv6vQ3/Hk6nq+V7uZmSSZk
         sqhbP1cETMQnoKEOLn2NeCghuraD47UzEdETPU/J5KL1qjaeFoU/idLCjlTG/Smmo+N7
         f7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mrn7pGJ6EA8j7TPEPTpjeMOC61dKsbmC3/U7h4kPcEs=;
        b=AwyD46l62IXk1Y0DcUDqvcGhFVNJk9QrbbxfY7bIIkBB3iFel30LCs/9DLH3JbQXfc
         TpYOtf6DK/gQlbqUEPz63dr9pjZ3sk6qUV0zcLXGyfzCsNGfBlyUA61BIxEsoRb9Vh8E
         ACCpFf8z//z9Ztle7b/zd9K9nNJDJG3siOo0P3K99v3k7WzPlhNfYzinXz3bQjIpMPAz
         zi3eW1oY0ez8klbJTN98Qo3Ey2gl8COD9zFwpBw6n6WzN3X8pIiXpXj4k2v0dFmK/Xv6
         mGU8F8HVx3MdNr3vOUMuMxT7Z1dIBHI/NwDfzGKwoy3FZtAUUIfpsfisiSTvrbCRXvo0
         tWBw==
X-Gm-Message-State: AOAM5328rDWMQXLJQ5ig21qnu37BNAXKyA65d2Or40wIMRU1px980bfW
        jRg9wM9wl8JkmEpGGmUccBln3vEEDrmq3sdH
X-Google-Smtp-Source: ABdhPJwAPqaNNj722xcyZk3qD8qQtGRy6b9gj9BGAuhFuKjnTtOdn/Zbs7QBGHQtrd0ScUmhxhFVdA==
X-Received: by 2002:a17:90a:dc13:: with SMTP id i19mr21321166pjv.194.1618782964403;
        Sun, 18 Apr 2021 14:56:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n16sm10423160pff.119.2021.04.18.14.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 14:56:04 -0700 (PDT)
Message-ID: <607caaf4.1c69fb81.c29bb.b4ec@mx.google.com>
Date:   Sun, 18 Apr 2021 14:56:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.113-64-g6ac9d2aad325
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 91 runs,
 4 regressions (v5.4.113-64-g6ac9d2aad325)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 91 runs, 4 regressions (v5.4.113-64-g6ac9d2=
aad325)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.113-64-g6ac9d2aad325/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.113-64-g6ac9d2aad325
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ac9d2aad3253946aa525934b4faefa3090b6101 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c6f155fc1db94b2dac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c6f155fc1db94b2dac=
6b5
        failing since 155 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c6f09a7c95c9b4bdac735

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c6f09a7c95c9b4bdac=
736
        failing since 155 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c6f1c5fc1db94b2dac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c6f1c5fc1db94b2dac=
6ba
        failing since 155 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c6ec09ef98a8573dac6ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
-64-g6ac9d2aad325/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c6ec09ef98a8573dac=
6ee
        failing since 155 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
