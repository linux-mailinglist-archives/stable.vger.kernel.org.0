Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3783D7D42
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhG0SQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhG0SQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:16:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3FDC061757
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 11:16:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n10so16868638plf.4
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 11:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XYmOw1ej8CuAksS98+w/cLBbV9fEvYwqQt9fqd97t+E=;
        b=OjxV9iiLNzIAGjt8pJmaOQWY13hx8bR5dTZbgVhayBfaMEy7cSl1US48MJcB69s12L
         uNOwzQN1fqCe1islPSkIWq8ASRGWJTNScufZ5Ks1PtxrOpUT4JuawuvI3KT9k/2pXKhE
         U3Pqat+OD8eQfrPdzlxHYcwY1so/Mb7CgNwhC9fPj/aUKzP/NU2K+4lzrPu6zkKib6wD
         /+lSYXut1BGTMVvEljCoAHGhWZNFKhQOTuwQ+WpCMuOtycJz9yxIwR6IoaHrEkXDsOCX
         8C0ZkBlb9T8an7KaczyDuLvlrqIbOPFaDmFLu0oOyQ/ePWQSifZNQBePFwk+BJXNNa4s
         1Hpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XYmOw1ej8CuAksS98+w/cLBbV9fEvYwqQt9fqd97t+E=;
        b=Ik1yioXR5PWm36U38pXfVCRq4qIxUTpvIF2xD59FAZ8Fg4ojDkKoR5XE1E7tSGmmWJ
         wccJSx6O5qnXxX7/zKDuELh/5lDTh6WQ+y2mSRfLtMWueSppmMkL/qAdXkqkWlZD9OU9
         5WFM9bcV6GzFsChi5DqsgdSCGN2wg5PmvvM7MMFVrcWQbktEUM64L03rq29iEGXSW+IV
         53qgVEyIz7PT656hd7LVXnOXCL6vj8HqRR6eud/NwQ+uR5N6l8/SZHdBZtDkTB1ID8nz
         6ENTnLfX+nTSg2oNxDfu74ZmIGb1gjrwWU3EIkkKn4gGWXVM4w94NJYEhAEMO0n5iLgF
         wxrw==
X-Gm-Message-State: AOAM530P8MJGmithUWsoz+WbtbhXX6b3DJJwzTLW+rcNZBwSwG6ASsPy
        CX6ImdAOpmnP6Dvh0R3Ekh2QiuoHvVFmzMyL
X-Google-Smtp-Source: ABdhPJw942aHgXp7mFahO/zp8bDY1oXf551C9mUMibVhU+AlWQz13dTcFzIW/qLOWtvKmA04pujfIQ==
X-Received: by 2002:a17:90a:c57:: with SMTP id u23mr5447508pje.186.1627409788101;
        Tue, 27 Jul 2021 11:16:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ie13sm3618385pjb.45.2021.07.27.11.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:16:27 -0700 (PDT)
Message-ID: <61004d7b.1c69fb81.ac198.aebb@mx.google.com>
Date:   Tue, 27 Jul 2021 11:16:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.198-120-gb72fc3c0016d
Subject: stable-rc/linux-4.19.y baseline: 151 runs,
 4 regressions (v4.19.198-120-gb72fc3c0016d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 151 runs, 4 regressions (v4.19.198-120-gb7=
2fc3c0016d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.198-120-gb72fc3c0016d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.198-120-gb72fc3c0016d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b72fc3c0016d5ba671bf6e5ee31852a03d8c3a0d =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61001e5e117c6dfc1b5018dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61001e5e117c6dfc1b501=
8dd
        failing since 251 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610016324d5bf3a76b50190e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610016324d5bf3a76b501=
90f
        failing since 251 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61001666579f4f91ae50199c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61001666579f4f91ae501=
99d
        failing since 251 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610015e7fcde2e03555018e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
98-120-gb72fc3c0016d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610015e7fcde2e0355501=
8e3
        failing since 251 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
