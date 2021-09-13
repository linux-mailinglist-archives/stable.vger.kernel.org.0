Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF4F4099D9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbhIMQrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239652AbhIMQrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 12:47:35 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678CAC061762
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:46:19 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 17so10011327pgp.4
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iYFOPH8xud+kXpHJ39nYzA6VGlPd2iUhlxNFBiFBN+c=;
        b=C6iFjBXEk6H28SzxUmKEFHC06UmvVmzb9uWJvLQPQgqWy2tLchBDFIyg/q3gB5QGOy
         DgIchKgkoo9xdPPVVcvFiUzoXOpV2CimCwcjSuNw7YuCGwreXHt6uuLRoHh1lauVD3W1
         ysrxkE16vxLrCnPqWcZID6YCQoE/6dzT/ebQd3AQakUBNkMs9oc0hA9e5TmFfdd3uPGV
         ruFOnkPDT5/9tJsrx+jQCKKTqMDQMPHFmkRr4keV0CNFRZ85j4YuEoxSM/Y6iQ2SwkGd
         bDTH8rjasYwY9NIiamIH02I3DVPPRGAA6Wx1yIYBks/6062hciElr/NnhXiuUNp2JRvy
         JQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iYFOPH8xud+kXpHJ39nYzA6VGlPd2iUhlxNFBiFBN+c=;
        b=FM/D+61CnGuwdyep8SFHDLztw3Xm6/oVDge21Dnlag1F0KJhskihj1PTIywQ35ETtW
         sG5KqteorI7D29po4VVtrvLOeMcKeONDBWdzzi2sL5beak+SmJgB0SiBt4FhHym8+Yl3
         aUAEHrxDjd9/554mBSkfZwyn3XbjbVCbuTJSbCVolQ/jX5N8nrImQjQ74jKMroMMtmaK
         C4/XDbm0bY9qQMTj6Qb6uI5cCsodHsLxsieQ3HIAJa6mLOUFwlNnC6tkW4C2evc5CWAD
         GLI2nCCldk5tIC+jopAezCROhy9dmHEVQk9Argud9pU+W4Otl5TAuAZjKVesykOmghSl
         BR9w==
X-Gm-Message-State: AOAM530afd1ML5nAnSJ06KW9xbQ5l3m6rgdi4pQN5yPbcc+bjTd+fZCr
        84CO7VLLluWNBrkyqcnC0iG3Nu/x5F+MTYKz
X-Google-Smtp-Source: ABdhPJxKa4DaTgexvd+hBGtg0GY8zvgZXew0EQcRGsEtXkRUGS7GFqpiIEUYHhQ4rkV5t0TjvOWfHw==
X-Received: by 2002:aa7:8055:0:b0:433:7f11:5f17 with SMTP id y21-20020aa78055000000b004337f115f17mr315203pfm.49.1631551578725;
        Mon, 13 Sep 2021 09:46:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm8529228pge.65.2021.09.13.09.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 09:46:18 -0700 (PDT)
Message-ID: <613f805a.1c69fb81.4a90a.8e45@mx.google.com>
Date:   Mon, 13 Sep 2021 09:46:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-107-g25757ef9597c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 151 runs,
 6 regressions (v4.19.206-107-g25757ef9597c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 151 runs, 6 regressions (v4.19.206-107-g25=
757ef9597c)

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
nel/v4.19.206-107-g25757ef9597c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.206-107-g25757ef9597c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25757ef9597c29bcb6ba3becbfc7b206f246e507 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f4920a5e913960d99a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f4920a5e913960d99a=
30c
        failing since 299 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f49488a825c0ed299a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f49488a825c0ed299a=
2f4
        failing since 299 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/613f48ddc5a8b88dfe99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f48ddc5a8b88dfe99a=
2de
        failing since 299 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/613f5f2cf7d1d9789099a321

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
06-107-g25757ef9597c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk=
3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613f5f2cf7d1d9789099a335
        failing since 90 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-13T14:24:29.317305  /lava-4509441/1/../bin/lava-test-case
    2021-09-13T14:24:29.333965  <8>[   17.899401] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-13T14:24:29.334428  /lava-4509441/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613f5f2cf7d1d9789099a34e
        failing since 90 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-13T14:24:25.861914  <8>[   14.438215] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>
    2021-09-13T14:24:26.876060  /lava-4509441/1/../bin/lava-test-case
    2021-09-13T14:24:26.892909  <8>[   15.457574] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613f5f2cf7d1d9789099a34f
        failing since 90 days (last pass: v4.19.194, first fail: v4.19.194-=
68-g3c1f7bd17074)

    2021-09-13T14:24:25.856525  /lava-4509441/1/../bin/lava-test-case   =

 =20
