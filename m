Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A3736D9DD
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 16:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhD1Ow4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 10:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhD1Ow4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 10:52:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14750C061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 07:52:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lr7so14788822pjb.2
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 07:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xbK6cWY9G4vcDrkcKFyyHl05bGjfTlvE7EVfqKUNhTk=;
        b=rBbnL5HGAjwJ6vx52KvicjA+Gv1PsmtrT9iOWRn13oG/Dk3i2bcZKMmfeXCZyki+Y0
         y9Qyry0hDv39oTc9tZXkXPVlTa/Lc85TflV9T2yCy1S42z52oCKbWiiPwUMLyaO+ZRYe
         e7nJUVGW2wyHYNA4d0l8DxREk2vqUCJ3Uahyz8XbgC+2LuClgV/zTxClgHXMMZ993QsK
         Wkxs9JiwpxYmHQehklvphyAMUWYCwC3fTH2bM3eIRCwm8lvgyEVCsnj7PwD/F6Co8rwW
         PQ5GBCONV8dTcA+9aMWhAiEr1qXx+8RDlCOOARQF5tUWxqV5w84ndJJL5DBLuNOkdBzF
         8SYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xbK6cWY9G4vcDrkcKFyyHl05bGjfTlvE7EVfqKUNhTk=;
        b=rmll3OraCHbpBIWGnv6S8eJnV5Sj7ksjzaJTza8+A9LmhJfA3Ei63x4x+pGW1dRYco
         RveT7gQMjLAd9Dw1+IeJ/6HCWLe8liziobJe1Cuzwy458BAa+ScLCirp0MWlD4FXPRZQ
         FmFUuu7y+8VvqxfhsEDgVKLPSk8Pt8qpfSRe+ZSbuC4uvJ/Qefak4qBjcGCsO9oeXYn5
         +D1R4VAym/+2m30D+Apm68GMShdCuRJYfI39spq387cZay+QHHrN82mZDGEW7HNKYHeR
         BnNbPVMHwKUySeOSFhqIICPFPeAWpP10ohrZj+0QSOVmzvDK0k8lecijiRdYPdDK/aCx
         q9Bg==
X-Gm-Message-State: AOAM530JK+pZJp0d9gJ14UNipg2sQm/XVZEA71RAUabMSjFKrD8YUu1d
        JtAboF/1+CPXVJf0TYTf2kwYU/UUvEzcSY19
X-Google-Smtp-Source: ABdhPJwjPBMi/LXr0eDzXDTekVUhHvQH9S9O1iIz08qUGhpdprnCBXssGloz2y96N9TNUmGEVW9QDQ==
X-Received: by 2002:a17:90a:850c:: with SMTP id l12mr4348378pjn.224.1619621529436;
        Wed, 28 Apr 2021 07:52:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 132sm54828pfw.38.2021.04.28.07.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 07:52:09 -0700 (PDT)
Message-ID: <60897699.1c69fb81.94091.02b8@mx.google.com>
Date:   Wed, 28 Apr 2021 07:52:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.268
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 86 runs, 5 regressions (v4.9.268)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 86 runs, 5 regressions (v4.9.268)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.268/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.268
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7eafd3bfea5a367852687cbef3eb1a526704c9b3 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60894282c7109852919b77b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894282c7109852919b7=
7b1
        failing since 160 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6089429b8f7288cd449b7799

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089429b8f7288cd449b7=
79a
        failing since 160 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60894280c7109852919b77a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60894280c7109852919b7=
7a5
        failing since 160 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/608970ff9c073495e69b77b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608970ff9c073495e69b7=
7b3
        failing since 160 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/608944032c3b8e151e9b77d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.268/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608944032c3b8e151e9b7=
7d2
        failing since 160 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
