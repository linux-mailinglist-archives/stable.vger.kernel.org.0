Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF01403E24
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 19:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhIHRKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 13:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhIHRKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 13:10:38 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA43C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 10:09:30 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w8so3302843pgf.5
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 10:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eLM1faZkvzq3nDETgMjuHJ/UvH6hbBanUDLCcegRevI=;
        b=fSMFs78W0wv9CfkauO1Q8xSzbwHVYiT8r4F7aXeGlPc3TNtfzQ993sMZkwDtU4yvIO
         slnrvTCMoXoSXvL5ITLkKnT8fpJK+dcrAOBeARKGXN6TYeb6U75JkCTy/pO+uc/245p/
         kbmYTxr8KZAk4FuWCbIUaE1bK6JdoUFa24HqrzX3M4LXX2YtHFz7EwUsIX5KwayWDT9r
         TZn5KFLNnoyH5QkwSARGQtCfj7E/mNuWtdNGTOqLcas7tnbIUaD0KcR6A9/KDqLj48ll
         Usok4V+5+0paqXYI7INQD78VqIwhzu/f4ZMZcMLMi9XshmrZm1zc2TzFmRPdAdM+1eX7
         5LrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eLM1faZkvzq3nDETgMjuHJ/UvH6hbBanUDLCcegRevI=;
        b=T2gReXZsZbW36xaPz+feEr6Re4+Pv9lIFawYJ6n90S74zRVKg+KpVDpCoKSOiMlllU
         8SrIN06E31/I5oSVlxlIB6DTpMy+AvV4AHhkgyTSxxzYCn0osUZeYZVtl5z4YCnlQTjz
         pzK59A004StVwDWXCsUKOtmMeQ1ZFBZ2XLREAK2hdoSaetEja1SmF5v0Qvj23Z4D6Z2f
         RgfLLKVLuPzyqGP4g9I+Gk8PYYd1AImXCD0gw75bVQSeTrbjEBvvK9Yo+YWfYYnEN8BC
         sA9+2AvjeZ8szH9ihtgPAZkJWctWPXZeNkY1PxbmHF4Ri02U0HrsJG3++Cj4Ct0uVIxu
         qU3A==
X-Gm-Message-State: AOAM530HzxD+d7RK4IVlc7dSC3CYPsD6F8v3VHzuzfrjnYlgB9YMHiJW
        tMEmYi5LkmNBPwlB034yOJspwf16i+xZrGaI
X-Google-Smtp-Source: ABdhPJx9cf/3vu1fW+kLa3t4Ietya9u7VGiFwnSeyKD6MtCU9U/B64p07/mEto/Z3Bh689ZaE1gutw==
X-Received: by 2002:a63:d814:: with SMTP id b20mr4759587pgh.268.1631120969807;
        Wed, 08 Sep 2021 10:09:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4sm2737959pfv.21.2021.09.08.10.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 10:09:29 -0700 (PDT)
Message-ID: <6138ee49.1c69fb81.77f4c.83c6@mx.google.com>
Date:   Wed, 08 Sep 2021 10:09:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-3-gbf9435541571
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 203 runs,
 2 regressions (v5.14.2-3-gbf9435541571)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 203 runs, 2 regressions (v5.14.2-3-gbf943554=
1571)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-3-gbf9435541571/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-3-gbf9435541571
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf943554157109bdd3a0c38c32e80cede172049c =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138b85e72cbd9bf8fd596b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-gbf9435541571/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-gbf9435541571/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138b85e72cbd9bf8fd59=
6b4
        new failure (last pass: v5.14.1-17-g77d60f40b9ee) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6138b70e18f2274f16d59674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-gbf9435541571/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-3=
-gbf9435541571/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138b70e18f2274f16d59=
675
        failing since 0 day (last pass: v5.14.1-14-gc097b4308d82, first fai=
l: v5.14.1-17-g77d60f40b9ee) =

 =20
