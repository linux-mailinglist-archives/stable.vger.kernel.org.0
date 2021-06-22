Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4B83B02CD
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 13:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhFVLch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 07:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhFVLch (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 07:32:37 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897FAC061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:30:21 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l11so7572345pji.5
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 04:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hSF6cMnWg/U6pHmieNi6MGnq+EpuHBzzsuD4BU3q2Fk=;
        b=I5vTeEaL18sofJ4P14ZwBHeaJnE5RQ3mPAATemgeN3WXM/5w65pQfsXNaOoaUEkuHB
         uAFftJxFH4B3q22YcXyVlvydsRttPXT65lqSyGx8dR4VMKHIscHfvj8ho+4tM9KH//0l
         ZxEt396kvZRrTlfqjT8h93X5PJZHQPl3XubWRKqAmOIjAGtq2CQednPZJoZ0gK1Zza2B
         H5tJz6BtYnrVoRGIGr0lb0PPGWj7y7UOO/QVk3jHHsI/0iZnC6qfn0Jhl2JPEyvlqcRP
         pKr4a/4wbgAqFVOV6TAzSG/GJ0I7P6hgzzy2lpUJLQs9MT+L3F3Ku3m5p1nRHbjLztGn
         wlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hSF6cMnWg/U6pHmieNi6MGnq+EpuHBzzsuD4BU3q2Fk=;
        b=i0hMARlvJbDMh2m+ka8hURqrS63FQS7f9ywbaBwEHaHp2Sw0KxVzF/SrSWSimtLV82
         84ULCQJFgx+KXdOaBbqrq7Y6Mh7eqkUs5rvhaCi5+Rb/2pjIyLD3FbEmk6AFB/BIcDi5
         aRtxB8NrhS0Xqn+MthYUUVje69qM+GUqfhUIxw5q+IzAJUuCwUrvctvxa8YIwxr5o2Ei
         1Zee49e1sOLqHFdvJVEv2Zscglk0m3WmXFLyQJa/HeUsLyzPMFVV4OdQjy2MxzfP3aO+
         yUghfEUr4352y70vu6MdXto9Br+f50cQ2xjm9xHO1HhILTAFR2FQNKIOjcWfyGz/U1R9
         eZVg==
X-Gm-Message-State: AOAM531nDnkO355Le6coMl/DMMBpHziDiY5AOmprXKXthziMShICYjk7
        EWJ2FJTN2fTkYduN70xZYKPqOGFXQZ6AaQ==
X-Google-Smtp-Source: ABdhPJwZoV91D/fxBLJoLTYUMxz19AsF/N6EOS10n+Rpu4tgKp3hC31Lmvh56p4+5NnqFkX8srAm8w==
X-Received: by 2002:a17:902:8207:b029:124:4f60:740e with SMTP id x7-20020a1709028207b02901244f60740emr10887483pln.56.1624361420912;
        Tue, 22 Jun 2021 04:30:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t6sm2150947pjo.4.2021.06.22.04.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 04:30:20 -0700 (PDT)
Message-ID: <60d1c9cc.1c69fb81.9369d.5bf8@mx.google.com>
Date:   Tue, 22 Jun 2021 04:30:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-62-gaeca90c0be32
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 147 runs,
 12 regressions (v4.14.237-62-gaeca90c0be32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 147 runs, 12 regressions (v4.14.237-62-gae=
ca90c0be32)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
fsl-ls2088a-rdb      | arm64  | lab-nxp         | gcc-8    | defconfig     =
               | 1          =

meson-gxbb-p200      | arm64  | lab-baylibre    | gcc-8    | defconfig     =
               | 1          =

meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
               | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =

rk3288-veyron-jaq    | arm    | lab-collabora   | gcc-8    | multi_v7_defco=
nfig           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.237-62-gaeca90c0be32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.237-62-gaeca90c0be32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aeca90c0be32ea6b4cd7d2adf1fd9862ad013524 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
fsl-ls2088a-rdb      | arm64  | lab-nxp         | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60d1a86dd35d3a0d20413291

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d1a86dd35d3a0d20413=
292
        new failure (last pass: v4.14.237) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
meson-gxbb-p200      | arm64  | lab-baylibre    | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60d1962596c8dd264d413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d1962596c8dd264d413=
267
        failing since 447 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
meson-gxm-q200       | arm64  | lab-baylibre    | gcc-8    | defconfig     =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/60d197dc3317c850a2413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d197dc3317c850a2413=
26a
        failing since 88 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60d19613567352f4a44132a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d19613567352f4a4413=
2a8
        failing since 219 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60d196f0536d3b59324132fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d196f0536d3b5932413=
2ff
        failing since 219 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60d1962a4fd45668a0413268

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d1962a4fd45668a0413=
269
        failing since 219 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60d196b8624282d8bb413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d196b8624282d8bb413=
286
        failing since 219 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60d196ac1cc2df277641328c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-=
qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d196ac1cc2df2776413=
28d
        failing since 219 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60d194aba387c8ba3741326d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-brooni=
e/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d194aba387c8ba37413=
26e
        new failure (last pass: v4.14.237) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
rk3288-veyron-jaq    | arm    | lab-collabora   | gcc-8    | multi_v7_defco=
nfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60d19e3062331ee3504132fe

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37-62-gaeca90c0be32/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d19e3062331ee35041331a
        failing since 7 days (last pass: v4.14.236, first fail: v4.14.236-5=
0-g2e03cf25d5d0)

    2021-06-22T08:24:09.166153  /lava-4070814/1/../bin/lava-test-case
    2021-06-22T08:24:09.172081  [   13.015880] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d19e3062331ee35041331b
        failing since 7 days (last pass: v4.14.236, first fail: v4.14.236-5=
0-g2e03cf25d5d0)

    2021-06-22T08:24:10.185851  /lava-4070814/1/../bin/lava-test-case
    2021-06-22T08:24:10.202528  [   14.034561] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d19e3162331ee350413334
        failing since 7 days (last pass: v4.14.236, first fail: v4.14.236-5=
0-g2e03cf25d5d0)

    2021-06-22T08:24:12.617009  /lava-4070814/1/../bin/lava-test-case
    2021-06-22T08:24:12.634154  [   16.466037] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-22T08:24:12.634640  /lava-4070814/1/../bin/lava-test-case   =

 =20
