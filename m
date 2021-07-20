Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4BC3CF479
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhGTFqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 01:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbhGTFqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 01:46:37 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12254C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:27:16 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j73so13533pge.1
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HVt9E++8Mn+OwBZ720ESMFo8EjQft34+nYBhhQ9WdWU=;
        b=Ouw3rK++sXAFjLzTwivG2XUyd9D6dk8RWJ8g4xPRVx/afw3pzHpHPlt0wKzmCWKNn9
         rTt3b39FprNlj/8ElhmcQO8AS9w6PMV+ZoiFCQP3ay1bWHfEAf8lv7hlB00vexVUHqxN
         7zXHTcRYjDA9qfl78JMaWNl4HhLSOP3EuG9AGm/JXl1/14ZRU5rqdA9lluAe9nK8aKkV
         ixdnJnIVAayToqUeikPDDGQIikwrkI9gjGnT0P/DxcmenwSMxqi39yNaLvqc9Ddl0Ek5
         fhX/tdMqixZkVC8+6rIkx0vQgl8xspM5ksYFRAhGthgmIR+Cgh/kXPiBj0VAxw8lph9n
         voBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HVt9E++8Mn+OwBZ720ESMFo8EjQft34+nYBhhQ9WdWU=;
        b=e3R6YqnAVkhrj2Zz9ckMOLYo/tOXX/Zul32L+xb9cw4gS9vo6MnDAomefR3gjQI8ti
         k00JJKHdCzOJdtDPellBGv5uqcro7so4CjOMxmMbdU3rxdknhRsQb+j1Ja2hVkkrBJOc
         bGZRGW6mRnMkxx27HcjgZwbFv1VKyRaPxFQFNjtTqvzVs6kr4KLsZecn/hRrSEKw31Vw
         TXygUbKI7Say3ZCmgG7vVfCIxL1TJZGM6PS5UueUidk/2TtlwN4q/EVUcb9nsp8hvoh0
         u/qsRRMW+ga/f+RRRps20WcNYVUp2gseGNI4u5ovghWO+K2/qWLwR+jeaSgnG1bO3s36
         3jiw==
X-Gm-Message-State: AOAM532U0r27iPGgETRAiQAIYkoZgCql7BNxgJZ2+ietG1MRS4UXI4zG
        Yc/+Qc4zeXWA36iv/Fe6TCWiqUsGS6FB3A==
X-Google-Smtp-Source: ABdhPJxC2SCGZEh8q7Jl8tRcGhCQWWzeJYptlGq7Ok7XYWLKqKb66FdLJDta8op2/B36uU9yd+rMTA==
X-Received: by 2002:a63:171d:: with SMTP id x29mr29163684pgl.418.1626762435387;
        Mon, 19 Jul 2021 23:27:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1sm1503122pjn.11.2021.07.19.23.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 23:27:15 -0700 (PDT)
Message-ID: <60f66cc3.1c69fb81.1420b.5a0a@mx.google.com>
Date:   Mon, 19 Jul 2021 23:27:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.197-421-gdfee0ece72748
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 134 runs,
 5 regressions (v4.19.197-421-gdfee0ece72748)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 134 runs, 5 regressions (v4.19.197-421-gdf=
ee0ece72748)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =

qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.197-421-gdfee0ece72748/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.197-421-gdfee0ece72748
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dfee0ece72748f6e5a717edb5eaedcb8fa3060ed =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60f634b2303411b59f1160cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-=
sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-=
sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f634b2303411b59f116=
0cc
        failing since 398 days (last pass: v4.19.126-55-gf6c346f2d42d, firs=
t fail: v4.19.126-113-gd694d4388e88) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f631772085fb87291160be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f631772085fb8729116=
0bf
        failing since 243 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f63181aea8a64b9d116108

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f63181aea8a64b9d116=
109
        failing since 243 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f63177d59c87e14a11610d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f63177d59c87e14a116=
10e
        failing since 243 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform              | arch | lab           | compiler | defconfig        =
   | regressions
----------------------+------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm  | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6312246d84b093d11609e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
97-421-gdfee0ece72748/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6312246d84b093d116=
09f
        failing since 243 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
