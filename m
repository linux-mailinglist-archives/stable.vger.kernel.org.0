Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED3A3CF3AE
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 06:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhGTEMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 00:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbhGTEMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 00:12:39 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9ADDC061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 21:53:15 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p9so12995381pjl.3
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 21:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zxBhfq7tRvwOwLKi7zZ0ByqJ1889R1XVy+/VIs3EWb0=;
        b=HrLIH3ASSkC463ukRU7mNym4ihHgcwW1Vl7/4PCHewRCgEaogvLw8VDuS1kwT5VHF4
         /SV5UC5ucjSldZIC6vMkXENXXmSm5IlDqTvR0mcGJVGJZGEY3lHA+V/bR97xeVY89Xwi
         CmZ6A99iln05MxJQo4MCTxWuWUZgwTzsiLJ7B1tv0LDDo6WY4rY3PFi1Qb7pMaTPc/q8
         moF9SfdMj0r2zJq3qPirTIfhOVpzH9nEqBQFJWIc3VTJ0vC6/LJxtVZMqQVfK29Tp96+
         ceFrLA16X2JESRsd/oamVBZc/RVIfFL1aMf9BYBBD5IGKsoMAZxUPDjIXf9W+Ap0ztb2
         9Bog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zxBhfq7tRvwOwLKi7zZ0ByqJ1889R1XVy+/VIs3EWb0=;
        b=IIsvR9gaAJaJ2NI19uAI9Hr6ppGPlpqQ/mimyvOFOky5oLR98te76w8CeUPhMP7MJY
         1ZfBQemFgVhXd4eg/HingqhLMn5ZrFcmyMQ7i8sPn7mErYF9BUp0wouXaLAJLKjDhcD7
         rhe5z/FlJhCVp0fqHdEELW2wZJYhE3JPdV07c8ouK6zUfumy7qlk3EXUfDeyImy3VlGF
         ScZcu/N5kTpZDQRG7mhvptYliQxEe5lnMBgTEBKJ0Asc/Sw7oPse2OcFyflm4EpUre1D
         CrhUc+E9NFF1UUa2uQIKeVQGq33gWa8w7Q7tVDuiOsDHiY6/rBNoVGnC62347Y/lYEW+
         VVmA==
X-Gm-Message-State: AOAM531pvyuSmnJCaVXzCDfwl874WQRRginZll1RwHgjDOjep1lP9tQd
        GbQ+3q3AzLGVTR5DFGg6glVDZ6kqPXA2/Q==
X-Google-Smtp-Source: ABdhPJzXe8ZNW/H/IY3L9hiuDiseOJvZqWXhg8WLi7apeeZ88yvaHJuMTDusjg//jiNGqHB5A5HBlg==
X-Received: by 2002:a17:90a:28f:: with SMTP id w15mr28142951pja.70.1626756795243;
        Mon, 19 Jul 2021 21:53:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a18sm21843010pfi.6.2021.07.19.21.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 21:53:14 -0700 (PDT)
Message-ID: <60f656ba.1c69fb81.f94a.1799@mx.google.com>
Date:   Mon, 19 Jul 2021 21:53:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.3-349-g948be23c1d3d3
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 192 runs,
 5 regressions (v5.13.3-349-g948be23c1d3d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 192 runs, 5 regressions (v5.13.3-349-g948be2=
3c1d3d3)

Regressions Summary
-------------------

platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beagle-xm               | arm    | lab-baylibre | gcc-8    | omap2plus_defc=
onfig          | 1          =

beaglebone-black        | arm    | lab-cip      | gcc-8    | multi_v7_defco=
nfig           | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =

d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.3-349-g948be23c1d3d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.3-349-g948be23c1d3d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      948be23c1d3d363230d17559423ba4df617d9c2d =



Test Regressions
---------------- =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beagle-xm               | arm    | lab-baylibre | gcc-8    | omap2plus_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f61f992628a772bd1160af

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f61f992628a772bd116=
0b0
        failing since 5 days (last pass: v5.13.1-804-gbeca113be88f, first f=
ail: v5.13.1-802-gbf2d96d8a7b0) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
beaglebone-black        | arm    | lab-cip      | gcc-8    | multi_v7_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6209fe60c4e6f0e1160be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6209fe60c4e6f0e116=
0bf
        new failure (last pass: v5.13.2-253-g45582c2691e0) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconf=
ig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f61f0b0a0d0e52ff1160b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f61f0b0a0d0e52ff116=
0b7
        failing since 8 days (last pass: v5.13.1, first fail: v5.13.1-782-g=
e04a16db1cc5) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
d2500cc                 | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f62859152491da151160c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62859152491da15116=
0c8
        failing since 8 days (last pass: v5.13.1, first fail: v5.13.1-782-g=
e04a16db1cc5) =

 =



platform                | arch   | lab          | compiler | defconfig     =
               | regressions
------------------------+--------+--------------+----------+---------------=
---------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe   | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60f62570fd19a2f5151160c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.3-3=
49-g948be23c1d3d3/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62570fd19a2f515116=
0c9
        new failure (last pass: v5.13.2-253-g45582c2691e0) =

 =20
