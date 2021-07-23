Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1683D3760
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 11:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhGWI2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 04:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhGWI2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 04:28:49 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F40C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 02:09:22 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id k1so2351567plt.12
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 02:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WYoXAh4A13G6cVwSO0wB5C6CBf71AyoyKnUPtNbRByo=;
        b=RICpDQgfYcLkMSCeCPuOnxosuAVGa6NrGrb2HKoNeG+SrB6lQkR44CYvn4FltnYTow
         zKA00DRglmJKpvw/3hiBOQIq9AoSJDOnESOv+3TdJ6VyxIcFETIKC3bH8S+mPCVFNjQU
         fIXnihu3GlgNbFPBI7lo971zweKK34QkUZR9I5UqtyyN7NBdYHsOf1Xd9iSXgMejmufA
         W7BhuOQ7s6QWC6i52ep/JnV1aaUcKfkFmaU+S5UdKAoV3ok8ok0+nreuARY72GNMn4MO
         8DhGjyfed5Qq9uDExEnV2fanxUGLgOBFabAqVrh0IRdy7qmkjwH0Esu2XF2ZmhwDTaUr
         Uztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WYoXAh4A13G6cVwSO0wB5C6CBf71AyoyKnUPtNbRByo=;
        b=P9JlwkMkuhh4NbjPhhvVwQuMPTcY1fyDebUE7Bj3pYZvUUelISDdETYTc5LutWQIqp
         yDOSo8/XfyY0tPC7+WgfymzEUhyRh4qi26ZLah7856bj8g74re7cKmo9w5BkSnI5UcW/
         nYNJcG/NsoEK5BvvYChKEokxnCGDWJj9nvrwrCGEObjsbBChbcPkpQWJa7Jkzdnoh15C
         /E8VEcE7Gd4R5VURqslAVzlNwDQhmy6k6vCu7HfdP2jBKT2s4YXUv1QImkOlkDbaqLPd
         pkGkBNSqQh43ZWI8ebd4clw26Zxra2lASZ6o8OwnoC5v9vIHnbtIgXpSVB3rTXhLnmYE
         1HXg==
X-Gm-Message-State: AOAM5308mFp4MvQSVn70pyuJZ7PRODKJz3u6wvHPzrkrgsml2RiVGp3s
        y31v9+uogt6p7hBRv5auQ8eyto9hapEBlvJz
X-Google-Smtp-Source: ABdhPJwc1tSbRYJJHOmcFi9+yaRVn83sxDNGFVrpflNSoGCG9lptp1e1I9h+XcEJDHAU8TNrqalvWw==
X-Received: by 2002:a05:6a00:24c6:b029:332:6773:165c with SMTP id d6-20020a056a0024c6b02903326773165cmr3666072pfv.33.1627031361503;
        Fri, 23 Jul 2021 02:09:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm27625630pjr.48.2021.07.23.02.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 02:09:21 -0700 (PDT)
Message-ID: <60fa8741.1c69fb81.c4d8f.5041@mx.google.com>
Date:   Fri, 23 Jul 2021 02:09:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.275-208-g4712f99800a38
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 114 runs,
 9 regressions (v4.4.275-208-g4712f99800a38)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 114 runs, 9 regressions (v4.4.275-208-g4712=
f99800a38)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.275-208-g4712f99800a38/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.275-208-g4712f99800a38
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4712f99800a38eb6f2c4147f125d171b17254926 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa4e06ff891073cc85c26f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-d=
ove-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-d=
ove-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa4e06ff891073cc85c=
270
        failing since 2 days (last pass: v4.4.275-189-g9a5ee5f15ce7, first =
fail: v4.4.275-189-gffa748a4e4ff) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa4e7f12ecf4e92485c2a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa4e7f12ecf4e92485c=
2a1
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa4f318dc5665d1f85c259

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa4f318dc5665d1f85c=
25a
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa4eb0f94dc3781485c25e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa4eb0f94dc3781485c=
25f
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa602624e7585c8a85c272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa602624e7585c8a85c=
273
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa4e7d12ecf4e92485c29d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa4e7d12ecf4e92485c=
29e
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa4ef53e4ee9c2d385c27c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa4ef53e4ee9c2d385c=
27d
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa4e89d20cc562ae85c276

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa4e89d20cc562ae85c=
277
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60fa5fa1a67094dcc485c26f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.275=
-208-g4712f99800a38/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fa5fa1a67094dcc485c=
270
        failing since 250 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
