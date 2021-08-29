Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601403FAB6D
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 14:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbhH2M2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 08:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbhH2M2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 08:28:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F2FC061575
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 05:27:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so10527844pje.0
        for <stable@vger.kernel.org>; Sun, 29 Aug 2021 05:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HtCt89F18RpqhiATtLoHznQZaiwD1CRCtNazZtbD5Fs=;
        b=biuO1dwO4Tiv8qTDfSLJcUlqU/8tAiP1b288dte+Qlwrzk56nc+CujLmslosQzkfIT
         Al18Kyt8i8X07eMYuMswqOq2Fr+Nw55JHPD9oiwiZuujU6RMIDv0P5r9rdbEKL3LCEqd
         QoMxMoYgyBvxWkJxV6fmOug5tAEyRqiE6lurlLuUnaiqMB0NaF0ScKGzz61NQlCmtZZB
         oaaejy4G//P3TCMDE92qZFtwF3Pvo49OLHCJtsQHWkKpwKpO1iWlkJGFWEhKpocUh2MY
         85pfUJPUBydBHEY2KL0ILoVz4klA1Q2qohOAwMwvcrN2pHdKkJZ+Hu9JRQqCaWcM7aP0
         ZjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HtCt89F18RpqhiATtLoHznQZaiwD1CRCtNazZtbD5Fs=;
        b=jvC9nPbYUVSYdyKg8zQEmZmLnWQIutfqZ2gULa/vymZ4MCO4pXiFTBar9wq8VBSbtv
         Fb06JfdrV0FErMZICCTdoljaOFjkhhFtAOyg/pgPFEZaFxHzOHPCdKs7GdQGO/lh+wGh
         mfPiFGNtw/flMoF/UHrba5ZfKxYBJS19TkC1W9mGnfNJvPy45BxcRgvML4Kiw2v1K2sd
         9+bdg7kwZp3BZVoiplyRg5mPlnlydAlCfm7+V8toBJqRqW9SJNaNPExtBbzmTecu21K/
         E9YXCiG4PSHXTSc4NsSm0MlbFkhVJn7aB/lnVFu/jV2buO8umeHLB3UnO8cAhf3IG29v
         bikw==
X-Gm-Message-State: AOAM532KgYF1Yh+4EKKA675frmw1Ciw2CL2RaRrL9+GFW+nscR7yZxWl
        v5GYoEx7QI4ueEPbfKns8iu2Cys8n2XbQxiT
X-Google-Smtp-Source: ABdhPJwD+nuKmA4bgfe+mY+7Eu2Gn3tTEXdz0Y2GjSCjSrGjQ4RcBw+XHao7UAQY6wz5uVYkHhULsg==
X-Received: by 2002:a17:902:7c15:b029:12c:78ec:bb61 with SMTP id x21-20020a1709027c15b029012c78ecbb61mr17218220pll.61.1630240062683;
        Sun, 29 Aug 2021 05:27:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i24sm878128pfo.13.2021.08.29.05.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 05:27:42 -0700 (PDT)
Message-ID: <612b7d3e.1c69fb81.66261.193d@mx.google.com>
Date:   Sun, 29 Aug 2021 05:27:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.205-12-g720f2d18684b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 158 runs,
 5 regressions (v4.19.205-12-g720f2d18684b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 158 runs, 5 regressions (v4.19.205-12-g720f2=
d18684b)

Regressions Summary
-------------------

platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-baylibre    | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-broonie     | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-cip         | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-linaro-lkft | gcc-8    | versatile_de=
fconfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-8    | defconfig   =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.205-12-g720f2d18684b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.205-12-g720f2d18684b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      720f2d18684b88ecce22dabef43b357a5f8f23df =



Test Regressions
---------------- =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-baylibre    | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b4871bd4986d43d8e2c9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b4871bd4986d43d8e2=
c9c
        failing since 288 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-broonie     | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b4d255c19bb5f7a8e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b4d255c19bb5f7a8e2=
c7e
        failing since 288 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-cip         | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b4a3ba559ea22d58e2c86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b4a3ba559ea22d58e2=
c87
        failing since 288 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-linaro-lkft | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/612b47a6509df17b888e2c93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b47a6509df17b888e2=
c94
        failing since 288 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/612b4afcf786a1b4f78e2ca2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-12-g720f2d18684b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612b4afcf786a1b4f78e2=
ca3
        new failure (last pass: v4.19.205-7-gdac1f330021c) =

 =20
