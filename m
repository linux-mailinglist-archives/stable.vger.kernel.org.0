Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D0F42587B
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 18:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhJGQ5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 12:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbhJGQ5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 12:57:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC26C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 09:55:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so7376894pjb.1
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 09:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V0pceDXe43+038wZ2zSM90U23i8a8NG2xc8b3lrmD6Q=;
        b=AqE5usmzPiMIsMij7N3jO0LLmMHsh6PXHfxMlc2xM+7nuir/YgV9r8KUT4xlwhHMrQ
         gim7QEjYypKLin90N9ZQM3d1LgbmQf6IIvBDOuNVrSMkFsM4bFXAr4zX1Nwt4Y0+L2aV
         USLebLCqgM+cWS+X7HUw6uh+bUdd7araBnsYNUAFPcAoGdtvhyKATIH5rUhHN6C29SHE
         QAm1w2XfIhQhJCFBd65j5BlYj8PXkcsmCYIxQSz175VvTDa5YRdcsYcA9i6xRBbClY03
         /i+1aF4ohjiz8eSsL/w6+q4lpVU9LBRCmFfitgvWOtorA+AfZJ0I7n4LJ/ccY7Z8bkTR
         Z0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V0pceDXe43+038wZ2zSM90U23i8a8NG2xc8b3lrmD6Q=;
        b=wlFFEWv+dftEayr3qlO1eP/wAnCFhkdiMXw082nyi6zm6SG7wMWwOYJYMyorFRD5dN
         fP5Tzql8ymbgrb27yld7/tvKU7S2ZKFoXNHcZQaYO6pwTbtJlCcsC5as5r8nF04WLf+I
         iDlwG4O5KaXVcSGQHNmFVYujYfjJv2SS+nlLMrAseSJTB5i4K/mEA+VrcEpX1XnL3Dt9
         0Rec+dSXBjYTQjSbCwYzm057+gvW/iq8E8b30gcAFLCeo+tdLF0iGVW41zTME7yCfKjY
         tZqNxojTcXJGhEq15/avG14TWgGSEG/1VrttDbzSvM3/EDfjqI8gzLZ3AVHjjXOg2ZX/
         iugw==
X-Gm-Message-State: AOAM530Vz6Dlk5xam20KytxSm0PppMC4EjoK+Bd6ZuB4umeObsgISUt4
        o0TjtZVte1qWB4KoM0GPqnxudgggG+nqioUE
X-Google-Smtp-Source: ABdhPJyxhnEU64BU3Mn+3EeoOHnGqzETof3VkTT0mTe+7bEZexNmwuenuVEn+QhYih3fcLPEHgrrqQ==
X-Received: by 2002:a17:90a:1a58:: with SMTP id 24mr6750104pjl.45.1633625713609;
        Thu, 07 Oct 2021 09:55:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2sm8925250pji.30.2021.10.07.09.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:55:13 -0700 (PDT)
Message-ID: <615f2671.1c69fb81.78705.a2b6@mx.google.com>
Date:   Thu, 07 Oct 2021 09:55:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.285
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 103 runs, 3 regressions (v4.9.285)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 103 runs, 3 regressions (v4.9.285)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.285/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.285
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af222b7cde477ac2c3f757520bf7e6b7625a380f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615eef4568fb8a974c99a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615eef4568fb8a974c99a=
2df
        failing since 326 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615eef7089b350649899a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615eef7089b350649899a=
2ec
        failing since 326 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615f0ba903fbe8bd4299a372

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.285=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f0ba903fbe8bd4299a=
373
        failing since 326 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
