Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466C44003B8
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349856AbhICQ4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 12:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhICQ4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 12:56:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC84C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 09:55:06 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so15962pje.0
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 09:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z7noYAFkkSIM3cjbJhBvh841ofJZNMlVPTJ1TnEtn2Q=;
        b=aVfQxl5XWUYiBeu3jcqQ5TjPZYCGoYs3sF8dlqW4VodCrgJG3BGftHudz9U0DzpQI0
         /EbVbq8YPy/zvlhwkQ38NloJ98w4wRw+lCo1T+ppcflYYDr2T0hMKxxknH/eS7EQ4QfK
         miSKWWwzoJvEjobd3GkVV46fyuD2NPu9v3Fx7uGgOE4zGmRpQ49krX0kwCaRGhUYbMm6
         mPbkJ4/+QfNxn2KuwQyj61jCDNsPTGwchvo7P4+q44e8MSi9Htu0XU3stqULAKS5rxjA
         A3Rgd8yKVZJBuwwL6HWNXT7yIGJUcndwP0zbgIY/ffwPH2+15DCy92zPJvZ4hIn0ZDRW
         JuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z7noYAFkkSIM3cjbJhBvh841ofJZNMlVPTJ1TnEtn2Q=;
        b=GmfcnPdwb3cWEcC2gKupngfcmUM8KntJYpMHZ2UCORYzFUXX3Zx5+YqkkEYBye28qM
         HBGvSoPQzNVczGe0mAQ/Gg4gF5tstrU1+yy2t6O6kFDRq1bYosjIYwHeZjsFC4EodC9I
         sb1xf/4X92HXSBhbCguZ4bRdd9ndny3cZY4m5cXV17h1NRmmBQKpLcSWCP9gGaK2JdmG
         E39cm5HYiH1cQ9wGEt+ejyyEOSfuzyh3iCQ63UhWWG+W8sUkq7CkGQYYKexoUNADQCNN
         ZLBBsPgjzRj3iWrAt7YkDEgy/zN2FwPtLFZWkSRdZFAVfQ9mxObwDVE3kIG2BXlyv2fp
         uy7g==
X-Gm-Message-State: AOAM531IjQD1P02UVfhvIBafbYT8X1HSxyC/xTlQqDhCDTD4fPH8Slb6
        iffalMhPaOdPTpOx+Dqigq1HXSj2YcgC/TXr
X-Google-Smtp-Source: ABdhPJxpgAISz+Gl2NFixfkzYr7sNhOMkcoEuFtruljPhVS4N7kHDyBnwjbcy2RnndOKLl5tYEPkyg==
X-Received: by 2002:a17:90b:710:: with SMTP id s16mr1733034pjz.56.1630688105655;
        Fri, 03 Sep 2021 09:55:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v25sm5821970pfm.202.2021.09.03.09.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:55:05 -0700 (PDT)
Message-ID: <61325369.1c69fb81.1a918.f5c6@mx.google.com>
Date:   Fri, 03 Sep 2021 09:55:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 119 runs, 5 regressions (v4.9.282)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 119 runs, 5 regressions (v4.9.282)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.282/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.282
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9f6447b82e75839bc8a7f531daa43f74f292a0ba =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61321fcd3495e203cfd59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321fcd3495e203cfd59=
668
        new failure (last pass: v4.9.281) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61321e73bc9d786ef3d59694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321e73bc9d786ef3d59=
695
        failing since 288 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613228c4af9544ff4ad5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613228c4af9544ff4ad59=
66c
        failing since 288 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61321e731c3f6b3c15d596d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321e731c3f6b3c15d59=
6d2
        failing since 288 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61321f8f1f8db4e7aed59683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.282/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321f8f1f8db4e7aed59=
684
        failing since 288 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
