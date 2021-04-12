Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9717B35C840
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241628AbhDLOFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 10:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242201AbhDLOFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 10:05:36 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7263EC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 07:05:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id i4so6701879pjk.1
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 07:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3tEdvhOwre7MyH8bAAIGKH/QThnO55YQK7wdrPwK/a0=;
        b=Rd6LINm79gQnkn9dpyjgHprGM0X8a1/UVSxXQLydILtOJUP8cnxPI5XmqrbM75iapt
         EP5N6QvLmmituB3tGWkXE3kBjGPQkRDfiQhpsYZdSxnAdQ21YCqNqWuKrN0iQZBvcRfc
         LzTK6DZFmr0nVJ8BuqFIFw21pVMh32zDMseAWB5OnpJew+2Wgdrd0xgeD+wnR60qgGDC
         NNe25C5hB0qG997AAEgE6Dla7KHMLSdsJrikVK4dr8KjMCieRMUDcQvynpkbt0uBLxK6
         plD59QmZUTJi7BG+gQXe7/ERjey3O7tbv2ANayilkJ+YqaNbj0zabCRK8x5Dz0EnH5tW
         s6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3tEdvhOwre7MyH8bAAIGKH/QThnO55YQK7wdrPwK/a0=;
        b=KrzNx8wKXs3AzegKl6wx/WYJCyBdexmZAuoUYCnOyN5smN1Ob57jACAzeBV07TN7P1
         xuqngtIm1c3KsVSXSBRhVcveqtQJmPlOjCBajyFivs/uy718J2XaIW+Dl0XMlCBFMYhn
         fb97KzcEqjc30bq1oeOGz7FhATRJ5Zyy+dLX2YFkF3paZaCeym2tsM0DDN8+PIgGYKoE
         tRhOueMUUK+F/uVa1p/c3rM/fKGA1YDI/Oic1mgyldFIkJj1+zawtVDwLObC/EU09dWs
         DaOaqXAYKQ7pyPrY8xf4oxD1wSFmqRBGK/9txH/NnSyaPgx3TrU5Y6Gfx5ZmMFXQ47sH
         8BIA==
X-Gm-Message-State: AOAM533v1+b+AlHdJn88zEc6ZJfaCaiSQE86MpA35ZXe6rAPgAaOJTAJ
        PvFxssEMZR6As1hdXhaYeQQp6N2fSGZ39IDW
X-Google-Smtp-Source: ABdhPJy7xrtcHxaMov0iD6djCfJkA5x07WWmW9DI2N/vrysk/7aPrA25dmi9nORLQTd3tcSggdsQxg==
X-Received: by 2002:a17:90b:228a:: with SMTP id kx10mr9131155pjb.33.1618236317736;
        Mon, 12 Apr 2021 07:05:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1sm11788761pgl.25.2021.04.12.07.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 07:05:17 -0700 (PDT)
Message-ID: <6074539d.1c69fb81.ecb12.b998@mx.google.com>
Date:   Mon, 12 Apr 2021 07:05:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-59-g8186e9dd7149
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 106 runs,
 4 regressions (v4.14.230-59-g8186e9dd7149)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 106 runs, 4 regressions (v4.14.230-59-g8186e=
9dd7149)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-59-g8186e9dd7149/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-59-g8186e9dd7149
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8186e9dd7149bcba5072c58c5903016b94e0cdc5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60741e55acb9e73ec2dac6e7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60741e55acb9e73=
ec2dac6ee
        new failure (last pass: v4.14.230-58-g25bd7e2a3beb4)
        2 lines

    2021-04-12 10:17:54.255000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-04-12 10:17:54.264000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60741f0181cb2d6102dac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60741f0181cb2d6102dac=
6cc
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60741f013de9d536b9dac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60741f013de9d536b9dac=
6cc
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60741ea51ec2380539dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-g8186e9dd7149/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60741ea51ec2380539dac=
6ca
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
