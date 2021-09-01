Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFF93FE560
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 00:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhIAWSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 18:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhIAWSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 18:18:14 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2B4C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 15:17:17 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id t42so36502pfg.12
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 15:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5AzMFQbQKGNVdyLSqlVVBQA5KZu2uyBDJiOIh2SgYh8=;
        b=W25bksO4tOh+UlCr737AuI9LOPwpWdjSz5lELe+JmbmPYcH6CRN1qX9QQZUERafny4
         IS+xcbitroHcpdYTo8OrNXCMjuqJZcSL2C/6MvUGUPe3NqNAA3ZeK3juZ6SPJS9XdbLm
         tdz5tGhxkEzSoV0BU7JzylClIsL3NpN3ttrHfya9psOGrk5tyDem1m3mcdpMYGJG/kII
         vaZBwX75TPoHbAN8LKHzYiwt0NAkxJQRVBGkLXtXkukH/RRyH/lNsvQpjYXx2hK+Gh1s
         9aLH4gDtfQFvUWQm/yIbu0q04qPicr+rbd/ORKFeenVdReSiKN8Y+WrjX4RXaFWMtMU+
         tiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5AzMFQbQKGNVdyLSqlVVBQA5KZu2uyBDJiOIh2SgYh8=;
        b=lz6FGhQR86PPsj1RBGE6w34aAm6PDWXCwruOjDRQZ/613xd6fwOVUDOF+rPAqJJOu2
         kG2VypSUNYaJihx4N3QhpOHWm1Bh/Qkyn0OsQapMx/w+xrHNEIbzWC7xVjp9CAT8wsHV
         X3rdFMrXJGdqy3pTH3CcumCM/UcJj5uv/ZFWmRNBFavfg023yyIkm9JojzbkRncrp0yl
         HfgHuQNb/PMobmkotJmpz4A8T/bqHwcYRPG1xYdU1cAtzaVCyu74JYezpMtUnHaqCJ1J
         9Gry5OZjXIL2ibuFmynZuHvKkNBKJBiaq3HH66zda3v6stDghWYcTdZ/wxiMaIXiCzyH
         3c1Q==
X-Gm-Message-State: AOAM531UJ/RQHemEY9dodW+pgVLYJp1ZVhrvrx+XTOV40WyJZ6FVu9HW
        HdE6WHAcSX35Kk1dVu1yJ0+tcc/tXJYAnpRAWeA=
X-Google-Smtp-Source: ABdhPJydMzkIu4Fj473NjKUbRn7wDIWM6nB8VzXP/Xciif2XnlF0mtSSg0AeaGLoBsERPKj4BUBf+w==
X-Received: by 2002:a62:1a8b:0:b0:3f5:1b90:415b with SMTP id a133-20020a621a8b000000b003f51b90415bmr55700pfa.51.1630534636330;
        Wed, 01 Sep 2021 15:17:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w5sm646945pgp.79.2021.09.01.15.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 15:17:16 -0700 (PDT)
Message-ID: <612ffbec.1c69fb81.22202.2db4@mx.google.com>
Date:   Wed, 01 Sep 2021 15:17:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.281-17-g8256eac05712
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 138 runs,
 5 regressions (v4.9.281-17-g8256eac05712)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 138 runs, 5 regressions (v4.9.281-17-g8256e=
ac05712)

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
el/v4.9.281-17-g8256eac05712/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.281-17-g8256eac05712
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8256eac057128912fe69a399bec3c22f7f9b77d0 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/612fc669f3646d9925d59699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fc669f3646d9925d59=
69a
        failing since 291 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/612fcd56889aed6351d5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fcd56889aed6351d59=
66c
        failing since 291 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/612fc661f3646d9925d59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fc661f3646d9925d59=
675
        failing since 291 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/612fc6be870e76bfc6d59675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fc6be870e76bfc6d59=
676
        failing since 291 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/612fcd32eabb0b40d2d5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-17-g8256eac05712/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fcd32eabb0b40d2d59=
67e
        failing since 287 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
