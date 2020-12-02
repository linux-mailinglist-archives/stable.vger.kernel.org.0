Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EBA2CBF14
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 15:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgLBOIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 09:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388939AbgLBOIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 09:08:06 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843BFC08E864
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 06:07:03 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id t3so1122835pgi.11
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 06:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WjmvJwH12fGr+1uhCIaj1cquat3GHoPrnc27WxzwHk8=;
        b=NtwmTydUoYGw6l0sd6h4XfuvEuKcp/b5IZdXfwmPwmf7C+7A9UTHnMYXUicr4b+sLk
         QT9wITZTpdrNDy6L1/WchnSPmSooeYDqS+hcKFvgQ0F6GDdT8k0ZVWHjMGF/z6jTa/Zd
         HSyO0ZuODHGope5DL5bJ4vQmUFTuV+E5K/b9aeBoHPcYABB4RtcC1wdVA05ie3RgAKHa
         AB/bT3VQbpxschLS1WNu45s7nPpXRTwIsSCD1ODsal+a33b1bDiygqQV1JxJ44TcT8kA
         8QUWhA57yWGtPVd9IIQXMulYgjJU589vp6Nv8hzeOoPkF5Fy3FMZH0/OWQz3DgL1x+gE
         3N6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WjmvJwH12fGr+1uhCIaj1cquat3GHoPrnc27WxzwHk8=;
        b=PUMTXhtu5eLeH+l9Nug2hJt/e1j+RRzWObrHenLONlSVhsFOmSrFcq1gu/Rn4zFnKj
         IN4YvFuamAMAcgFuwRPbdxYRrXsbFm+xjYw9VvCTlulaSWX7MpPUj9WmXaXuLAnXrSND
         Q4lvre/whbqx2qgXX9xPDkDjHjS+btajLSgSjgI42UPQ5YXIx75moipRQqdBQn6gaxvU
         qUxOtMdmKHhEGwZU5y2MBixqwhlkBSUG9cTrmONu7RyNoURqib/dECa2LG8L4LUcmUVE
         fl+OLw2ngTtUQw0+QqqCqdjY8Vnc0VKGvSBlvv6eL4u/BrT0zb25C7U2+wA8Cttt+P8y
         S4SA==
X-Gm-Message-State: AOAM532gI+ab6ulj4INlDhDruoO004Chr6TLptZtfxQWKa240mEp/pVz
        P0TgtUBdsNlZN4t/fK/vpM+j7sK6ypVgGA==
X-Google-Smtp-Source: ABdhPJzRb3AhQ9hOOIi29xbcAIawCSrCx1Zp7h8g6+O2IbivpWJewT9ZwTmchPspU6bFG2bMa/ouNg==
X-Received: by 2002:a63:d618:: with SMTP id q24mr29675pgg.171.1606918022066;
        Wed, 02 Dec 2020 06:07:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d3sm2042159pji.26.2020.12.02.06.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 06:07:00 -0800 (PST)
Message-ID: <5fc79f84.1c69fb81.71ca2.42c8@mx.google.com>
Date:   Wed, 02 Dec 2020 06:07:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.209-49-g6a474a1a5ba5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 133 runs,
 5 regressions (v4.14.209-49-g6a474a1a5ba5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 133 runs, 5 regressions (v4.14.209-49-g6a474=
a1a5ba5)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.209-49-g6a474a1a5ba5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.209-49-g6a474a1a5ba5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6a474a1a5ba5b6f833e2179128475c18810ab66d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc76d0a9c53baf161c94cda

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc76d0a9c53baf=
161c94cdf
        failing since 3 days (last pass: v4.14.209-11-ge2326a479d95, first =
fail: v4.14.209-14-gefcf305b1a7e8)
        2 lines

    2020-12-02 10:31:33.834000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc76b5ffad9a1d651c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc76b5ffad9a1d651c94=
cbe
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc76b53e2129bd211c94cee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc76b53e2129bd211c94=
cef
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc76b4c12a72a22b5c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc76b4c12a72a22b5c94=
cdb
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc77649194d51612bc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-49-g6a474a1a5ba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc77649194d51612bc94=
ccb
        failing since 18 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
