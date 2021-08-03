Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEA03DE3B1
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 02:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhHCA46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 20:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhHCA46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 20:56:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5106AC06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 17:56:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id q2so21692583plr.11
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 17:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dN9seks4HCgvuS6zFOa93ccnb+I55oS7SLAhGWRSbo0=;
        b=kbsH74nWULHDkkRE4sDtxKay452iJ51Y05v98L68FTtCVBrN9Ju5B9QEvp+WfT2yYO
         JiKXS6t/8XsJzVZp9E+QOBFa6ppLmGQxKt7XGdmINT+TaDRyVpSNUgn1oCcJ7uZkNVDn
         OuEzpScOpcEzp9pqkBN62/l7nORhZw5GbDTQvecxWWkIPRWfQ33B2IBADnpJyIxwWENg
         jgzUTQ3fTWP8ZofN21BUdQslY9gPKMlRtwhnl4leEEgvgVtLRvEJNI7cXWEIBw5x890Z
         BVoLR/liRYNj55D/6+aT0a7FHNDvwPvA/9g0CrECKpsW6gKPhGol+AIb1fRVCy4twKHd
         AIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dN9seks4HCgvuS6zFOa93ccnb+I55oS7SLAhGWRSbo0=;
        b=f4ANjMTvixmBkXOzgDQ+/jIHOA9q0kAGSzSLNiCpKS5LF+h+Z366X7xrQ8MJlu9zow
         1P9qiPkeH0ALSUeCjJph4dTe0+0ERWBUcejwHgopNgzBexd/NkfDoz6Ro5kjm/0Ev84k
         TwEeXMM/54tGFs+RjdQwMwhiHO7HvDEfmfzBbnMytDVeUvSfJT0LuH6XqxKA214Z02U7
         UI0fZ/CS/jOotKVAkIy43yRy+s8vWjOvC0m6O8TYXlfsY8Kx2riiMtUo08GDyZWRxBPx
         3Z+i1bO5BQEaW8VAg+MWcTA84u082UkRsVmHTl9lThkUGT/trE45nnMkpfO523KNXYv2
         Gd6w==
X-Gm-Message-State: AOAM530NcDSrZcyC3UIvgpHM5Xfg92+Zdj98bZVZKy4zQtn2F4u8R/Da
        oAubMbvElAwtr6c4BPicmM9X6FWK+QlGbvZw
X-Google-Smtp-Source: ABdhPJzAVjgBEPyfzVJkZdptNe6DYt57LIj/leBv2TRSAbvhS2bTleQLEHaVKaCEGlVLzaZOuuL3sA==
X-Received: by 2002:a17:902:9046:b029:12c:b5b7:e443 with SMTP id w6-20020a1709029046b029012cb5b7e443mr6978492plz.31.1627952207700;
        Mon, 02 Aug 2021 17:56:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11sm13276196pgj.75.2021.08.02.17.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 17:56:47 -0700 (PDT)
Message-ID: <6108944f.1c69fb81.c37dc.77d5@mx.google.com>
Date:   Mon, 02 Aug 2021 17:56:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.200-30-g6b7de56bb341
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 7 regressions (v4.19.200-30-g6b7de56bb341)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 7 regressions (v4.19.200-30-g6b7de=
56bb341)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.200-30-g6b7de56bb341/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.200-30-g6b7de56bb341
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b7de56bb34108f60bf36b4a11bb1482ff378fed =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61085a349bb077bd23b13674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61085a349bb077bd23b13=
675
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61085fbb69d6ac2eb5b13684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61085fbb69d6ac2eb5b13=
685
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61085a479bb077bd23b136b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61085a479bb077bd23b13=
6b2
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6108613975c20cb6e4b13685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6108613975c20cb6e4b13=
686
        failing since 262 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61088cb5457b741e04b1368e

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.200=
-30-g6b7de56bb341/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61088cb5457b741e04b136a6
        failing since 48 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-03T00:23:59.439440  /lava-4311454/1/../bin/lava-test-case
    2021-08-03T00:23:59.458534  <8>[   18.613390] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-03T00:23:59.458764  /lava-4311454/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61088cb5457b741e04b136bf
        failing since 48 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-03T00:23:56.997637  /lava-4311454/1/../bin/lava-test-case
    2021-08-03T00:23:57.015690  <8>[   16.172101] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61088cb5457b741e04b136c0
        failing since 48 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-03T00:23:55.978711  /lava-4311454/1/../bin/lava-test-case
    2021-08-03T00:23:55.984951  <8>[   15.152626] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
