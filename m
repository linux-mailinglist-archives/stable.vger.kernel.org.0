Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A01940BCB7
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 02:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhIOAoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 20:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbhIOAoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 20:44:13 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB751C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 17:42:55 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h3so962773pgb.7
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 17:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j5oRX6MSAcsAj8+65IR95ccrhzZ+p2bp7xqpr7GG8jg=;
        b=WY8PQgoRHhvfPzvtOK0zSXddfCLLCQQs1I9AVNISat6Dh6CoDWzGF+aazC2jLKqWjQ
         5rLVA9EPJFVgmS0lsxi8a9jP9rvoZ8gpHSjTF8Pylg86MnPZ9Io8QQF+z5IS1Dn31hzq
         SJIywQf+DgXqgMA+e2L5QYCSiPEDPmm8pxp1/X2xu9IuV5QsdhiNHZNQP2x230XFDYat
         wZ5A9JvMUju94xMSR1kAt9ZHqTs1Obl3lBM08vN2thAG95UOEGmGiYzmptxC2HoI1xaM
         r2aVYqA0///mvls0+8/8hk9SGdGFEYZKY/Xv+cCT/8f7ima0WM3uVOhq09VuSdJtm5JO
         O9TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j5oRX6MSAcsAj8+65IR95ccrhzZ+p2bp7xqpr7GG8jg=;
        b=zsTu1Iial+fFh794bw0apbtIZ7jSkklPYybcDFHqm49gQ+w2AZaRGfPQ9rAm0IzGXl
         pXpap4k1seEaq1iSDIXkZdIb26bINC2hKFAVEtJeqM+AvV8QT6CfWZTFh5oGrnpw3fiK
         7MYpYuxt4ICy8pCgAwwmuN6RiYN6qWbWULaCvxY2aH3hLNchy4o4EhDORJvwyH5k5OGe
         L21ZDv/aVslgTrqBPRlOMmWotPMRaccQnNKdmmukKpd1kMsONi/kLIBtZQk7JqE6qbqT
         UGR+GkferLcJUl71xFTEAptM+Fzq7wrMg6f1aDv5x9ufgjx6aWhdMj9wWzAylHvW1Zeq
         kxAw==
X-Gm-Message-State: AOAM5313m2FeGyQhDq6yqw0NSuKVLw3wd/nuTIYJj9ohqfnicZePe8Ja
        FZXWPLcH3Eay14ubF8bfP100H0EcO1Gl9FQC
X-Google-Smtp-Source: ABdhPJwXkimXahN3SF1b3osA49WOVUYBOEk0eOArugUn+9KKxgWSE9ET0vx4joDne0GXmTdb8vmlgw==
X-Received: by 2002:a63:1f24:: with SMTP id f36mr18114254pgf.6.1631666575180;
        Tue, 14 Sep 2021 17:42:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p13sm2730514pjo.9.2021.09.14.17.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 17:42:54 -0700 (PDT)
Message-ID: <6141418e.1c69fb81.5b61e.9473@mx.google.com>
Date:   Tue, 14 Sep 2021 17:42:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-119-gce9875a18ce0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 164 runs,
 4 regressions (v4.19.206-119-gce9875a18ce0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 164 runs, 4 regressions (v4.19.206-119-gce98=
75a18ce0)

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
nel/v4.19.206-119-gce9875a18ce0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-119-gce9875a18ce0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce9875a18ce05428712d4eafba9d15a390a549ff =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61410d80d4f326e1d699a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61410d80d4f326e1d699a=
2e5
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614115849ebb2eefda99a312

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614115849ebb2eefda99a=
313
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61410ef47e92de21b799a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61410ef47e92de21b799a=
2e5
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61410f3f68d6a3582c99a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-119-gce9875a18ce0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61410f3f68d6a3582c99a=
2ee
        failing since 305 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
