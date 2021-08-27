Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9DC93F94E2
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 09:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhH0HM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 03:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbhH0HMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 03:12:55 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5106EC061757
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 00:12:07 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w6so3365934plg.9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 00:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q4OhGt5AzFWQajRTYEZfl8YZDYTLN83g/8e0S0EReJ0=;
        b=BpnG8XGX1WbBFm/cO/JfIBTI5UTSG39Fm6RLmzj44u/t9mxMG3xH8QueeAY7JrUTLV
         qs7oBvoIHErX7lP1GC49c2BlrRiI4MJtQm+SngCBOrPqwftVZk6w6Bd9cEF3rjGNnvMD
         4UsctIm7Bdjlmejoogvakzo/3OvQ7M2q87Ka4Kgmfl6YnXCEcjnQqeOo7h+ujtqCJ/k0
         zC40pKspClNVOcAIXGXS90Gwkjz+WPiOWLCV2Fo351YTSUpHkiPZzIrBABWOUXcPvM9u
         I+Jh8a9VUUjRURP+35AaDufNFGDEcT8gJ+a5NeQLsX6DNvMxnuJupHPNu1D81zk8ki9T
         pDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q4OhGt5AzFWQajRTYEZfl8YZDYTLN83g/8e0S0EReJ0=;
        b=qvlbqjbwr2zzgtSnSK1xMFHjl2JowiaaVK6kCUaJBZPnEsfGenNrZ37Jo6IGuNC6d6
         Rd/K7SORAHChFcPGmXTbMplyrA4mk2mosOuZl8aSmK54dUGLGdZ5WROX1jgatdRC3gqT
         /382P/APkXshMUWHM2VIIcNVT04XkCDGOqim0dOSevQgkfAdQ9tqB0NlvUihyTHKcu93
         +bwWAVNxDZn2vrfGTiT7elMbP4ioUWMI+fb3YgNEaM/FOozecF9UB+p75yrgo0L36Lea
         GGoY/ZrcZuCFWNDdCi8kA9SxVxTTGJn1kTmmoUfQNnAwxvkDdUGYH9ZGBSWebcue9rRI
         E+Ow==
X-Gm-Message-State: AOAM533kZh7/046b6+6TpsfiFW/DMv7e8yzZ3cPV/k2PVqbz+ot5yzI0
        nuO4qii9uiUvdxXaH66/No2deABVDSH1/BQq
X-Google-Smtp-Source: ABdhPJxSHbBCy5clh7P92c5HDIR3gwCKfKFo3iTTQ8mYL2V5o5aPNCTW4l6EzEEmTqnCYD/al9P6ng==
X-Received: by 2002:a17:902:e804:b0:138:9904:ef6e with SMTP id u4-20020a170902e80400b001389904ef6emr2007187plg.77.1630048326599;
        Fri, 27 Aug 2021 00:12:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b5sm1158725pfr.26.2021.08.27.00.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 00:12:06 -0700 (PDT)
Message-ID: <61289046.1c69fb81.5fc0c.2ec7@mx.google.com>
Date:   Fri, 27 Aug 2021 00:12:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Kernel: v5.13.13
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.13.y baseline: 126 runs, 4 regressions (v5.13.13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 126 runs, 4 regressions (v5.13.13)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
    | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7aeadb5bb82ad21ffbcd54c81d77727b7a05e6c1 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/612855ed996d8a84048e2c9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612855ed996d8a84048e2=
c9d
        new failure (last pass: v5.13.12-127-gb85f43f33b05) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612857f30eb31dfc408e2c9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612857f30eb31dfc408e2=
c9c
        failing since 2 days (last pass: v5.13.12, first fail: v5.13.12-127=
-gb85f43f33b05) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61287a04874771f1198e2c99

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61287a04874771f1198e2=
c9a
        failing since 2 days (last pass: v5.13.12, first fail: v5.13.12-127=
-gb85f43f33b05) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61285a2054e97c47d18e2c8b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.1=
3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61285a2054e97c47d18e2=
c8c
        new failure (last pass: v5.13.12-127-gb85f43f33b05) =

 =20
