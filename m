Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE24361137
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 19:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhDORkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 13:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbhDORkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 13:40:24 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C74C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:40:01 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id z16so17386741pga.1
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YQuOKOsUgq2fleqy4OEoeLzEVKE/knSEyvGx+ap3Z6A=;
        b=hJ+kBaRvmIi2o8pj7gDF70O6Jrs54O7deXa9VjnBZ6Ct5HwTcZ+IXSR9ZDDW8JwM3/
         OnDh09acVGEM19nnUHJo67gXrVMC0lQhfojou8rV1XT6SOoxY/qelzyu6RUNGCLFy8WW
         7L0EHCCYtslyxS7vqoVmTKx2DHe3rxDQPm8VImNOzcT3uOuQswmmCIF1Q763GRwzvhjK
         nVFJ6o8O3/4kBVhXJ9Ev8nQiGIFKQNnF0sGQXxlI1IiRAB4uOY22OXxmuXxHZyZOQleH
         2+xp4CRFoFMbIQxHqTl7pfFB8Ylejbx1sEeN9hBCPXtVvxybD6oDnWFSX1VOaKBKrKgR
         dOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YQuOKOsUgq2fleqy4OEoeLzEVKE/knSEyvGx+ap3Z6A=;
        b=OMJ1YeZDBzkuJGFN+1U+cozCq9vtwARCm5j7c3bxNJrWnuM1OHkZ85KmmmTW03J6Ew
         IP9gtc12RvDdgyG98QDFmvlsg8ceB5vFtFU3NFPgu5WJG/zCZX4fOmacg5UXp+8Yn4/2
         kYgQWtET1KMFwpDyDKT8YpbiyJYUkoRy5ITmxFAnVYjJ0BA11MzgWdetP1PvO755rctV
         Lbp5xqXDLwX9cy70fMM9uN/lBllxXWBA406GUpvWH2QebcwTfSe0s0PD9MDSrAZKZ9uT
         8+dKrUqQUiu+eHG0MAdUetQLawBiTukBD3JIshM5XCsFNF69JoDYIjz5f0Fdoj+vpAaL
         E6PA==
X-Gm-Message-State: AOAM530nEscf6/7RLW+b1xygIdV7cqLBDoZvhExMHMFiMoEixa7Kj5Su
        locFczYHlJWEMwgmQn2cLh4M89nVwcRAUswX
X-Google-Smtp-Source: ABdhPJz0xqJ7/hLuF6owdcmqWguKKY/05X58GuijYd8SeTDS0uZA3fkuM8Qc25Q9QwjAqZixMO4cKQ==
X-Received: by 2002:a63:a64:: with SMTP id z36mr4422569pgk.342.1618508400589;
        Thu, 15 Apr 2021 10:40:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s13sm2937022pjl.48.2021.04.15.10.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 10:40:00 -0700 (PDT)
Message-ID: <60787a70.1c69fb81.fab2b.8244@mx.google.com>
Date:   Thu, 15 Apr 2021 10:40:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.30-20-gb2ce1496b0e5b
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 5 regressions (v5.10.30-20-gb2ce1496b0e5b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 165 runs, 5 regressions (v5.10.30-20-gb2ce14=
96b0e5b)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
  | 1          =

imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =

meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 2          =

tegra124-nyan-big    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.30-20-gb2ce1496b0e5b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.30-20-gb2ce1496b0e5b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b2ce1496b0e5bf919b38a6743014c7caa89fd6a0 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/607846ef89a5a5f40cdac6e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607846ef89a5a5f40cdac=
6e3
        new failure (last pass: v5.10.30-20-g6723c3f2e871e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
imx8mp-evk           | arm64 | lab-nxp       | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6078490cbe708b9058dac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6078490cbe708b9058dac=
6ca
        failing since 3 days (last pass: v5.10.29-90-g9311ebab1b30e, first =
fail: v5.10.29-93-g05a9d4973d3b9) =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
meson-g12b-odroid-n2 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
  | 2          =


  Details:     https://kernelci.org/test/plan/id/6078470b5f2c89c371dac729

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6078470b5f2c89c=
371dac72d
        new failure (last pass: v5.10.30-20-g6723c3f2e871e)
        11 lines =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6078470b5f2c89c=
371dac72e
        new failure (last pass: v5.10.30-20-g6723c3f2e871e)
        2 lines

    2021-04-15 14:00:18.663000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2021-04-15 14:00:18.663000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-04-15 14:00:18.664000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-04-15 14:00:18.664000+00:00  ke<r8n> [  : a l1e6r.t3 50274] <LAVA_=
SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMEN=
T=3D2>
    2021-04-15 14:00:18.664000+00:00  : Data abo<8>[   16.358885] <LAVA_SIG=
NAL_ENDRUN 0_dmesg 99990_1.5.2.4.1>
    2021-04-15 14:00:18.664000+00:00  rt info:
    2021-04-15 14:00:18.664000+00:00  kern  :alert :   ISV =3D 0, ISS =3D 0=
x00000006
    2021-04-15 14:00:18.665000+00:00  kern  :alert :   CM =3D 0, WnR =3D 0 =
  =

 =



platform             | arch  | lab           | compiler | defconfig        =
  | regressions
---------------------+-------+---------------+----------+------------------=
--+------------
tegra124-nyan-big    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6078682db71d42396fdac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra=
124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-gb2ce1496b0e5b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-tegra=
124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6078682db71d42396fdac=
6c3
        new failure (last pass: v5.10.30-20-g6723c3f2e871e) =

 =20
