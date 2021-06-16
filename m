Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CF93AA637
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 23:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhFPViZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 17:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234082AbhFPViY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 17:38:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74367C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:36:18 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id k7so2528381pjf.5
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 14:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p+KgiTaIoWwrpA14f5KsQUSP59oXyQuiO+z2Gpx8HB0=;
        b=GUUqZOYHXq50xTAjdn2hLqtZCiQ83rqCymJjkAwYn6HHToC2eXUa153OxawQQRAx90
         8mLUoS2P/BjhHRnRd/g9O7uXarvcgln8m/Nty/wklG125vwFN0jaj+pjwoMvzKmSCQbW
         6+WowM48iMRWG0KoqylzaHPgxwMmKI3JgdaskUbEE1TL+z4rRc1XwKm+yUzHMydfEZMJ
         MFxmngVvJj26vBWoM0Vqxk+L1fFZYIs7zLuc8a9IkS8lWHL0QgK2M2uG8tpBQKILHznk
         FHHXRY9z2hkl3KXnx3LlPDzI2qTXaknk9ndIIHVba7kWvBpfBIo4mQ1H37o/r/c/mbSH
         xjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p+KgiTaIoWwrpA14f5KsQUSP59oXyQuiO+z2Gpx8HB0=;
        b=ckc1tGYcTnPXwfjksUrTWdE0ktp60HAM6q2t1BSoe5hRCHdpoNuGNWBvBhLLYYSeW/
         GDR3L3PO7dSqvtNYkkTW3nIktRqycFhRvW42Ef6QG5yDUNcD03NSA0VTbVqK0r8n7LLa
         /aZQ8SGVWRo5sY+6n826bM8dQlrxTDjIZHJsg48QdHislGqcHsWMrKjK8CJvMbtxfR1l
         9Zyo8b+YZHOUgzaX09Ow1MZTM8m5OTrt0707PM5oGuo+hlnKwj2TSbSW19GxNSf/OBVk
         G0OPxNKeiEkv92Ji5gG5eDae/TsdKrAsHMBPZbZXVIx4jBLQMh4SwbltYTR4MI3K9P6i
         krtw==
X-Gm-Message-State: AOAM533zDm8l4Oas7SvKcugiBdfKbdKU2LOkiStRLiFdo41o5oSykkwL
        j66XPlwKvgEiO7xaRz4NVMR9LlKEn/fyCvYV
X-Google-Smtp-Source: ABdhPJwrn+M4FWwPDVe/+uTOzNvkMor79fS6jgq2SF73eCgPPfCPgSGsni8mLu8KsY3gTBMZng04fA==
X-Received: by 2002:a17:90a:a607:: with SMTP id c7mr1913753pjq.199.1623879377659;
        Wed, 16 Jun 2021 14:36:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2sm3365437pgh.5.2021.06.16.14.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 14:36:17 -0700 (PDT)
Message-ID: <60ca6ed1.1c69fb81.e60a9.9fad@mx.google.com>
Date:   Wed, 16 Jun 2021 14:36:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-18-g5fea905d8e5c
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 78 runs,
 6 regressions (v4.14.237-18-g5fea905d8e5c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 78 runs, 6 regressions (v4.14.237-18-g5fea=
905d8e5c)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.237-18-g5fea905d8e5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.237-18-g5fea905d8e5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fea905d8e5c72c300985c91a797fe457bcdcd79 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca4f0d8e0da65413413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca4f0d8e0da65413413=
267
        failing since 214 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca3a2ed2993782a64132a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca3a2ed2993782a6413=
2a2
        failing since 214 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca5e9324c5adc88e41329e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca5e9324c5adc88e413=
29f
        failing since 214 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ca6a14921c3d00d9413292

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-18-g5fea905d8e5c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca6a14921c3d00d94132ae
        failing since 1 day (last pass: v4.14.236, first fail: v4.14.236-50=
-g2e03cf25d5d0)

    2021-06-16T21:15:56.510725  /lava-4038233/1/../bin/lava-test-case
    2021-06-16T21:15:56.516165  [   12.762547] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca6a14921c3d00d94132af
        failing since 1 day (last pass: v4.14.236, first fail: v4.14.236-50=
-g2e03cf25d5d0) =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca6a14921c3d00d94132c8
        failing since 1 day (last pass: v4.14.236, first fail: v4.14.236-50=
-g2e03cf25d5d0)

    2021-06-16T21:15:59.959607  /lava-4038233/1/../bin/lava-test-case
    2021-06-16T21:15:59.975455  [   16.211177] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
