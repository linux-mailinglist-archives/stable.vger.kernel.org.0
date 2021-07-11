Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1208B3C3ED0
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 20:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGKTAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 15:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKTAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 15:00:34 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AE5C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:57:47 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t9so15818183pgn.4
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 11:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=73tRIixfyhdR0kz+Jn7CqRhGi1nYhDAcgvECmcKU3Cc=;
        b=f/KS95cpOGtFrmSV6ug0+2jf7b0bxov8oaqAvcuCL+1bq4JVTbyh2/hclHXJ3uvhWJ
         xPxO1GOnSGw5pggs4RN986ye8QfrqDyoxD2EFBatil+LrqLugHc4MhnwpDv1cKnx61d2
         6tzQ7aqRmlwQBU9Iowtlc8RqqepdKVexu+2yY5T0m1q149wR5tyEDgWpZxM30rpUIr1X
         nhKmL3EIiT4d5BUVxTAqALym2oZRu6ozqRCV0z+Goy4BKVNd23mSq9AZa7n4xGKvUxy4
         sdISE1l7tTYK51L55OVacIE7lRrmsPF5f3LVFZvhNBAlnqh39FxgKVVdRCoFb4ZrgVIN
         2wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=73tRIixfyhdR0kz+Jn7CqRhGi1nYhDAcgvECmcKU3Cc=;
        b=rsPMoZBJ6N0NeG505cjGX05Mau4cXoc6JnyOACyIWp/xuufp+ArDteCzL/MnZ6On5L
         +bQ0RbXz/nZfKMpqtX7JnOC2093UQ8aVpsMp7vsj7lA8VMgtK5q1A+ASi1xu5P1nsCwt
         LJrcV7nrkqi1YmUGlDxmnejDFSkuczyjMXlSw7wgN0eLlz0QkzvURZmhZfaw/ayS6CUt
         bjja4BUv+8AlvrwkSlZ4+hQl5rRVi2XO4Vp/qqXP8Jlq2U4eThvRL9l42+P7WlmRtENB
         ouvHh0F68glqW/iKZ+vD/GO9OxR0qCrI9EQzpTVKVylseqYY9V5/sB+G+jzpe3bZcvK7
         5CeA==
X-Gm-Message-State: AOAM5327XlNqY3awopEWhCi0oxl/+Nwoits5nqu4vY++aBXeRkGgKZQC
        JwvJgee0GOTM8ODDe5oBluud+DbWT5WWUnUT
X-Google-Smtp-Source: ABdhPJws3EeeamN3hTGFkRCmhQfc7vbhOejRLFNFsVmzHJTp4dNv2I6S2ephjBVfnU1jIXcB6SPiuA==
X-Received: by 2002:a63:1622:: with SMTP id w34mr10378651pgl.354.1626029866196;
        Sun, 11 Jul 2021 11:57:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o72sm11901264pfg.44.2021.07.11.11.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 11:57:45 -0700 (PDT)
Message-ID: <60eb3f29.1c69fb81.79277.2586@mx.google.com>
Date:   Sun, 11 Jul 2021 11:57:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.275-28-g6b87a8c3f6a02
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 4 regressions (v4.9.275-28-g6b87a8c3f6a02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 4 regressions (v4.9.275-28-g6b87a8c=
3f6a02)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.275-28-g6b87a8c3f6a02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-28-g6b87a8c3f6a02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b87a8c3f6a029f79b120770fa5a302af45ca122 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0c22a892e149fd11797e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0c22a892e149fd117=
97f
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0cf9d593a398e81179a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0cf9d593a398e8117=
9a4
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0c0f9b3798f5db117993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0c0f9b3798f5db117=
994
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb0cdeb6d0c24fa41179ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
8-g6b87a8c3f6a02/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb0cdeb6d0c24fa4117=
9ad
        failing since 239 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
