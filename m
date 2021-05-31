Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529E93968AA
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 22:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhEaUQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 16:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhEaUQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 16:16:08 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31069C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 13:14:28 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c13so778331plz.0
        for <stable@vger.kernel.org>; Mon, 31 May 2021 13:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RAGRTFPILQ9V/aJEeKiafOEDD1+JIDsRcQkIdVGM118=;
        b=S40/Zg42QIpP2m4iocF1/N3PM0HFV9Iw+kcuuolDW07NxHq0ueSzZ5CAXijqfArQiz
         RCZG1OqLUIAtH27TlR0ddgiZfD6jYj08TzFkccU4DpkyLpraOKmNN7oxZ7LR5TTeyGSz
         Gll04Y+MPrl+EkoNm/8+fnBcBQ2wtNTFCB0eWGrN8X/aLuqGCYfqawUisa12dzILjraX
         IN+1lW9b8XP6IWSIAx+jAbaw1F67/WP6FOBt6MwzQMqT9LrzWmyDG+DM+3KrUhl5xjF+
         GSjEZ99tnfBiGNnETdFXp/SSJwRvkhGAbWPF4IuGXtfn36wboVz9Z5HyWLlZnfNT8rQ8
         rt2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RAGRTFPILQ9V/aJEeKiafOEDD1+JIDsRcQkIdVGM118=;
        b=lRrEEjONuODA1dR/PHjao+r7/CRDjYyYX0h9B7+AWUUGBixL5t54VQ2WIb2ihslVRf
         U9enD2AgI7we5aiM1TdcbW5/Ogg5gpOh6pZgyqsr5rS5BhFJRwtMHZfMItGj/jisxhLS
         sXAy7D28yP3dDbTQa5XH0IluJoAb3nfw0fH7WlMDBbjn5ZCbtypZOeXwyxdNuyaq1SxO
         Y8BhwdQ91TEzyMTnkbeDP7T7gn4VRNhSviEzyFPlJlPxUIkmQ7KeFAlhdigyzxHiU5Is
         GX0PJgKdHhtqimjefrNbvJrHzyBe5kgcxZuoxjRwSpWesgHV8qwNggrGDoeKEHdc49gs
         XXhg==
X-Gm-Message-State: AOAM530hdrzXFMI3qRs42N5yBQ0SD54rTKg0fOcIkqBlkdH2zRB23aVW
        thOKy8/KC2LQCGdy95I0vvuglhhSQydWg7/j
X-Google-Smtp-Source: ABdhPJxM2BuBlqse98TAzdL3eGjQ/GhNTncZ7RJOBuXaRFzYwEjzpbX/89cyW6NyfpoEjBePDSQbGg==
X-Received: by 2002:a17:90b:400c:: with SMTP id ie12mr13066915pjb.107.1622492067321;
        Mon, 31 May 2021 13:14:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l9sm11672890pja.20.2021.05.31.13.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 13:14:27 -0700 (PDT)
Message-ID: <60b543a3.1c69fb81.6c332.480f@mx.google.com>
Date:   Mon, 31 May 2021 13:14:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.122-186-g4142e74be32e
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 167 runs,
 5 regressions (v5.4.122-186-g4142e74be32e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 167 runs, 5 regressions (v5.4.122-186-g4142=
e74be32e)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.122-186-g4142e74be32e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.122-186-g4142e74be32e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4142e74be32ee4ca40200301fcabfca32800f9c5 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60b508f6ab4386b3f5b3afc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b508f6ab4386b3f5b3a=
fc8
        failing since 192 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b5083cfc682f7c64b3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b5083cfc682f7c64b3a=
fcf
        failing since 198 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b50844c2180e1935b3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b50844c2180e1935b3a=
fb8
        failing since 198 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b5082bc2180e1935b3af9a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b5082bc2180e1935b3a=
f9b
        failing since 198 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b50ae4eead4db47fb3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-186-g4142e74be32e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b50ae4eead4db47fb3a=
fcf
        failing since 198 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
