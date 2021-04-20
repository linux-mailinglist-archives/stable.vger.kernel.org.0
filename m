Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04D3366112
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 22:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhDTUlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 16:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbhDTUlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 16:41:05 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED262C06174A
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 13:40:32 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c17so26485815pfn.6
        for <stable@vger.kernel.org>; Tue, 20 Apr 2021 13:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ya7v7JkyXac1H9weZlQJU+GSSu6xhlbRojXf6CRbIAU=;
        b=cBdASvvD1OQfMHN0HMlxwhRD/gSoTOBG2CNj7cc9eFJhqfiXwae3bLlI80rlDS0apV
         fC801RcqFufXibuHStQ1zdaABZYlZ23Syf35Ks1bdtXC6dvhrL4BLoY/RGDlo0tuJuIk
         SXYib479Qfy7ns1vzqKxU93aWuLn6Fat/OjvwbUC5nJmVKYmsGGrbySzmmFj7+TlI4QA
         irDIeqd0ef64/GPb9vBc0YRnwUbZE3RKwLNysL/ukBxC2PXTzps8Q8l7HGnd2hp3xylX
         fguBESB2O5/GSXPlGxVq7dGe/0cpeapQVYZolcfw0hp6ZiaJENLkZkyzwj/ON6N0Y/LO
         dekw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ya7v7JkyXac1H9weZlQJU+GSSu6xhlbRojXf6CRbIAU=;
        b=Om7bWFknNT7fH7B4sC1r6vMueEV2V8P9/dAW9c2y7XR0CYpsv+g42uyYJMpBKIaHwG
         JRx7eYL6d+bo+0TR3CDobFDAEcEp2wHLDY/dykztmi/Pkrid2QMTjczRr6JDEJc60f8Z
         IH5TfUq3gFAwDitqfaqpS157DjqiGMKsGN0wZ7naJU3sCRkHMpm+uPOJ9V0Rp4lJyX6J
         OzQcoHQwGP5mb12qWV1lUzjfZiGldndgBnv0QhUA7pePHxn+/HQas9jQC8dgTwMGZmCq
         pS6v9Yt/+u4R5KfLpY9RXO0PJMVrVlETT2XLZ66f1As0RmcAg8OOP0aTDryYEMORX79Z
         uNvw==
X-Gm-Message-State: AOAM531MiRdKnnSFdLXcu+nO8Gb/XqGKi74OTlaCkvPI2d8BXAsLKNBl
        0Tz0liOEXYSAe96e5c+kJC/jBPCi78NI8o39
X-Google-Smtp-Source: ABdhPJwo4ftPNvFbEKwem0c7uAG+CA21cJt8FxgXfmru5qQkbRhM8kH0tzPYwEeRk36wbp0txkViLQ==
X-Received: by 2002:a17:90a:c404:: with SMTP id i4mr7027455pjt.10.1618951232233;
        Tue, 20 Apr 2021 13:40:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g2sm10518pju.18.2021.04.20.13.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 13:40:31 -0700 (PDT)
Message-ID: <607f3c3f.1c69fb81.f27b3.00ea@mx.google.com>
Date:   Tue, 20 Apr 2021 13:40:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-35-gb3cdc73d29cd0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 113 runs,
 5 regressions (v4.14.231-35-gb3cdc73d29cd0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 113 runs, 5 regressions (v4.14.231-35-gb3cdc=
73d29cd0)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-35-gb3cdc73d29cd0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-35-gb3cdc73d29cd0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3cdc73d29cd0bb5723426cec587213144b1c8d0 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f07e39e8394c76d9b7798

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f07e39e8394c76d9b7=
799
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f07e090388f148a9b7796

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f07e090388f148a9b7=
797
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f07e6b74eb286a79b77c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f07e6b74eb286a79b7=
7c8
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f077a70b6ac3a0f9b77be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f077a70b6ac3a0f9b7=
7bf
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607f078dc77a539c8c9b77a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-35-gb3cdc73d29cd0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607f078dc77a539c8c9b7=
7a7
        failing since 157 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
