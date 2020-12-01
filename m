Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D8A2CA8A4
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 17:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388938AbgLAQsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 11:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388874AbgLAQsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 11:48:01 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7509C0617A6
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 08:47:15 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u2so1435829pls.10
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 08:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Uryw49sqEBZp5WG97yMXepdJSptAo9jaEbNQbd4iePw=;
        b=At9g/NLEzGzDVpL1SfuZl7W7ET7ZgFGHHcQdFPV1veQnkWlj1QQGYV9Ae5D0Bl2M8y
         DjH+gUDTTQZRaAqpUtc1dfCC/MrTqwsbF4pq3K35drYy5VG7BiY/vNV8RohWUQJ4O4qV
         24kUBqjQJ+UfEnDN5ka/KHKZan6RlZOV4j2V3lebkxIVwK+XrgiPrpxjZGImt+9r6pUS
         cs2Vy7hxQ/u+s85Wr8PftHGpWuQQrnPpUOgmkZvP39xOcBbcY4ApU3gNDmkqEM643Kf5
         bLZp8bEQcyBnuSt5GgfU9ozhTVl3VAIYytxbE1N62U36F44rhGYVopHtLdK2VppenvN3
         I/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Uryw49sqEBZp5WG97yMXepdJSptAo9jaEbNQbd4iePw=;
        b=syY4glfuafsbTJXILUCTs8mH21qCi9SM+U9fkEyoyQdnbP3GxH1uVxFD3DK/92j+Up
         I6poTRHqDqLO/PTEjBoZO7mVN8PM7Q1zucnolZSCHEf2eeFyeueUHepYmHjWos0iwUut
         P4Bda9XCQcoBtR9LAi2uv5fDSIez9L1NXQaIHxJCDiJ8qEZrNLVgFtwCtgt0iZ3jktCX
         jyn1yhplR7AG94v3JWqVDQ+tdFm++gITnqgObjYZSOYe3knooeX7DtAeR6wrPcSolWWK
         gP6Hzq20HTyqoD7QRPdZh5eIUW6n0jyvqPgVyqAPGott88OPb+6TmN0/Zkrz6+dbt7S0
         t7CQ==
X-Gm-Message-State: AOAM532rvqyjkZqrmX1QG+4Uf1UOmUDHgT56EqiyV1/KR2snuwnyh4tL
        9Fy9EVZME0I+uX+mxbuJsFdh9H3kiVadkA==
X-Google-Smtp-Source: ABdhPJzgqB2YQtp2p1oI2z9pTmWWHlAV6ImIefm2U076lvMDWzOWQZzBteLbzjYx0JTtvmD5N0JHUw==
X-Received: by 2002:a17:902:446:b029:d7:cdda:87 with SMTP id 64-20020a1709020446b02900d7cdda0087mr3610289ple.11.1606841234928;
        Tue, 01 Dec 2020 08:47:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 143sm286021pfc.119.2020.12.01.08.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 08:47:14 -0800 (PST)
Message-ID: <5fc67392.1c69fb81.397a1.0979@mx.google.com>
Date:   Tue, 01 Dec 2020 08:47:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.209-50-g130fada9e24b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 144 runs,
 5 regressions (v4.14.209-50-g130fada9e24b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 144 runs, 5 regressions (v4.14.209-50-g130fa=
da9e24b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.209-50-g130fada9e24b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.209-50-g130fada9e24b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      130fada9e24b335647c85829644a292724f7c273 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc6412e3890b66ff7c94cd7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc6412e3890b66=
ff7c94cdc
        failing since 2 days (last pass: v4.14.209-11-ge2326a479d95, first =
fail: v4.14.209-14-gefcf305b1a7e8)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc63e14966d3e9e15c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc63e14966d3e9e15c94=
cc4
        failing since 17 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc63e3f1dc2d101ddc94d2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc63e3f1dc2d101ddc94=
d2e
        failing since 17 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc63e1ea4955eebf9c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc63e1ea4955eebf9c94=
cbe
        failing since 17 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc64722265b59753ac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.209=
-50-g130fada9e24b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc64722265b59753ac94=
cba
        failing since 17 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
