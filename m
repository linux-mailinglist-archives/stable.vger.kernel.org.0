Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536B23A07CE
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 01:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhFHXgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 19:36:43 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:42581 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhFHXgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 19:36:43 -0400
Received: by mail-pj1-f47.google.com with SMTP id md2-20020a17090b23c2b029016de4440381so277383pjb.1
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 16:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YylFPIjeuidPf46dPh0ck9zsRWjf6ooNV2hYyB0bQME=;
        b=TXGGqQYT8w4gLi6lXmoL/cgUo/mXUsw1lYzufS5SxThqY3LSu+oXJ22lzIs/tdNJsP
         sTewcI3dg/0tyqdCpOt7I6SnA5QodEemoWBmL7X7t4JtV5kLGP3JvWHUHW7nVZK3PbNs
         R361Jdq7ARR7luGykEumB4BXa1Zgt8BBm8ZyyCFmkmdZXRRkXkOf4AdhDWv+cPyQOgba
         s32YDh/ZUBhT/fQuJ6Oow1+Qp/Nnb5X67A6suydvsbJgRLWN5hlb0hPp2KFseYSVl6SZ
         Q5acyyGxDO0zNV4i38OUsZO6YkDEsPvSoHXQCEJVEC0u6OIQw3jTm2cvPOrvK8apZx7W
         8dwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YylFPIjeuidPf46dPh0ck9zsRWjf6ooNV2hYyB0bQME=;
        b=VckHjm0JhZF8rfBdH0PvREcGdiwzAYIqbH25sO/S3Ls6YWwQr4A4aCBZIMvn/BqBM8
         eRenUfZA91x1El0nOKtDS63Ma21/3IQCZ0V1fngHdzyFpJhY1SJ1UwbWck6VT65f/5nM
         1gY+naWoSZNzyOS5O//gOUmDpy7m+1sj4vU0t5YVTPt6s0psIiRpApodXyNNXvOzr1kA
         SFIxJf+kSw+hYtsqzHBo9weNbn+JoXo4+wxumnEmu0NPvpdtHtcGJnyjBWoEKX5dxP9t
         QPXqBQcwXTs+FiHKK4eKi3x3eJJxMAX8x/WFo7iG9TpMgfvX1+w5qsrjyBZOjSZu1BB3
         GRAQ==
X-Gm-Message-State: AOAM5311IkeTR6j21e+UKQa4smgchEc8iFSuhCSgGVTS9JimuXT+3nlu
        ueZ4dm/GnN/1Zse2kMH4PfJRwV2MK9baVYlo
X-Google-Smtp-Source: ABdhPJxRgTTBZkK41FdvyzD0JUL5BtcCIhod76n/xiHY2lOaWzlVl4pUtyq1kMr5TcRjDt2exnN6DQ==
X-Received: by 2002:a17:902:f688:b029:112:7c0e:d027 with SMTP id l8-20020a170902f688b02901127c0ed027mr2519612plg.34.1623195229337;
        Tue, 08 Jun 2021 16:33:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e17sm11547302pfi.131.2021.06.08.16.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 16:33:49 -0700 (PDT)
Message-ID: <60bffe5d.1c69fb81.97200.4533@mx.google.com>
Date:   Tue, 08 Jun 2021 16:33:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-58-g878626b6b122
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 94 runs,
 4 regressions (v4.19.193-58-g878626b6b122)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 94 runs, 4 regressions (v4.19.193-58-g878626=
b6b122)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.193-58-g878626b6b122/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.193-58-g878626b6b122
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      878626b6b122f11c401c0a1b7c86a22a2a9dc08e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfc8695394590fd40c0e0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfc8695394590fd40c0=
e0b
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfc86929cec0a0c20c0e1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfc86929cec0a0c20c0=
e1b
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfc87386a85121b60c0e10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfc87386a85121b60c0=
e11
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bfdce166549718650c0e02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-g878626b6b122/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bfdce166549718650c0=
e03
        failing since 206 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
