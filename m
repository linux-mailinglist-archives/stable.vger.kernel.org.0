Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933FB3FAC66
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 17:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbhH2PII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 11:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbhH2PII (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 11:08:08 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51990C061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 08:07:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so12117245pjw.2
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 08:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4nv+cnacVxv5arFVB0vRbqDqL5/oERLTFlgy0AP8oD4=;
        b=c6NvyDyX+odbMbtF5WGsagF3W48tx4/1MXdrQmVAp9HFv6UIgbIIwusv8IMIq8EUFj
         BZcewmDqEagt9mzzJBib6SqjoVdeeNX8FELQSOq8Zil1px5Kv3Wwmfqxcv5p7TqLbLty
         eUhDJVQ5LupkDgqgIe8X6Ebys+/OGodBotrZM743Dxb65nw3E19l5O0zouaiSBYxiseH
         ubLh5U5DX+H4aAsHmVR3mwPJ3+7uQbbH3LRMQDQiMNQt8avl6fFvT+PLjY2mLduQ09jh
         HGW3EG+ng2o3R/IqDdtmBC8er4DoCzzBXWTw4oI4NDtjoRpsvKpjwoCRoUwpSCZkySOv
         7Fow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4nv+cnacVxv5arFVB0vRbqDqL5/oERLTFlgy0AP8oD4=;
        b=rZe2r3eaBGNytA41zDDMCeEtg9b0zhmNvHBHStIIsz+og8NqPXqDOlKpJ3/G6uHJVq
         WbRf0encGKWzT3oOKIoOQhEquDPxI06IS0j01OdBldW5midkCxBnwg4SFX82E7ueibnT
         Uy/mIbS2cIbFtBDZc1jnc6xH6Z0dOw5JCDaCkwv8sCMl/4fALjW3hchQkh5J7Pmmx5gh
         4DqeKS9Uf6IILSSpBeebTL1EMDJlEe38CKgmU2U7TXdq+456om8WAod180vTVbpQDbC5
         mD//zuQ0MgMaUS+hd8zdBXNvA+iPPnvDT3ct71IYj/ik40rBqCHzboroHjw9XIxwAPH/
         FmVA==
X-Gm-Message-State: AOAM531/s18m5eMq3kfYw72VAHGEm5UD4uJnCJ3J9McZRSjIjT/2Th4k
        Gs55ZNkmWHNmeFJaAOesVXj+vLlDI7EBUXdl
X-Google-Smtp-Source: ABdhPJxhATZmmwzxMhHaVfJHvSKvjctL9gWxPfJaOUvgFkXgRilLNQ6PFCI+lWH8EDOhOJ4apxccBA==
X-Received: by 2002:a17:90a:8b95:: with SMTP id z21mr33152009pjn.131.1630249635685;
        Sun, 29 Aug 2021 08:07:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p16sm917665pfw.66.2021.08.29.08.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 08:07:15 -0700 (PDT)
Message-ID: <612ba2a3.1c69fb81.1b36.1abb@mx.google.com>
Date:   Sun, 29 Aug 2021 08:07:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.245-7-gc8c7d84be632
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 114 runs,
 5 regressions (v4.14.245-7-gc8c7d84be632)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 114 runs, 5 regressions (v4.14.245-7-gc8c7=
d84be632)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx6ull-14x14-evk    | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfi=
g | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.245-7-gc8c7d84be632/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.245-7-gc8c7d84be632
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8c7d84be632e1def35813a96d35cebee4c2695f =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx6ull-14x14-evk    | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b775d78d6a6a67a8e2c92

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b775d78d6a6a67a8e2=
c93
        new failure (last pass: v4.14.244-64-g156fc46e6ef4) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/612b72e0c20b27d0918e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b72e0c20b27d0918e2=
c78
        failing since 515 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b702688cca526418e2c84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b702688cca526418e2=
c85
        failing since 287 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b70a7e73025d71f8e2c89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b70a7e73025d71f8e2=
c8a
        failing since 287 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612b703f96938f81348e2c96

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-7-gc8c7d84be632/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b703f96938f81348e2=
c97
        failing since 287 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
