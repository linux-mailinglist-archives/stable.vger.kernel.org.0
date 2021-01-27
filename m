Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3289E306194
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 18:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhA0RIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 12:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbhA0RHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 12:07:31 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC2AC06174A
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 09:06:50 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q131so1578016pfq.10
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 09:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c/iapjcyowuL7uRO04WAgB+m/7WgvBohDgBc70Yagzk=;
        b=eCyb/Hdwx5V6/+Ltj2JJlIiJs00aseHEDeBpgrYj9+iv4lCRkV5T1KLWcqqr4CuiNV
         YNnuqRNPo8ZmtgEYeYD0+cyB2L6LP16UOS7AgTrxontlC0eZ9YooQRh2wXiRY+zdxfRq
         EaHEpxBOkJpeaBq2t2PeVws7rZTsLkXZb6tkiCfz9upzfw9O5PaLOeLIUAxK+lbSGI9M
         IBJ1FJP7KEuYsvfxz/qG9mYNlFsijw/qyYB9sByF2dr9YUx445QgV2DVztCJFRJlkyUW
         gdzwBtNuiHDoHcI8Z+bf+NjEqYcs4aifozBeQU5ZDiIiX4AmdivEhkMFv30qsDdN44CJ
         Uhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c/iapjcyowuL7uRO04WAgB+m/7WgvBohDgBc70Yagzk=;
        b=WuyVDTuQ5X1V0WmMCLwkLIz7O1Atv/UtOBSib5CpGGW9AdkOMJUHEW51OFaICW65OM
         VZ9uyloi7flYuHY2+9T4POL/Fk6xROh9FvS6dEyP7gbW7OWMkrBO3JZKolTMjqyJIMaa
         DiJs9awId/WxRzgh3C1385JlQC9TKjFrDgmhFzxpKIc1Xk0laRs87LliUXTB0FMYSe4f
         Jg52v04m8BoHCTDrJPnLqgmHHkh7zoZoyUzrqzKC46FqOS8dZMCRHhTbPt4M7f0PI95J
         yzm6RTK3NFiOXtkCSNh2qtcHr81oHpbLE+viIauL0Drxd5oi1CTUTkdprcYu7wwSlHcO
         oGDw==
X-Gm-Message-State: AOAM532TTDjZyFDHh/RaLd5qZ9mUv+iBQeTF/EiJRpZFRnfaV3Q0Wbn1
        z/YGH9SK0NpmyDIEUkBF4Vfg/DMwNIi5izTg
X-Google-Smtp-Source: ABdhPJx/N4hl66XahJjvBDeS+u+bLxJJzkD9+LLc1UlY4mTZ4tMKv2ntBoKLegHAahVCtos7BlIZOg==
X-Received: by 2002:a62:1995:0:b029:1c0:c4d8:adcb with SMTP id 143-20020a6219950000b02901c0c4d8adcbmr11611623pfz.60.1611767209749;
        Wed, 27 Jan 2021 09:06:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y22sm3061214pfr.163.2021.01.27.09.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 09:06:48 -0800 (PST)
Message-ID: <60119da8.1c69fb81.da2a0.7084@mx.google.com>
Date:   Wed, 27 Jan 2021 09:06:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.217-36-g4f8c1a1df3d6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 133 runs,
 5 regressions (v4.14.217-36-g4f8c1a1df3d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 133 runs, 5 regressions (v4.14.217-36-g4f8c1=
a1df3d6)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.217-36-g4f8c1a1df3d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.217-36-g4f8c1a1df3d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f8c1a1df3d61d8aa22d1341ce4f4ca62ef089ee =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60116e2339f0b1d560d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60116e2339f0b1d560d3d=
fca
        failing since 50 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60116bc04a8975bdffd3dfef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60116bc04a8975bdffd3d=
ff0
        failing since 74 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60116c060e99a9753cd3dfdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60116c060e99a9753cd3d=
fde
        failing since 74 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60116beabbabe44e80d3dfe4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60116beabbabe44e80d3d=
fe5
        failing since 74 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60116bb74a8975bdffd3dfd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.217=
-36-g4f8c1a1df3d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60116bb74a8975bdffd3d=
fd8
        failing since 74 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
