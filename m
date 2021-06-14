Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9043A70B0
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 22:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhFNUrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 16:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhFNUrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 16:47:04 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8DAC061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 13:44:50 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v7so909210pgl.2
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 13:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3yC0zhH6vVT9XUMhSbmj+YJL1y44Mn5/p69Q/Z+w8uY=;
        b=hWij3VaAkG/osgNmjzSwDD5ETUvWVoVrY7lpdfdqcaA35inacwkEz+/ddyUSXUg5BB
         OEj21YVGtiNe5zFeDCxRQdbTZjcA85lNkkf4WZyyIT9J8a9zlPS02dKmE2cJlDC1p+BC
         WTsk4Cq6+wSk2FQeSfuzGOsrofffTX75pOj2ykUmu9+TOP1lhvdLRKiRklGTwxEFaNot
         tbFOghW4tEuLpfR/9U6rYveoR1PsCmuXs8H9dy+o8VWPLZseN+Gv9OdxCbUDnnQvWLSm
         jf+UdrSjVy17Tjj3mP7AbbDwX/rBeS0qsleznQUEH43V3L4GKGaMts2+NdrL5w0bJVLI
         b6qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3yC0zhH6vVT9XUMhSbmj+YJL1y44Mn5/p69Q/Z+w8uY=;
        b=oNXqgL+ZOxhl1TNxnmd/X7o7iDSF0vsggqWZUMHHc5aMczPjDE+7Aygv7iHE5HDL2m
         /8lY/ct2RzHfcGi4gCtVxOjONSINa9h06ZJW7/U0ci8EZAa2YhLUiUaq2JPVM/s6Mn6U
         /alCvFCY13r8nBMs/2gxFWLiEVUjGG7MRhXEIvyuotBhSL/HyDEv9mGesAuFpMreYqow
         ZOCiSSguv5its1HnTK3PVI8z4NeGFh0a5HXzRewUNmlZAAIMjuGpT2qNH3aTtEO5Lvx/
         rhWgI1dUnCQEPjKENpnomRVSZUBIIRXmMZSwS5cW3q+rUaJpFuG9ySLt1yxG11VFvXPR
         8QsQ==
X-Gm-Message-State: AOAM531T1AShhLmUw/5tV4nEf2YZ1njIuXvdM6kXbYLU6G6L29YOZiqK
        WgQ7FrPj8tU0zyGmYA18bKPejf4JES9DAeiz
X-Google-Smtp-Source: ABdhPJw+Ult7c+ClBk11+sMDCEFSxEVfZhKnQSsds9W4ii3bjSrDaXY7zpNHob8UKX/Bz1dXvWMaIg==
X-Received: by 2002:a62:e307:0:b029:2f8:d49:7b65 with SMTP id g7-20020a62e3070000b02902f80d497b65mr772131pfh.48.1623703489345;
        Mon, 14 Jun 2021 13:44:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t62sm5192147pfc.189.2021.06.14.13.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 13:44:49 -0700 (PDT)
Message-ID: <60c7bfc1.1c69fb81.898cc.e207@mx.google.com>
Date:   Mon, 14 Jun 2021 13:44:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.272-42-g97a072b96e7e
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 5 regressions (v4.9.272-42-g97a072b96e7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 5 regressions (v4.9.272-42-g97a072b=
96e7e)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.272-42-g97a072b96e7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.272-42-g97a072b96e7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      97a072b96e7e5c2e8fba7e36d8eba93ff39102b5 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c78d3057040b4d87413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c78d3057040b4d87413=
268
        failing since 212 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c79ea1f38ddeee14413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c79ea1f38ddeee14413=
26a
        failing since 212 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c78b615e2fa69ded413278

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c78b615e2fa69ded413=
279
        failing since 212 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7b77a0e0bc1d436413295

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7b77a0e0bc1d436413=
296
        failing since 212 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60c7a0822167a00fb341326a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-g97a072b96e7e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c7a0822167a00fb3413=
26b
        new failure (last pass: v4.9.272-20-g1c7647be16f2) =

 =20
