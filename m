Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7690341BBB1
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 02:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243410AbhI2A17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 20:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240715AbhI2A17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 20:27:59 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD05C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 17:26:19 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r2so812256pgl.10
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 17:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BVeg6wpPfEjirfpFyJhOMNYoKmJr9108wUx9jB9HlAU=;
        b=hD+4kLdtV2DOvSSa4T+DV7py3vjlji1lubG445Z7tJDhm9OSxUbvQC031Zt8+bvG90
         OPU2TMzgErcHb3zsWJXGwseUJJ+Io716OI4/tFj2wyDeuHgoYo0mr3GjYPNy2TBKtkbV
         zlDZAF86WctCOYNIORgqGsVBmt3Flk0gRyKaLuGzvbneIEVOXoJ8gOUaJCJQqorEjgGZ
         WSDEm7WDYAgrzsgOqj3A7utmx6GEMpUQwpqHpMG8RVGRcn9HD80Ysk518lmHgIIw5xgT
         htCBfSAGEDZab+U5HMrzeQ9iVMXm3OcG2a6GaIssgCJKIe8ymITg2CVawsXW8vhhoXfr
         KP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BVeg6wpPfEjirfpFyJhOMNYoKmJr9108wUx9jB9HlAU=;
        b=YuvCaggeaQG/3RF1lk/UobAx07N5olEzyy+VIurzXydb63ZNK8e2XMUy/VW12hPp7T
         PbjuiCKzjLZtZu0UkSUAoM2AYMTS4irNwbZehI09j2+0Dz/Q19aq1jkOM0AFaM9YB+/R
         TCkN2EySjP4MqCHwcHFN9T89wP2wO5bEghlLCSvt2qFhZZ0N4KA5N9c4d+BV7JuyzG7o
         99EKNEamdxNlL/Fl4kmImSiorI5oy1jr/ga/7vFOKVsThzYq1jYOCPhONUQBaNnDjdfk
         IVP0lUFox6lGff+C7Qe9vXE8KNuguAbqEQbScQMP50c1Jr3bMv/dv+sPtIiUj1nkMZey
         NtzA==
X-Gm-Message-State: AOAM530D5kC1bQf3BNSS7OY7xu1MQy3/Xd0N/apix+4RPNuKPOp17xK5
        6wChjJvYidEPIY93sqLKdCL8NK1aDYWmhBzf
X-Google-Smtp-Source: ABdhPJzC+jcYzWpFfsBIcemgZTPcj9lRmh4LUueP8SPjN24ZMbohp5GCRMrA88uXbQv4IVN7TRYhkA==
X-Received: by 2002:a62:7543:0:b0:44b:b97a:d0db with SMTP id q64-20020a627543000000b0044bb97ad0dbmr3805828pfc.9.1632875178322;
        Tue, 28 Sep 2021 17:26:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d12sm303928pgf.19.2021.09.28.17.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 17:26:18 -0700 (PDT)
Message-ID: <6153b2aa.1c69fb81.6e391.1fb7@mx.google.com>
Date:   Tue, 28 Sep 2021 17:26:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-31-g4bf84f7dee1f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 78 runs,
 3 regressions (v4.9.284-31-g4bf84f7dee1f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 78 runs, 3 regressions (v4.9.284-31-g4bf84f7d=
ee1f)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.284-31-g4bf84f7dee1f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.284-31-g4bf84f7dee1f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bf84f7dee1fa59c524f60a45a8e308589535c2e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61537bbaccc2da9e3b99a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g4bf84f7dee1f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g4bf84f7dee1f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61537bbaccc2da9e3b99a=
2fe
        failing since 318 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6153788171f31c48a099a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g4bf84f7dee1f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g4bf84f7dee1f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6153788171f31c48a099a=
2f1
        failing since 318 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61537ba806023b850399a348

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g4bf84f7dee1f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g4bf84f7dee1f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61537ba806023b850399a=
349
        failing since 318 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
