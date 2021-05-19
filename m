Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4B43890C0
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241909AbhESO0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 10:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346987AbhESO0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 10:26:21 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057DFC06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 07:25:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so1900550plf.7
        for <stable@vger.kernel.org>; Wed, 19 May 2021 07:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iVHhwYTVM0EcAPQTu7bDESEVHbmu29BgnfTFWF5z8OQ=;
        b=VB2S964KWT1rE8NuV0YAe5VmTCIV98t3Zqp5UK56T84M81/PchwmNQDZfIJXydEtxS
         uytGZKqI/2BeRhLX86ZamlalVAlEJ5CNcSrEpcwEjmX44GeNAy/8ufQ2UVHe4CoQEmBh
         kUxhut4T6TGVQKOYDf2CfsWMmZ9CKnyGDSff5fjcDgNH10MREP9V0U9Zck59duxUv9Vz
         XCGzZjaLh1nBWFMhX+qfaCE9iUM1BjJQhJMI36PjTETzxcriBq9Oqhzil5t8SrNbujHT
         i8db9DHAzG2K38pvtEu6MpuAxwNKBgNl7IzxRg4JrT+Ovo8vkDy3eniYqkwLxbMEuBi1
         9bVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iVHhwYTVM0EcAPQTu7bDESEVHbmu29BgnfTFWF5z8OQ=;
        b=KjTNHRwxIDNKVHpeoylPjh5YOuzfzXwTEHWkC9hXUorrhFxBFxWRAAao2r7aJMzVwU
         WZASP6VOuw9tz4+cn0MKrI/w9pO4LxDg6FZawCQ9P45OTn3PpYwv8P5kqOElIAUzaflZ
         IKckXaamPZ0nMDR1aVlYvHQ2qKpKPI9WxTJajnguP4xeexFwlt4t28imr/H4GdjYH5U9
         xkrBXriJUPlX7OGXMgmJuMutnNFqcRfm3oUE/KQV1nAAkCNs+Qodg5jlQsn3kb8txiPG
         /b2lZb1AiYBgWaiTXACg2VauPoA2p9Uuiv96EykrQ6e5shl1Lbw3gCpNFJhWbVdsxY/p
         ss5g==
X-Gm-Message-State: AOAM533/2DWBckFSYD25v0ZjoHkqc2Uc4wxViuvIxx2yDJ2ufxvh9Egh
        i2nttJUSESBl0f/lbe5IIWgXi2F1cFRh4Q==
X-Google-Smtp-Source: ABdhPJzNI1+yU+7N98lMpOXLtNodlvrO0rDDhnXX9wae3FoLCCiB00OMeF+/09QzaZ9yGjI6kDIy4g==
X-Received: by 2002:a17:90a:4288:: with SMTP id p8mr11657486pjg.42.1621434301239;
        Wed, 19 May 2021 07:25:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4sm15520737pjf.9.2021.05.19.07.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:25:00 -0700 (PDT)
Message-ID: <60a51fbc.1c69fb81.44884.35ad@mx.google.com>
Date:   Wed, 19 May 2021 07:25:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-301-g83a9a3e565d7
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 4 regressions (v4.14.232-301-g83a9a3e565d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 4 regressions (v4.14.232-301-g83a9=
a3e565d7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-301-g83a9a3e565d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-301-g83a9a3e565d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83a9a3e565d74ac949a2e31f283a07b77ccb2c6c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4ec5de287aa48e7b3af9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4ec5de287aa48e7b3a=
f9c
        failing since 186 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4ec4a4897f159e3b3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4ec4a4897f159e3b3a=
fb6
        failing since 186 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4ec5ce287aa48e7b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4ec5ce287aa48e7b3a=
f98
        failing since 186 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4ebeef7d7bf9d4bb3afae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-301-g83a9a3e565d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4ebeef7d7bf9d4bb3a=
faf
        failing since 186 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
