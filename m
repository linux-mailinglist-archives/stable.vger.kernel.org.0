Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E722F3D3117
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 03:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhGWAXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 20:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhGWAXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 20:23:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D74EC061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 18:03:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so6704164pja.5
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 18:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GahsNaO7IFVeSp203c+wxpUEU0wnT45r7t+k6VvltoY=;
        b=Nb5Qf3mg7lrUH5MGgAFf//b8Capp3Ds94Uye/s8sNUR0qnon4/99ETwFciNvILBeCw
         X4TcAvLRjppWE4yrQ1JXVGwAnmVTld53/m5+vcedmg18Ji1sn8pTiNLFjqGBXdHjQ1YM
         ocoMiBTv4j186LbNzEdVv4kT1s/5mfei9KAagXRLfQsNxipsPkvGEBFkcGydduOpiUVE
         oLacCjTGWnTeXf/0+UGTM1UZR7nWfpnQTT2eHeewGCoMeja3hWkr85o3rAAJ50sZiSeN
         j2Je3rE9eeam7i+zlc37nhLgLRGBDgj0tbgv1e1y7v7TyrIDJdOB5sL1netpWQEeq5tX
         eOnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GahsNaO7IFVeSp203c+wxpUEU0wnT45r7t+k6VvltoY=;
        b=pB4UgldWBRife0eSG4ddUYgLoeIKtqOjUTwaaUjoz0Afm4SBaihAe2gtOuBi7GHd0/
         PPocMGDNgVAvhFLxkxbB6fRw1HrtCGvF8yhB/cc6BqratLO2DazOBvFL0AlkmvC1hCF0
         qp2ZD7tGJeo6qKfr4TPNvpsrlrXQmR893K5EXAbqjr2LTawpA1o6blxO2L9NI4ZBewVv
         G2RDrxWAYKqcKaRMsQuSJntB7A0ZmuxVn+aHqQi7PFGT/iAID8cj/nmjEQFvIWwS3Vd0
         plFOIkgTRR+VCaHxeoNUBcY8RkRLAHZ9ibM8tNzGPQyT0+IzPf65l3amf+CoGF9FhUv6
         uHew==
X-Gm-Message-State: AOAM530BRQCk9uwNIheUCFF3Kb32Q+pgtcRk0i09Mhg00tr8XqY6cnZI
        1/ggj1ltzP+OgNoVgGORw2x2fgZ5p5U5zhIP
X-Google-Smtp-Source: ABdhPJwjE/y5NdFIqWo7wXpjp9TlXNVsH8Vs5A+Oi0Ro9L/q9+LN0Mcfm24TSxu0BFEXPMSIB1bPPw==
X-Received: by 2002:a17:90b:1d09:: with SMTP id on9mr2244407pjb.191.1627002236873;
        Thu, 22 Jul 2021 18:03:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm364989pfk.140.2021.07.22.18.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 18:03:56 -0700 (PDT)
Message-ID: <60fa157c.1c69fb81.33c0d.1dfd@mx.google.com>
Date:   Thu, 22 Jul 2021 18:03:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.197-472-gd60381c96e1dd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 151 runs,
 4 regressions (v4.19.197-472-gd60381c96e1dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 151 runs, 4 regressions (v4.19.197-472-gd603=
81c96e1dd)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.197-472-gd60381c96e1dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.197-472-gd60381c96e1dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d60381c96e1dd3ceeeb9b46090d2fd7957311072 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9dad63f34efd7b785c256

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9dad63f34efd7b785c=
257
        failing since 251 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9f2d74abb0ae0f185c257

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9f2d74abb0ae0f185c=
258
        failing since 251 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9dad2b07f6e4afb85c283

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9dad2b07f6e4afb85c=
284
        failing since 251 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9dc2303aa7934eb85c259

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.197=
-472-gd60381c96e1dd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9dc2303aa7934eb85c=
25a
        failing since 251 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
