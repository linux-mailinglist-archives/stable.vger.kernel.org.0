Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACDE38F220
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 19:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhEXRSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 13:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhEXRSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 13:18:34 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07896C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:17:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t21so14955830plo.2
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ojU2MYlQ/RoswsduyltWBFVjcKU/VBuqHocL37t1Aw=;
        b=p1KWNXmbavdFD3xNOCgLV4hFyzGyXkykYZIpGpVfzTb0+EgerW3TZ3JwzO6MhVzail
         JeRQIXLVD7FO3vMNBdZVlRAQGNvfB7U5xmoIE+kTaSJoltuOAoJBXdVOzh1Z4oi1nM+/
         8QBcexOWq6daq2xvXp/BFpETHkuN3w10nINMZ1uOj5lDILj7J0MRMWr91vlrgyFh52eT
         od+pd3cB320g44OqoFvfv6R3TdslZeDkg/TU1xHuEtd6mBknA7S8+h1GafdIt+uIx1Hn
         0yIZ8K6NzQAjhlZMWUYb5G+7l/lYgLNCtMOIDgNgAcgjYj3t5VZcL911f70eFaTsyIF2
         XJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ojU2MYlQ/RoswsduyltWBFVjcKU/VBuqHocL37t1Aw=;
        b=E2nyzr4nxmOR6aFiY7YMGKbBsZgqRUkvzMVSJkTnpxHIbiXQmiq2kNQpPeUquu3LuY
         wxDAqRFCvyoc9z2BmCF/3lth24pTatn2GgIhxm24F2p+e8ODig3GGS2WbuehHgEyipXI
         MjDFfXc/GIhTb89xFenJjY3MYvzMFittrJ/2AxfHYnuiRQexxwR0JGOp0FR5aUT6ejmk
         KX8S7xFb3PeyYJ/T9Ct7jCxYntV7h914yqlqN6t9M+HRXq0uX6ZWOg/GxeJv71ytUpk4
         2DK+ISJWjmXVY5Py5LHS46IHh1upPfNKXGFCAbBTePglfnCvLZL7V5qrN4IVQ2SzQ+6Q
         LsIw==
X-Gm-Message-State: AOAM532CRZHWhIUyfmWd6BtpZSOuk2Yz29M50R25QezWOjDFUh3Yrp4Z
        2r1ynJDBRXccGgQoxs6O6SjZiLXhmz5/V9aT
X-Google-Smtp-Source: ABdhPJx+8L/tMN+MGoyhich+JWtRl6Kyvqlzz8k73Bfymu1OXa+kx1qJHgGf7lnhLlk+fPG2y+Rduw==
X-Received: by 2002:a17:90a:7442:: with SMTP id o2mr219326pjk.44.1621876625300;
        Mon, 24 May 2021 10:17:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4sm10741489pjf.9.2021.05.24.10.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 10:17:04 -0700 (PDT)
Message-ID: <60abdf90.1c69fb81.25d2e.2c9c@mx.google.com>
Date:   Mon, 24 May 2021 10:17:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-49-g654c4488b681
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 94 runs,
 4 regressions (v4.19.191-49-g654c4488b681)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 94 runs, 4 regressions (v4.19.191-49-g654c44=
88b681)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.191-49-g654c4488b681/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.191-49-g654c4488b681
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      654c4488b68138ac6fc6da729f2bb16f502a2a3e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abac21738be2e12eb3afa8

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60abac21738be2e=
12eb3afaf
        failing since 0 day (last pass: v4.19.190-433-ga1bcf11cef15, first =
fail: v4.19.190-434-g7549be3766e0)
        2 lines

    2021-05-24 13:37:32.861000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abad490afdc4e799b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abad490afdc4e799b3a=
fab
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abac79d1c5fefa10b3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abac79d1c5fefa10b3a=
f9f
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60abacdfd1c5fefa10b3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-49-g654c4488b681/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abacdfd1c5fefa10b3a=
fbe
        failing since 191 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
