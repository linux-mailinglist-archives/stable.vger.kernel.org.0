Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF95442CF4B
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 01:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhJMXur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 19:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhJMXur (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 19:50:47 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F26EC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 16:48:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so3534545pjb.0
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 16:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TSnWaCFKHmoYAeUiX2neNpY7D+k9CGZmyT8uqjB00E0=;
        b=x0fzMhUdUmqk8YQLO2cLjQgJCRy/giFatetqPf+DZUZDCAkEhOWiahm/xB6kZy6+oc
         NObcZhaWiw+mw7VNGhh5fK6xuhnCqH61R3ChsYfOHqzvMPjVi4596LI8esry51jsvDdt
         xno7S389niyELe8Tk3MNnEoCLaDV5uDqiO9x7POPPHnFks/hbNP7HSojxZbixohDvPeX
         dtXi1QS8h6VSJNg7uSjDCFLT9JcfmeWIECmft/HFOEPhEptJEX+Ur6Ehqff55AIaS3gH
         UJySo+rahEg62SGcyTYFoYMDNT5XsBWNzD1pM/O5mgztUtCMwWkk+/5CuyBF0vVLzVhQ
         bifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TSnWaCFKHmoYAeUiX2neNpY7D+k9CGZmyT8uqjB00E0=;
        b=2SPUfH8lB47XgOdOrzVRyaruKxiaUbvMcvfHNL3fYVdYUhtedHjoXTBU7QpcM34npC
         G5ad1s4fAI6RuRqpKSr22fS/uytvuPMhm3zOf4CxU3k1T8D8/R5gF+xR4Nrk1R2MsJeO
         mo3TqvUy/eWgeylXmw+nwPEYxHjUH9Rm0VLc/iWenzy+ZSXlA6KoGw8WrllZdIPLqmmt
         e5UPWW2PUNzbpKAHAwv8eOJx902Wb6VPGC+p3mD8ALQEHUr5bBisj6nFcdGIZB9DIxpA
         gIrKvlqMUMDVdP4H1QZxPWbtIYqdYXHEIfPJNknEXY5EBNlIZj0ElgHzMMT51yqq/xx+
         J53Q==
X-Gm-Message-State: AOAM532kXlistsUhMmIT2eUkX8GcwC5XKds+2N+tpY1rzzNH7xqbFMmi
        q9RhIFpYc44keZsL29CjeOOJYSE/ppXe0OHy
X-Google-Smtp-Source: ABdhPJyJz2a3xZ6s+kJ0jn+IZLs+aXPvGP2Ob/U614CO5tUZMy9lz6uZStlNUTuMH82OUqV+SkL2zA==
X-Received: by 2002:a17:903:11c8:b0:138:d85a:7f09 with SMTP id q8-20020a17090311c800b00138d85a7f09mr2020144plh.75.1634168922523;
        Wed, 13 Oct 2021 16:48:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a30sm544820pfr.64.2021.10.13.16.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 16:48:42 -0700 (PDT)
Message-ID: <6167705a.1c69fb81.e8459.2758@mx.google.com>
Date:   Wed, 13 Oct 2021 16:48:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.153-17-g44df9e100cc5
Subject: stable-rc/linux-5.4.y baseline: 60 runs,
 4 regressions (v5.4.153-17-g44df9e100cc5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 60 runs, 4 regressions (v5.4.153-17-g44df9e=
100cc5)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.153-17-g44df9e100cc5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.153-17-g44df9e100cc5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44df9e100cc5636c5e21064992e0de3bfa16f3a1 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/616735e4373ef1017708faa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616735e4373ef1017708f=
aa7
        failing since 327 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61673099ac72c06d3c08fae7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61673099ac72c06d3c08f=
ae8
        failing since 333 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6167308aac72c06d3c08fad1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167308aac72c06d3c08f=
ad2
        failing since 333 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61673084ac72c06d3c08fab0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.153=
-17-g44df9e100cc5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61673084ac72c06d3c08f=
ab1
        failing since 333 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
