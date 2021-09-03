Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2D8400403
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 19:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhICRVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 13:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhICRVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 13:21:31 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F46C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 10:20:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so58203pjb.0
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 10:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wz4DiQ6P5qTn72M2HH9YU6e9unUFqjE+VXpGzexgR9E=;
        b=K3aBScGzNh16t/gDMfPfpLYWs6boLIn/BBOSJQwAclnfJ7D7cj/p4CxIzI9j+Fu2yl
         5YncxerSNQ7CqhIpj9pLeBt4qzxznZ4wP+uMUvF63/Gyq25l2i2PufpSwChJrN9dsBd8
         3ofnfqdjIMktdBHT/2HPCFTBXlSAJsM33Q6yi47Zv+Cb9rgQBaGG/rbeQxqlVG1G7SIf
         dcom6Ur7VBjvUUc5aERImZrxqSc41aIQ4QxjZ/7XizN8z0S1d2Wwk36+GK8Lf0nonCTD
         7rWBg2ugXCXTpioCZ87zc54Zm+E08z9bXm39JVldmGKDiTslZILcawG/+/IKupIDTlw2
         umEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wz4DiQ6P5qTn72M2HH9YU6e9unUFqjE+VXpGzexgR9E=;
        b=DWqeWzim9UAAHRQNsBvnD+Sg2iOwrThgUCFG9t5+FpZCZ+NQHC2dWrEZOI7/PSF4AL
         ATGg786EYh8mz1rEWumfW+Ncpo91v0FCX7I9urk/FcAzfrdyo2X01wahl4RFKXOSJK7K
         lPTuPj3F53WRHHYtMVEtuuhw0k897DiA5Dhzn4nEpUA9KvbpXwkx5Hy8KNkAWGd6iubg
         UEbbzLVT/GApYFnNn00mqaM707Rpx25Um35rDGMa7EC5zA+1Pd6UAM/7M/QBWC/V99xZ
         03DemVZ+EVWxvM5Pe6ibE+sFj7n/ySUOZpi1ABKkz51AaW1RmlTmWYoM7l4NaUsW4Ocf
         T5MQ==
X-Gm-Message-State: AOAM53153Ajet609FBEnDFCAAHbYKxJav1oPUxKGnNqPSoy68MuDH6ml
        0DRQL6+BwFzGfuyanGRHU4IKfNsDn9d69aAi
X-Google-Smtp-Source: ABdhPJyi+YQxlppFo5C3d0tMdE3MsA40JUVgM7Be3Czxi9nMq989bXC0a394gI3VM0+CFiEgKN4qjQ==
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr8549pjb.123.1630689630557;
        Fri, 03 Sep 2021 10:20:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a80sm9347pfd.179.2021.09.03.10.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 10:20:30 -0700 (PDT)
Message-ID: <6132595e.1c69fb81.9e8a0.0099@mx.google.com>
Date:   Fri, 03 Sep 2021 10:20:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 119 runs, 5 regressions (v4.9.282)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 119 runs, 5 regressions (v4.9.282)

Regressions Summary
-------------------

platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm    | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm    | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig =
   | 1          =

r8a7795-salvator-x   | arm64  | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.282/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.282
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f6447b82e75839bc8a7f531daa43f74f292a0ba =



Test Regressions
---------------- =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm    | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613224dcaf06414b72d59673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613224dcaf06414b72d59=
674
        failing since 292 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm    | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61322d4d13d2562503d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61322d4d13d2562503d59=
666
        failing since 292 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm    | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/613224d12244169936d5966f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613224d12244169936d59=
670
        failing since 292 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61323046afcc9f34dbd59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61323046afcc9f34dbd59=
675
        new failure (last pass: v4.9.281-17-g8256eac05712) =

 =



platform             | arch   | lab          | compiler | defconfig        =
   | regressions
---------------------+--------+--------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64  | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/613228151481c0b883d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613228151481c0b883d59=
666
        failing since 289 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
