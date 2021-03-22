Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C3F344FE9
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 20:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCVTai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 15:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhCVTa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 15:30:29 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B93AC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 12:30:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so9098446pjb.0
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 12:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7R1gyDqIcuqGv2ug6DvHiQqE+tLVkPZ4XLLCkvet7Hw=;
        b=ncgOXIHPd8/QDHXp2nBJg7PqMXP837xfTCk9tRok3zFg7uedtWKCKfy5JtLA1icyrf
         d4mYRrUqzL9cSoKSml9oS6IIgUnAG3f3sgeIc5JvDQ2znlL7TyegvO76fFu2hMUoKBlI
         6hbf++JZZBhHbJegdWaPIMJw2UXecwDStbQhsKb0vwZmCcYTeoA+T+hRMrcHAifv98DV
         gfQPbuzsodFkQjuA59SvckgtzSAfzVVg2p03k18sCUgwspCHfQ+6GWr6sRqRhfFlamY6
         oTLyegcMHQXLlbByEyoUvQh/tCsSwLuAGRpXnMNI3M1ZpiDvBSMj+gyo+yeTrjKtMALK
         feHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7R1gyDqIcuqGv2ug6DvHiQqE+tLVkPZ4XLLCkvet7Hw=;
        b=NtIdVyeVolYSCTHPm0N66kLTxpOo37uLJ0zCVyVagTI8fpGYBS61tA/8e9h2PxyAsV
         0x9SvyNExh7ynaKT9Pw9aN39vf0NS4BMX+Vaqk6S/C58bWAkL+/z68SJ3EyVY0GeoJMf
         DZAwig+3MGmvCXp4b0stHU8cMAUcLikof+d/h6lM7Wi4YIYfM+q10f5Sn7C00dHY/TbS
         XKkbWIfcm9bEnQmOHRqZkK9xa+rJh87ja+l56wzazYaSHE55Xn9dw5BLH9pwfZIc+Ra6
         sa1cQCP8Cqqk4SiRavo5aVsjUEBy/jX1b8Mz9HyaU+O36ZcaKmYKGmKtnm8l8D59XuHp
         18mA==
X-Gm-Message-State: AOAM532CuG91WuYCkwPg/njWwaVxAOK07Df+ZYMGoovSSZ9G3c5x0rSJ
        rvPf2XCcN34bOHD8V6B77tY2JfIDwtdzNQ==
X-Google-Smtp-Source: ABdhPJxXapra1gDB74qwCVzfDU+YsvclYmpujgoEJyl+A/QWlvAXzDcNwtOcOIk38YmcqBMd1tGFqg==
X-Received: by 2002:a17:90b:e0d:: with SMTP id ge13mr659057pjb.1.1616441427614;
        Mon, 22 Mar 2021 12:30:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk6sm192052pjb.51.2021.03.22.12.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 12:30:27 -0700 (PDT)
Message-ID: <6058f053.1c69fb81.c0198.0d22@mx.google.com>
Date:   Mon, 22 Mar 2021 12:30:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.226-43-g8c28f674eebdb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 122 runs,
 4 regressions (v4.14.226-43-g8c28f674eebdb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 122 runs, 4 regressions (v4.14.226-43-g8c28f=
674eebdb)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.226-43-g8c28f674eebdb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.226-43-g8c28f674eebdb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c28f674eebdbc134023dc1b443f63bdd4043a8a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058bd30ed98d6ad95addccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058bd30ed98d6ad95add=
ccd
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058bcb261a383becaaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058bcb261a383becaadd=
cb2
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058bd64f2e0bdbd6faddcf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058bd64f2e0bdbd6fadd=
cf1
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6058d6d68fd9f4b370addcfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.226=
-43-g8c28f674eebdb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6058d6d78fd9f4b370add=
cfc
        failing since 128 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
