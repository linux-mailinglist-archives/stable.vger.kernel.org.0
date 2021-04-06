Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD6355E76
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 00:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhDFWGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 18:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbhDFWFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 18:05:54 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E2DC06174A
        for <stable@vger.kernel.org>; Tue,  6 Apr 2021 15:05:46 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso233342pje.0
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 15:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zHu3TY+HfFKD90Eac4tfUucemDNTX8k0fcIAMotqDvc=;
        b=VNy2fl3727FTnfRn4YmBH5FzipWY/vXNQDcPjoN0Z8lZrhZjrxjPt4fe399CuzIctu
         Adr+deu6Oyiyn670ZTAm7m9JYD/ajYBZjwLQSefBJXEZlWLt9cFH0QRugIef4f/7B1St
         3Fk8SHU0BQt0W3t5CF/kdtyL5l4NwPtP3tTYZzjYbnkk80mJjekFW6IHWTJ/qkQ8+hms
         2QvQKbM6Oa5z4miar0J+0KzOqLkqWYk1IPx1BK8TpDJ9Z11VSOEJSXzQKviA/Rwy7ylq
         ncR8a2GrZIADKEO5qfxO8wHl51LU+Wa8EmJIokGvdMRuV1qS6pcbgS2+vzuvPJf+iadg
         +ugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zHu3TY+HfFKD90Eac4tfUucemDNTX8k0fcIAMotqDvc=;
        b=WU+XaW48N9+6LFsDwee3tgIAr5dJR9/faVvwpIEZJA7sZ66199BslQJTNIB2Tm2vK0
         KAQ7xIqJpMSso0ID/M1YjORDr+qCahEIXSOH+NpU2yo+CBu85RnCZt0SHop9k75YAH7W
         XJprZd2aPX6QRplIYaDeSYNR7MBXqQmnbIS1vDRA6HM2kT6SPI5BOlXKdLhItjBiazQB
         XmDYlfDlgqV5l2uAiYd46taKSwakdqqNXA+ZFFhZ0AvLgi0/A+JM4yeTpH2QcMP5ly3s
         ri8N6zeu3FRIdf4kRLgo6Lp17che2Okb4m2+CIMRBTbz10klhDAd6CAQiz4jmIeCcmsU
         1jFg==
X-Gm-Message-State: AOAM530HMFxf31cJ1g4av8q1hoKdZsYlur8H6m5P9Bwlo0X+zAQd7wlD
        dhyV0PUxGvt12KHz5KO1vnDS6EJJB0jL20jz
X-Google-Smtp-Source: ABdhPJyuHr3UyM37vT7QgpOh0TkMgu+xWCufo9JwUBnm81qfLj5c+aSQooafoxg/hmnuh/nT5mADsQ==
X-Received: by 2002:a17:90b:ece:: with SMTP id gz14mr278627pjb.192.1617746745622;
        Tue, 06 Apr 2021 15:05:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v11sm19288980pgg.68.2021.04.06.15.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 15:05:45 -0700 (PDT)
Message-ID: <606cdb39.1c69fb81.4b252.18cf@mx.google.com>
Date:   Tue, 06 Apr 2021 15:05:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.184-56-gf912b6024ff8
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 117 runs,
 5 regressions (v4.19.184-56-gf912b6024ff8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 117 runs, 5 regressions (v4.19.184-56-gf912b=
6024ff8)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.184-56-gf912b6024ff8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.184-56-gf912b6024ff8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f912b6024ff8087b37416962934dbf68ca465299 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606ca1b233654b98bcdac6ed

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606ca1b233654b9=
8bcdac6f4
        failing since 0 day (last pass: v4.19.184-39-ga54c31013b292, first =
fail: v4.19.184-56-g73d616e2eed85)
        2 lines

    2021-04-06 18:00:13.576000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c9f2eb5490a3a6cdac6ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c9f2eb5490a3a6cdac=
6ed
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c9f24d9c2ccb887dac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c9f24d9c2ccb887dac=
6c4
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c9ebdd04a3ae4dfdac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c9ebdd04a3ae4dfdac=
6c4
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606c9edb9a2ee8dbd1dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.184=
-56-gf912b6024ff8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606c9edb9a2ee8dbd1dac=
6bb
        failing since 143 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
