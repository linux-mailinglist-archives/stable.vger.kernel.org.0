Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E968422EBE
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 19:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbhJERJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 13:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbhJERJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 13:09:38 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E026C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 10:07:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r2so20375465pgl.10
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 10:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MDp6fWhyae5K1RNdo/hds+kBd0YHDS0ut0pS8DE8n3g=;
        b=6lELR2Ye+npjP6T5Zi50wnUnuz+/adB5lx12mplpix5ik7YlJxWZMh56X1wC/KvKnI
         g3RJAthsw/eVdxMShquaqTueuvRHSu6UqRy5AysmSsL+ImVP5ACoPuC7nrg2cnVm+RWP
         Tb3adjQSao/e03I5v00ZcoNH2behFpr7rzpTvK7NEcnFSxxWY1BgXB3jyQlzaJmBZr8C
         rBwSBMtDpDU4cNf5ZpI4BPvehVw0qdllErZhnAK+XqQQQB3ANsIBaFI6acvrH00hoU1j
         guf4v9m0S6do7xgZczJMb/N8qsk3qES46vMulSuQCAppmwfThgAWUAAqv1Z1bmHhWCra
         sSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MDp6fWhyae5K1RNdo/hds+kBd0YHDS0ut0pS8DE8n3g=;
        b=VFcs/z1Vfq0mOylgnJjcsmRKIMKPruBZxoqYgWhbymsTP3pNd946lIil2U/PCYoW1Z
         SvF9oltO4pgoELDnO2YxOeKfhQwcVZtnmn/Fx2Imx424PIa/McnOHrRcs9xYFTNIzkYv
         2ydq8cgiy74bbyBhsdkxY2X3tJuc+Rz3YyfPMNgMoR+PZoU0e4JYZ3DVa6cvLjYCNax2
         hKRVew62kKnPrQ/VyTZ63LqQ5OQGYwPZR6c+ZhaZvMXEBKNsdUiBHHnDOtkACiCGva8C
         UthIB4mUSv9zZHmUVIuUjtozwIXPRK3YZbjlP298GGIBb8UhAq855xBc5qDVbc8KF8hp
         w5ew==
X-Gm-Message-State: AOAM5335WufNvH0wEPpEv5T50GZNRBp1vY8gQYyWTHgbJz5U0MXA36wz
        Z4u8y8aHRYCrYA8GfwGQb+tZfTK1al9BZgUu
X-Google-Smtp-Source: ABdhPJw+zrzz2/uRewMiv/kFNh7bBkFJGlnIMqVmGiYPYYj1yZJf8UMBtALuJHk0VZ8ULckpnhh+aw==
X-Received: by 2002:a63:4f56:: with SMTP id p22mr16531707pgl.134.1633453667410;
        Tue, 05 Oct 2021 10:07:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm17897078pfe.215.2021.10.05.10.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 10:07:47 -0700 (PDT)
Message-ID: <615c8663.1c69fb81.eca7.8553@mx.google.com>
Date:   Tue, 05 Oct 2021 10:07:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.70-92-gb230df3cda42
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 152 runs,
 3 regressions (v5.10.70-92-gb230df3cda42)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 152 runs, 3 regressions (v5.10.70-92-gb230df=
3cda42)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =

tegra124-nyan-big       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.70-92-gb230df3cda42/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.70-92-gb230df3cda42
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b230df3cda4208645c2f73de3bdbd50c1907886c =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615c508c1a09d4f39a99a34c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-gb230df3cda42/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-gb230df3cda42/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c508c1a09d4f39a99a=
34d
        failing since 96 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615c50921a09d4f39a99a359

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-gb230df3cda42/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-gb230df3cda42/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c50921a09d4f39a99a=
35a
        failing since 22 days (last pass: v5.10.63-26-gfb6b5e198aab, first =
fail: v5.10.64-214-g93e17c2075d7) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/615c7deb7182daf56299a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-gb230df3cda42/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
92-gb230df3cda42/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c7deb7182daf56299a=
2e9
        new failure (last pass: v5.10.70-93-g42da4b1238c5) =

 =20
