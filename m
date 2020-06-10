Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17051F4C49
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 06:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgFJE3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 00:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgFJE3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 00:29:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52720C05BD1E
        for <stable@vger.kernel.org>; Tue,  9 Jun 2020 21:29:06 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x11so454606plv.9
        for <stable@vger.kernel.org>; Tue, 09 Jun 2020 21:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WcP1LJNHJg9Z6dXLAzk54S/3Z7/9cOsXVC5Se06UYX0=;
        b=YaQhqWJ0Hm+iCALd3YGM2HdUGroEh7PmcWzfjU2VbZ9ZZ9uWab8PDbyRA9nalGnawb
         aX4fjPmrY//Px3Yw+3949ZuDURyNkGnrbC2QQZ1/wOEtGzt0j/kyNOi/T859itntTxeb
         2UOG6NWJ8UHvBBYq7qmqsw8sw8YgiSzG0juIafJ3FIhV5qjOAssh3u4USs+DgFs11YId
         5/1RksZ7n9gcgO8lycRuBWQSrZpdHxKU4kpPc3I2L0Zn/qjNz021dpB9zWmdMHqSoBLj
         pJOKTm/tW9mR7qCvmAhy7meXgNrAQkc8mqVPvRR5Ap9dzIL32BkYxvLSkhVNE70aUkHu
         wvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WcP1LJNHJg9Z6dXLAzk54S/3Z7/9cOsXVC5Se06UYX0=;
        b=hTmoB2RWSATm9E+V8qe7i9TX5vixHb9RjAKAmsPrDzQ/fT2U6kq+42SGy+VK8JsJZ7
         hBfhJVcYipZUSaXqSGk118b7sc0jMRZm9EHStZNE8JByShwY5S5oxPYvu1J5U4GvDAlO
         8GoxXwklyDXQShkcTJ/pFhIjnAtnicjqaIyuv+jmnKAlhLH++Yqb7Eu0ILOAQXsfgdhF
         pTkPgnbtM9+wj3TQYhq6SegfoZ2cQV9EBV/kWLIkyzO1NPla2gKL4gp/SXalkB17ThqN
         nFx4r123WUaQyJdMDmS1wHmd+2rCBhcmQ17gkGX6gCMAtBfj6befJYzqTjd3L5BOi6dH
         qSzA==
X-Gm-Message-State: AOAM533VHYivtfnOHJXB7Jvus0oTKyJuA6a4KVTOpA5uhiBAbuM7jAnA
        7IgQcr9WDglbdFFuvGsHBGy8GIm4m8o=
X-Google-Smtp-Source: ABdhPJx+zQZRefhzGhuGzLA6ENEyk9N3wj52yGRrFaTDAAcDfHHNbKZkoL8PcsGj0o1pjldFwGvA4Q==
X-Received: by 2002:a17:90b:11d8:: with SMTP id gv24mr1228714pjb.66.1591763345488;
        Tue, 09 Jun 2020 21:29:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hi19sm3707212pjb.49.2020.06.09.21.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 21:29:04 -0700 (PDT)
Message-ID: <5ee06190.1c69fb81.4a3d4.cdaf@mx.google.com>
Date:   Tue, 09 Jun 2020 21:29:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.16-86-g1bece508f6a9
Subject: stable-rc/linux-5.6.y baseline: 61 runs,
 4 regressions (v5.6.16-86-g1bece508f6a9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y baseline: 61 runs, 4 regressions (v5.6.16-86-g1bece50=
8f6a9)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g        | results
-----------------------------+--------+---------------+----------+---------=
---------+--------
exynos5422-odroidxu3         | arm    | lab-collabora | gcc-8    | exynos_d=
efconfig | 0/1    =

meson-gxl-s805x-libretech-ac | arm64  | lab-baylibre  | gcc-8    | defconfi=
g        | 0/1    =

qemu_x86_64                  | x86_64 | lab-baylibre  | gcc-8    | x86_64_d=
efconfig | 0/1    =

qemu_x86_64                  | x86_64 | lab-collabora | gcc-8    | x86_64_d=
efconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kern=
el/v5.6.16-86-g1bece508f6a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.6.y
  Describe: v5.6.16-86-g1bece508f6a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bece508f6a987257cff511f9ba8b67da8734954 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g        | results
-----------------------------+--------+---------------+----------+---------=
---------+--------
exynos5422-odroidxu3         | arm    | lab-collabora | gcc-8    | exynos_d=
efconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee036d4262251e46097bf74

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos54=
22-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos54=
22-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee036d4262251e46097b=
f75
      failing since 8 days (last pass: v5.6.13-193-g67346f550ad8, first fai=
l: v5.6.15-178-gc72fcbc7d224) =



platform                     | arch   | lab           | compiler | defconfi=
g        | results
-----------------------------+--------+---------------+----------+---------=
---------+--------
meson-gxl-s805x-libretech-ac | arm64  | lab-baylibre  | gcc-8    | defconfi=
g        | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee029931d9350542497bf1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s805=
x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee029931d9350542497b=
f1c
      new failure (last pass: v5.6.16-44-g6266fb28693f) =



platform                     | arch   | lab           | compiler | defconfi=
g        | results
-----------------------------+--------+---------------+----------+---------=
---------+--------
qemu_x86_64                  | x86_64 | lab-baylibre  | gcc-8    | x86_64_d=
efconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee029a7b2cc506a4e97bf15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee029a7b2cc506a4e97b=
f16
      new failure (last pass: v5.6.15-178-g1c16267b1e40) =



platform                     | arch   | lab           | compiler | defconfi=
g        | results
-----------------------------+--------+---------------+----------+---------=
---------+--------
qemu_x86_64                  | x86_64 | lab-collabora | gcc-8    | x86_64_d=
efconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee029d0e35f3e203997bf14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
86-g1bece508f6a9/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee029d0e35f3e203997b=
f15
      new failure (last pass: v5.6.15-178-g1c16267b1e40) =20
