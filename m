Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663B63FE423
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 22:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhIAUg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 16:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhIAUgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 16:36:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29990C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 13:35:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ot2-20020a17090b3b4200b0019127f8ed87so439580pjb.1
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 13:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WIcQ1LdXy/1Sjshh7w76hBnK0n75kPRSO1NT+fzJ8Vg=;
        b=Z1inGmNhq/UecKKWhGzAVFmYNMz1rfo9TXHVp+6a3FJyFJHDF6zJPjl68GSL7bdOks
         5TW1N8DbcvtUycOwARhRoHHosKcS5CMeJkslKMVorslqAC50ui2ndnHtDUdeYMgVdT/D
         YKRhPNzjkScuJXDiO02Ye4K46rQ+r+MS2swMF/wb6c25XU3pMos5SfZqHkYkG4L97jsb
         ATrlCJdwzvo1rVrCYVNVj2Qr1A5Q/UzVlZiVD0rNf/U3aQbJx9BEnIbdmUbOTXdPxd8j
         V2jaTaebgQMXvrK1tS4JU5Qf0a0XXOCQpyIM3LIyFDaCC53+fmxiwppd1wUHuOD/2Pc2
         XCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WIcQ1LdXy/1Sjshh7w76hBnK0n75kPRSO1NT+fzJ8Vg=;
        b=tIfXbtQj1zvu/8/vU3jafx/ewTDnt8Zq3bey8jD1ovlTbcFZCqGAGYMiJdNrW6Qx6h
         ohvrgiLWJBgUeOP/Oejv7GzwDdDd52sjoB5unyfd0lpmBLSOA++fCcixyFnsrsJY7dow
         K7cMDuuIBbwloKYnTlEy+Yj2d0siyZj/PVytTKw907zIpJx2+8j5v6U9TlB8krMa58UT
         41PDFfab8SHWLyb9WFe5brXWePWytgkTkvDsAmK4hWpLOKsZRS453bTXx7jkp7kbJe/i
         +XTnnBIcdR0CvWfU+3enj0xM4InP/Oz60Mms7hb1oeNkJtXo9Q/X2fQiignXG8DYg0jV
         N6Qg==
X-Gm-Message-State: AOAM531gzEUtS6tzBVsVb1FdaN3korwwiEhs6mWuTkofZkZ3sL9qMto1
        xZR5XwGCeA1yN9xfJ7yqwUiSKQrAdEADUD6NXB4=
X-Google-Smtp-Source: ABdhPJytyoUmTnVbNrYP4tNgIVJAvb0kdUN7+K3Hiyh+SIaKAm4fLznXjoCTbji3fSFzO+RagktzaQ==
X-Received: by 2002:a17:90a:cf81:: with SMTP id i1mr1202176pju.76.1630528557485;
        Wed, 01 Sep 2021 13:35:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm566844pgq.0.2021.09.01.13.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:35:57 -0700 (PDT)
Message-ID: <612fe42d.1c69fb81.e1dd5.277b@mx.google.com>
Date:   Wed, 01 Sep 2021 13:35:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.205-34-gfc1fd7aed81d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 173 runs,
 7 regressions (v4.19.205-34-gfc1fd7aed81d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 173 runs, 7 regressions (v4.19.205-34-gfc1=
fd7aed81d)

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
nel/v4.19.205-34-gfc1fd7aed81d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.205-34-gfc1fd7aed81d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc1fd7aed81d18bc92d0e096033e11161cea98aa =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fae18d2e4ea1157d59687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fae18d2e4ea1157d59=
688
        failing since 287 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb48d9f6bed349ad5966f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb48d9f6bed349ad59=
670
        failing since 287 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612faf417323cd734bd5969b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612faf417323cd734bd59=
69c
        failing since 287 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb0ff65cbf1b2dbd59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb0ff65cbf1b2dbd59=
667
        failing since 287 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/612fc7cb51997de1b2d5966e

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-34-gfc1fd7aed81d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/612fc7cb51997de1b2d59682
        failing since 78 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-01T18:34:32.433919  /lava-4429683/1/../bin/lava-test-case
    2021-09-01T18:34:32.451291  <8>[   17.770575] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-01T18:34:32.451572  /lava-4429683/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/612fc7cc51997de1b2d5969a
        failing since 78 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-01T18:34:29.993112  /lava-4429683/1/../bin/lava-test-case
    2021-09-01T18:34:30.010058  <8>[   15.329554] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-01T18:34:30.010315  /lava-4429683/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/612fc7cc51997de1b2d5969b
        failing since 78 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-01T18:34:28.974086  /lava-4429683/1/../bin/lava-test-case
    2021-09-01T18:34:28.979818  <8>[   14.310228] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
