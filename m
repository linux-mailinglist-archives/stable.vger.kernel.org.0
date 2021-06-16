Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41ACF3AA256
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 19:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFPRXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 13:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFPRXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 13:23:51 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD9BC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 10:21:44 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x73so2727945pfc.8
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 10:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sr6LmrZPtXI5gJIrRtwTLkVTASuAkzQ5ANN6kqbhf30=;
        b=VlTVJ6LWD860hQfvMxmBYCT4TCWQbp40sPQIfdwwc2ZD34nNZ7ePQQliowxyVrjFud
         QoVWxT5ZZkeprxslGwbrj1QK5MPuy1K9JCPhx0YuCqPN1Q/br0SE/KI5aLWnrKsrDM0p
         u0zwRv2ss91HTbSUSzwVImj4jJHDnbRE3nrH6/5cZFMdPyoFv6thzh2UtS2W5noTHXVa
         E4+1B/3x2T/WZ/abp5/BLZppYzPwhaDlgUV4De2kUiINOVrRtDKqloIjgJpcZZ3qp19G
         WWaRcTmdoSqnBCXMShDP82EtL3lD8LU0hkk/T5rrcG1kn1BRwGElfiUQEW22RznkQBlb
         2j/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sr6LmrZPtXI5gJIrRtwTLkVTASuAkzQ5ANN6kqbhf30=;
        b=EcxK12TNbjuurtgYTfc3eoZNaLoUCE1DM1fS07mnJb6gJGrSHirNAOnifNDQ6yh8xb
         yx7k7nWW98HKeUsAE/qQtTeswci8SOnqPuf9qo3+YXLpEqJP33pj6j+vwq2IcxOxkyrN
         vRoAn2rqblSYqUVDRhbq20spVXLavb2IDd9NPj+i5QGduuT35f4vcSCGDE21S38IocHH
         1C+A66hS/P5lo6hUUjTf3bRyltupQxmob3ZcrolVSTkQhC9kqDnwxTNzcnVHN2xF2mcg
         YlnAR3HACjsdE8At2W3nBqDAiT9ZcaIe5QkUOpt3iZaStTG/i0r/6VGqvFteDxh+V0lq
         Ni1g==
X-Gm-Message-State: AOAM531iV23FakpqOU8jL4RS5W9NpHt042l5OtPVANz6oxy/2y4+G8pL
        EU1wwl4yfgvYWCe3Cy7C4e1obCqzgMF4j+jX
X-Google-Smtp-Source: ABdhPJz53ykF+yEYN8n7lx5sdJ9iKQjF1GXAcRyxseFpnBbegP20Gwluc5ZlSYK4mXSml6UZmwMvxQ==
X-Received: by 2002:a63:c1e:: with SMTP id b30mr695072pgl.118.1623864103337;
        Wed, 16 Jun 2021 10:21:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm2716843pfi.122.2021.06.16.10.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 10:21:43 -0700 (PDT)
Message-ID: <60ca3327.1c69fb81.7e5b1.722c@mx.google.com>
Date:   Wed, 16 Jun 2021 10:21:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-14-g24267faae718
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 92 runs,
 4 regressions (v4.9.273-14-g24267faae718)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 92 runs, 4 regressions (v4.9.273-14-g24267faa=
e718)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.273-14-g24267faae718/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.273-14-g24267faae718
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      24267faae7186532713790ef36d5a644004af09f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9f8f17b9feb2d17413283

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9f8f17b9feb2d17413=
284
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9faad4930f4e72541327a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9faad4930f4e725413=
27b
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca01ea23052ea862413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca01ea23052ea862413=
286
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca2be7ab25ba07cf41327b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-g24267faae718/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca2be7ab25ba07cf413=
27c
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
