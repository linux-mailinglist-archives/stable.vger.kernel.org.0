Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5A13AD2CA
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 21:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhFRT3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 15:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhFRT3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 15:29:35 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED513C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 12:27:25 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id t8so3759647pfe.3
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 12:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eWFVeSx/tNt+zhl0eebGsx7JYJEL7IkkilLa8BMf92I=;
        b=Orx5bAqJcBZBdEfwyeIoSjPaisjV5XFP2R4vfeE5x0HkmKKqz5dIXSNgNrBlPYC5Ux
         3M1zpIQaGtw6OX9Ilpj2xdysxKj2BGSGDJOx18Ypq5PAg2VqXJOEj5ceUtneCd/G+sXu
         0hDqJuFZ/lLx3tfmSR3WeCa1rurOkKkz1t2QwtV3yJReWmW9Op7CmtSJpDgxSRuepMO4
         KFwQL859xRHalp7geCpU36OsNXI5SJ49JanUGNyT+ftjtJp1zzDMBUJ/R3+KDAISDjn5
         pZ/HMc9o7ZlnT0IpI9ihtSxKMd+KvNeWY+3mea9YVsjFSdNMolHwZd/6V2teHHftxarT
         pggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eWFVeSx/tNt+zhl0eebGsx7JYJEL7IkkilLa8BMf92I=;
        b=rXvCdJVO7Xc12lXIarsnFXm2qnhudVc5CDpozF1xQGSN1ZM+BFsiFBJk+9l109YPL7
         6rADROwkIyVoDyaQIbKm8EVJlG42NW4RCMJimYWTDyODRqV5TMshnTfC2dPcTEo3OuSK
         Q3ESwWp4BTKCGPRDrDABRpICBOt2OKDz4VAnH1l92epDtdLCb5VwIoGfsEvGMlTs6duq
         X0TQvr79sSsEEuIM5dfqxbleCiyl3Gn/eQmT6FLTkrjed8BiAhiw9ahVndQFxMLk/uZB
         Ag/ZLuiqqSN1mIM+u+6PiSE7f4YhD/738l6kMG24mOLSHmE977c2NCDa06jbE9tyUAKR
         hQkQ==
X-Gm-Message-State: AOAM531S69xkXkJuIlVpJg93KTwSdoFLtxb/3Hiz3v5UG4l7E70RlJbz
        dlzo0S09Vx8+h4IueCXKaurWMiE0rGiYcoIH
X-Google-Smtp-Source: ABdhPJw3KT8SnbrsThnETVjXPa7V14lhfcV9Wu+Y6LeDepE6V81rjrpOE6tR9iXovsr1kE3uumYtfA==
X-Received: by 2002:a05:6a00:1acd:b029:2fb:81a4:b06 with SMTP id f13-20020a056a001acdb02902fb81a40b06mr6410062pfv.36.1624044444909;
        Fri, 18 Jun 2021 12:27:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm5405615pfu.1.2021.06.18.12.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 12:27:24 -0700 (PDT)
Message-ID: <60ccf39c.1c69fb81.53dd3.d672@mx.google.com>
Date:   Fri, 18 Jun 2021 12:27:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 113 runs, 8 regressions (v4.14.237)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 113 runs, 8 regressions (v4.14.237)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.237/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.237
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cfb41ef9deb1e6572ac218ddfcec9567e5d1c101 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccd0cc2793f900a9413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccd0cc2793f900a9413=
267
        failing since 444 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccd19251a4c2a36c413279

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccd19251a4c2a36c413=
27a
        failing since 85 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccbfcd0b59ac5280413275

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccbfcd0b59ac5280413=
276
        failing since 216 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccc94834ec43a979413294

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccc94834ec43a979413=
295
        failing since 216 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccbfe44083c62580413280

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccbfe44083c62580413=
281
        failing since 216 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/60ccd6a86ce70b69eb413278

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
37/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ccd6a86ce70b69eb413294
        failing since 3 days (last pass: v4.14.236, first fail: v4.14.236-5=
0-g2e03cf25d5d0)

    2021-06-18T17:23:44.994843  /lava-4053019/1/../bin/lava-test-case
    2021-06-18T17:23:45.000203  [   13.104117] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ccd6a86ce70b69eb413295
        failing since 3 days (last pass: v4.14.236, first fail: v4.14.236-5=
0-g2e03cf25d5d0)

    2021-06-18T17:23:46.014085  /lava-4053019/1/../bin/lava-test-case
    2021-06-18T17:23:46.030774  [   14.122877] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ccd6a86ce70b69eb4132ae
        failing since 3 days (last pass: v4.14.236, first fail: v4.14.236-5=
0-g2e03cf25d5d0)

    2021-06-18T17:23:48.443796  /lava-4053019/1/../bin/lava-test-case
    2021-06-18T17:23:48.449087  [   16.552958] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
