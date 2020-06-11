Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181A61F6C64
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 18:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgFKQuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgFKQub (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jun 2020 12:50:31 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1152BC08C5C1
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 09:50:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id b5so1815151pgm.8
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 09:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1fYYryRV56wDZ1QXuDYry8Au+lKA2Wgq+TGqrxiwU3U=;
        b=jx8zKaQz5a8CxqoLbNLPLmVXwgmGNWypBWgL1rSMJb4Dh52WzZ9mt9B89BQOXp9IVr
         UcuDudeb1h3SuPKkzF5uG+76fPcDydlKjAhOZmAs2ajNTkFCL0V/A2ZSS0H2byHvfu/B
         /SDm7aFj4Z+34Sx8U2+2PMzn/ZLU3kymTryjq/g02ECII0gTAi6wl0vRshlu3QEjgARP
         g281ObTADwBLjyox/xNIpmIBaIJ4gtceB5VLXLB1lqxvJtih8ni4WZP32CrNsftL7tqh
         e4y0sJ3KDOk35+xK1BAZ2f2cp1yBfJeeX8Urir44uRvDfIihU9tOPijBqBUNTah6R31F
         ScmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1fYYryRV56wDZ1QXuDYry8Au+lKA2Wgq+TGqrxiwU3U=;
        b=pU2nX1kVY8FS9pEbJIFnBsJOUTDpr7+ZEwBMRd3OouARv69VImQuOgICX+VlBoBsnJ
         K1wDvUiUta7aa6Mg85/aEzcfAEsujT3XUPbiO/XWBZxiFfsIJrMsFVwolkT/rBeOrrjK
         UZ85vzLC+L7EcLbmQLOiDLqft4RHvXU9xQULMZ/mzIcsxPMCfkuw9Yj1dh4G/BaHvnuW
         29L/WqllJHyHfZUPny+mEw0WxgSwCf1dy9gqOZ4tdORDNnuVNz0ziscJPDSWnYV6Mb5G
         1+3R74PHnaUQ2e493csj5GkOQPlMLw6vOZhswZjGVFReUCFhAM1qzExBYoiaMb5uKunK
         StoA==
X-Gm-Message-State: AOAM532BeBEuixFfbvn+aOelHiXIeH4VxwKlN8OEAi5MMLaaILMQVDcH
        hIzIkClpdG9cDXHB7yFM1vsKqT1phO8=
X-Google-Smtp-Source: ABdhPJw3S8c2aobanXTLLDhKvVBSldV4J4P2ix2Sloicf63iPOPUAeWy1TQCDF6+CRqNv88nQFIXwA==
X-Received: by 2002:a62:fc86:: with SMTP id e128mr8339240pfh.133.1591894230220;
        Thu, 11 Jun 2020 09:50:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y136sm3577958pfg.55.2020.06.11.09.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 09:50:29 -0700 (PDT)
Message-ID: <5ee260d5.1c69fb81.4d01a.948b@mx.google.com>
Date:   Thu, 11 Jun 2020 09:50:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.184
Subject: stable/linux-4.14.y baseline: 63 runs, 2 regressions (v4.14.184)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 63 runs, 2 regressions (v4.14.184)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig | resu=
lts
-----------------------+-------+--------------+----------+-----------+-----=
---
meson-gxbb-p200        | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1 =
   =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1 =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.184/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.184
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b850307b279cbd12ab8c654d1a3dfe55319cc475 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig | resu=
lts
-----------------------+-------+--------------+----------+-----------+-----=
---
meson-gxbb-p200        | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1 =
   =


  Details:     https://kernelci.org/test/plan/id/5ee22f2d780a0c187197bf10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.184/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.184/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee22f2d780a0c187197b=
f11
      failing since 69 days (last pass: v4.14.172, first fail: v4.14.175) =



platform               | arch  | lab          | compiler | defconfig | resu=
lts
-----------------------+-------+--------------+----------+-----------+-----=
---
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1 =
   =


  Details:     https://kernelci.org/test/plan/id/5ee22f9067edef26f997bf14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.184/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.184/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-sun50i-a64-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee22f9067edef26f997b=
f15
      new failure (last pass: v4.14.183) =20
