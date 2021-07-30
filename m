Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8FA3DB15A
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 04:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhG3CxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 22:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhG3CxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 22:53:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20A5C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 19:53:08 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso12301749pjf.4
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 19:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZQ/Hc7B5bF8E6FGSUOsVUDKKVX+3+2tLgHC/JWSfz6A=;
        b=g7SVPWrYNHTieuvemTjKECHff8wAw9jLyMnw9/djjE0Ucbl8oGDV09z4KYTUlhULTH
         pjx7nHkHXQLZaIwENodeA0+KOcueG9S00QweNDH46pEEtaPu0uPPM3fDlkTGd/nBFGJA
         /VAWq/gqGwuhK63mtHJAcozMKfMSuWNOFTYQcqqpJiJF8Zb52t6O59gPjskJR4ZHYPHA
         qV4A0aOnLup/yQ95FotEC5HM6DSvXzBaSgxMgrZ9SN78ClObhoyUrRosx1APxNmGrp7U
         AWxQ/ZQvd45lRfRbzBMXof6sS9JtGp4ii0rhuEzcybzxojnJdovMXKK4flkugQ5WGh1m
         Sz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZQ/Hc7B5bF8E6FGSUOsVUDKKVX+3+2tLgHC/JWSfz6A=;
        b=N0ZALKghUmaSMFtT3LaHmoPi3l5fjvO2pKtYgo/wrqWl5qk8/MQv00kbZdAdRTShsy
         GQXj8pdQmDJRnEfSEOcxoBvLo7nbedKr4Dpob0M9y6te00BwPBUxxDUSI+gPRprepn/G
         Pn/gMhW0Nk/iz1qwIW047wbYeeLRoglIf4I3dNOtUscBKrxG3IhKuDY+gO9TGuDUWqv0
         BJsg22IKI7FGjv0TcTlSPWdMCX9hUTRhYMoOauFFyo20uCG1LBIKyP3apH/L+IzrOQDL
         rtdEFkxInjKTOEKW/YVH3joowmzn80v7MI3tD2ye2tI9hK4EYMvHKZYMmw0h5CJhfl/9
         iYQA==
X-Gm-Message-State: AOAM530aiFHQFOBjMQqxnaQWAjbt0JO/zHdt5ZC1QcO6dyAYT0SJI8ZW
        PGHc2/rCQhLCXrFR6OwVmCeUIcYIFREuz9s3
X-Google-Smtp-Source: ABdhPJxpepfgxemxuSKsL96pSlgJrC2aAA/FHTr1EKU1AZHy8P7tTkJi4aNTX9rhY7nleLBjcwYvXg==
X-Received: by 2002:a63:504a:: with SMTP id q10mr227220pgl.383.1627613588254;
        Thu, 29 Jul 2021 19:53:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m6sm241088pgs.75.2021.07.29.19.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 19:53:07 -0700 (PDT)
Message-ID: <61036993.1c69fb81.efcef.100d@mx.google.com>
Date:   Thu, 29 Jul 2021 19:53:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.277-12-gbd9cd7373feb
Subject: stable-rc/queue/4.9 baseline: 99 runs,
 4 regressions (v4.9.277-12-gbd9cd7373feb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 99 runs, 4 regressions (v4.9.277-12-gbd9cd737=
3feb)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beaglebone-black     | arm  | lab-cip       | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.277-12-gbd9cd7373feb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.277-12-gbd9cd7373feb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bd9cd7373febea46d0f981cb9b1c801ffcafa706 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
beaglebone-black     | arm  | lab-cip       | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6103325e28c8ddb1a65018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-b=
lack.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-b=
lack.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103325e28c8ddb1a6501=
8d8
        new failure (last pass: v4.9.277-2-gaf4b7daff4d2) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61032e901e831e850b5018c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61032e901e831e850b501=
8c9
        failing since 257 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61032e8a0e35bcca585018cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61032e8a0e35bcca58501=
8ce
        failing since 257 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61032e84a3fe54e8b25018ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.277-1=
2-gbd9cd7373feb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61032e84a3fe54e8b2501=
8ee
        failing since 257 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
