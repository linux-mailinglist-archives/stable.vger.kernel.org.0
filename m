Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100343FB69B
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhH3M6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhH3M6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 08:58:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C02C061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:57:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa17so9438018pjb.1
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ut3YD4fMmkQVD4cEpbbCR/xRyx2ke+oFaYIhxclnpiI=;
        b=nFwu7vbUHU3E8+kceC2akufBMU9bv0KoQga5ZEnX5P7GRY1yZYE0/NapYZ7HO/Ax4K
         bYhzp+zxl4Z6bqVo41WwzLITbEoAzFQRFPzODb+tsREJ0FSPJBgGTNIdrsGI+PW+WjSe
         un4a3qDSgh2LmQLawHwz34JJrHZr/+QCVjn6l0rCvxNPFGF1igmGtyHVpXhL3uiwAPrY
         LIi7E3f+f1S5tXj3/sKMxH17u3sHJXO5Y/IZIm2DqmQd8+tT9z+1RI4lRQ2vC+VtVaus
         IEqBEZsi5g2Uwge5v93wZN+QA6s/CvlWOQZkMhJFvCZnU6libPkH/CyO6CcTT8nCe/W7
         /ZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ut3YD4fMmkQVD4cEpbbCR/xRyx2ke+oFaYIhxclnpiI=;
        b=K+AwM0S/Kx6iPO7axXAU4aqPu1/F9BymUSY3k3w9npvAXiXSHwiXdYhoQ2R62lRjEZ
         NsRAnmWjmvH/ll+woUWhhpJ7gd5ZvW8WOaiepBHmSSVu4WxnxeDLqZgUDh4s67QSmzDS
         MQ+SzRlrJI9ECl2i28fzi+Lomh/acfcAdHpb+A7KFoIacd+0/9LUfFO+HIYGNluuRwsU
         r0ZaoUSO35f08drQJ7Dnsn3PiQ0RkjWHvUaLuPrctJcw9dK2D2ODER1/hOO5UMD5a3EH
         brGtP0RykKhcTWHFMTA+RRiYKaPgAUKwEwe3h40LxcecUerqUX2TLANIu7ak+nndR6JZ
         18aA==
X-Gm-Message-State: AOAM533EWWDKB6y70Kx2DM0rDrw8z2/5BfI/25ZKoT8i5haVIVeC7p2o
        /7hKWSn4VDNqcz+8MODI/L/g7iubO+cw3qc/
X-Google-Smtp-Source: ABdhPJzeTzNekpgZ/4S4Tw0cNVG5I/CgJXAqWCCDy749EEjfaTQYouudMJFNnXS7Wd2p/O3AbNuDXQ==
X-Received: by 2002:a17:902:7584:b0:12d:8cb5:c7b8 with SMTP id j4-20020a170902758400b0012d8cb5c7b8mr21673867pll.84.1630328268578;
        Mon, 30 Aug 2021 05:57:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 132sm14702887pfy.190.2021.08.30.05.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 05:57:48 -0700 (PDT)
Message-ID: <612cd5cc.1c69fb81.8d55c.43b5@mx.google.com>
Date:   Mon, 30 Aug 2021 05:57:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.245-13-gcc28263d7625
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 122 runs,
 5 regressions (v4.14.245-13-gcc28263d7625)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 122 runs, 5 regressions (v4.14.245-13-gcc2=
8263d7625)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx6ul-14x14-evk     | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfi=
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
nel/v4.14.245-13-gcc28263d7625/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.245-13-gcc28263d7625
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cc28263d76251aea0d1848beb508cce2c5c46574 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
imx6ul-14x14-evk     | arm   | lab-nxp      | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612ca87170fd7950428e2c8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-1=
4x14-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ul-1=
4x14-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612ca87170fd7950428e2=
c8e
        new failure (last pass: v4.14.245-7-gc8c7d84be632) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/612ca2d5f2dee506f48e2c9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612ca2d5f2dee506f48e2=
ca0
        failing since 516 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c9fd2d4df4aed8a8e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c9fd2d4df4aed8a8e2=
c7d
        failing since 288 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612ca0fb19ecf41ed98e2c9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612ca0fb19ecf41ed98e2=
c9c
        failing since 288 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c9fdca1ec96d51c8e2c93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
45-13-gcc28263d7625/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c9fdca1ec96d51c8e2=
c94
        failing since 288 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
