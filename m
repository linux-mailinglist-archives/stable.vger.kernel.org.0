Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AA6406E8B
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 17:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbhIJP5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 11:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhIJP5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 11:57:19 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8226C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 08:56:07 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 5so1419795plo.5
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 08:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IgdVTh1HPuSZdJ7pv56nKHAw4T1JDAeMdmWmACwmzhU=;
        b=kKATvd2Wl+0aTXnnuSiCeiKu3uwO+j0z1G2r7fF8DycQgERCQMh5eIQjyog9rqYs0Q
         fHbO5AInbQCKyVysIyeRYsv55udKPV5RVGWiwO5kE/0IP9mII4WNSF4VCUlborb92l4P
         tgZwVTb4ztT3ZrI89bHdUfsrWmp+4zpQEUdPxxJsWvJuh6+TVrypwhH6R5AJxxf8F6HR
         BXvMDZCZJJcR2oJ4MJDjMJEiY3QGEdx9zLyhPjKPjCuCVDvte6hmDclUv4d/MlFKJ6dY
         MWl480/uhf8QHhtNLhTDuysugtx1oyungKvJmTKQcpwPHgATXcd3sfH9Bj9N9xt4l/+2
         OBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IgdVTh1HPuSZdJ7pv56nKHAw4T1JDAeMdmWmACwmzhU=;
        b=4Tfyf03Zpoejx4ILjW4lQ7eNe7bImLSszeam3OQHm+pZuLNDzQu0dwnE1b4/7Gn8Aa
         xFiaq3Ygdrwin+se3bjRglwTQAffBEPhwLfUUAvCfyPXAuHPa8PGPUnyp+0UAUxbsaWG
         WDkDgCcQLzlpdWvWy0B8JUFKORDyj+kza8Z0zMCz9G/tu2uQA3U02F3j9Cn5dd9begXh
         FZBwj0unhlTGymp8UmabSXY2iiVdAjkue2/f+FwzE9p9/cOkeVHO+FrBnUpc4l4UrtBG
         qDEEcv0xtQHLPVlF5r9Lh48kER0WZCx3CWz0lbtVC63eveqNlDmRkS1HcjqtPp/9r6nc
         1OXQ==
X-Gm-Message-State: AOAM530h5+CNPXr8uR0zqu0gUpxCe8nu5sD12imu6NiF/2WzFTiqXGLH
        GHCNBgWGPHB0Goj5IEh0w5Cy44scgdmUs1FV
X-Google-Smtp-Source: ABdhPJzQLWmqNcufi3vNOXeQrit78DfAdFioz1yGmS+Qb06rwo9E7vXW1O252FkenJYhnEU5p4lI3Q==
X-Received: by 2002:a17:90b:8ca:: with SMTP id ds10mr9841756pjb.68.1631289367273;
        Fri, 10 Sep 2021 08:56:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm5818880pgd.56.2021.09.10.08.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 08:56:06 -0700 (PDT)
Message-ID: <613b8016.1c69fb81.fd871.0bf7@mx.google.com>
Date:   Fri, 10 Sep 2021 08:56:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.206-32-g8485fb0f54ee
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 163 runs,
 6 regressions (v4.19.206-32-g8485fb0f54ee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 163 runs, 6 regressions (v4.19.206-32-g848=
5fb0f54ee)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.206-32-g8485fb0f54ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.206-32-g8485fb0f54ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8485fb0f54eec58723555ba8b20f1074d7a06553 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b4f59f157a14e70d5967d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b4f59f157a14e70d59=
67e
        failing since 296 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b4fecf3ff79b3a0d5967a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b4fecf3ff79b3a0d59=
67b
        failing since 296 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613b528250b227a425d59693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b528250b227a425d59=
694
        failing since 296 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/613b661d07bb42d1e4d59669

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-32-g8485fb0f54ee/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613b661d07bb42d1e4d5967d
        failing since 87 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-10T14:05:00.066178  /lava-4490945/1/../bin/lava-test-case
    2021-09-10T14:05:00.082196  <8>[   18.918621] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-10T14:05:00.082649  /lava-4490945/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613b661d07bb42d1e4d59695
        failing since 87 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-10T14:04:57.616292  /lava-4490945/1/../bin/lava-test-case
    2021-09-10T14:04:57.626096  <8>[   16.477504] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613b661d07bb42d1e4d59696
        failing since 87 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-10T14:04:56.605113  /lava-4490945/1/../bin/lava-test-case
    2021-09-10T14:04:56.610437  <8>[   15.458194] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
