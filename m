Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE99137ED82
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244544AbhELUhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357293AbhELSiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 14:38:22 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7F7C06138A
        for <stable@vger.kernel.org>; Wed, 12 May 2021 11:34:40 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id i5so14071821pgm.0
        for <stable@vger.kernel.org>; Wed, 12 May 2021 11:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=axophDw2rOn3fSlwQgcUa2rNJi6Lzu7lJkM0tDXsr5M=;
        b=lmbefM/NG7IgC5LLhPAeGxIMIMOd/pb2EYvk+JKOdq+zWxIgvPzRP/UQ1taTdBsBSy
         hE+o8S/yY1DAZ+h4ALAEut6qJUdKUx7Oax0qK5pdKdSUFGtb6wjMgki2vTQIgtcNYv5H
         ThlM2AY10KO58FGomPX3MjeTts729LMm/CYU1FjX0c8YAxhHG7BCpGTQIRNE/7vsiWLM
         n2DMJBqvWCNhkOq13JmDhlguI/LYqfo/+U5m3nPEWwlusIMC7u1NKGbM2GN7L0VTaHNW
         7zQUOlWq4i32QH36mpZ8Ec+ohn52yy0pedOKfDyRHTqxWZ6+6LM23qQLePpq+G/+xYGX
         AeSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=axophDw2rOn3fSlwQgcUa2rNJi6Lzu7lJkM0tDXsr5M=;
        b=bQB/37DvOhKXP+QTPrXMAJUz3DlmmyUWrmvh6Q8RI2ehjb0yeC/nymWBIyNurW5m5W
         PyJe1T3/24HEYsus2ymlT5pd83h1c9Xc1DF7fkuipYW58N2eSOGoYHiTsT85gm3YWej+
         DmpPL+XUV/1gb0x9ZCxr8U9d1vgDCqfYiaIeipo19YLv1zZT0wcHYSR/QfBbd7jfXAfD
         feIwLeMKVj1vYTtWU4Tno65HckruxH+mqZUfEQi1oX9KFzKPcRvi/R5dd93I3cn9ETjG
         Ehgx71XUNZ9xSybuqsUCbxvQo7p6hmNdRyQfSjSy7psc4znk18jn0eVKWrKg4a4XC5YG
         6U0A==
X-Gm-Message-State: AOAM5337/N96EETN8VcXxfM0Ly9fNYojMkiAotongy1awS28ImMaQGNN
        yUTVV8DBNYmZQ6PUQ4FLUEsr6i3zxsFIjpf7
X-Google-Smtp-Source: ABdhPJwpbsrAKsdXHiMWJy3SX8xmJJDmhNVNv6K9e10kYSwahxiuEn+IHvM0ctXuXIauZc3y94Q+3g==
X-Received: by 2002:a63:d47:: with SMTP id 7mr38254512pgn.400.1620844479455;
        Wed, 12 May 2021 11:34:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n30sm446715pfv.52.2021.05.12.11.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 11:34:39 -0700 (PDT)
Message-ID: <609c1fbf.1c69fb81.2fb02.1fee@mx.google.com>
Date:   Wed, 12 May 2021 11:34:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.232-232-g70a041fadfacd
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 5 regressions (v4.14.232-232-g70a041fadfacd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 5 regressions (v4.14.232-232-g70a0=
41fadfacd)

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
nel/v4.14.232-232-g70a041fadfacd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-232-g70a041fadfacd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70a041fadfacd18c186e01bc61a861d848be5d3e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/609be8ff87508bbb96199291

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609be8ff87508bbb96199=
292
        failing since 72 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609be6d739c623f9401992a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609be6d739c623f940199=
2a6
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609be6dadcb187e35d199279

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609be6dadcb187e35d199=
27a
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609be6d839c623f9401992a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609be6d839c623f940199=
2a9
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609be69724f760203a1992a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g70a041fadfacd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609be69724f760203a199=
2a9
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
