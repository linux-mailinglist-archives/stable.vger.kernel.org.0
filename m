Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EA63EC3A3
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 17:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbhHNPot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 11:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhHNPos (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 11:44:48 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68719C061764
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 08:44:20 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e19so15771554pla.10
        for <stable@vger.kernel.org>; Sat, 14 Aug 2021 08:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QmVYb+z43F87hwuVtiZSJL0C4tkr8C8IvU+ntpBhPzE=;
        b=W48hQb+bNsRdvLNE9N5CVFxiXS9lzPlJqH8WJDE0LCM560hUvHawquEqjjBJA6YCJW
         WtAoQB1DWE6zui3mXdXQ3XdzljqwKSY+OECamdOuHEe7OKo7CfFTXzfbmxJm/gOoN9TM
         yUFmPzFKzmlkAkpMLgEDbDCi9hRwJlAtBgMrLauHwD4uWWwkXmLP4LqCL2OlkWUBEE/N
         wHMLCNo+VwrA6JRBf7ZI6z766nx8W4Jg3XFZMryCoj+VZVh3qwIVSsohCc/W6aMWZ38T
         4iHAal1WlbWyYgiEqgjQ6uieScdBMQAuN7iI+Mv3Fbi59JQVuI+Yf+rsSHxl/Z5zF4vR
         7MEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QmVYb+z43F87hwuVtiZSJL0C4tkr8C8IvU+ntpBhPzE=;
        b=E4bzN+5df6iOZ7iq1ov2Rv3zM5mfRlRp0qvyzh9v4bwLcHMMvu1Z5AiCNmzCoLF7Cn
         +JbXLMzq2wyAs0aBzjTmbFwKE8znl9q3koKqSaxWtekvg24lretOCL4bJLaoSz35yZ/f
         F8SnplAKMERbi59ROrXc8jyWYdCAPqA+dQq1ehHoXCYeZKRdCEIsMLe9DFsn3gWzTtRl
         hZYmpj2f02C2fTeFz/QbprCNxmJlHm4WKJ86GlphKJk6hsQ44FI0+jxh05S8hZlCmaVv
         ZU/ovvZ3G5krNmh2/WmDuvcbAIWLNUQ5cS+ipU2o6FvP6RZNGeSQyILHqjVR5UleGGB1
         WDXg==
X-Gm-Message-State: AOAM5334h7SskYC93RwbnfH1lfwcb9zvKuQo2MU/rJ9lcjBkyEqU6n0+
        PjwFsooh7oviLWeVSCtkRaw/8ih1kpHS5EWh
X-Google-Smtp-Source: ABdhPJy22kG8S0pOqGGF6fe2PrUwpfT8S5svI7evVDd1hrZd37O6f5vjmPiO76qcKPACpgu+3TNuww==
X-Received: by 2002:a05:6a00:2171:b029:3ab:eca3:af59 with SMTP id r17-20020a056a002171b02903abeca3af59mr7598907pff.46.1628955859694;
        Sat, 14 Aug 2021 08:44:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r10sm5995975pff.7.2021.08.14.08.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 08:44:19 -0700 (PDT)
Message-ID: <6117e4d3.1c69fb81.ed963.f23a@mx.google.com>
Date:   Sat, 14 Aug 2021 08:44:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.279-31-g5124b049250f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 128 runs,
 5 regressions (v4.9.279-31-g5124b049250f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 128 runs, 5 regressions (v4.9.279-31-g5124b=
049250f)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.279-31-g5124b049250f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.279-31-g5124b049250f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5124b049250fa384487453ee2be70fbf82aea45c =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6117b01ff36b899d7fb13691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117b01ff36b899d7fb13=
692
        failing since 272 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6117b023d5daad9485b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117b023d5daad9485b13=
66a
        failing since 272 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6117afdb7f169b4405b1367d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117afdb7f169b4405b13=
67e
        failing since 272 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6117afcd903196cf0bb13676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117afcd903196cf0bb13=
677
        failing since 272 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6117b10caa94f3054fb13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.279=
-31-g5124b049250f/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6117b10caa94f3054fb13=
681
        failing since 269 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
