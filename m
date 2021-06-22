Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3AB3B0F82
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 23:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhFVVkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 17:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVVkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 17:40:46 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05840C061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 14:38:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y4so593782pfi.9
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 14:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wffk0PK3Jn5Axdh0/yzwndjXsLr+54qLdnH/WpQyoJo=;
        b=tZ4pt6xIlQkI8u+tv1+JKb9+ip7x9mEOWDSy09FRNxpuZLvMmho7QbIaqmt7WuZcMW
         +X9Vy2RaXw7rtRk/rXMIA80sYKp0CMuwm2Egql3go/j1wAHDn0XbyfTEETy8ejXW25rp
         TzfqUZxwSlnP1s2nD5M6WhLi2sBHdr0PYSG+WyE1tJtcfnJzR0ND8nHz5jLJ9h09/6Gc
         IldV/T9qnNdM/GJduRyLvFWGhDDHfAxZUBB6/D7LZHFU/+AXejrzNRuxVrneepe44GG1
         LwMnibPPuApWks1SHRzQY3ZaEIu4XbvxKzeELyzxih9ZcCW3maqQlw1TmKC1tdpdO7Gq
         03dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wffk0PK3Jn5Axdh0/yzwndjXsLr+54qLdnH/WpQyoJo=;
        b=AE27vPHYb59Mp7Sd6krLx5zTppCVdFZYORwp8uMn41Zytxx7B/+eYuGPxTIhH0APHM
         Mivc+TPvajl0zB6lr0JWy3RMQrlEKNC0fmegXz8Tfym9rijriVgb0/IMJxQGrneXIhxG
         S6o/fA9b8QB+Mgszl3O8f3C9Mc2qE+iGBjc2LZ0cy4rMmFc+0RCxxbmv/F4jHcsj7YYD
         K4Ip+C2rvPROkKTBgDUSWx1JJp0vitXHrD8uYiK2P1SCLCdsb3d1L7xLSYpu3P3WRN50
         8JFSs6OFWERJlJuhJHPCA0sczUhLpFLiE8JfU6bzePR0UOby6gsiLWtg+k586lVL9NAQ
         xBdQ==
X-Gm-Message-State: AOAM530Xfab8QmdS1vPNOV6IPFRtFw1kLvntN2HaNM9Tv0SgwTke8F1y
        bLvZX0gWSAUY1AfjqBaO78JUpY3IApmVSA==
X-Google-Smtp-Source: ABdhPJw4DqQQinW3QZEXO37WP0gAyfBUg+hWq1fpTPYPmwd2uGv6GOeefons5lgu3hLjmHWz7qNQiA==
X-Received: by 2002:aa7:8489:0:b029:2fb:4ce0:339c with SMTP id u9-20020aa784890000b02902fb4ce0339cmr5643836pfn.16.1624397909260;
        Tue, 22 Jun 2021 14:38:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s20sm3456641pjn.23.2021.06.22.14.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:38:28 -0700 (PDT)
Message-ID: <60d25854.1c69fb81.f309b.96d8@mx.google.com>
Date:   Tue, 22 Jun 2021 14:38:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-50-gf6020cfd3e1d
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 121 runs,
 5 regressions (v4.9.273-50-gf6020cfd3e1d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 121 runs, 5 regressions (v4.9.273-50-gf6020cf=
d3e1d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.273-50-gf6020cfd3e1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.273-50-gf6020cfd3e1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6020cfd3e1dc3f15d86d2eed35b3bd980260d9b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d224b025b71e7f2b41326e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d224b025b71e7f2b413=
26f
        failing since 220 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d22b0cf10149dde7413290

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d22b0cf10149dde7413=
291
        failing since 220 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d224c12015ac3b13413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d224c12015ac3b13413=
286
        failing since 220 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d2299672eae1588941327f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d2299772eae15889413=
280
        failing since 220 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d224615db9ef55c1413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
0-gf6020cfd3e1d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d224615db9ef55c1413=
267
        failing since 220 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
