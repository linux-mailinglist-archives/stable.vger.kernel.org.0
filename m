Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8145C3E8A19
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 08:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhHKGNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 02:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhHKGNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 02:13:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028EFC061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 23:12:48 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d1so1334745pll.1
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 23:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DdYlFBYEXncmZeZBYa1Pz2EJC4O3h+Gct+CsjZFjve4=;
        b=Ca/pqdVKTbMrIoCrUn84b+Mlqy5NaaTl6toRVWtxw2zUA/u7kxNFcX+JBB/rXzGUD7
         iLFSvucDLmR4MrcvWHApjDHUuPuiIURL04nua2Lpi1pJ8uiD0pQfLmfWthZZVtcGIW58
         RDS37AsIrR7JBkVycbyxogMZ/NXw7bCGqeCnaS4E/VKeahDIIsZeo8fBz/ztXw9TcEJk
         fHjpwYdwjhiexaNZjACfhoWhpwqd3Ywp/rPpL6+7yOLEqmmVUD/7QsiH3ANWrJqCEZQq
         Igv+Auvjmk9h3dcpTQyLhhrYF6B+5HdMENz5yWEJBxhbrlq0ZZPc/l3yPWSDEf0YfC5R
         heVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DdYlFBYEXncmZeZBYa1Pz2EJC4O3h+Gct+CsjZFjve4=;
        b=KvzRiDpdqP/PN02Xo28KgQe1DRSQ7j6kxtsfZu+qNlwgssqH+ifbTSnAgVPQX/QWnm
         HOaMKHCt/xisL6cGut59fACJDIooxAnuLcA1FZqc+j4NyXP4tDDC5JI+n+wJ/R/4mfvL
         /Rq2qQG06HmNpTqGGghgBC95vEv1DRjGTHdrQi8ux/mEF2lUAjq0WBXkCa+prmLv0Vgd
         zzTVFfF25iCt4G3yJhZD7z0PzoKwZK6olK8pJUpWImAj5zw3ReopMMfKg1E6cUXAW9TZ
         8qXTNdcBiCl4r2j+gFXK29EJ1sQZDdMWCq9G1PQ4XwsAck4a4hSjleevrk8hF2alogTP
         nO7Q==
X-Gm-Message-State: AOAM530jKK/EgcKSFlrA/xxseMhPmooxi1aYPmMXzNmsrEp7INetx1AO
        ybcNH2SlFDST1JPQozf3lCMKdkWutE0VGemM
X-Google-Smtp-Source: ABdhPJy2zwP/mZKaAS0gfAIipDx6O8V0tUhhKi00JJV2b8D6WHp6pOOduMfXVTnhDkhUoKmfPzuyaA==
X-Received: by 2002:a63:e841:: with SMTP id a1mr265168pgk.197.1628662367336;
        Tue, 10 Aug 2021 23:12:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm19364504pfm.85.2021.08.10.23.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 23:12:46 -0700 (PDT)
Message-ID: <61136a5e.1c69fb81.409f5.853f@mx.google.com>
Date:   Tue, 10 Aug 2021 23:12:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.202-55-g752ef2004f4b
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 143 runs,
 7 regressions (v4.19.202-55-g752ef2004f4b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 143 runs, 7 regressions (v4.19.202-55-g752=
ef2004f4b)

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

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.202-55-g752ef2004f4b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.202-55-g752ef2004f4b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      752ef2004f4b5225de4a6c8e3275d84e3ccdcba8 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611331226bde3d209fb13698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611331226bde3d209fb13=
699
        failing since 265 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6113311ebb53cb17d6b13692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6113311ebb53cb17d6b13=
693
        failing since 265 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611330cd0686ea5a4fb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611330cd0686ea5a4fb13=
662
        failing since 265 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/611367c62bb863e480b13685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611367c62bb863e480b13=
686
        failing since 265 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/611334033a97f18fb7b1367b

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
02-55-g752ef2004f4b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611334033a97f18fb7b13693
        failing since 56 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-11T02:20:24.039029  /lava-4345809/1/../bin/lava-test-case
    2021-08-11T02:20:24.056539  <8>[   18.487123] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-11T02:20:24.057000  /lava-4345809/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611334033a97f18fb7b136ac
        failing since 56 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-11T02:20:21.598653  /lava-4345809/1/../bin/lava-test-case
    2021-08-11T02:20:21.615492  <8>[   16.047061] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-11T02:20:21.615951  /lava-4345809/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611334033a97f18fb7b136ad
        failing since 56 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-08-11T02:20:20.579406  /lava-4345809/1/../bin/lava-test-case
    2021-08-11T02:20:20.584551  <8>[   15.027836] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
