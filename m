Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34409309F0E
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 22:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhAaVQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 16:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhAaVOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 16:14:10 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6FAC06178A
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:13:22 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id e19so10237316pfh.6
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TqQR09b3AduBuaUaudp7qcSxIveiSbXWbQ/8TqxQw/U=;
        b=dVtJ6rOeaxRtoH/0EMkdC1r20UnFbUCxhHF5JmNThm+CTJXaoiXLzWj9rC5O6YQ/rn
         huOyF/U89ZAqi2IosGFfZHHPB8Voi6+pb1enszDCmRYV4QoCUCOyVQ9SynyaaVL8bUar
         gVk5x/Vg73wD8cGwCqoE91mSfXyHUUj0w8RLVcr75kXBz9rrEIOU7yxa4e+YDBly7FA3
         SgQFfdBj9cZSgjGCsoojLsWtDdyL912Co4hdmCj85JaHY19Gfp8549vY0tVhqdqNdV1E
         +BuMk8uG8rar6NxSs4T43+3tLb4wiv8fq7hQq/bGa1kRkAztN72B8LhzL5zcrICwBsLv
         MDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TqQR09b3AduBuaUaudp7qcSxIveiSbXWbQ/8TqxQw/U=;
        b=ggSEioqYXXn2BhJzTIoGNA9jyH9FkWjePfgPvW9LVu7dcZnsJqIxcXUTg4QyMVXp0f
         uKvR9fx7+L/SF9tzCdn/ZkWTyd4kA9Xudovu2NCdPeJhX4Co9k4IHEUEgrc0cXL3QDI+
         w0Zym7dekTMxd1TpXKn6L5mVJW5cowRYYqgq2BGrxGT/bF2MjSS/mdm3Q/sGs+coKt4t
         MKz/YtQZIcDaJidPONW3YcC+PFwDqmru+jz8zLiv+1iKNc3ZBFoWdopB0XvyH3S/F6Ds
         0icEvCQkuvZXf/HorqOf76h6BiwuK/WVPZ2XxWbG1GQ0n2IL7o/QIF8l/1HG7VZkbUNY
         u90g==
X-Gm-Message-State: AOAM530LXr5kJXCYutwAMkUUAbQvZze7m5n+sSaxEy88pGyh7g3Mgrac
        cMohpWqOQFeyn+zZCHm4s3jXtKVt59L46g==
X-Google-Smtp-Source: ABdhPJxqga4anzmvm0z9qP3y2Gmu8TfvE9qVIgM6AET+PhYmIQo2iCEh77+MAA2Bpl+HS5uFOdB+3A==
X-Received: by 2002:a62:444:0:b029:1bc:ebb6:71f8 with SMTP id 65-20020a6204440000b02901bcebb671f8mr13050261pfe.75.1612127601451;
        Sun, 31 Jan 2021 13:13:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gg6sm16550078pjb.2.2021.01.31.13.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 13:13:20 -0800 (PST)
Message-ID: <60171d70.1c69fb81.5e5f5.b395@mx.google.com>
Date:   Sun, 31 Jan 2021 13:13:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.218-5-ga35d3dd51047
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 139 runs,
 5 regressions (v4.14.218-5-ga35d3dd51047)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 139 runs, 5 regressions (v4.14.218-5-ga35d3d=
d51047)

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
nel/v4.14.218-5-ga35d3dd51047/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.218-5-ga35d3dd51047
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a35d3dd510475e66c30be9cafe7ae902d3dbe1f7 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6016ef56b059990417d3dff3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016ef56b059990417d3d=
ff4
        failing since 54 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016eb48d83db21187d3dfed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016eb48d83db21187d3d=
fee
        failing since 78 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016eb48cb4af48b50d3dfd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016eb48cb4af48b50d3d=
fd5
        failing since 78 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016eb4e23dc77fdc4d3e040

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016eb4e23dc77fdc4d3e=
041
        failing since 78 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6016eb04eb14776c40d3dfdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.218=
-5-ga35d3dd51047/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016eb04eb14776c40d3d=
fe0
        failing since 78 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
