Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8586344BDA
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 17:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhCVQjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 12:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbhCVQjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 12:39:23 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373BDC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 09:39:23 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id h20so6884723plr.4
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 09:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E0rOMtvWsr2A6Z/paEuaU5KFGWkvP+UcCsbPpo9Dg/Y=;
        b=suzcb79TL8rN4di2qC5psavt/ssmoNRBZiqpR3ezcmnjVleye3FFVdMkzNXSh07loR
         U2ZTthmZOmyFCOO1UigOfXTPO5+XCGXeGmquAEoz98+v7PUeAdsKrKkuLmIb+RgLky/j
         188d8vFxYC1dvJWU0nQP7o9t94z9ooGYWVCTONNqK8k0pzO/PfnlwZD9WoUUsvMWPs5c
         Dcx0E/aZqsFm3gVl+oES8tIijtTPtFMA6yRGmvhbeM4xbySv/kuOXiL2tCDjuJ89DRew
         FD0sIBOkTCdyyv8rWnsN4+sYNiIl793P23AZBhM90BBKLIXlYgvstX+HP0G3W6MENnWl
         jkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E0rOMtvWsr2A6Z/paEuaU5KFGWkvP+UcCsbPpo9Dg/Y=;
        b=hqVdevvw8sO1kLtpbNxgHXMGm0oeWKHV8tk4bd4bp0H38f+jO7/csSaNaHRv0v8HSf
         OZDG15/fwEZxrfVlm2aAIUWmE2JZr5wihNoW9Be6N70ifhgb/J3Bu6TDXpaKczp3nyMx
         g5jwfaIklIfuR3SqlZPYI3JCexYSWeZjvdhRukWP278HskyXMC0qgN10U8wrXi8xFYb8
         K0lynKDToAtP2X0jEBlDTQsbDWXXfi48MIOODwMT7vmVf+VjPPwSV2wOKZe+XmsclW2q
         31W0YFJJBCv7rkxXpqw3F24PsvBpZKLuehSEINTItkf89WW36xM4Lc7fGWp1Te2lpb3E
         EEsQ==
X-Gm-Message-State: AOAM530c/BTE7qjlUKuCPkEcyi04k1NkEAo7xVClpyO5DiOWHZfw4UdC
        auaUHblo9DiDD4v1Xf8zFXCIEcwk4yHD+g==
X-Google-Smtp-Source: ABdhPJydy2Y/8dFOtBT7mdUCSMpI09C88azz5c+ftSL2Qsxuy+hlNcl8IxtYP2Xg4ULmv/EK8FwvEQ==
X-Received: by 2002:a17:902:7fc8:b029:e4:32af:32da with SMTP id t8-20020a1709027fc8b02900e432af32damr654983plb.24.1616431162555;
        Mon, 22 Mar 2021 09:39:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i14sm14712790pjh.17.2021.03.22.09.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 09:39:22 -0700 (PDT)
Message-ID: <6058c83a.1c69fb81.23825.27fe@mx.google.com>
Date:   Mon, 22 Mar 2021 09:39:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.226-43-gaf4ddeb7be22
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 123 runs,
 5 regressions (v4.14.226-43-gaf4ddeb7be22)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 123 runs, 5 regressions (v4.14.226-43-gaf4dd=
eb7be22)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.226-43-gaf4ddeb7be22/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.226-43-gaf4ddeb7be22
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af4ddeb7be22b75d98cc5333261ac263fbaa6b1f =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6058bfac0b82d2cd72addccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058bfac0b82d2cd72add=
ccd
        failing since 21 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605894352ff12575a5addcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605894352ff12575a5add=
cd3
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60589437b5920159a3addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60589437b5920159a3add=
cb5
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605894312ff12575a5addccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605894312ff12575a5add=
cd0
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6058bbf170bf513ca3addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-gaf4ddeb7be22/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058bbf170bf513ca3add=
cb2
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
