Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639303CF0E3
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 02:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhGTACx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379816AbhGSXqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 19:46:21 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87687C04F7D6
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:15:40 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 62so20963717pgf.1
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 17:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5XVBCv/7CT4DotW4vr9kg00vPwjZrNlzeFYolEJmY1o=;
        b=hC9dSwOqNDRmYDqehFdFZ//VP7PGURb6D8aSJrQKt7S3gSv/XI89/bZOH7gYDOR8sR
         tkcsVupAa4UYX/T36X5/tfZhPVd7ZAPoNXji/hTOk7UHRvyw3Y9T9nmtc6TM0zet1Y8e
         ATy+CHn4OYLsY24aX8UXSblERbSACrd3JroNUgIhrg7lSgZhD8d5YPwLy33/W3+hJfaM
         guAHTO22duuBdX6FLUUzRbShCA4uBF2VATfPtKCK8vsEdKr/s4FwaU257cEMsPYcK5Sh
         cor0q9Qn3lN0iOYNxk9JJ5ez3nRaa0nUtf/IokDSwPX+N50c35Fw8DHZc46pLWi9QPlr
         j4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5XVBCv/7CT4DotW4vr9kg00vPwjZrNlzeFYolEJmY1o=;
        b=TrFyeYxrJAIbDbsTEy/ARe1LcE8jinR/1K0lYbQQEIfRV/kdVFbm8y2RSdQdJF6P96
         K+vM3MPqYil3K8RyHumhdlD4/QHairx82hHCbGgVerlC3so4KKEIEpwkzWpjY77lzIuW
         o/L3so/OruznOwmPvgU6TLGSf33FlzyMSKTJBVI3qpL8uXACR2vIbVDHYuQytLAVXBBT
         BqpQ/uhg/ypbktvUG82d8enF3MnBt9erCNP78WmVK1+017RqkTuz58juLDHyf85LyzTZ
         xBHmaFrC0AOfXArjpp8KaL2FuTGqrKdHGl06Y+fGHo9g196bLyaS+1oldG9ObDs/x9UL
         gFTQ==
X-Gm-Message-State: AOAM530RL89tvsdsH9VBAok9gHAsc7rcsub5OqEd7oXp2pDjz7hyICNo
        hJsGY8wP2rXfncSCVbAxA5wApYPQv+o0WaAA
X-Google-Smtp-Source: ABdhPJymgJ3JahxS0TK8MtQbEIYlgZA8NMDwt4QiSzdzcaB4S+Y+rIEWyYtF2cMdKokKTVPA2m66uw==
X-Received: by 2002:a62:7c52:0:b029:329:d4c2:8820 with SMTP id x79-20020a627c520000b0290329d4c28820mr28557890pfc.59.1626740139804;
        Mon, 19 Jul 2021 17:15:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p25sm21436720pff.120.2021.07.19.17.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 17:15:39 -0700 (PDT)
Message-ID: <60f615ab.1c69fb81.15178.ff68@mx.google.com>
Date:   Mon, 19 Jul 2021 17:15:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.197-420-ge4386612b30f1
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 155 runs,
 5 regressions (v4.19.197-420-ge4386612b30f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 155 runs, 5 regressions (v4.19.197-420-ge438=
6612b30f1)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
odroid-xu3           | arm  | lab-collabora | gcc-8    | exynos_defconfig  =
  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.197-420-ge4386612b30f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.197-420-ge4386612b30f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4386612b30f16c01780143e0c7d4d3ba01e8397 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
odroid-xu3           | arm  | lab-collabora | gcc-8    | exynos_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6110718db0e7e9e1160b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6110818db0e7e9e116=
0b5
        new failure (last pass: v4.19.197-279-g088e1d22d7f1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5dd672e34f49b741160d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5dd672e34f49b74116=
0d9
        failing since 247 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5ddc20dc4397b501160ac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5ddc20dc4397b50116=
0ad
        failing since 247 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5dd6d07f66e5d2b1160a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5dd6d07f66e5d2b116=
0a5
        failing since 247 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f5f63ecc2ed6ab1311609d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-420-ge4386612b30f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f5f63ecc2ed6ab13116=
09e
        failing since 247 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
