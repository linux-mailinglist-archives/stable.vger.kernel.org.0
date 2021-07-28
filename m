Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F193D977E
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 23:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhG1VYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 17:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhG1VYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 17:24:52 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17837C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 14:24:49 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1so7128310pjv.3
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 14:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LoBKQEqLPu+AmyJfFU/cEIeZVDTvNi13IuHzIgcM4GU=;
        b=Sv/wP6JwpgOMqwr7iNoVVVRxjUn3yNv338CvXh0BuzNjtxX1p1/3D6fMdJ71A+k4t6
         9YLZ4g3ZmbRfeGw4Od97Ab2S1X7tPY+4cgjJAMFgawpuOWy5NgWmxdY6rcJW+rVbWiVq
         n0+Q0xn1UG6KS7JgmqlVpnh3ACp9EZbTtg5MPt52jiBgBur+cbwO4Xv+SwRBTVOBtLnT
         u9yldcW4SdAGz1DAUDurZ7zgwVCMEXe6+avpilOrDnOBSeipI4Khq8majQjA61m9tYX0
         P6HwgAwp5U7lrhOaHkGfCkuIy4HhbmAVOU2X066Ijs0fCneYpmsE6K4slv+pdR/STesk
         qJgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LoBKQEqLPu+AmyJfFU/cEIeZVDTvNi13IuHzIgcM4GU=;
        b=oWT98NxfvGmRKnVlwzm9WkYsCzVYxItrtBtyt/bGiKm8Gny9+WxuvEWUI8lFTVfoz6
         h2Jr7VoAmIuX8r2HCyt3FdtYAcuRbA8kk6eB/ZkcpbqrFZ6oAlX0eMGyZmqReijHR7Ae
         iQK0r+qJs75gFGdqxfxzSeOjDVnA3jPIcp1/8TrNY/iL3PGu3iasvwXo1ftrFAaEBUt2
         +FxWsKCPJhsM1RuOb71VYUK+8/L22LTAtnHeyhguDu9MRfrXtBdwhNiYd9n30NL7P/UQ
         xoSGqaz23BTFGA0S6x+VDzTcqvpYcWloCMXgrt2SO6zgJqQNPx+tRrp+Px65qz2XeKdz
         q1dw==
X-Gm-Message-State: AOAM5305EvtAuT1w0AIMJA3wnnvTwGa8ki2+ZRAcMCnuZNAc3wQdEDcR
        tFHUjAJj0yXX2bbLTotlPf2m+aGAXfKAvaXe
X-Google-Smtp-Source: ABdhPJyGKPEPZjGUwmqyGC3lbg33iAYL8R4JMc0Z73JwnIkx6VFG+yBXzenw8T4S81DGH9ZDJV1iMA==
X-Received: by 2002:a17:903:2289:b029:12c:5642:c4df with SMTP id b9-20020a1709032289b029012c5642c4dfmr1607372plh.23.1627507488335;
        Wed, 28 Jul 2021 14:24:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5sm691359pjo.25.2021.07.28.14.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 14:24:48 -0700 (PDT)
Message-ID: <6101cb20.1c69fb81.cd8b3.2f46@mx.google.com>
Date:   Wed, 28 Jul 2021 14:24:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.136
Subject: stable/linux-5.4.y baseline: 155 runs, 4 regressions (v5.4.136)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 155 runs, 4 regressions (v5.4.136)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.136/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.136
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      253dccefb5cb05c8a017150c34daf810776d914c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61018f55628230b6b95018ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61018f55628230b6b9501=
8ef
        failing since 251 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/610197eed73a43897a5018cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610197eed73a43897a501=
8cd
        failing since 251 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6101979ce251e43e925018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101979ce251e43e92501=
8c3
        failing since 251 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/610197c4d93c0daabd5018c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.136/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610197c4d93c0daabd501=
8ca
        failing since 251 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
