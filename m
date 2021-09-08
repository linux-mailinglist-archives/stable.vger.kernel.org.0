Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6D3403F7C
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 21:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhIHTLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 15:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhIHTLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 15:11:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54267C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 12:10:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id k23so2421052pji.0
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 12:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KIaCMNcMhg5m8WgBo0DhgM7rGgZMRmpXbJssqUNr8jc=;
        b=CVOKpKoGo+QX6oa3ZTaqytXWEzWe3xmoYEVEqh0tQMG/Tr2Di8N2alyeHP79zmIKk3
         otUswoQW/mCeQB8PkyNAOuAntRVwx2olhno3nlS8IfMt4j2TrrskYcZi2Xs934kqjiSv
         rvrJTcHfUxXil6840zgyXYQ/JhlaB7dLQFQcUx02dAAeM90C35V6AZD7aPOSHemhzLkN
         FccsHVlK8VUHHxnu96Yj9qBQX12DB0i2Y+G2iJR6kFojKaRdFHbnhBZxlXhn0O74smRD
         CDcmeX7PQh/DWqDHjBEUTunv4KaM0aCdBERy59NnpdNol2WFBtE5wjEeyZxuLvMHEdEj
         RZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KIaCMNcMhg5m8WgBo0DhgM7rGgZMRmpXbJssqUNr8jc=;
        b=sNNBVFM9RzsOFfxXjXnBjRdC+xYoeTebeHU6s5hWNbc+r5UjTRxq6/3BdWTfNnk5Ii
         hnusTC4iVvSfJEYcvIKOxBHM/0vldf/eCQVKb8i3/S2QencZxi5q3lgxMZH4d4LEwzrK
         3yi2BGIFzx+ns6XLpwcl+7ffs5+UT+TYxfdgPwiMlDuNnX8rpvbKvTgbJ6QB7gtYW/4h
         pcWnfhKSuogvV/746MB1s8cROXtqVQ9hPDPajqfpb7Q32apSHjAtfSI3HYbKuyGq7QCe
         q5O7w9Uf9vxvFBiFJPw4YIGHBREBrAXigpCgpXzhuhQvWe/PBOERJJmM8epmbmmluk9u
         werw==
X-Gm-Message-State: AOAM530b8uJVzHaFTYl/CUQk4kAp9j8jC5GoSz831FjYc1mDR7SikrWH
        Ocd/s7VNgVp2E9oKS6OQcl9mJpNql9zpGiTz
X-Google-Smtp-Source: ABdhPJxEcRak2CKmSIbo2KHuq/OM8JHKQEf7/PiFo6B+E61xo3RDKs9LPONucIfac0/hi17hJ7T3Jg==
X-Received: by 2002:a17:90a:fa0b:: with SMTP id cm11mr5625743pjb.103.1631128200218;
        Wed, 08 Sep 2021 12:10:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm3542597pge.65.2021.09.08.12.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 12:09:59 -0700 (PDT)
Message-ID: <61390a87.1c69fb81.4c73b.af54@mx.google.com>
Date:   Wed, 08 Sep 2021 12:09:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-3-g5e3461135fe5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 202 runs,
 3 regressions (v5.14.2-3-g5e3461135fe5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 202 runs, 3 regressions (v5.14.2-3-g5e346113=
5fe5)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-3-g5e3461135fe5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-3-g5e3461135fe5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e3461135fe5e259e09bffb69f3faca12e8e7e9f =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6138dad62f2ca22fe9d59688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-g5e3461135fe5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-g5e3461135fe5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138dad62f2ca22fe9d59=
689
        failing since 0 day (last pass: v5.14.1-17-g77d60f40b9ee, first fai=
l: v5.14.2-3-gbf9435541571) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138d730c7f093dc11d5967b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-g5e3461135fe5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-g5e3461135fe5/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138d730c7f093dc11d59=
67c
        new failure (last pass: v5.14.2-3-gbf9435541571) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6138d4ade9c79b4835d59695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-g5e3461135fe5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-g5e3461135fe5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138d4ade9c79b4835d59=
696
        failing since 0 day (last pass: v5.14.1-14-gc097b4308d82, first fai=
l: v5.14.1-17-g77d60f40b9ee) =

 =20
