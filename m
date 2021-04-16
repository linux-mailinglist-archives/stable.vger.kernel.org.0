Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCEF36273F
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 19:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhDPRyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 13:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243993AbhDPRyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 13:54:09 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63595C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 10:53:43 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 10so9952557pfl.1
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rCPejJn/HzPbh/rMB+uHRXHYd1wvPmE4nNPbTIwGqbs=;
        b=jbYaE2lEAIWCsK0NY0GTCsjrfYIbx4nQ2MS7zzTqGxSu9DKJmXAy8bbnN4qbIvfgsD
         vMGywYQnEIgIm9GZbZpp+XmcFWdU60KWLZ1qnGsvXJWWnTL7bXhDBjD/IslDTXL9HvDB
         xk4ouqWpUOzPXiQ8PLTn1nMPk6WnHgrX6vkEw3FBSP7HDf/21G9MzGHAEbBSP+1s+A7h
         UaezmSD6zLz5eHABONUfRyrCcVzrBBmqJrcP6o1mDUw8Rci+dYdfhneuVFvflcxcKt7f
         fX4HAr4ito9vJs9qaG5Ntjh+RMerZ8Eha1fBf6JU0Z7WZzDaYp5DnYY9aoLVvnkAAC6X
         OpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rCPejJn/HzPbh/rMB+uHRXHYd1wvPmE4nNPbTIwGqbs=;
        b=UK3ku9RslPBXZ+InuhM40rOBA3oWSFtisjOiNEOsak71Lik45jYnajhMLyK7mAI+o2
         a97sBwUJwP77Y9pwLahtyL2oUCt6cX47tEUH7chGg69O2bMDKKKDP0xnMNE01zHo6o9i
         1zgmxbClZ1QJ/bk5HgV78UuuiBzRPhUIv1taIvg5PjXEOumLrHHC0XZ/LeiXZx6lDeYF
         fd1MJLTA90Zxc7y6Mixuo/De4GguIRdN5DvYddCJKTvPOW/sMw37OvYL7VDlDOeRlyBT
         2P/nDTaTdLSJre78Arwg77SceYIaUkS6arXnnrv0Hb4JDYrSAwiJUjo6THkkPiJZ1j88
         wE8w==
X-Gm-Message-State: AOAM533mSwH9e02SZ4+QcJh+fIoOsxaiUFesh7+CDrvFLV6otLVvHrAu
        AfLRvN6jC4jYTaviiU0gKa7EEAq/tq6jaSPA
X-Google-Smtp-Source: ABdhPJxGTng+uqUOVtIW4aRSYz85c+8MB7dvoYf48FokGXmGwBMxWqWoez4IMnVvQ7VADCU2Z0e3xw==
X-Received: by 2002:a62:8c56:0:b029:253:e99e:f216 with SMTP id m83-20020a628c560000b0290253e99ef216mr9281468pfd.0.1618595622755;
        Fri, 16 Apr 2021 10:53:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm7157349pja.3.2021.04.16.10.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 10:53:42 -0700 (PDT)
Message-ID: <6079cf26.1c69fb81.b4570.2c6b@mx.google.com>
Date:   Fri, 16 Apr 2021 10:53:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-47-gfd6a14979efc7
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 5 regressions (v4.9.266-47-gfd6a14979efc7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 5 regressions (v4.9.266-47-gfd6a149=
79efc7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-47-gfd6a14979efc7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-47-gfd6a14979efc7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fd6a14979efc756e08209701203e7a28e8cc6ee7 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60799589f9ef0cb88fdac6d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60799589f9ef0cb88fdac=
6d8
        failing since 153 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079958ef9ef0cb88fdac6dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079958ef9ef0cb88fdac=
6de
        failing since 153 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607995883c31bddc06dac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607995883c31bddc06dac=
6b4
        failing since 153 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60799537c1c270e357dac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60799537c1c270e357dac=
6c6
        failing since 153 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6079953ac1c270e357dac6d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
7-gfd6a14979efc7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6079953ac1c270e357dac=
6d2
        failing since 153 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
