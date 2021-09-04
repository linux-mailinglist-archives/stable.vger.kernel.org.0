Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3720A400BD8
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 17:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhIDPOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Sep 2021 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhIDPOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Sep 2021 11:14:24 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F80C061575
        for <stable@vger.kernel.org>; Sat,  4 Sep 2021 08:13:22 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s11so2032841pgr.11
        for <stable@vger.kernel.org>; Sat, 04 Sep 2021 08:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H/Jie0owjK3eDqkJG237ZYvUPmJHAvv3IB8eV+KtSOo=;
        b=xjuFK7XRkH+gnZlR1c9T/7cRMm+k5xPwZb1nyxkd75uGJHKKxwEpmHZAGjnqYG8CnA
         O72RNlAOuTVjdKRauTy/KN900P8VIqDAUpxXmdD4jeQZVuAb0RrP8Lrd/lG2oyu+401J
         Jh1Bzm0MB3vvjhvbzmZMOvJpQXrwcvM6PqaMNU9jA2hpnFEKBMw5qhiPLi8lX4ORDted
         LpL7dHyzXQnljI/db3nT8ojR8tPzrNZubMxDIrtYWB+GcPVXFwEqrH2sMgrxBEQuMMRh
         Z+LyECZp28Jv4ocHXWwWgBl34HwMXMjj4YfBBNGBhIAejNiQbkKv/tUsp6iZhE6QKeFI
         yOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H/Jie0owjK3eDqkJG237ZYvUPmJHAvv3IB8eV+KtSOo=;
        b=T/ldQAEpQTwl/wMB56WtJbxHUqTx1nt/b37awRlemuqB1Ff4f1+DfrNDzd+kDnZJfJ
         0Yi1OyueahybbR0uNkkT37pjRwrcR4s+FWxmTHd0ZsvLhL43a07ymJjpjSm9CnAtHqac
         WMcTTbWefDP+6h/kEMsw9I5t0xT5qnpQXYY+J5Ae5VvUOHV+nal8waM8Ocbl7Ov9qSeJ
         IDo0So+4nILxu1eT4qThe+BJb4qjARM1eynrLDnBATVs1v0gCkTMaiqrO5pKg9YxS/sm
         2AIfBbcYVRUCvJuI6NKpSm6fdNyT24BloEYlg8LAEUA8UTdoneY1/BT/BojPh/Wyb+kK
         mc6Q==
X-Gm-Message-State: AOAM533S8zWXs9Mu/S68lNcTYbhwjOKb4HS6pqpab58cV/OUVh88XlD5
        GMEp4T+RBShS8wluDAcK8mN9tdedigrQtakg
X-Google-Smtp-Source: ABdhPJy6jqkOyy/s8HqDGtp6vxxaD0CgJAEQ9uXzVahBR9OwTGbkC1qKfwmDwT/KGw215Ai/jdL+Hw==
X-Received: by 2002:a63:4206:: with SMTP id p6mr4023311pga.449.1630768401765;
        Sat, 04 Sep 2021 08:13:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm2678322pfl.41.2021.09.04.08.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 08:13:21 -0700 (PDT)
Message-ID: <61338d11.1c69fb81.af56d.75b1@mx.google.com>
Date:   Sat, 04 Sep 2021 08:13:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.14-2-g74aad924bd80
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 193 runs,
 5 regressions (v5.13.14-2-g74aad924bd80)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 193 runs, 5 regressions (v5.13.14-2-g74aad92=
4bd80)

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

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.14-2-g74aad924bd80/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.14-2-g74aad924bd80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      74aad924bd802745a3d55e5ea2cf48679d479f65 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61335b9e2048a5eff3d5967a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61335b9e2048a5eff3d59=
67b
        new failure (last pass: v5.13.14-2-g1b53bca7aeb0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61335d1a94520da920d5966b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61335d1a94520da920d59=
66c
        failing since 37 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61335b84ee47e7be55d59696

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61335b84ee47e7be55d59=
697
        new failure (last pass: v5.13.14-2-g1b53bca7aeb0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61335ff1e1f0721ce2d596a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61335ff1e1f0721ce2d59=
6a6
        new failure (last pass: v5.13.14-2-g1b53bca7aeb0) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61335a9106ebc3d45bd5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.14-=
2-g74aad924bd80/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61335a9106ebc3d45bd59=
68c
        new failure (last pass: v5.13.14-2-g1b53bca7aeb0) =

 =20
