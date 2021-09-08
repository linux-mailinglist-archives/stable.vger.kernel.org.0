Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E167540405A
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 22:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350410AbhIHU4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 16:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhIHUz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 16:55:59 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5047FC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 13:54:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y17so3015361pfl.13
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 13:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NpRpsEBSuHDA6U1ZkyJMMR4ncGQoVm8Sy1ODAr8UOGw=;
        b=AGNKhReK4yq46oA/6z7KO1wk3cGyDPzyWyTrvmyNTkIm/XNHlr888yH+n5eI7mVyXX
         WueQ1zEUPlDzzOM2SMeaOumKpbk6izuhM5xrpZrJe0HiG9Csn778JkroGe4mbSHpvhAQ
         2tsHOxfdp5OAGLDjyXgA92s2f6MNl6fP7jGzbf4Q6ZIF1dDO2ih3fRkt7DEB+pBwfhNK
         KvP0z8N2H5OiMihoVRybKoeoY6LRU5DrvMShZcA64aD/QigwRBVIWkPuTrk0hzhP6Rhw
         xZRYpO8F7WhutPg2IDegOOV6kiOxDVDdaosH/zv57xcWM/wFyR8BQLPw0XRejaMWo0hZ
         SWpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NpRpsEBSuHDA6U1ZkyJMMR4ncGQoVm8Sy1ODAr8UOGw=;
        b=6gDzR3dBcplXqV2Voz/RyshgTxgPmUggEEgcTpM8PBYg+iB47wd0wQhNszJCDOllzE
         HNwgxgDyY7X6N+yHAiIH5wQB9kGbjAkGdpBZx96sNNsxqt8xJJq6581/fz/RxdkilhJu
         iuYoW3M40CdEG4Yvul/sIW81rd5Vj9MFSgCkIn2aJs9lKXFYWd6Z1Pj4DVCxmBQcctqY
         exctnXbLTvcpVb++sNtjT1OEOFEcknAlcSx1MaCt7n8O1qZVLvIKcVWzlaeeMqznJW6q
         uUTKZi8LMb8Aj/aSV0zUo+G5xedtJcTTH8YPPsOjIv385qQPQAbol/99l94ky1CksL4M
         h2YQ==
X-Gm-Message-State: AOAM532bs8svEA1IFtjAWGdLg6AOx9EB0xX0K3Yy4mMdtVVGvASwgWDY
        wPAaD4yfrdvDKfwjF04cG+KIh9qjiFp9VXaO
X-Google-Smtp-Source: ABdhPJxa5+k/J6UfSgGxlPG2ZuUMiZOJBMUwu1qDOgIIZhV30LnkSYf73vGMmbCSJpMAJ9y6zRoC2w==
X-Received: by 2002:aa7:9f5e:0:b0:409:dbf2:88de with SMTP id h30-20020aa79f5e000000b00409dbf288demr66636pfr.14.1631134490579;
        Wed, 08 Sep 2021 13:54:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 70sm107481pfu.93.2021.09.08.13.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:54:50 -0700 (PDT)
Message-ID: <6139231a.1c69fb81.339c7.08a4@mx.google.com>
Date:   Wed, 08 Sep 2021 13:54:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.2-4-gdaa4b4126de9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 200 runs,
 3 regressions (v5.14.2-4-gdaa4b4126de9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 200 runs, 3 regressions (v5.14.2-4-gdaa4b412=
6de9)

Regressions Summary
-------------------

platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
beagle-xm               | arm   | lab-baylibre    | gcc-8    | omap2plus_de=
fconfig | 1          =

imx6ul-pico-hobbit      | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-8    | defconfig   =
        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.2-4-gdaa4b4126de9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.2-4-gdaa4b4126de9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      daa4b4126de9dade28f698fcc637dbbd2ea0915b =



Test Regressions
---------------- =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
beagle-xm               | arm   | lab-baylibre    | gcc-8    | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f14cae42cae97ed5966d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-gdaa4b4126de9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-gdaa4b4126de9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f14cae42cae97ed59=
66e
        failing since 0 day (last pass: v5.14.2-3-gbf9435541571, first fail=
: v5.14.2-3-g5e3461135fe5) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit      | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f2b8917c0750b8d59689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-gdaa4b4126de9/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6u=
l-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-gdaa4b4126de9/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6u=
l-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f2b8917c0750b8d59=
68a
        new failure (last pass: v5.14.2-3-g5e3461135fe5) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f33cbe6b21d040d596ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-gdaa4b4126de9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.2-4=
-gdaa4b4126de9/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f33cbe6b21d040d59=
6ed
        failing since 0 day (last pass: v5.14.1-14-gc097b4308d82, first fai=
l: v5.14.1-17-g77d60f40b9ee) =

 =20
