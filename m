Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42A3DC789
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 19:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbhGaRyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 13:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhGaRy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 13:54:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C165C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 10:54:21 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i10so14909545pla.3
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 10:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dGx7ITwfLOruMNwp6QitVGBUlip7srxzvOqd77htqgI=;
        b=w4DFtBS/24e41zIvZP5+eg5QQfF5yseQtf+Er86BQHDqYv7pJkL+DqRr7XDSAtHI8K
         MPdthdGGVSYXPU5HQurQy2Dr8tFJ0lINKdqAjVSl5fHM02jTX26TX31okNuxTfr166Eh
         zEVw4TfG6j3DbaDCTheTwcmPfUE8gzdryADnkf1+puJC77V1c/HI7Ydt/zxHGA6hHzay
         k+l7+eyB0se6E6AApJV4p2I2XBW1n7aSVBBaX1Lr9aYp3qwxL4x5wBSDUybeWPJ5DJUo
         4YbTiLPKp0fihp6zmRWzINj0IWMgBSjGWVvrpGBvrp88YXzwCb6xLXArwA2QjZtHhGmv
         iLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dGx7ITwfLOruMNwp6QitVGBUlip7srxzvOqd77htqgI=;
        b=pJIuIx3XioVf0VLKSgD6ze6OfQqhM2Rywq2nHzM2B/w/betfxECNBnEmQtP0X89ZKf
         vYPpqNN4K8fbtTEvuJF6mk+mPBpzoy1lVslzexO1b9YkTWBTJZ114r1Kx68zEAvC2tH8
         PEnPCdZNVktewhbCSPRaHegpWMS/oAaScNG8e6EJdRiUUVtntAzPb+gS1wrb8JxqQ3Br
         iFHSp5BoUXdJVkuZx/7Kq4qmc6D8n2jblBr9PrPciKvLjlJBu1jZBrUytNfQkJCkm6DQ
         L4A1cVZjO9RaXkCIWDBZbcLO1HvVaTtTPXNJrsi0kNyUln/re9Z+geOwA0L+/BLs+5vv
         fOyQ==
X-Gm-Message-State: AOAM530hBUC/JAqCavcyvXGuQW5kXiiAdhZC0FDdX66paMdmIBS8n1RO
        KFK52CXmPz//zhHhGJahwg8jDLbppsj9C8IU
X-Google-Smtp-Source: ABdhPJy24m3+K9G7R/JscBHFDoXnNKEk0k2fNqu++b3qpfqSNv7yIAxiSLWMQNDlJCTyu++k6JVaOg==
X-Received: by 2002:aa7:8116:0:b029:346:8678:ce26 with SMTP id b22-20020aa781160000b02903468678ce26mr8514573pfi.15.1627754060332;
        Sat, 31 Jul 2021 10:54:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e3sm6382902pfi.189.2021.07.31.10.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 10:54:19 -0700 (PDT)
Message-ID: <61058e4b.1c69fb81.eaa14.11b3@mx.google.com>
Date:   Sat, 31 Jul 2021 10:54:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.55-27-ge0b8a9439c81
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 158 runs,
 4 regressions (v5.10.55-27-ge0b8a9439c81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 158 runs, 4 regressions (v5.10.55-27-ge0b8a9=
439c81)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
fsl-ls1043a-rdb         | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =

hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.55-27-ge0b8a9439c81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.55-27-ge0b8a9439c81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e0b8a9439c8195151591d99e5bc26d0c145c20c1 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
fsl-ls1043a-rdb         | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/610560516903ccdc8985f45b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610560516903ccdc8985f=
45c
        new failure (last pass: v5.10.54-2-g41c54732efb5) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61055e44bc0b9c9a7c85f463

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61055e44bc0b9c9a7c85f=
464
        failing since 30 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61055eecb7841fbe6785f470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61055eecb7841fbe6785f=
471
        new failure (last pass: v5.10.54-2-g41c54732efb5) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61055e5eb2fa10211e85f481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
27-ge0b8a9439c81/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61055e5eb2fa10211e85f=
482
        new failure (last pass: v5.10.54-2-g41c54732efb5) =

 =20
