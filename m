Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDF535C95D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 17:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239508AbhDLPDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 11:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbhDLPDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 11:03:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BFCC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:03:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z22so1386332plo.3
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 08:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wD9IQc90oud+iCqRyOupIvQZUMgB1eRPGMYQFVmj9/0=;
        b=TTb61KtKAMbZUKnCq2m//3893Ln5i/hD0KbVMlFsJf0dbMOYaaf0u+/rZQH3Skn2/L
         Dg+mv/kZ6p7LPzS+KLJiFvV8jCoSzXQ/nLrpcZUZPUATp0eHfq1QkzzGR7up2f4TE2k4
         OEPF8/zZQ1vciguohmqcbAiQGqHdASjZ47IhS3M51s9bmdO757nBkJeDoNvt4C0VJyZ0
         E/MfQalgtQB1fIW66YD4DzeqFXxuBdEsU3zwl9NPrxHFQqG/S0dHj/UknKTMYeHkxcne
         KRMZfqPabRasv3GCVNVUeVOGzW0UxRENwOrLpV+2yxCPlmx7KAt98DBgvRdZmF+MCQbY
         NQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wD9IQc90oud+iCqRyOupIvQZUMgB1eRPGMYQFVmj9/0=;
        b=ZcqPKZCbhPUjMV1v4ljbYd4Mqn0gfpGvWG7Rg/+QfZa0KjucjYsntrSas+548tj6Av
         gfcaHWsZWZLR2/43iOg+CVA/SdAHvrc1w9zYWGVp+zOATqTPzHs1zZ9TAqij3+xjuXJS
         HGOctJAw3oP1MLftPh3bf357nQ3ir3llYXotBIzNwj1/5fYuxtUv5i8vqn162BV2SCqK
         XgmZxkM8vcW+M8SxGcjJufkCiG9r75FJmwH/+eOu6Iblarplb5wm3tKO411IfMzktdvz
         kMFH4n3Swe3djmHZjROo7NLjSm2zJp7V2ZmPtD1wWiPIQtDUuZ1RQt9GmUUYKE86aXRm
         GWuA==
X-Gm-Message-State: AOAM532uJyaw3mQWMoj2JQKAkQnBoc8XQ5ye8Yq+koh4y9867UGbuzfv
        y1PjT8ukdbFO2aSvZpd6tC7kPL8Gy37Xc6NG
X-Google-Smtp-Source: ABdhPJwuTnQtLbk+zPo1w6fOiDP2zhzM7KzNg59Oj51I2ybSfs+OzpZKn2JeUUUly+s63cMUTqgmLg==
X-Received: by 2002:a17:90a:4e0b:: with SMTP id n11mr5562630pjh.108.1618239803997;
        Mon, 12 Apr 2021 08:03:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k13sm9584434pfc.50.2021.04.12.08.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 08:03:23 -0700 (PDT)
Message-ID: <6074613b.1c69fb81.d2a05.7a20@mx.google.com>
Date:   Mon, 12 Apr 2021 08:03:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-60-g9c0b97ea1e558
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 105 runs,
 5 regressions (v4.14.230-60-g9c0b97ea1e558)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 105 runs, 5 regressions (v4.14.230-60-g9c0=
b97ea1e558)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.230-60-g9c0b97ea1e558/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.230-60-g9c0b97ea1e558
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c0b97ea1e558b579cf048703c6ddb24c5c9d7ad =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60742b299e0d0612a9dac6d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60742b299e0d0612a9dac=
6d7
        failing since 376 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607429f5d863aeb8a2dac6f4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/607429f5d863aeb=
8a2dac6fb
        failing since 1 day (last pass: v4.14.229-15-gbbc0ac1df3446, first =
fail: v4.14.230)
        2 lines

    2021-04-12 11:07:24.631000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-04-12 11:07:24.646000+00:00  [   20.359924] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6074274b60dcb03f91dac723

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074274b60dcb03f91dac=
724
        failing since 148 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6074274b60dcb03f91dac720

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074274b60dcb03f91dac=
721
        failing since 148 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607426faef707a34e6dac730

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
30-60-g9c0b97ea1e558/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607426faef707a34e6dac=
731
        failing since 148 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
