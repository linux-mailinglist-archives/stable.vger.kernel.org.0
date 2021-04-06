Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD6E354CFE
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 08:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbhDFGhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 02:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbhDFGhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 02:37:20 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50D2C06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 23:37:13 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c204so5955993pfc.4
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 23:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fXt4hG9J8oWaVrHryHlbMHRc1Aa8D9AuGMn5nZeXgCA=;
        b=vjwaX1go4Fw0ISNTxph8C0t3iOeLYTuXFrgceBdYWPC4l/+PojG3GT6A1kG7V9JTlu
         Ho80ha1Jem51096mLZXyXNIuKdpcat4w+mrZxgFbNpIW67oBzIdB6TMP0C2CTFZkmot6
         k2X4bbRQHMdFKgftqcl6zTwm4R3h3R73I54Kc7Ekn5eyxHsy6aq9P7a3U+LFgWP9jWM6
         v6qWvcbaMp5xt1ihFlgbn8C3ey9cMVSeZgTvCcjyNkrQjA6vnLHmpGgva7O8AtNHqOJY
         MwBo9/AGxPHjwvbSBFPKELUkkXjJ11px+nt1dXFt8bWRDsKNV6z/39lqP88M0P9qoZCF
         CZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fXt4hG9J8oWaVrHryHlbMHRc1Aa8D9AuGMn5nZeXgCA=;
        b=CsGQ7/aZ1K6ZTRfKTm1+rjMSW7kpAIlZXhxNtoLXya4w//h/ARPO6sFPytLI5uFE/Q
         x+ypMi8685WTPJaXP6WywYbtBpF+86zauZEP4zpdG7GTD9YC8x7ONwIP1hdbpYycT9sA
         Ny4Oq21+4NGmQVFaUC5PrnsRiHTWDuGC/xZYbau2KKxA+xROCmyWiMAyaSDxvZym3B4s
         wHs1jV4v6aboTNUXTSvZudA1ANz165KsK43WcJapvOhC8qn4Mb4knxv2T+9e8/P1i9wM
         fVyDbOmpb1KtT/Atk6mH1Y0NzZBBdm1mN0DJmiWcMF7VMjNYRwIYY8iBIJf5G+vpiiBO
         OjPg==
X-Gm-Message-State: AOAM533p95XDE6GhoLgAhsxbiJExBHu86Rk7ipTwtLrsenaHCjFTYACF
        tKWWmAEXQJdSbJJCVLhs7ehDGZoPS2XAvg==
X-Google-Smtp-Source: ABdhPJzr72uL2vSU1K64yaA/u8xw1VXCcFJQ8Dkt2xb8sdNkzL0zsVENQ1bC7RTSSJ/KTo0qOYD8Cw==
X-Received: by 2002:a63:ba1c:: with SMTP id k28mr16825433pgf.328.1617691033031;
        Mon, 05 Apr 2021 23:37:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j20sm1634831pji.3.2021.04.05.23.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 23:37:12 -0700 (PDT)
Message-ID: <606c0198.1c69fb81.bc5d9.5c68@mx.google.com>
Date:   Mon, 05 Apr 2021 23:37:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.184-57-ge80ef2122d5c0
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 110 runs,
 5 regressions (v4.19.184-57-ge80ef2122d5c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 110 runs, 5 regressions (v4.19.184-57-ge80=
ef2122d5c0)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.184-57-ge80ef2122d5c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.184-57-ge80ef2122d5c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e80ef2122d5c0531670cb281f5beea2cb469aee1 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bc89c3921b1b791dac6d6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/606bc89c3921b1b=
791dac6dd
        new failure (last pass: v4.19.184-40-gea7c9d15cb8d4)
        2 lines

    2021-04-06 02:33:59.314000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/108
    2021-04-06 02:33:59.323000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-04-06 02:33:59.337000+00:00  <8>[   22.744018] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bc9c4c2ed8fd504dac6f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bc9c4c2ed8fd504dac=
6f3
        failing since 138 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bc99ec2ed8fd504dac6c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bc99ec2ed8fd504dac=
6c8
        failing since 138 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bc9d271740bcc59dac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bc9d271740bcc59dac=
6b3
        failing since 138 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606bc94e784e8e23f2dac6ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
84-57-ge80ef2122d5c0/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bc94e784e8e23f2dac=
6ed
        failing since 138 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
