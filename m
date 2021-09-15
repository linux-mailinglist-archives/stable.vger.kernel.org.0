Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845D640CE67
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 22:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhIOUtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 16:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbhIOUtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 16:49:42 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89737C061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 13:48:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t20so2986883pju.5
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 13:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=je7KcXzeUS05rSGZJOp5R1pX13M86y8/V9jezfkrYjo=;
        b=fTqOT5iUQDdubVNV+Is1W2k7d+tju3R6EwLXQQted4HMaW7c0mN3hWNeml0N7NAMsR
         C+J2QwVIZOcCmrVyxS5I3UVBXoHXWNMU910ML6rFCP/tCxOCYMj/Nj1F8xEodL3YOses
         +U/BD04hwqxP/3z31qYVCE4zGNUyfXDrrjZBPOyEePWvCvXj8v8G4ib1YDljhAdg45Fi
         Z96yEbPerz6Im9ckHAzQD2lr/mL0/EAgnwHDqwaX5JRCyR/C09jPeHLvQKJoykkd/72z
         F5eTca4WwQUvXoZIylbZbpVNII7BNdkfN9ayyouwpfv7UEUPhyB0QA0uwvxVTsWhcvK7
         SQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=je7KcXzeUS05rSGZJOp5R1pX13M86y8/V9jezfkrYjo=;
        b=OIqaIwBOtSWwoKuUu6IHeEhk/GMLKVgVzzuxwV7xchTJZv/XViGbrHgJtvr0Hk+Xog
         +zwPAZc41JySEmonZDhSvit78ITjCsgZcyE9g6Rod8vLaGL5aZAbR35GiB3bLyw/X2E4
         9NxGM05AEPdFtdGqjkVxalvrwm9oELYlG6ldk2MA5t3UhNiekdnMeA9PnglihLVUXkOw
         g/sR8Hw1N7hLRm4g0yroydaCbhGTN8AlP5OSTZVgJM/uD+G9JOihwPCrB0mXWHdEE8uC
         zfqtHWNjPXXVkkH92LjXIpEdo2QCqN7WqjuoQ54urriYVAsbQPHWk9cy8HXuLH9XkNRD
         91mw==
X-Gm-Message-State: AOAM5326hMh+CbYrFxl5Kb33BTSxszc+zC5oGktKYdABb4t8Jm6ic6Dm
        pIF/0q2cw1Z78f6bm68ZKiswcL6jCYztf0wqGag=
X-Google-Smtp-Source: ABdhPJwFZe0jFnNE2e8jouFc/qnGis/c7CQKxQIzcZudzrbDPYlOP0+/xwT4a0IFFpwE7LqbkXpK/w==
X-Received: by 2002:a17:90a:1d09:: with SMTP id c9mr1810069pjd.204.1631738902881;
        Wed, 15 Sep 2021 13:48:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm854737pgn.39.2021.09.15.13.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 13:48:22 -0700 (PDT)
Message-ID: <61425c16.1c69fb81.bdbd8.3d51@mx.google.com>
Date:   Wed, 15 Sep 2021 13:48:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.17-68-g71a177e69b76
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 134 runs,
 3 regressions (v5.13.17-68-g71a177e69b76)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 134 runs, 3 regressions (v5.13.17-68-g71a177=
e69b76)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.17-68-g71a177e69b76/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.17-68-g71a177e69b76
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71a177e69b76fafb9c29ebba5e30b866bb2decff =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6142594e3e0a2b3d0e99a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-g71a177e69b76/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-g71a177e69b76/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142594e3e0a2b3d0e99a=
2f0
        new failure (last pass: v5.13.17-17-ge0578f173e9a) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61425a2c908f57d0f099a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-g71a177e69b76/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-g71a177e69b76/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61425a2c908f57d0f099a=
2ea
        failing since 6 days (last pass: v5.13.15-4-g89710d87b229, first fa=
il: v5.13.15-6-gd33967f7a055) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61422a36eb36ef405799a2ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-g71a177e69b76/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
68-g71a177e69b76/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61422a36eb36ef405799a=
300
        failing since 2 days (last pass: v5.13.16-263-g6cdb0b2e1c97, first =
fail: v5.13.16-300-gcec7fe49ccd1) =

 =20
