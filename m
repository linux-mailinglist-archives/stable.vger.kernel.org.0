Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C667C33FBBA
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 00:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCQXNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 19:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhCQXMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 19:12:54 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B43FC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 16:12:54 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id u19so203101pgh.10
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 16:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PYCza918l8MsYDlBbXHNu7LXmuTgRyehk+s/LnLkcTA=;
        b=ujaFMDh2ORESCN4p5+7Q9NhTf4hEdIdobPm4jNZjWwYaSHEP/Ar3YmtiL3tw/1e4yR
         fwZx6W2NQYswkZHjA4wGpQRzhc18hNO0bVy7hwLwhFt+WNHU5/SNRuZXVFerpWfS0+Wg
         xbo1hJ8T1CtfRnpqm8qTsAk3t0sZQ5Wh5ijtssCPWf0FJwlToDQp92Uh42tlWt4+fnZ0
         C/QuD59BBC37+lscVebgHOaAcn94dCqJSfuaXz3z0Ea38zgj3Xm/cXEngJ5ID7J8T+mK
         XT2vrHNgt0rjEfMIuS2gVaywkIYsFZbRp3rNBD/pTN6pvqoPoC3ykwB4Ry7UVZoc3GQF
         5aog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PYCza918l8MsYDlBbXHNu7LXmuTgRyehk+s/LnLkcTA=;
        b=Axg7SIpvY828evcFHq81Q51XZ6ylhMgdalJm5JdYnP7bJLbu2TF8cdLGLOgUU03acp
         vWYYATNzzzW+mc8Q9bVTJDnKOLyc4OQJcB/88tf5T6nV+/DR+IycqSVXeX40gHYVuwOy
         GlJlzOi0XWM454lEvHPHQUC+GtXamypUKDAFDIH/BJgGr93JAe26JJwIysoUohGAWfUg
         4jeXLznDgNGXAbandxRzyIZN66U+KQHbCDo9dYWG8M7y01zu+po/yV5ay80rK6eDBlWi
         FsKWRJZ2jTBLDChlUGM9aRgMOnxQ1bBGuWZuqMBsvir83x3QQejqbJk7VKT6JTl1UUDg
         wB6Q==
X-Gm-Message-State: AOAM531dTO5qHd+1LghiiS6MUTRjXHBxDp1cNQhi8u53EGrkQW4I9Fl9
        m3FBa0J9T8kioZBiCRHJMR0GoyleWqmbvg==
X-Google-Smtp-Source: ABdhPJxrHdnsYqhnbqSt3jv2DuFEBIBICVXmD/Gu2yYPVdTUz8x0rbl54/OTXGsNnaywwWB0b4dssg==
X-Received: by 2002:a63:4502:: with SMTP id s2mr4700388pga.94.1616022773457;
        Wed, 17 Mar 2021 16:12:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 25sm140442pfh.199.2021.03.17.16.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 16:12:53 -0700 (PDT)
Message-ID: <60528cf5.1c69fb81.d2cb1.0a44@mx.google.com>
Date:   Wed, 17 Mar 2021 16:12:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-121-gb2303b65c8f2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 4 regressions (v4.19.180-121-gb2303b65c8f2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 106 runs, 4 regressions (v4.19.180-121-gb230=
3b65c8f2)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.180-121-gb2303b65c8f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-121-gb2303b65c8f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2303b65c8f2f3db4c6b4c74b4ea9220c8921d1e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605254e2dfead8bd96addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605254e2dfead8bd96add=
cc0
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052640db8c43fc3afaddcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052640db8c43fc3afadd=
cd3
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605254b358985269cdaddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605254b358985269cdadd=
cb3
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605254887705a85dd0addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-121-gb2303b65c8f2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605254887705a85dd0add=
cc4
        failing since 123 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
