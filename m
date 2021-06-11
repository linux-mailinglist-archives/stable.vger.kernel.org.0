Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8783A3CE0
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 09:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhFKHVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 03:21:34 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46964 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhFKHVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 03:21:34 -0400
Received: by mail-pf1-f175.google.com with SMTP id u126so3705877pfu.13
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 00:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mdVG/QghvZB7umDv/hJew6FaLYc45vOEhR6i8Lg28qk=;
        b=VQCOa/FcFxSAThong2ZVathEB/iP71asp9WdDecAandbD33Vpsoo68cTYOYM/H06qH
         mAZK7MeVZiTH5BpC9xurpA/yZT9yNZ0mzLGeVn5X6rPqzRNk1oXr08pRaxJCR8Fiz+Ni
         vogyLp60ODOacUztjrq3Xz0kqtjoHxe7EGQsPed1XQg1ogVKmHxrUvx6NcWNvKFZOM+w
         HEnMiTSIssqVDR4BrYidw72uHS5bnoAeUDjvLKH/mLoF5fczNBzdGMzyPiLBnRQDQSUf
         pfXJ9R0S+a06yPTsm8Z/ZVRpo0BIN15lDgZ81UZCmyQOkfjP9l8uBG7ckt2+ngSol1Nt
         mjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mdVG/QghvZB7umDv/hJew6FaLYc45vOEhR6i8Lg28qk=;
        b=E7QVJQwr6jzrjDTk+q7BYLUzZxmtKXRAgFPpk+kRLSwWahdBMkXCRWov07fX31cJz3
         kxeNXqJYeZHw/XMcxvPkappIcfLDazEdWONrIiUPFK03EZ0bmiUsAGSJ/UUfYkmcn4li
         uW5q4JWcCAGL00rhlqZp1F6y8rkL/p8bogb7x48/Y9jQsbnm68mxM/vK3C08+ZhrtQv8
         sAZRgYAB/cqUCDM2ZOcSy1+Ftzea1qP8VF0DBKqpcqS0AmkFDAEEjIatZcUmCFukPG96
         2eMtTlFg8h4WPkP6cm1MGLnzu/Ydz9pOiCNwMtKw2uZ+oQ/C1CH3a2ziImHIFBwg/2GR
         isgg==
X-Gm-Message-State: AOAM531tdrh2TLvAwBIBhCkaYR+FiBxVOV7Y9KWRl4hieBM7ETncEFph
        nVzq3sh2kS8ZBrXZ0Gl6gbDe683oTO0QRJO6
X-Google-Smtp-Source: ABdhPJxAAzpykeSmLFuCmu35mZYWwIK+LpAXC7IefJkpJsMxMmJM1s9jEpzz0/5OnmUON4ULWty/eQ==
X-Received: by 2002:a63:5c4e:: with SMTP id n14mr2267432pgm.192.1623395903721;
        Fri, 11 Jun 2021 00:18:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p7sm4414326pfb.45.2021.06.11.00.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 00:18:23 -0700 (PDT)
Message-ID: <60c30e3f.1c69fb81.b21e6.e784@mx.google.com>
Date:   Fri, 11 Jun 2021 00:18:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.194-26-g872ef4fbd314
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 123 runs,
 3 regressions (v4.19.194-26-g872ef4fbd314)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 123 runs, 3 regressions (v4.19.194-26-g872ef=
4fbd314)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.194-26-g872ef4fbd314/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.194-26-g872ef4fbd314
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      872ef4fbd314bd8d191edc719aafba415a970dfe =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2dae4b7d0f23b350c0e1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-26-g872ef4fbd314/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-26-g872ef4fbd314/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2dae4b7d0f23b350c0=
e1c
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2db84cc86db76590c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-26-g872ef4fbd314/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-26-g872ef4fbd314/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2db84cc86db76590c0=
df6
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2db0047d1ae448f0c0e28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-26-g872ef4fbd314/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.194=
-26-g872ef4fbd314/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2db0047d1ae448f0c0=
e29
        failing since 209 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
