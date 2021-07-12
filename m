Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32FB3C404B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 02:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhGLAI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 20:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLAI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 20:08:57 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2C1C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 17:06:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v7so16423717pgl.2
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 17:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RaqZ6t1hFL0d1iQPV3AQljhRU6QzXKY0Agc7xlBCxzw=;
        b=fQ4AC0rBsKLhR0uzrIDegkKLonhfmTyTPP1D5f0a/hScZk7mEm6f3Vrzfar8P/KY/P
         IWNsh7ccTxW+SWxNXTMy5XoMUvMl1Cm8vlMN4cjekuLmfOT0BcPzmDeLMkM/TaR3SI6q
         d8e6RbFAhEVZYmwlwzw/HHcuQ4hDQMT8BHjAChTeEv/ub3MZ5+EPE1Qxrsp9MP37LT9C
         0IC0OyP/49dXCbM01UhCW0YBue2QXQGFedzt8TrTBrpiV327dMXTjaNU8SGuVn6MV8D1
         M2djevYqcPMzGbtwSRgRbXDk6YGQ+p9DTI4vZpL8XDPeQOgO6KTHn2izaXl+IREmMNIe
         +flQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RaqZ6t1hFL0d1iQPV3AQljhRU6QzXKY0Agc7xlBCxzw=;
        b=nfIXudS7DZ/xArfHs2YkERm3jyBroqTScvreRv+QiY2+6jrvINln9wWFKoPYer7AhE
         FE5PVeuXD/NTob3UghP4zBOzR2gwqFAx7dSFF8sh+aYf0AnM3+NaqJias6vHfoGq2OeJ
         6YliMzHOY4/Ksniy/zb0IBizkMKRYHBQBq9JkIeTPbnnTOMvkaAHZOEFlvOx3fNEtq/S
         afZlcr0a+DImrisY12gL/lkjt6mdKPNgTLqBKc+xsetj281iOp2ZPgOxNM3xEPv9h6wx
         /XTo9N/yJj4+9RCzNTAJIriwYtnjvyqJdqbQ631MGJUYZMMh425884hPOc44P4Ehln8S
         fYNw==
X-Gm-Message-State: AOAM532VHS4lcoxuCLexUg9qp+tnS7/1Eka1wjvB8c9SpiXylm+W/jVS
        OW4RYOX2aJ5kr0fZXEOukGG72DgAinlPmxLc
X-Google-Smtp-Source: ABdhPJwtAseeT6PQLltobXv74dOCAWt0RWbe5+zITGg92i6aZWFuOHjrazk3MfHzGM4KJ9jRlXmtkg==
X-Received: by 2002:a65:688a:: with SMTP id e10mr7222133pgt.48.1626048369681;
        Sun, 11 Jul 2021 17:06:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1sm11349120pjo.33.2021.07.11.17.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:06:09 -0700 (PDT)
Message-ID: <60eb8771.1c69fb81.f3080.2384@mx.google.com>
Date:   Sun, 11 Jul 2021 17:06:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.197-227-g865e367077ab
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 159 runs,
 4 regressions (v4.19.197-227-g865e367077ab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 159 runs, 4 regressions (v4.19.197-227-g86=
5e367077ab)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.197-227-g865e367077ab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.197-227-g865e367077ab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      865e367077ab9525db1cc9a83010b6ba61acae1e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb535ee48340c5761179a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb535ee48340c576117=
9a8
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb55c685db0d44ad11796c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb55c685db0d44ad117=
96d
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb53d3a2112d613e11796b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb53d3a2112d613e117=
96c
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5e4ac59c62ce1e117988

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-227-g865e367077ab/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5e4ac59c62ce1e117=
989
        failing since 235 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
