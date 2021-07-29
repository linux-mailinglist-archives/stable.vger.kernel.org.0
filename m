Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1253DAD6B
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 22:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhG2UVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 16:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhG2UVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 16:21:10 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777C0C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 13:21:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u2so45024plg.10
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 13:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jiXBmPGo/DwvstWlMyREidsF9ubmVrvdHMzSEy/wg24=;
        b=00CfqIpEghQNAL7P8lapoXC/OdTSMXtlfVDyo4ZIi4RHzt2gZJcVRsS+Iyv3SNZqvG
         Gtijt4LjhaGkVNgOzOkHE4Uh/WPenkEe9A5zAdEtdVo28Qhykaa+6ECXsIdEKZdABjEX
         RAMu4/06kr35ms43XV4tM7RBZ4+tIveLTa0INC+37vnZrZQHSq8dq4RRPaE+1SsCZvsH
         WywqOO//GZ8mz+bMpdgNcRHWupA7ROffCCafRtmKg79yFVLzzQ/RcQU/x3YEZ2wiCUOx
         zI0exFHpOIrC0lVAy0WDsVkmY/oCe5lR/ZWq3CrAQs2Gy+j2aIMzQ9CxZAS9V3zYZZQ5
         7FBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jiXBmPGo/DwvstWlMyREidsF9ubmVrvdHMzSEy/wg24=;
        b=f5z4l2eIt5woz9w2YTCALxce0kfsX+hXli0qfTdiMBbYQ3aPCpUaHWBYXxOZ5H1k8l
         7ovD4/8kbE+p+0yn7ZxjGtV2Fvz+0V2FL+a1/JXUJHFTUhiclPs0CizDQ18cv2ApJdbi
         t5f/WgcigfGhbx6I5+ct2ksxsjlLy+3STwQSjyIwIvEdxnM5G1LkK+w/ZjmEvsX+F8n9
         +oyiBR4h4B68yHqfeUE4WYP311uTHnBC+dHRecBd1FXQayU0h0kGenJz1X7ehvG5R/4/
         PqsEHhlddOEjBDN1Ut4mG6LMARBJrs/8wwa3BhpgqlXaU3CL34J2y9dReUPuTbQwVJfr
         wraA==
X-Gm-Message-State: AOAM532Nddi6K0aBBK31340BQl59RKPHk0T9rUuLsaxygjoo1Xx0zuRR
        lU4YtV7cXtZvPtiZ9vgD5rFY15JVXRPPdfXJ
X-Google-Smtp-Source: ABdhPJw8HLlp3ncgDV4MqXFUAEUG/6cr48HKFsJWwv+dVHyrMoasLQ06iTvVJ7FIZ5PNg1F2o1ChCA==
X-Received: by 2002:a05:6a00:91:b029:330:8ab3:d7d9 with SMTP id c17-20020a056a000091b02903308ab3d7d9mr6814184pfj.22.1627590066723;
        Thu, 29 Jul 2021 13:21:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11sm7379123pjq.13.2021.07.29.13.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 13:21:06 -0700 (PDT)
Message-ID: <61030db2.1c69fb81.b1cb9.6ea2@mx.google.com>
Date:   Thu, 29 Jul 2021 13:21:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.199-17-gb297088c8b30
Subject: stable-rc/queue/4.19 baseline: 133 runs,
 4 regressions (v4.19.199-17-gb297088c8b30)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 133 runs, 4 regressions (v4.19.199-17-gb2970=
88c8b30)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
imx6sx-sdb           | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.199-17-gb297088c8b30/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.199-17-gb297088c8b30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b297088c8b30cfeda30109de0db811cd8f06494e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
imx6sx-sdb           | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6102da47daa96e1a5a5018cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102da47daa96e1a5a501=
8cd
        new failure (last pass: v4.19.199-2-g6e7bdd8caac9) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6102d6d5198893197a5018cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102d6d5198893197a501=
8cd
        failing since 257 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6102d6c8198893197a5018c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102d6c8198893197a501=
8c7
        failing since 257 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6102d9811c28f8d5b95018d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-17-gb297088c8b30/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102d9811c28f8d5b9501=
8d9
        failing since 257 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
