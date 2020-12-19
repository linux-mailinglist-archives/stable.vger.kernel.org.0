Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6FE2DF08B
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 17:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgLSQvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 11:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgLSQvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 11:51:52 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5793AC0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:51:12 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id g3so3128280plp.2
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V54Y6S9UqakibhaCV07rNudhMWmvRKyEwrtYA7GXibU=;
        b=BZ9XJOrzK2i2CWeKlZaR4PiAMYZ15AtnDSmnDuQ5tPNMjSRO//qBdA1fJvgjUW455U
         FyXRWSTUli2c/mYAbmlXRJ8zGHDnXUODayJxHa13GglQ/+5FqdxD90751ELrAI1pdmUK
         wrmgCvP7OZGefLOvsCy6QPcAuOrMd51dHVfUqtqssuTYPo/We9eanD+nAFQmxDFrPFuh
         GXC7zAw0PJBym4pfrda8oSsCsQTGrkTiiV05iZeIWM4L6f0shlOP9MEXmrGlZojJpG+W
         5fRjzxrx022I8N8TPvI1G1pGTnYU2lVujZ8Ohlebv3+XNcFQ0z5sBQ7MlCZ+axSnGF0g
         suFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V54Y6S9UqakibhaCV07rNudhMWmvRKyEwrtYA7GXibU=;
        b=aMG9a9X4yaMig/v6hY74dliTLqXr+oTCcqgsgN6X2Nb2rexK3hUsvYU7pDopGWG1M3
         bdahHCKZss/9UZDh/si0aZjFk6hUVepR+oyBccKDcwBwRph5UA0anF5R7m8brLAL0BM8
         aVPHgd80xoDNZpxi1dVuTcVWr3TG8GWagKKo9J+Ny3tJ8hEffV7/iHoAjDZTXdHQwO+D
         fJpC+iwoAcpHFw1JZj6PPLeMvtXCPuo64xyYQmY/lmV0WbU72sFql/rXrlead1nLXAeF
         NmoNUEYydw2BU/KXl7xcSB4CpvwQ/w00kzMQE3z0tITB6LhARPdhmXQBDbk+BVNkSrsk
         4bYA==
X-Gm-Message-State: AOAM531GDmZ7gkmoWQfv+o/u+x+QpHjJg24nL0TusYufG9R3aZrgZ0BQ
        u18DyZm+mVil99Tb9rl8IjikAaJ8S/+l1A==
X-Google-Smtp-Source: ABdhPJx3bCX0d3HJDr+gDxmn1k5R8Mpj1R/olJQkoYyYfAoP3bNMmzlKXgeCayjil5SpKZ895fUoLA==
X-Received: by 2002:a17:90a:6705:: with SMTP id n5mr9684241pjj.215.1608396671573;
        Sat, 19 Dec 2020 08:51:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b12sm11647777pft.114.2020.12.19.08.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 08:51:10 -0800 (PST)
Message-ID: <5fde2f7e.1c69fb81.60e6f.fc38@mx.google.com>
Date:   Sat, 19 Dec 2020 08:51:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.163-47-g20080454fdbb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 135 runs,
 4 regressions (v4.19.163-47-g20080454fdbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 135 runs, 4 regressions (v4.19.163-47-g20080=
454fdbb)

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
nel/v4.19.163-47-g20080454fdbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.163-47-g20080454fdbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20080454fdbb5a7f248cebc64ce3869c1f41263f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfe77880be0399ec94d0c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fddfe77880be03=
99ec94d11
        failing since 8 days (last pass: v4.19.162-27-g7042181619c5, first =
fail: v4.19.162-40-gbaa0b97cc4354)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfb31b5ad6f2f92c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfb31b5ad6f2f92c94=
cba
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfb4eefd857f815c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfb4eefd857f815c94=
ccf
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddfb2eae344132abc94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.163=
-47-g20080454fdbb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddfb2eae344132abc94=
cda
        failing since 35 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
