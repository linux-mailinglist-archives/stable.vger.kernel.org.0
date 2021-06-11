Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7933A43D6
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhFKOMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 10:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhFKOMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 10:12:19 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2706C061574
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 07:10:21 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t9so2561798pgn.4
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 07:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jtV9B8UkMeXAeU7PnrLKBNrFuYOaSoBJu1UJubSDRzw=;
        b=ovyE0neomhCzJLtU7kchim8y/b8f7n40KuSRbyGeEIPkpLLi+2KdjIth6ltpBldb0u
         4+DFEMmvh41Z/uP0KU3j4AEP7Vt8hl2+MZrkqjIm1vN6b2yvhuXF4byGiWM0xegik+9B
         gwxJH7/FX2KIFSgwPkpI9mdlsdTGQDfR/NjprQ1PkLVgw5DDdDHtzHQxPvBf8Td2wbp0
         +9U3xaJTB+Z57KgAsZ4c1g7WklKSBGG5AamWwM7ICCa+YkM2wu2NISKKtnREtJnfdIxZ
         rIDkqNO8Jkc17gUCtQU2HN240p8Aj7Y1yRJIfppuq8pJ39W12nJgpx/Fr5V1z+iIrelD
         1A/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jtV9B8UkMeXAeU7PnrLKBNrFuYOaSoBJu1UJubSDRzw=;
        b=a+8sM8DHtlt6CvhtPV8mgghiTcAIeai3WKdtb7cYsTdI9L31W/MvBhtMxAFi5nxMn4
         RGDaFMvf78NYg0SoP/AbO9Esmh/n04V3y7jsxvjASqOFG3K/5mt+6zsBBmUPtHQdYKaq
         d20YO9zmFex+08piSnKg8kYXVBuPCgrh0uFq6M79+irzfh9znA+emGvNZEi8eUtQIPb6
         a3t2u5PAlyRRfnD7W2UuvAyABVa2j4ITh6BE2YrzrEshBIIDJfOltypFLphz4oXsu4GE
         oEFZFKstBt0v9ALojcm1SpjuZ24LB5iOLa3YD7+aJ7+zF/0aQn+25kbfS05jJNuTNmF5
         AUOg==
X-Gm-Message-State: AOAM530ldcPrD8TVrMBE38xWwP32VFW8f0ANF6ifml6fHgP80Xe9h/5V
        dmpDo6igR0/wC+GqUlkYxBri8cVTIGyrL0L4
X-Google-Smtp-Source: ABdhPJx1dw2DZbItFXKrpmzFXPH7DK0FlOof/QtVrxl/8ZooO93QvKkNpS0YwgjUm0rmBzkp+Pzecg==
X-Received: by 2002:aa7:860a:0:b029:2e9:f8cb:489c with SMTP id p10-20020aa7860a0000b02902e9f8cb489cmr8431315pfn.50.1623420620081;
        Fri, 11 Jun 2021 07:10:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t143sm6342989pgb.93.2021.06.11.07.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 07:10:19 -0700 (PDT)
Message-ID: <60c36ecb.1c69fb81.b621.2fb3@mx.google.com>
Date:   Fri, 11 Jun 2021 07:10:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.194-28-g6098ecdead2c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 166 runs,
 5 regressions (v4.19.194-28-g6098ecdead2c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 166 runs, 5 regressions (v4.19.194-28-g6098e=
cdead2c)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.194-28-g6098ecdead2c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.194-28-g6098ecdead2c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6098ecdead2c29d7174c2722b8fdaf813c368f6d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c33b65b25a6410f50c0e02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c33b65b25a6410f50c0=
e03
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c33bdbc1fe36899e0c0e21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c33bdbc1fe36899e0c0=
e22
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c33b753e32f66a640c0e08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c33b753e32f66a640c0=
e09
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c347fa96aeb47d4c0c0e21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c347fa96aeb47d4c0c0=
e22
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c35fe991b4efb56b0c0e37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-28-g6098ecdead2c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c35fe991b4efb56b0c0=
e38
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
