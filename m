Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C6D3CEFA9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhGSWam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376501AbhGSWYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 18:24:43 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AD8C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 15:57:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g4-20020a17090ace84b029017554809f35so777484pju.5
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 15:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vZAhrbo6n7ZsN/Uzs4rjzMyh7rE7TB7E/+sukMvGgVs=;
        b=ZjGzisE0s7/B0ppUlrg5MlyR3WjOhzHYCF94tipBtSn2oxBe6ABfxPkfMhoXCVU0+i
         7O1VF0vrsDbDmrIzjek1DcGlcGrefVQtZL3E1v+wTv0q73EKbMGRbZH2iwwlVVQtl/JA
         FxFX5Wh8EXWC8pWF7FNbOtm4woI4vElnhf8Wf6BZfg3Wb6dpumgq6Z70lIuCoRpoP2tE
         2oP2x56cdKiJv12wM3U6sXHIfIH4aO7NTIIt/1wOCcPakaqEo70ra/7NgnT3pe94TNJn
         pZg7PsEi0ZbZjfPMPkHACEAWhbzZABIjtrei68Xb/dlMF+k9ZflI44blDfWl6IEPxGuv
         jaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vZAhrbo6n7ZsN/Uzs4rjzMyh7rE7TB7E/+sukMvGgVs=;
        b=c0tRKuTsNjr6mTh5YuZ8MnL+20iI47/4UN+bfToyeGDKp6eeLD+zmXjugB7YW5wkf7
         hWuRJdQSQ6oIFno4JLd1YcNCfBvewMGAKDx8isxb/sStM9wD2Xmj1QVTH2oOjedgOdwS
         PiNNMd9bEDXj3D/1tVyB/jda7cJY/mz3WKaMh0Lnprrp4Ts4+Xc8w7ZKgBn3/pBkPzv8
         rvqmoReqd5OuZVjPEEAq95n8aeVbz2M41g7tfZQnOy/A1PwziHaQaOuyjiong/xhzIuV
         4+Ec0XgN9zafQv3bjpTWV6B26HICzsehb7CC/CUvHmMvW60rYnzGW55WHD+JMIdC5iet
         2jNA==
X-Gm-Message-State: AOAM532SLV32F1QhLdr2i/1HPm2pHlJu4Fp4hj/t5dXYivZICQYQDaEF
        RiISvRAlIQnc2oakFh/LuLEoE4FLL3LxM4kr
X-Google-Smtp-Source: ABdhPJzxcyyXd4pxBHh7uDeiRAR+qui7OTiYSDunHSXuW1NeVazjIQrIQo4fvnEwPr0QnIrfZnF3Dg==
X-Received: by 2002:a17:90b:310a:: with SMTP id gc10mr26757828pjb.173.1626735473730;
        Mon, 19 Jul 2021 15:57:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q4sm22193907pfn.23.2021.07.19.15.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 15:57:53 -0700 (PDT)
Message-ID: <60f60371.1c69fb81.8eab6.0fdd@mx.google.com>
Date:   Mon, 19 Jul 2021 15:57:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.275-246-ge0e2485d7d5d7
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 132 runs,
 5 regressions (v4.9.275-246-ge0e2485d7d5d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 132 runs, 5 regressions (v4.9.275-246-ge0e2=
485d7d5d7)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.275-246-ge0e2485d7d5d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.275-246-ge0e2485d7d5d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0e2485d7d5d7ec3169736be095949496cd8dc0e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5cc95bcb71ebd5f11609d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5cc95bcb71ebd5f116=
09e
        failing since 247 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5cca24f5fe737401160ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5cca24f5fe73740116=
0ad
        failing since 247 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5cca1c325e1468111609d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5cca1c325e14681116=
09e
        failing since 247 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5ec2252be5fa56f1160ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5ec2252be5fa56f116=
0ac
        failing since 247 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5d3c2fa7f8cf09f1160d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.275=
-246-ge0e2485d7d5d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5d3c2fa7f8cf09f116=
0d4
        failing since 243 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
