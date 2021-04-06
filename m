Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696EF354A67
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 03:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241851AbhDFBrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 21:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239470AbhDFBrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 21:47:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11555C06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 18:47:36 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id y2so6609967plg.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 18:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OGqKjKe8jIH+0KF4Jes+F+0KTLQ0HJ7sC6v/AuGb4XA=;
        b=IJaq5Z7sEMnQKAgA6wtcyegkMpxWsffW2/9JTkJ8vRiyk3iQ9ckAfAoZX1PIM9EmQ8
         wQWp6xDl3rfD31qnUdzexqy2q/Q021jKBNG0hvpYWhxbhQiDIx7bEzdRFBH/MIrYC/RV
         nl7+VjC9Vt/gIbEdyQ5MdKZelfejY150rRSbofUspo3zuHw3uw9lzTnv9bQ9oRQrh1U6
         S/KSgiFYLPj4yTKLoLyBO7EJMWRHbOZfxlLan7X6Rnv9t2HX59i4HWqW/QNoPs9X04nw
         QnKR0b3hRxHxNw1Buvq6b4UW0IxiguW0/SsYKudmLpz1Jl3WlFK3w71x8UsLkLfXTzpl
         n1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OGqKjKe8jIH+0KF4Jes+F+0KTLQ0HJ7sC6v/AuGb4XA=;
        b=C5tfRF6MYvxf3SuvaConsYFKBa/44U4qsg+c7o8r9G60UoCQmpsTcZLxUyVgXKXTIU
         K4nfvvamJ3+HcOy+6loffL7tksqhYEssDI8VEgCKieiG6qBBz9C/dRJGPAFlSsCqLlpF
         4lACJMHAmbgy7JEfBm5PxQzWl5rJzGBPOWndFQOeR4ZPO0VTZJ4rozwXBVXRQwOvYwWO
         pxFtObMjPS6WW7/BkzsZRU1lCzzgZiZRIpB2CkAzlhC8e2FuR/f6fOrUGtZQAfd4AfdT
         Y192FJ70A3uQAcO0Twz2MIVMVMmAOERbmQQ/Px0KNzAaQip9XFUey6dIt2eH+WZFeRkz
         2ZCw==
X-Gm-Message-State: AOAM532s8ycgH15gX8+yJDbTcE9RwXxJlQz/WSd6Xtxu3AR9NfyThgvq
        4J8maR8PXT7eIPX6rMv3oxZg/jpfeSRpiA==
X-Google-Smtp-Source: ABdhPJwhPq+xkM6O7l1uwCLL1EVRElqVmBIA9+QdXL0oeNK4AvgfUM8CLYjPMj3TcAJyab5ssIJlTg==
X-Received: by 2002:a17:90b:3cd:: with SMTP id go13mr1957421pjb.148.1617673655439;
        Mon, 05 Apr 2021 18:47:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm15768852pfg.69.2021.04.05.18.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 18:47:35 -0700 (PDT)
Message-ID: <606bbdb7.1c69fb81.7d32b.9721@mx.google.com>
Date:   Mon, 05 Apr 2021 18:47:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.228-53-g9d1c6513551e6
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 84 runs,
 5 regressions (v4.14.228-53-g9d1c6513551e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 84 runs, 5 regressions (v4.14.228-53-g9d1c=
6513551e6)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

qemu_i386            | i386 | lab-broonie     | gcc-8    | i386_defconfig  =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.228-53-g9d1c6513551e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.228-53-g9d1c6513551e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9d1c6513551e6928da195e22c6b32ed0adf42593 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b8362d99e169680dac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b8362d99e169680dac=
6be
        failing since 142 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b8366b794d653f9dac6dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b8366b794d653f9dac=
6de
        failing since 142 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b82f4e7578601aedac6b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b82f4e7578601aedac=
6b8
        failing since 142 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606b82fde7578601aedac6c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b82fde7578601aedac=
6c1
        failing since 142 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_i386            | i386 | lab-broonie     | gcc-8    | i386_defconfig  =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/606b80bee5d51abf19dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i3=
86.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
28-53-g9d1c6513551e6/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i3=
86.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606b80bee5d51abf19dac=
6b2
        new failure (last pass: v4.14.228) =

 =20
