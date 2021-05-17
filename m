Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7549B383CD3
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhEQTBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhEQTBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:01:15 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED934C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:59:58 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p6so3687569plr.11
        for <stable@vger.kernel.org>; Mon, 17 May 2021 11:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gSaecX0YPuCmXiCAPttHlUIjF/WN0eyz1P64pj2weL0=;
        b=Om73t4aogYZRUuOXJjaxVdjQi8lmuYeBaQNIp97mtfT9I2zvzjQMdCbkEXQ6d/Mdz/
         wg0SQ0t4LoV+y3XyJOqrZ6sh17yos9UeQUOoRhQf22hLQtNkLg3n9Aw5CRquos5cRjfS
         nXnLJgHj3ErDsyq9Dcai3VeRtBY+bswGZvXYscMVAYTQLXvA2aQibJgRtj0pKZtJ6rt0
         mbleter5Js7tGc5B7vI4b8tYX1oDFpMYUmJmhN6e+CePdA8m3PNpvnENrW50OKpYTNwt
         M+jiL4wPgpo/y8+tVy1rk9c1l6JyUvomqiIJBavuvLM3mScQGuDdxkRwNlVFoCJQiDyD
         vdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gSaecX0YPuCmXiCAPttHlUIjF/WN0eyz1P64pj2weL0=;
        b=fRhtPu/hyziud4pers7wmJHUkLMduZPTW4duUPr7WoRM6yzcP1MCs20NhNJrBD4OQM
         tefqug3TRKQaKCjT6h5UI7LxpdajSL5Wgzzb+jBQSDlif6Vghi9zvJjYmsWeXG7XPPf9
         mVdl5wZwzIGNjECD/AHfIbrAeaPrh8k8TMVe1FGk4VDjLvJe3ckhYLA0KLPPWL2tSX0M
         fYbbAVDlRulMHDVJwzPJo/974wDcLaQD8ynoREnHx9zXUDJdMFT0FKvbXQHdsY1smw7H
         0rMVBet8xep5Z8d4YTPVC4IGgnpkcnUp0h1/p7tgV1uqClhLFvEfMWaLLjutpABUX5Rz
         NsCw==
X-Gm-Message-State: AOAM533ypxsrQmhPhQ4rUwwRSfqcRdIg1RzDKpDNMQzuMyaPpGzVNeWv
        KFDVrgXFkIIZ0a0OymbZRfbc59srnn9NTvBy
X-Google-Smtp-Source: ABdhPJy2p2h1sgDBOtwNhQJ1yvCAB90uE00Jd6fF6mAYTxIfBdEZ+/gl+E6FTh8LmHhP7deeou0Jkg==
X-Received: by 2002:a17:902:cecb:b029:ee:afd7:e58d with SMTP id d11-20020a170902cecbb02900eeafd7e58dmr1580075plg.42.1621277998298;
        Mon, 17 May 2021 11:59:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm2279083pjr.32.2021.05.17.11.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 11:59:57 -0700 (PDT)
Message-ID: <60a2bd2d.1c69fb81.4ba50.6cb1@mx.google.com>
Date:   Mon, 17 May 2021 11:59:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-395-gda830a1e3cb8
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 120 runs,
 3 regressions (v4.19.190-395-gda830a1e3cb8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 120 runs, 3 regressions (v4.19.190-395-gda=
830a1e3cb8)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.190-395-gda830a1e3cb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.190-395-gda830a1e3cb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da830a1e3cb8f3c83379e2ba1d109c5991a1b8e7 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28949b40da69d51b3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-395-gda830a1e3cb8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-395-gda830a1e3cb8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28949b40da69d51b3a=
fb3
        failing since 180 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28961cff5c391b4b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-395-gda830a1e3cb8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-395-gda830a1e3cb8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28961cff5c391b4b3a=
fbf
        failing since 180 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a28942a48b168767b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-395-gda830a1e3cb8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-395-gda830a1e3cb8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a28942a48b168767b3a=
fab
        failing since 180 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
