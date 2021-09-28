Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDEB41B321
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241667AbhI1PnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241080AbhI1PnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:43:19 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC959C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:41:39 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t4so14522781plo.0
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n4jDU9w63IbIMPh6g7JQQDaKzGP3LqBW9agcSU/g3r0=;
        b=LE35SfEsXEof2dw6R+L+cKLhUjwevW8CuhVonk835dj9Z6Yq4Eh1EZ8B0IUJlokZMH
         g+GMq7hOxVU4bsNlrlK6d1RMPsE/HT5sHr/UuzS+YQgOGJ95/WfgI12x0pP75FCkXTYT
         6Res8ff4xokleCwxcBE+JwoJGDccb0XaVJgEaoXiP+dQsQc7bsR7o6W7aq+VFDdLl6d+
         zQd96uEleFY6/7nMjWT2x/D8HJ5GudxBe4k0nqDa+AMmmWLZTPkCErOHOfPvUiXi12Sx
         XlwcH5qouLlCCDXVLz0YDCB26SaJDzjv8ABNc884tl8fyyD55jKQHlra/GBavRBVAmZ3
         DLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n4jDU9w63IbIMPh6g7JQQDaKzGP3LqBW9agcSU/g3r0=;
        b=fdUAJvMj0Vlg6Tt5HRxNvjf1f0Q1U813TvufygMdyefAWiiUntZfgGUKBM4C2hGFnq
         q1VZkAkgjqWoSl5el96X5lExPAeLh4n0Z4ncyQlmk9m+QhexT0Gw5919vYDJdCkiatpp
         rITY0CEtFF4Z3RQ+2ZUIK/218P0MGGpyIjIeKlc/ZdvnPQQLWBlImyq3dGe9SPHKnS4A
         Ueo6+W5Sw7ElBjzGMD/d0rlEhTTulJlcg2intNFBGDZfpJNkToGV55mm6h9LdvNZnUrf
         O5oJ1G6i7frUIqLxXDLlfZfSAIVsshhgeIfGv4sf7sxwMsS33vtwvYhpiBKH7VB3PwOr
         PV/Q==
X-Gm-Message-State: AOAM530a/9Lt6y1mlrViT6h8YClXJvL6mR0pSOqTDwg+ZwdRUXML5OVP
        c03WRfMa0anGdZ+AR3IXA/u4ORQ+kHZ9gL4G
X-Google-Smtp-Source: ABdhPJz55QYn78Ct4NUz2Mif9KCrmMxkF8F4MfVDts+5ikjWijj6ts4XRH3NlHQq+T1ytEpaH/IXFw==
X-Received: by 2002:a17:90a:67c1:: with SMTP id g1mr567187pjm.177.1632843699160;
        Tue, 28 Sep 2021 08:41:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm3059581pji.6.2021.09.28.08.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 08:41:38 -0700 (PDT)
Message-ID: <615337b2.1c69fb81.5ca2c.9ba6@mx.google.com>
Date:   Tue, 28 Sep 2021 08:41:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-56-g99d9199153a6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 150 runs,
 7 regressions (v4.19.208-56-g99d9199153a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 150 runs, 7 regressions (v4.19.208-56-g99d=
9199153a6)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.208-56-g99d9199153a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.208-56-g99d9199153a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99d9199153a638f0f48a662191d7ef39af5bd87a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6152fd72cd590e954499a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152fd72cd590e954499a=
2ee
        failing since 314 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615300775a0ce5b1ec99a31b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615300775a0ce5b1ec99a=
31c
        failing since 314 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6152fd834f0771fc4299a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152fd834f0771fc4299a=
2db
        failing since 314 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6152fde2aa16e3788f99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152fde2aa16e3788f99a=
2e8
        failing since 314 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/615314d0f3c32eff0a99a2da

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
08-56-g99d9199153a6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615314d1f3c32eff0a99a2ee
        failing since 105 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-28T13:12:38.680123  /lava-4593364/1/../bin/lava-test-case<8>[  =
 17.585112] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-28T13:12:38.680628     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615314d1f3c32eff0a99a307
        failing since 105 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-28T13:12:36.233360  /lava-4593364/1/../bin/lava-test-case
    2021-09-28T13:12:36.250475  <8>[   15.143645] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-28T13:12:36.250973  /lava-4593364/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615314d1f3c32eff0a99a31d
        failing since 105 days (last pass: v4.19.194, first fail: v4.19.194=
-68-g3c1f7bd17074)

    2021-09-28T13:12:35.212764  /lava-4593364/1/../bin/lava-test-case
    2021-09-28T13:12:35.219004  <8>[   14.124256] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
