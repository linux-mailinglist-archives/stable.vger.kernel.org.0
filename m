Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44953F9C15
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 18:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbhH0QHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 12:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbhH0QHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 12:07:23 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271AAC061757
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 09:06:34 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id n18so6310672pgm.12
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 09:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=16dKzb4hhpyOKGUV/UTdlBN/ByZmvSl9eMntsqzW9zQ=;
        b=ONuN9b6Nu9ilSfjtU2qhjaEMgK2eACb30ZHXCPb7tpBG6mnlqFQWqVph8mMZyUly5U
         rPqG1FxYRAYMnLn13ssp5iP/u7cxkLMvbdBT1I/OhegpO2wd0BAWoXIMhFpgCOVBbOZD
         ovJIkPkX5q3k5x47slnppsQ9JDSSgM29tAB6dQW9YzszRnIgsDiJWkDy4oi1PSW295QY
         82syyezdEIYGiDByvu6dzDAeIlt8fJEL0mA5EoO8wLOY65kpF7n1TDjo46vFaMPaO6Rl
         vXUKfWFtD3R419/mdajsccs4TeWJuCwXnl1ZSShE+Mhao8r7H4r0cppr2w6lCTo9OdDZ
         1I6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=16dKzb4hhpyOKGUV/UTdlBN/ByZmvSl9eMntsqzW9zQ=;
        b=uoIx59sjJl90PZMm/RYHOFth3ZCDWTe2AdgeHpicbcpEGwJZReNORW2sYFnXz590Vf
         ZQK+csKF5yQMvIylAkB/fVY8P3h0s/ZsQyjZUXKvj79FitaDUtVi8ymseThw5hfR0oRz
         xfEcFicqfi8qRE+NUCD0SKDOYoEfpZfKXkPyIytsBq66RUiD+sp1W0RpNXaBHXEIAaO6
         eeMrEQ60KYfneKTmcmfGwnRlyDgpKhElw2aQT7HAy1IUQguAs6j2E3w5BZiZUJ8VWGss
         rwuzEXQ6sQ/oO7vFKaJdVn8JthMxaU5mSIeSr9Ti0y83U0etY2P1buzeHHxzbgvTmeRD
         hapA==
X-Gm-Message-State: AOAM532JXSlBcXbXavxbP3FY8DvY5/iJwLi66b0OShVJELt6lgRimfn4
        WZkmv3lXPu1odUv4kaGyzTyuMtpWseexq1FA
X-Google-Smtp-Source: ABdhPJz5NzrUpuzRTUDfbiSce+/2fQKYXQbNTNT/sMhgo+NRzF5widzDuTpOSRrtZIZZ5NQB4OxprA==
X-Received: by 2002:aa7:8041:0:b0:3f2:7136:ff13 with SMTP id y1-20020aa78041000000b003f27136ff13mr6967094pfm.9.1630080393311;
        Fri, 27 Aug 2021 09:06:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm7041386pgl.85.2021.08.27.09.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:06:33 -0700 (PDT)
Message-ID: <61290d89.1c69fb81.b00a2.2aaf@mx.google.com>
Date:   Fri, 27 Aug 2021 09:06:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.205-1-gc31f950080d3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 133 runs,
 3 regressions (v4.19.205-1-gc31f950080d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 133 runs, 3 regressions (v4.19.205-1-gc31f95=
0080d3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.205-1-gc31f950080d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.205-1-gc31f950080d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c31f950080d34bed9616f649ceb9565f14e020fa =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6128d9a5adc46fb8378e2cd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-1-gc31f950080d3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-1-gc31f950080d3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128d9a5adc46fb8378e2=
cd3
        failing since 286 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6128db8200fc0a79e78e2c93

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-1-gc31f950080d3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-1-gc31f950080d3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128db8200fc0a79e78e2=
c94
        failing since 286 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6128d9c17977d536cf8e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-1-gc31f950080d3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.205=
-1-gc31f950080d3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128d9c17977d536cf8e2=
c78
        failing since 286 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
