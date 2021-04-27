Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B0736C867
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 17:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236488AbhD0PMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 11:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbhD0PMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 11:12:36 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B864BC061574
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 08:11:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d124so41537738pfa.13
        for <stable@vger.kernel.org>; Tue, 27 Apr 2021 08:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LKc8YzMlf8ksxBkBSkEs4P6d/R6VtJvXpAnSsfed+r8=;
        b=g1QKZ3t2voVZeFnzeSaX8M3Zhmn4MaVK2qnc6vGp/XmajYZf8od8eDykBWzQi69ynF
         1fPOaroKWcER72kpbhS9DsZtHsSyU/edRpU4l2MYnGJIjBbDcaf0wpVuY9uq8xoylsfc
         nnXv1ZpDlstE09OQxDAkmD2p/Xp88q9pHNwMeg2VNvF5wjD8GuGmnB1Q1snrCLqmg9bO
         3X9CV+xZ5QTY5SRFBJxG36uMzyoAQCaCp80MgQsnM/qRd4Gqu7hOnZxNH4YSeOEuilcb
         ktrqa1Qnega2613WiIO9h63yeJ9+dUOFoxTOCidVswMjmyCPYOdK8o/Esfrwm/0AYeEC
         Or1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LKc8YzMlf8ksxBkBSkEs4P6d/R6VtJvXpAnSsfed+r8=;
        b=d78/LFGzQc7+j1d7pMRWxO58w2QD+dZIKfZn+G41Vlq8KGgNydQPaRdocW+ELlzapQ
         oOwl69PhL7q+RiPzhej7OuR3kyiTTpp64okzUamk5orDPPDKLVd0hH8XqsNmRujXkjWh
         mEuKhjIyDolo17eZcBZnyLYXl/aPoHBkCcfbhG40MnFVWKtg9QGrxNtsU0Aecu6B4nbZ
         ldhAPsx9CidbcPNm3BDro6aFdRrihBj16ToSm3H1dT/RMZd6igHlnKeZCNqubn1uvH8m
         ZsUVeyBiYg1wvVOFTNx1G6YgL44Zx1Y2GgoiCFeRv4iwV9pm3tYebhY0SD8zI8ndG//p
         TdZQ==
X-Gm-Message-State: AOAM5325TUIHAblNDWn1cMqGrUuNd0A/VEYk1EluLNROgFEF8SNIAzZl
        3SG8ayoQXVea+Gcu3f4IaHn+E9OhkXpPBxD3
X-Google-Smtp-Source: ABdhPJx0bVBD6a/7LFOthFLbB92A8V9IX99Y6PrbkI3d/K5mXuIZAkgMclgYKfW8MHilkPcgyccuyA==
X-Received: by 2002:a62:e10f:0:b029:25f:2272:2560 with SMTP id q15-20020a62e10f0000b029025f22722560mr23031304pfh.47.1619536311109;
        Tue, 27 Apr 2021 08:11:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v16sm2774715pfn.56.2021.04.27.08.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:11:50 -0700 (PDT)
Message-ID: <608829b6.1c69fb81.20a01.849b@mx.google.com>
Date:   Tue, 27 Apr 2021 08:11:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.188-59-g44040da4ce0d1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 123 runs,
 4 regressions (v4.19.188-59-g44040da4ce0d1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 123 runs, 4 regressions (v4.19.188-59-g44040=
da4ce0d1)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.188-59-g44040da4ce0d1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.188-59-g44040da4ce0d1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44040da4ce0d1897073291636e2ae30cfa27557a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f61cc351ccfa1d9b77ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f61cc351ccfa1d9b7=
7ae
        failing since 164 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f6203a9f673fba9b77d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f6203a9f673fba9b7=
7d1
        failing since 164 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f628c351ccfa1d9b77bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f628c351ccfa1d9b7=
7c0
        failing since 164 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6087f5dfdcb6286fb99b77b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.188=
-59-g44040da4ce0d1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6087f5dfdcb6286fb99b7=
7b8
        failing since 164 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
