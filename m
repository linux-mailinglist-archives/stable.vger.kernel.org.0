Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059B32DF0F4
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 19:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgLSSI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 13:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgLSSI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 13:08:56 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D0FC0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:08:16 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z12so3181136pjn.1
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 10:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+o/XO+JHKbdi1l4LEKGKIKZRvpOOV3A5nwIWx4ctTPs=;
        b=Qyp3ZKgIQ612w1ddGkN46jOEmJGO7zJc4uErRfEdc7MKw2Y8oePno6Y1NP/Fz4wpQr
         5s2rmvbrAvU079hFfPtuqQ6Nwhd/7X0JqRxrDAAqLwZVLUMOKz86NzHGwHi/M4/4/lTc
         0pVW1tPP0GGP0l+9mGIzfRaqwIC2cyh/tP/qmMPNcRxLtqx4OqOhLRqZ3/h24lO3AnRs
         EvtjAMvslbaVQL0ENRm4y/kfoRXFzz6ZErlpS5PXy4bUt+fsCrLFXG5lQZr9UfCDIth/
         wkJveD0USkDwIveXWgIl1G5tUegDRr+zESEpueYx9Sf6Z2FYiJQlZmXj7oR/YtZxIdvW
         AxJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+o/XO+JHKbdi1l4LEKGKIKZRvpOOV3A5nwIWx4ctTPs=;
        b=R9vqGhQ1WC/sYAyhVjXX4R9SgQa7uAChGFRgmX+Y6j7WNjrM8Ms9DQjKg6WOs4wRkf
         MHZVgOu8An5ejkdUpeysgyP7di9XVErSdAxWZYT0AlluomcLoBfja4hMWYdmSa7IJmgN
         ax0vrSSh2FnMcVE+Cr2HGQ2Hmwx+malF4b5KSrQELw5R0bjxdIHI5t9N7IzVPCzfM1il
         FBRZFa82+bn1gWPWrJowUmvuCdohSB7gCqLa/cHGEbU8qcS+bjqqqWnV7LcsbFD18DA8
         HBhchZhP+e63kmK2bSfw/qqxe77DDrvMvMhQOmiA08kkfp3KsTQs9/+J72EELwgphOFt
         Ei3w==
X-Gm-Message-State: AOAM532NBRu/daMrW4Y7J0bh91XqANkgh3pL5BRXTbip2p/p4WZrzYUw
        04OP/kraVGKLHwzJy2d40wN8vu37jLguAA==
X-Google-Smtp-Source: ABdhPJwbidiA5rky61Ul/Lpvs9QyxeTOugIlO4r28gSbNBXzo+Qx6IvZXA5e4nWVxSkmGFedwrvSow==
X-Received: by 2002:a17:902:eb03:b029:db:c0d6:5845 with SMTP id l3-20020a170902eb03b02900dbc0d65845mr9713082plb.76.1608401295351;
        Sat, 19 Dec 2020 10:08:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u68sm8922333pfu.195.2020.12.19.10.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 10:08:14 -0800 (PST)
Message-ID: <5fde418e.1c69fb81.c8929.a985@mx.google.com>
Date:   Sat, 19 Dec 2020 10:08:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-35-g3790859de489
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 109 runs,
 6 regressions (v4.14.212-35-g3790859de489)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 109 runs, 6 regressions (v4.14.212-35-g379=
0859de489)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

sun8i-h3-orangepi-pc | arm   | lab-clabbe    | gcc-8    | sunxi_defconfig  =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.212-35-g3790859de489/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.212-35-g3790859de489
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3790859de48957f4a94dcf7bf41f94df2eef9949 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde0e309c65745e27c94d10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde0e309c65745e27c94=
d11
        failing since 263 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde0fd360133ccccec94cce

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fde0fd460133cc=
ccec94cd3
        failing since 17 days (last pass: v4.14.209-51-g07930d77d7ba, first=
 fail: v4.14.210)
        2 lines =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde0cdc7e05be2f69c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde0cdc7e05be2f69c94=
cd5
        failing since 35 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde0cd07e05be2f69c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde0cd07e05be2f69c94=
cba
        failing since 35 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde0c92791e4778b1c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde0c92791e4778b1c94=
cba
        failing since 35 days (last pass: v4.14.206-21-gf1262f26e4d0, first=
 fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
sun8i-h3-orangepi-pc | arm   | lab-clabbe    | gcc-8    | sunxi_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fde10998ff4bf40fec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
12-35-g3790859de489/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fde10998ff4bf40fec94=
cba
        new failure (last pass: v4.14.212-17-gb86870677ee8) =

 =20
