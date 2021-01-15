Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296502F84B1
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 19:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbhAOSq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 13:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbhAOSq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 13:46:29 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0982DC061794
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:45:49 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id be12so5157349plb.4
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 10:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9hDKapN1/NnAjgfrC9NzRq+9fnbsE4hcAU8uZAGzmH4=;
        b=Ehd2FWgB3M8sMsM4eUsd5ENmMhEUQiB/PdBHX7gMB9OgGR0lg+K23jPWHIJooNl+44
         L1CV866tArpi5042c65T/tK701bug3rLGi/3famKzIiZiMGN705pEkm4MskVpJLaWKTm
         4DYugnffwOWL2Mr0r3KcX4/RObZrP4O1sSMbHdXVexr4veyYXCsAAiDv1RdVZhPA2fZA
         w9Ao4e8mncBiVuOh08EKINbqhy32mRS/8KaBcG7qvPN0a+f4dJJhj7x2F9qxPfAct16Y
         cWV09kLBZdGt8/9qS7EAygrJGKxgG0FuncXDYoP+T2va3Gs36ai+7fvd9ISP4B8c6nIx
         0nMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9hDKapN1/NnAjgfrC9NzRq+9fnbsE4hcAU8uZAGzmH4=;
        b=DVfSMs1uxkAA6xwr09HkQeCLYZ0H1/tROb8+vj0dPonRV/CyTdEYClW+bT3k8hcsPm
         /GAlhdERClX+VBIs2UHTKeh100ESThuidnjqoxH/YOenjd3+VTHxZo7fud92vA+uoViV
         67nLTtxvaJSe6zPgShOnW69/vI2c1UVUc5pLi/Udd3KnaXBxtJe5NnqQBq7+1x05E+vK
         Jaj0B6jIOZoD2Vte+NVwvaa5id44PIfihXs/VZW2WAhlyiibEL9bLIB3DWYhxEB+G0OS
         2pJ+ZRKIhzEkg1fVetEoa2zSF0RYlMzsbiYR+jQCzXcTGg4a878FuNDFjMrVqbnXSw2b
         M5QA==
X-Gm-Message-State: AOAM533D+mpYzk7Lgb5rakly09fj1DIOgBP2Poac6KPQuxwffw0EULu9
        4W+bIw0SDBxhkmzdYDvonoAOpDmeNERvww==
X-Google-Smtp-Source: ABdhPJwDwNZjL/QNR99YnBfg8PRK96OgMJdUJAGp81Ig2XPhfLoeAsvFDNJlOrdF4yIOm+gAm1zPKw==
X-Received: by 2002:a17:902:ed88:b029:de:86f9:3e09 with SMTP id e8-20020a170902ed88b02900de86f93e09mr862006plj.38.1610736348274;
        Fri, 15 Jan 2021 10:45:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 8sm9245206pgx.48.2021.01.15.10.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:45:47 -0800 (PST)
Message-ID: <6001e2db.1c69fb81.cc2b2.640c@mx.google.com>
Date:   Fri, 15 Jan 2021 10:45:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.89-63-gaddd8d79e8f6
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 165 runs,
 5 regressions (v5.4.89-63-gaddd8d79e8f6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 165 runs, 5 regressions (v5.4.89-63-gaddd8d=
79e8f6)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.89-63-gaddd8d79e8f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.89-63-gaddd8d79e8f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      addd8d79e8f6b991ed5ff59f0ad22a1170dcabd0 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6001adb12811a69d88c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001adb12811a69d88c94=
cc1
        failing since 56 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001acfa78e625bbe0c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001acfa78e625bbe0c94=
cde
        failing since 61 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001af84945de656dfc94d0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001af84945de656dfc94=
d10
        failing since 61 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001acb9238d8853edc94cfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001acb9238d8853edc94=
cfe
        failing since 61 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001bdb78a077f0c38c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.89-=
63-gaddd8d79e8f6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001bdb78a077f0c38c94=
cc7
        failing since 61 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
