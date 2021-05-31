Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E13953DF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 04:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEaCXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 22:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhEaCXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 22:23:09 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9CEC061574
        for <stable@vger.kernel.org>; Sun, 30 May 2021 19:21:28 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e1so183703pld.13
        for <stable@vger.kernel.org>; Sun, 30 May 2021 19:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MKUuwAC/Cvto9anCLQWsF+QS+xJPtjZ+V2yRI2Mqwbo=;
        b=B14MHDQ0BwUYSWxU2qFiGqhWyfEY0t2VNhn+wUDx5dRKRoKizKcOjX3lXcAFFXZnNI
         hLbeErmwLSqOwuz+hyk4hUpgT7Rmj9f6pjcXNaYh0sRqu2NXzdxN+wVfjBNml3QpK8jZ
         hUXF+O9QPGHoi87WI57RCrXq7kdsaHX1JmMuUY3uqsI06LiP2N+hLLiY3imMk4sTR9ku
         r7UmTXBA/GEhih9xbYCsDdR2DkgmeqL9T0pJP6ZG+wsyl2agSmX21OeWIct5glBMjt9+
         DDY51Tf3BMCSuE1PpOfORHAg1bbL4TGnA20dglozkUitOUHvyCoqZj3LQSIV8LCSXPRi
         QucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MKUuwAC/Cvto9anCLQWsF+QS+xJPtjZ+V2yRI2Mqwbo=;
        b=eZXj5Wn5/9zKEeM25SeB2WE1oPP5pelrvromaGtYSKcVgulrUH1DLtaRfT1F1ZzwtW
         NUqFxv12dhzcKhpZOJX7cjot1GH1M0gNshZQ6fTyn9F6yjlMFppr44bagtmKzv797Yvs
         QXVAC1VbmA9y7PFNEdIyvAmSfAxBaH1uyqPXeQSA/hoJvDkcmNjtROVb4AVpeSaocZ41
         JpqCCI8dNdFKQ5xd/Sr9AmxS70gDaFS2hQ6pidTKls9Lq1Qku9EoT5OR8JRET6emaVMy
         48fzBMbXVvMyVFqJOGVoF50aXu+sk/Cnjnwa1W5IgKrTcbqsII2QxLecdMyv5n7wjDJK
         jp8Q==
X-Gm-Message-State: AOAM533r6P91RpMcs0tWMWAaz8kpuNKI5gXvJYhRMeeK4EKSla55ZGql
        4Mq6Ve0uCAC8zj3yFrDIzqBkMKqusB862t4h
X-Google-Smtp-Source: ABdhPJyQqfaVVeIinWcOt9GNNb5jeOHiMfaocQlovgLdZfwfI0mO9OjiwOfjohwX6DX9AdX6IvAEiA==
X-Received: by 2002:a17:90a:950c:: with SMTP id t12mr16291668pjo.135.1622427687501;
        Sun, 30 May 2021 19:21:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9sm9292246pfo.107.2021.05.30.19.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 19:21:27 -0700 (PDT)
Message-ID: <60b44827.1c69fb81.1dace.ed1a@mx.google.com>
Date:   Sun, 30 May 2021 19:21:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-97-gbcb6e5399a5d
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 178 runs,
 6 regressions (v4.19.192-97-gbcb6e5399a5d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 178 runs, 6 regressions (v4.19.192-97-gbcb6e=
5399a5d)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =

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
nel/v4.19.192-97-gbcb6e5399a5d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-97-gbcb6e5399a5d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcb6e5399a5d774506a251b7dc33b461fc166b35 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4408dc70bfd8f7eb3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4408dc70bfd8f7eb3a=
fa0
        new failure (last pass: v4.19.192-74-g7963f55f7491) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b40ce621fb503ee7b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b40ce621fb503ee7b3a=
fa6
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b40cdfaa1ebf46cbb3afb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b40cdfaa1ebf46cbb3a=
fb5
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b40ce821fb503ee7b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b40ce821fb503ee7b3a=
faa
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b40c8d60a9b69661b3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b40c8d60a9b69661b3a=
fbe
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b40ca365ed588fc0b3afba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-97-gbcb6e5399a5d/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b40ca365ed588fc0b3a=
fbb
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
