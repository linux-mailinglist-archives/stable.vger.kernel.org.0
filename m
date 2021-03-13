Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4794A339FA0
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 18:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234124AbhCMRtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 12:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbhCMRtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 12:49:15 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C736C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 09:49:15 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso12649875pjb.4
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 09:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QB8dhisHYQ78gIO1RlIRGpRAL5Or9p6YumTRkiADjKA=;
        b=u2pRVee8fIJcaMpmbjZDcwQNdFEAJD/lcaKScMhhXJNb7TCeJ+1TPV/cOspsNPwM67
         gwr8pywUq4CKtGcO2Nyd2Ay/go3NQO5shHs+vSmH7/1OzmAu3F0bFxP6z8INyjTgjbJq
         1X8+EYUerCo0qV4W4pw61U2ZUG+zzvEl9F5g+J3KmUsnLy9HNqp52ZDrnDo9UReacC3c
         VrWVSSrV+5FOvIrEcfoOtQdGsQZCzi++SKqiB/j+KT/poxQ4tw62DyTd7rLG5xFnBEHt
         /p+gqv0EKJsVedy9LEXzBw35gYuu9yzu1qGPu1pgedUxpaQmY3MKPRFoJHnVSFsR1AvU
         UfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QB8dhisHYQ78gIO1RlIRGpRAL5Or9p6YumTRkiADjKA=;
        b=cWHkxRWqE7JSDjx6qXNdhfT37nHikTh4zMZqqCgHU1A0qcgmNnlQezrlOOL78jdfT9
         yq5WGXLPw9ZWQLqEpMwBeCZBAETgPwQ10GPmbCj8VvWlMmaV2l/HZvyZH7a0tsEfHcu+
         8KBFEEOl6BsDlASh98bA9pbYGhLrS/fCux+F3n+7EsyDmI8zFNpPD3BF5VHtOEZKGoIk
         KshAHWFYDF7v7fBKLntcDxgOqoJ27/5BCyUF8W596Y4/68HFY3fW4QW60wstNCOSqfqJ
         zMJEttnc/bmFNt5B1uEWvI8NTE9St9EiD3/pNOgFZ6sK+lUnAEB4bGPoa3AmTMJMTHpe
         GY9w==
X-Gm-Message-State: AOAM532C9L5UsINpONqmh/FhZ5buqKAGi+vu3N75MVgWg0BkxL2z3Otg
        ONenAoqRLcNOqsCjpgGERx+ZFqnWU3JOrA==
X-Google-Smtp-Source: ABdhPJyTFCWGZWGVNpZSJRrT0T67RDN0xB4tzIVxsMpV1l5DROxxaZmaCzxhb2QcieRjCA8Hg5c0LQ==
X-Received: by 2002:a17:90a:aa81:: with SMTP id l1mr4646530pjq.190.1615657754708;
        Sat, 13 Mar 2021 09:49:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b19sm9068022pfo.7.2021.03.13.09.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 09:49:14 -0800 (PST)
Message-ID: <604cfb1a.1c69fb81.bdc6d.70f9@mx.google.com>
Date:   Sat, 13 Mar 2021 09:49:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.105-106-gc1720e578a90
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 114 runs,
 4 regressions (v5.4.105-106-gc1720e578a90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 114 runs, 4 regressions (v5.4.105-106-gc172=
0e578a90)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.105-106-gc1720e578a90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.105-106-gc1720e578a90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1720e578a90c550a3676e095333f34b46ed6331 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc65ea91c27450eaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc65ea91c27450eadd=
cb2
        failing since 118 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc66fbf4b8ec250adddd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc66fbf4b8ec250add=
dd4
        failing since 118 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc5e1f2d6a9dc4baddcdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc5e1f2d6a9dc4badd=
cde
        failing since 118 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cc5eb0fc7234903addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.105=
-106-gc1720e578a90/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cc5eb0fc7234903add=
cbe
        failing since 118 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
