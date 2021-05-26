Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD68391C9D
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhEZQE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 12:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbhEZQE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 12:04:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A71C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:02:55 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v13so838670ple.9
        for <stable@vger.kernel.org>; Wed, 26 May 2021 09:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5iJXmV3Lr5/H3/sQWaVWcvUT++1Dzekk0/q/L4qzp3s=;
        b=EdH5V/B896gSqGIE0y006A/2/EJTCwNcbW5R3ZmtHi0/26b5iLEfzhvWN6nPJdtoC4
         LPZ9lSJlJDjUuVeB3mpM5fdw0Gwv/kvAMz7RK4xKvvhYernFjngI7yDBfgAD8iLqhcI8
         hKyG82EdmYHIlzrM35TKwe8KuxwXqQUc9mZFcnhx9+uBiZEe+7PkjDODavYZvvzXCMfx
         bEzafkwRfJjU/z1m+eRebqL6bY2+k6no5gQYejnXnLUZlBn7dcP/MrMh5SuUc2CELNN9
         6xGFaP4l5PXRQeUk+DpU39oImSldi37Zmi1mz6Niy6pYCndcBI94GKB6HnD9eoL3WFhC
         PJEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5iJXmV3Lr5/H3/sQWaVWcvUT++1Dzekk0/q/L4qzp3s=;
        b=BXtCLvljcb7IfwVeL98o3kssBVCmFhQaW+idH6c5tHJVDnn5cnvqQQVXkA7PeR82Fn
         5VfvG4rSYsL76+OSlJIqHXbF0W4SbBG5VXqnf57YUdJuE6hTDLWhPBxfIx4906muLqPI
         57dsnwnm2f7um4pni4NWm424Lj47YeqUOU6e/M5eUYWPhuGClFyfdhkQLV1fELo+ycc8
         1EWXFqs4DnD9u1aENQwtG3JUAHEGaVtUCWy8FIl1M2pZDiLR6K4agMEtB1tGuEq4X8j3
         qea6l76bHHeN2WHmPjrT7aou7HmKYcz4zr3WC8+OVn918goxQ/zml9gvOcI3OGxG3iMK
         Nlmg==
X-Gm-Message-State: AOAM530fa++taQT5mPHNnGgp2zK3FN+A68y5B1HzlyylsZjVhGlNUKv+
        9+zKHgd9vPd1miZEu7spWtW025f/cRNGgTei
X-Google-Smtp-Source: ABdhPJzEdO9rXXF8arPyKCC1vhA1UolaTcrE4BUN8UW4nxCy17r3Tiw0UwQIfyXhYHeNkgDppuOsuw==
X-Received: by 2002:a17:902:bc88:b029:ee:7ef1:e770 with SMTP id bb8-20020a170902bc88b02900ee7ef1e770mr36652269plb.19.1622044974904;
        Wed, 26 May 2021 09:02:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a18sm16002532pfo.64.2021.05.26.09.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 09:02:54 -0700 (PDT)
Message-ID: <60ae712e.1c69fb81.d1ce6.4f6c@mx.google.com>
Date:   Wed, 26 May 2021 09:02:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.122
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 110 runs, 4 regressions (v5.4.122)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 110 runs, 4 regressions (v5.4.122)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.122/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.122
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      67154cff6258e46b05acc9f797e3328ed839b0e2 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3d59be1dcb7577b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3d59be1dcb7577b3a=
fc8
        failing since 188 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3d51be1dcb7577b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3d51be1dcb7577b3a=
fa8
        failing since 188 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3fbd88fce5b9b5b3afff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3fbd88fce5b9b5b3b=
000
        failing since 188 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae3ce9f67125cfbfb3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.122/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae3ce9f67125cfbfb3a=
f98
        failing since 188 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
