Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61AA3B02BB
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 13:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFVLax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 07:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhFVLaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 07:30:52 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0DCC061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:28:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m15-20020a17090a5a4fb029016f385ffad0so2092864pji.0
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KQh22CYxfuZmv/1D5swfG1RrsPfULSeY0Bs4EeF3IBE=;
        b=NuNTP/Ua6jCDubnpiBKQQA84986GnR7aKrGlr4w2aTRfmJMwbnh/wQH80WA/IH36D9
         bAdFE16jyfyppTNdnGfZ4LTcMSSzh8p0Cwn9Lxzp7ADyyVG9oeu7XJtmJu2jiNMXKOuY
         wJmYaa6uoXpWf+5DsfbzayjthyE+2pZTur16u/psFbjkNaVTeUrYRyqRczEvJWFYUMhs
         ygF2YphEK9XHxhj8D2V6cAvaE61zt2IQ/GFawLgnEAx3hskjXoo6Wq9IOvxLHRbYBraT
         HjMI/fJyoAMxv55pRn85Hx+5A+Pf8WJ0eCa2O0Mze8rW30b5K6x8mFG2EiQgt9mBhRFj
         Kw2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KQh22CYxfuZmv/1D5swfG1RrsPfULSeY0Bs4EeF3IBE=;
        b=X77qVd/Yk5p+He+E9grPeATaPME484N58ho2zIExbVJxX3oJObRMcBBb5tmi7tA0uL
         T8rLVFSIUrScEMs2tlOYxUN0e3IXc7tCUFGZcsVhtQktrKbmbEJEhC4CV417STBgZlFb
         J/bEzbmjs69bcxJIFX/SWvwpN/fFowxSHQ+yWi+ugzkQG2NNombh7jxlyZBu210tJgm8
         yDLLur/WShBEJmDBdqSpvTu2jBCNmfiya2uEZa3HjGNCzBOfkjDmuAGwPCt/bIYsOM5c
         cDRoPU1ercrnnC+VTesrZszIVDaC+Ho0aEkSdU6/ngp70ZadYGjG7YGz3Gg14CpKjXwQ
         FJXA==
X-Gm-Message-State: AOAM5312Z9gxJ+Qfz50js7pCKVN0ss4OlD3EZ/4WSVi7v/IGuGGeM3/e
        7IZm0EeEcHmp/zbRmzUb+2yWSAUvU+CS/w==
X-Google-Smtp-Source: ABdhPJwbPKeF1yFM/nA8fcJ3P1AKlX6Fm95WvmCosFSlWwSMaw6W4N2Q8HVSD1RF37fhyMu6ndLSlQ==
X-Received: by 2002:a17:902:b946:b029:126:cfff:2e4e with SMTP id h6-20020a170902b946b0290126cfff2e4emr2169356pls.30.1624361316227;
        Tue, 22 Jun 2021 04:28:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6sm19349982pfr.99.2021.06.22.04.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 04:28:35 -0700 (PDT)
Message-ID: <60d1c963.1c69fb81.450a1.4636@mx.google.com>
Date:   Tue, 22 Jun 2021 04:28:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-82-g991c57bbcbb8
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 122 runs,
 8 regressions (v4.19.195-82-g991c57bbcbb8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 122 runs, 8 regressions (v4.19.195-82-g991=
c57bbcbb8)

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

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.195-82-g991c57bbcbb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.195-82-g991c57bbcbb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      991c57bbcbb84ec204f64344560922019d6abf41 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d18e6dcabc667351413298

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d18e6dcabc667351413=
299
        failing since 215 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d18e7e5f778cf072413281

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d18e7e5f778cf072413=
282
        failing since 215 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d18e7c5f778cf07241327e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d18e7c5f778cf072413=
27f
        failing since 215 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d18e435b577bd5d2413288

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d18e435b577bd5d2413=
289
        failing since 215 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d19428ddb41ea3b4413293

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d19428ddb41ea3b4413=
294
        failing since 215 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60d19046f1a99fbe2c4132e5

  Results:     63 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
95-82-g991c57bbcbb8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d19046f1a99fbe2c413301
        failing since 7 days (last pass: v4.19.194, first fail: v4.19.194-6=
8-g3c1f7bd17074)

    2021-06-22T07:24:46.795950  /lava-4070498/1/../bin/lava-test-case<8>[  =
 14.287820] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-22T07:24:46.796316     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d19046f1a99fbe2c413302
        failing since 7 days (last pass: v4.19.194, first fail: v4.19.194-6=
8-g3c1f7bd17074)

    2021-06-22T07:24:47.809818  /lava-4070498/1/../bin/lava-test-case
    2021-06-22T07:24:47.827032  <8>[   15.307095] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-22T07:24:47.827388  /lava-4070498/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d19046f1a99fbe2c41331b
        failing since 7 days (last pass: v4.19.194, first fail: v4.19.194-6=
8-g3c1f7bd17074)

    2021-06-22T07:24:50.250733  /lava-4070498/1/../bin/lava-test-case
    2021-06-22T07:24:50.268204  <8>[   17.748343] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-22T07:24:50.268450  /lava-4070498/1/../bin/lava-test-case   =

 =20
