Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AD35FB4A
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 21:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353196AbhDNTFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 15:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhDNTFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 15:05:03 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B423C061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 12:04:38 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t140so15082791pgb.13
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 12:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+aY2/Fv0gyLqDUxPp7FGYrcNFdujsV6QKFJSot9/M6E=;
        b=BzYZHm8M8VGxOqCLYqVt4+sGWXK3QX2Rwx6Ltd8eSCjcuNRwTuTnowvhLOBV5dWjiU
         nR/L6DDur/+urg+KNgXHyKYMMiblp0uHktF5c1SCxJgA7p7ew9N61YBbQthpypwbvA+I
         We1tPmY/bw/U3xi4wjG1W9Ltlrlqiv9qF3DzK5U0A02SdAGqTx+fNU2dZ3S7dGncUzkY
         DKzx9YuVc0gZcdeMSDTFjhDfxLU39NP+ddZsuMvG5JqJw4PzLqQ/pi9gAw3cBRAIukaD
         6RaDBd3x2uLis2gqHoZN4PXll+FURO2BGyRChqtYPw8EPBY28FhfZFRjKXAGfEvLYM19
         jh8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+aY2/Fv0gyLqDUxPp7FGYrcNFdujsV6QKFJSot9/M6E=;
        b=R8zbBbQ6SFVrjdleHSeFV6yJeNW7m8zlHFp+gyAz6zmoUPcrPBpUNhKe82PNUraGeP
         ghya1CDaXq/BPDSLhXcZiNN18qZ8eUl8X5jX1ZGCDht0GQCCnrfD2vKUa+kgT66OjB5K
         OsK62Dqs95ILPdFBkEmxniDCOq1vtOSt0d9UCkhi2VqmJFLjRYbDMo8XKd0bXoM4qqLn
         uQF6HS63rdFqOX9O7BFhKqCh8LWAxTOjGTRoLedt6MVx2vd639FZZuqDCOvz7x6MH0rB
         gIBrk5tRuTFlQV1iu11G2OqIdie8QWgGd5jH98Ve60do5CYScf1PWNwxgEhruaaqzTmh
         1kwg==
X-Gm-Message-State: AOAM530HK7owPDIBVUUx1rrFs9GQBojQkU1UUMFa0QXgCympyHc+Ialg
        PpM6P+Sd4ZqXvTPrqqq/4k8T8SAD95KG+l1q
X-Google-Smtp-Source: ABdhPJwMRJHGhHesv8B3ekzv0Jt3kKnJzHBLc6YWPqKuc5if+qEiARWpMMKeiCHkdNpxg+R1p/ggTg==
X-Received: by 2002:a62:5fc6:0:b029:24d:e86b:dd38 with SMTP id t189-20020a625fc60000b029024de86bdd38mr14474298pfb.64.1618427077386;
        Wed, 14 Apr 2021 12:04:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 14sm178722pfl.1.2021.04.14.12.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:04:36 -0700 (PDT)
Message-ID: <60773cc4.1c69fb81.e86af.0d70@mx.google.com>
Date:   Wed, 14 Apr 2021 12:04:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.187
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 121 runs, 3 regressions (v4.19.187)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 121 runs, 3 regressions (v4.19.187)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.187/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.187
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f1b4cb77d7f5a442b03f8ad597768b422e8ec58 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60770476089ea787ffdac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
87/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
87/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60770476089ea787ffdac=
6be
        failing since 147 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6077045dc41c613944dac6bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
87/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
87/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6077045dc41c613944dac=
6bc
        failing since 147 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6077041566e496fc67dac72b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
87/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
87/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6077041566e496fc67dac=
72c
        failing since 147 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
