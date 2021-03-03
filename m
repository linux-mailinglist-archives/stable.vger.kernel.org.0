Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9BB32BC0C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382958AbhCCNjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbhCCBoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 20:44:00 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3043C061788
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 17:42:41 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id l18so3317052pji.3
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 17:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=95/D4bzL4fYXTwUf2wTEFOy7CBghMi82UkzJbDoSVcw=;
        b=Vcn9QbSVJNwNRH87hK0qOA3aK0zb3EbyX5zjSJ+qi0qawvJJFGZsdGMvm4ONZDCCb0
         Tb+iGg/4e2kw5nEk9dV8vA0UYtNLdMvTkuXT0FEn/78ZE7xO5hSFaqW4/WxkWRTZ3cEz
         45uBWf1EOtaqSyyNYZtioBRL/7dPKl+gFB6RDFQi5xaTMgsaGgWBXrTKgXA2M/PyPlZH
         4YQDxD4mxr3BIPYilNN2mXxLg2pyyYk3p6RbjX4OndoeI5PeArLe6tE/ZSnZCPF3Aqbd
         qXpcEBxgPsFGC0oqTSF1WmMLUMVYP/vIA7S7W8YFao/OXTrpxOrno22fipvLvnHufy1c
         Fgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=95/D4bzL4fYXTwUf2wTEFOy7CBghMi82UkzJbDoSVcw=;
        b=s8uMNRB2J8da+tyVO0WFhvugX3chA532NIHRXEf4Wv7gRymVCRuV2MKQVPxOscw0OP
         iM1xQx/bzmBg0eoEqsOWymE4UwePzwkyc6IjzHkbovZWF/hw7g7qHYBVvk7JTPut5uto
         +C/lOaqnlLGdE/vyzM+aR0nClbJp4UDeP13MbyFywBpvN3vFH+k+/tkOHa9F5ibfbgS9
         Oc9AmaaPIC22ZwMo9t97+jFyoG2iGefee1N1zohvIdVa6q7tMYIWHt5o8/0SmKsMMb4P
         OAcqhf7dlex4cjaU9O2kuS1504kQDvQXCZ1uVTfJSwPkmC/OtkNZQtwgs/ktSXsLz0Tb
         oVBg==
X-Gm-Message-State: AOAM5331c9kNTOe2BpFWF0TOAc4uX6Remz+Tg2JpwvvZnvpjmg1wXuyl
        shiL2bNighiPZpnOFT+2YjjXgo23deZ9Aw==
X-Google-Smtp-Source: ABdhPJwwgG1cE22terUPgtF/Pjf5vw5CdAUeGcpmy0TkTM4M81Zmhm9xpVlo7oGf+jv7RAhQoa/kgQ==
X-Received: by 2002:a17:90a:420c:: with SMTP id o12mr7316209pjg.193.1614735761136;
        Tue, 02 Mar 2021 17:42:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ms21sm4995000pjb.5.2021.03.02.17.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 17:42:40 -0800 (PST)
Message-ID: <603ee990.1c69fb81.9350d.ba45@mx.google.com>
Date:   Tue, 02 Mar 2021 17:42:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-246-g90138bf8c544
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 130 runs,
 4 regressions (v4.19.177-246-g90138bf8c544)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 130 runs, 4 regressions (v4.19.177-246-g9013=
8bf8c544)

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

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-246-g90138bf8c544/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-246-g90138bf8c544
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      90138bf8c544508814bc322a1cd793a06a1b935a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb65df290e873f8addcb7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603eb65df290e87=
3f8addcbc
        new failure (last pass: v4.19.177-246-g84c6db07880a)
        2 lines

    2021-03-02 22:04:08.207000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-03-02 22:04:08.216000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb3d7b7f35e22d7addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb3d7b7f35e22d7add=
cd1
        failing since 109 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb3e6c8ccd78256addce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb3e6c8ccd78256add=
ce6
        failing since 109 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/603eb3857eef8da40baddcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g90138bf8c544/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603eb3857eef8da40badd=
cc7
        failing since 109 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
