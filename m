Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4473C1BE5
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 01:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhGHXVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 19:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhGHXVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Jul 2021 19:21:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8B5C061760
        for <stable@vger.kernel.org>; Thu,  8 Jul 2021 16:18:41 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b12so1130346plh.10
        for <stable@vger.kernel.org>; Thu, 08 Jul 2021 16:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7o6VXs8ZvjOmaaa6swfTT1yHp7dYRTZYFv/dmJLbucY=;
        b=OnGI6ZqBbY4w7cByGqa6YWcpX/Jh+v78fr6tS0f8Tkeqaom9ph67u/aqSm72PwqC+Y
         vQpydiZmUxg0ik90JxjZsETNl+RggBWm1vrV9D96wSJKUY7fzKbG819Fjgo9H74SkL0l
         nzzZO2gB2s4fsrytA8zBltgRzSCZcgIM6cJsuM5tfeWlUzLTfdDQ9uUUwQ4IrMTyYhjn
         TxWbQBVkjM9pDTfdm6x6LJOL1HAFuPVWVJH/r8eFgTD1J//LTUzOJmfdeb0GKUpuEo1T
         YQoUF5wvlDZXJm5uO3eYC1oKwHExbory+IE+bnkUjgAQOgSz1ouX+o0a4HD5AK+41fdH
         o37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7o6VXs8ZvjOmaaa6swfTT1yHp7dYRTZYFv/dmJLbucY=;
        b=qrgw2PaoWcB2pkdaQyT4LAhMzswSdBoDIeGubjT50Xs/6D+6CulE6L2EWrKSc/zQuS
         +8mx+1kguCl9NPLZzhlUYzr5D7P6aDr21JQ/UrYK927f+ygPmcoRX0aukOMAueZc+jfe
         yJSOPpxEuDFbGtYY4QPqybT+dyJ+3gxzQbtYj/01qlam8DhsAm/YYECJ7lCVfu/2K0Dd
         VngwFXmf/DH3u8oNIXKsDT+ELJ55yr/yirIbNQ0FftFHgZmGNQxo59nCn7u95BJyuCHn
         xR7QrP6aX21T+VD4O2bF3iEZre9GSPKZGkijaIUaSEdRLgstAiWphLNprihychLGZuqt
         6gVw==
X-Gm-Message-State: AOAM531Wq/mwKQT+5t4tgTkgh4mbe4zLyidQXAEMWr1Pi2wAH7LBu1LU
        qh2zRqJaC+SpNLA0Qh7YiUR1uhZ4dZ/4nBfj
X-Google-Smtp-Source: ABdhPJz1ZONUumtkpySgohmkeBAc/xCcAwwMGtlTERQY+DUZ2xHknMelreyJORYkuNIw1u3SDIwuRA==
X-Received: by 2002:a17:902:8505:b029:129:c61e:e335 with SMTP id bj5-20020a1709028505b0290129c61ee335mr8447550plb.60.1625786320648;
        Thu, 08 Jul 2021 16:18:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fv8sm3621275pjb.21.2021.07.08.16.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 16:18:40 -0700 (PDT)
Message-ID: <60e787d0.1c69fb81.1c666.bb09@mx.google.com>
Date:   Thu, 08 Jul 2021 16:18:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.196
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 197 runs, 9 regressions (v4.19.196)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 197 runs, 9 regressions (v4.19.196)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
odroid-xu3           | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =

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
nel/v4.19.196/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.196
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f84340f012ee60c12aacc03662bcdd67419a31a =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
odroid-xu3           | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60dd75d548d2712c1d23bbbd

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-odroid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60dd75d548d2712=
c1d23bbc3
        new failure (last pass: v4.19.196-25-g7bbc9654862c)
        1 lines

    2021-07-08T21:24:17.622223  kern  :emerg : Disabling IRQ #158
    2021-07-08T21:24:17.645559  <8>[   19.342757] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-07-08T21:24:17.646030  + set +x
    2021-07-08T21:24:17.646280  <8>[   19.351359] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 4160148_1.5.2.4.1>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcb2ca226fce9cb623bbc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb2ca226fce9cb623b=
bca
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcbd9829f969e7f423bbd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcbd9829f969e7f423b=
bda
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcb2e669bb28def823bbd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb2e669bb28def823b=
bd4
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc011281b885fc223bbd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc011281b885fc223b=
bd7
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dd33c24a21263c9423bbfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatil=
epb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dd33c24a21263c9423b=
bfb
        failing since 224 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/60dd6c178846d7188923bbc9

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
96/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60dd6c178846d7188923bbdd
        failing since 16 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-08T21:31:51.377430  /lava-4160152/1/../bin/lava-test-case
    2021-07-08T21:31:51.394557  <8>[   18.440801] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-08T21:31:51.395004  /lava-4160152/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60dd6c178846d7188923bbf6
        failing since 16 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-08T21:31:48.935305  /lava-4160152/1/../bin/lava-test-case
    2021-07-08T21:31:48.953968  <8>[   15.999155] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-08T21:31:48.954723  /lava-4160152/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60dd6c178846d7188923bbf7
        failing since 16 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-07-08T21:31:47.922509  /lava-4160152/1/../bin/lava-test-case<8>[  =
 14.980013] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-08T21:31:47.922882     =

 =20
