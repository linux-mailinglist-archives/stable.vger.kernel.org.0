Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397AE3DC610
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 15:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhGaNNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 09:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbhGaNNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 09:13:50 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E44C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 06:13:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u16so5842289ple.2
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FUXi17DVKZjcBk8gd5iJkI4Aa7KGuzA+l7zMvj3wbwg=;
        b=IoZNP6tCNgnc/d47IKgmOmkjC4xoRH0m1s2WFjxyJY3iKgZPAxAZ4NZvFsLNPgg624
         wk94s5TWXkdHicqXXjrjfBVcyZsPnnBN6fOK8w4qeTn03tzgzzE53r8LBI3fyv/q23PJ
         ukkEvupyIQ6QMFeRrRbc0hQisCcMGLlgXQQPPUZnKvalO4k0TeQK9YbjJHm6lpnNEtyh
         gtRGwLKy7CMNstCWWet6Wok71NKAsvtClctyYYAB+4BSPQns+KG1x72qN6OQ03GoooQz
         e3+yOF1FWXALEFiGK+z6aAHZLoVAwAsLMjgSridltSNHkGpqJBJQ4Z302q9ablhkEe6w
         gq3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FUXi17DVKZjcBk8gd5iJkI4Aa7KGuzA+l7zMvj3wbwg=;
        b=YSBKXBJLkeLKqrOjfzzlIhKxyhMBjuIhCla3SC4uPuTvPxJqc61C274+HqElCdr5iI
         3wyUKsHkMS761nKsyx3YCM8KGzUsV2DsD4Ja9DD4FR7gxKBYuz33iDcuGZBLRG4pspRk
         OKhhJMNlBT7jpw1uR0D82+9H3AiCLOteULj/F6BdTu1ZUE/lUXHRFVGMKJjD+hkTa/4q
         hDEfPCYoBCFlI+qk7wrDSBvavcuUpoSGhuhCPqaYr7/j0kt00/GkYLMcgWzsjkAoPJ6O
         L099v3tIRGajTVYJ4qgCNHL3u39VLP7qX3yvaBUm8V+tQGhragsSxF8DGlXn7caKooly
         OXzQ==
X-Gm-Message-State: AOAM533AVlMxhS/NzCjiGqz5tt0V+WMPcQEWsRu/CH73SBC5oJQwbmjQ
        7UclBCVwrX9gAgCPRFTCdqrWrH9tKypW0hVc
X-Google-Smtp-Source: ABdhPJwmbxpclkqUm8ZN2TuCr5LlL/6gW+I81smepHT70tpDecDRQT0wC+DwTC/fOqIFT64iRzgxfg==
X-Received: by 2002:a17:90a:1503:: with SMTP id l3mr8040337pja.130.1627737223744;
        Sat, 31 Jul 2021 06:13:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm6533637pgi.78.2021.07.31.06.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 06:13:43 -0700 (PDT)
Message-ID: <61054c87.1c69fb81.ed1f9.1938@mx.google.com>
Date:   Sat, 31 Jul 2021 06:13:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.277-24-g72acd6f4edb7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 101 runs,
 4 regressions (v4.9.277-24-g72acd6f4edb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 101 runs, 4 regressions (v4.9.277-24-g72acd=
6f4edb7)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.277-24-g72acd6f4edb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.277-24-g72acd6f4edb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72acd6f4edb78cbf511e9c3f5ebeff7de4c36d05 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6105150f74f5fbd6b285f45d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105150f74f5fbd6b285f=
45e
        failing since 258 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6105185948c2d91b3785f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105185948c2d91b3785f=
45b
        failing since 258 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6105151274f5fbd6b285f47c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105151274f5fbd6b285f=
47d
        failing since 258 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6105154b7ee5a767d285f46f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-24-g72acd6f4edb7/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105154b7ee5a767d285f=
470
        failing since 255 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
