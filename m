Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37A93DC5D8
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 14:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhGaMIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 08:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbhGaMIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 08:08:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB453C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 05:07:54 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u16so5714941ple.2
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 05:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nBNyBlxwMIAhFHCpfuKX5m+RtFzoYPwVFvYEtooxKbo=;
        b=AD0UuWLeI1g2K/HBet5rbuJzrerJlBfdzMtZaKgfdHW7vHuOFFpFeteMIWZSxYZZdl
         KdFuqogCK2Gw7Hk0HVEPGomzh8zR4Ob1EYOEAyuGrP+uCZfPNaCXGJZQ2C/U/baciGAi
         yX8JGFkJNqfOZNFWJplk4C/586xD5tAKy79IRhrn+opq/EXJULmuCkFIZQ44jDl4n5d/
         HLaR7fTtX8pcOoDk57n+YJvXHD6/iJjdQ7GkGDjibXou3YGJRiN0FsL6Ego7ZQ3R3Gse
         upalkEMxiGC0xzRO9/Jc9kGQsjjjJv2csPT+CeAmkuNZCwhUZEBCs16Y5L/HNm8+/k1G
         cSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nBNyBlxwMIAhFHCpfuKX5m+RtFzoYPwVFvYEtooxKbo=;
        b=Ty1PUygzQEu+pMEoMeC6ZqYaziL9akE85rGn5WtvkRGKBPFbNCU7RGlv5wGKQ839r7
         wxHLyYl/GNozcqr4o3mJvuKWfNPlbhQZxiqhF8CtR6yr5rKL/bR/EmJQgu2sDTTplL75
         C6hAF8SSJc5pSjyG3RqwjbHlhbcG87OULuSpKFmBYvLuZinqmwe5G2D4YvEmdTvEtaao
         BD2CNaoB+utBFezsLlyDqZbW3rPENMl0fsmlMyHCjozRSyTbL24Nx5L67L6G8C01rWIb
         KFfc6bwityh3xrjxNn3QAgyz6aHpvqE383Xdprsp5hO9P0jwnARn0tAdwEUm4Lmba1AV
         kewA==
X-Gm-Message-State: AOAM530uD1ovcMKaLRUvbT8U+Qzncp5QHrtHId5111ux4zgXb88lxz2W
        wlgJVnhv0Jqv6WIBWnD8RpslFvsAMXPwbdbo
X-Google-Smtp-Source: ABdhPJwKC+lfrfGDag7RkFxUKIc6FClOBVwiyJ6ltNvaz3ncpih/D9ojLC7P/ixwRaU56p3klhzXxw==
X-Received: by 2002:a63:8c04:: with SMTP id m4mr2397207pgd.89.1627733274225;
        Sat, 31 Jul 2021 05:07:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v13sm5251461pja.44.2021.07.31.05.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 05:07:53 -0700 (PDT)
Message-ID: <61053d19.1c69fb81.38b23.df8f@mx.google.com>
Date:   Sat, 31 Jul 2021 05:07:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.200
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 136 runs, 4 regressions (v4.19.200)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 136 runs, 4 regressions (v4.19.200)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
imx6q-sabresd        | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.200/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.200
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      53bd76690e27f37c9df221a651a52cea04214da9 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
imx6q-sabresd        | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6105060f60f826b58185f4b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sabresd.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6q-sabresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105060f60f826b58185f=
4b3
        new failure (last pass: v4.19.199) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61050504bb0411954f85f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61050504bb0411954f85f=
45b
        failing since 254 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61050ab11ee280c9e085f475

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61050ab11ee280c9e085f=
476
        failing since 254 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61050569641d7882b285f46b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.200/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61050569641d7882b285f=
46c
        failing since 254 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
