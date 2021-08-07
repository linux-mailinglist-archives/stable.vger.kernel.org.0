Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4193E35EB
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 16:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhHGOms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 10:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhHGOmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 10:42:37 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0C7C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Aug 2021 07:42:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a20so11299291plm.0
        for <stable@vger.kernel.org>; Sat, 07 Aug 2021 07:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/ZRRSbki4FkJmlRA96vquzIy3B7tyqRBzE/TquaGjWM=;
        b=y+ZtPefqS6iE/0Wd0oNJ1bPhSjIs0mi7QD9Vs74NY/nGhBxgSLubTXsVLraPpzOdFj
         rGe25lhMifvhnBEaNVekO8mYuQkUfG+q2eoOqOlN0zS1Px82DmmKS9XBp2wxB4/19/1m
         Jo9IHip3AapqsqyBf4p4DLoQMQmMQdUCGWl+6pJN2geHK6AtAcWkxfXdB09+jnJHUxet
         3Fv/UxSyfCjMo1d2hAKEK3Zy9lGv26Lh+Qps3zSO1oENA2GZBAFz7Chyqz8G2Z0pLmBM
         6PJvatQ48QUsraCkD2bIN963CnjFIGIGxt8jCD8bLFCrtGjj78ElVN1j6LS4NQbPsYHN
         IJnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/ZRRSbki4FkJmlRA96vquzIy3B7tyqRBzE/TquaGjWM=;
        b=DcftfL0QoFoTT/gv3W4/j/4Ov/Yme/kByexXz0lzcCKdymb3eTISU/kTQjE5NbVyRA
         Pbqt4hG1VivuLMF5q3HWxqDIPapk/eWjh9885zMAknG6aEXXeoiEY/gqi0NzD/Gc0QWg
         oE1FL0f9HatZoqLkDfGCvlEWW50zFx5mDYbZP2o8mtgrhh2+NwscfTTCbG7V70matxGW
         c0GrLNEGvil/EvuXBhlywq+hu6aJ3pomKt+iToVy0nJzvqZnvl3FfyPYUCTrz1hfH8xi
         VBFjO9vuriiZY8F4sNxocUi4DRmzi95v8aODwTVUeD3UZH1cikjp9BIW0o6+QZKfeq9k
         CeJQ==
X-Gm-Message-State: AOAM530JShYB2L+6WrLBH+8NoWzXREVDkFiAxTnLxUve+LAwJpM9vbUP
        8NCnABBmD1Tt4SSHZAq+50YYUkVXt3pRVBIX
X-Google-Smtp-Source: ABdhPJwh1Y7l1m4IY3C4VKXfdRHnM+mj+G2qu/hFGzmWZpnxBa3eG3ecFuEG1N6ozf3w6jddPfSGkw==
X-Received: by 2002:a17:90b:3905:: with SMTP id ob5mr16048785pjb.211.1628347338903;
        Sat, 07 Aug 2021 07:42:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2sm14762130pfn.141.2021.08.07.07.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 07:42:18 -0700 (PDT)
Message-ID: <610e9bca.1c69fb81.549bb.aebb@mx.google.com>
Date:   Sat, 07 Aug 2021 07:42:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-16-g42d67c25de97
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 115 runs,
 3 regressions (v4.19.201-16-g42d67c25de97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 115 runs, 3 regressions (v4.19.201-16-g42d67=
c25de97)

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

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-16-g42d67c25de97/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-16-g42d67c25de97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42d67c25de97321b99830a09405e712281cf7443 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610e5f41a83e6b6ec6b13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g42d67c25de97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g42d67c25de97/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610e5f41a83e6b6ec6b13=
688
        failing since 266 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610e606c93bf208d67b1367a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g42d67c25de97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g42d67c25de97/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610e606c93bf208d67b13=
67b
        failing since 266 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/610e5ee914c01eb5a5b1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g42d67c25de97/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-16-g42d67c25de97/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610e5ee914c01eb5a5b13=
67c
        failing since 266 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
