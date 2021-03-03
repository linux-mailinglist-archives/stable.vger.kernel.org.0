Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C1F32BC0E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382989AbhCCNja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238457AbhCCCGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 21:06:12 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F922C06178A
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 17:53:33 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z5so293931plg.3
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 17:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rS+KoBPg7bzGUnV071BBOoHc8D9B+kWi4H6ikZ5C1ME=;
        b=utKWtXZ9NeUmZVd7t9lliU1gBllVjdi0DrHJu8fAWdtr2nXrnYWk1AQkCIPJ9upAv0
         WYvDgRRyCzFTX+QLawc5yg6TpsQfbyadymkpDe8xAz8uFzieYQcBqFUmJAVIso6WaM3d
         6Oclq92CWK8z4AAZ7gg3dlAMkrEzrkl2tsrfysLsyoS3xFUJA4LEHZmEpmghec2vKIZ6
         gpGbL3vy991rN/Ab0OQaGxmulo0Ov2BSzfDG8IaPxlD1h7t5fYMDllVDfc9akdZCmQWs
         ySiW9fALrfBeR+Riuw9Tvt+FHqDHo4bIjpRtGOK99T5iX0qrkFz5NG7TChQPVueQtgeR
         Ii6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rS+KoBPg7bzGUnV071BBOoHc8D9B+kWi4H6ikZ5C1ME=;
        b=pXlQN5Oeqy/mG0OJYgDoOnwN8OY0bwYyIWPfCyLn/kjz5q4b5Z5BnROTGTA8rrUtUw
         nizr93Mknrw/8E4ubKwfVtOyq+bwIo5fVqey+QQqMAq9DnkfcZOaOhd5AzhMoDTGbzX1
         XSFH2xTMCXBtbIzYtWVBYNxgYDbwWhxdlxISggD16/gPYtN8TJfg2llPPR7bbLTfwwzI
         E1vicBTUKa5FKzHfnKDKN1hWLOUbGyYLHkUOLcw9ofs1tNs1nNMg4kxNiuHeS3ad5XHk
         FxENxSxukencrLup2uFxlKZOdiAY8ykmIhJZVT51JQfutavs/HU0uSvPknsRQyMl2hw8
         dMYg==
X-Gm-Message-State: AOAM530H4JoeHXVPdYJHPFmIPjwEScID3C/eY96aM7JMElCkZFq+i7wJ
        CSz84aqzjfhJ4NaXQegDE8t+BlT9bXed4Q==
X-Google-Smtp-Source: ABdhPJxu1Fifj2m0XIfGSy/faccbgGbLZv3Z6LnRByZCnd4lnisdUbugvqw+9I9Lg9BRjnnQE+8nKw==
X-Received: by 2002:a17:902:7249:b029:e4:358a:1d47 with SMTP id c9-20020a1709027249b02900e4358a1d47mr851079pll.8.1614736412716;
        Tue, 02 Mar 2021 17:53:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f19sm22304106pgl.49.2021.03.02.17.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 17:53:32 -0800 (PST)
Message-ID: <603eec1c.1c69fb81.c5d53.3b22@mx.google.com>
Date:   Tue, 02 Mar 2021 17:53:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-336-g73aac2336083f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 145 runs,
 4 regressions (v5.4.101-336-g73aac2336083f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 145 runs, 4 regressions (v5.4.101-336-g73aac2=
336083f)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-336-g73aac2336083f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-336-g73aac2336083f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73aac2336083f971de5eaa87f8688f2707b5efae =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/603ebb71b2ceef4213addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603ebb71b2ceef4213add=
cb9
        new failure (last pass: v5.4.101-338-g7730b625139f9) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb7325c318a927caddcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb7325c318a927cadd=
cd2
        failing since 109 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb770e4192996d0addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb770e4192996d0add=
cb3
        failing since 109 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb6d91bfae89f63addcf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g73aac2336083f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb6d91bfae89f63add=
cf2
        failing since 109 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
