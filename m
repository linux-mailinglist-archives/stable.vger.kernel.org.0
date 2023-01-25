Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6CC67AA15
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 06:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbjAYFt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 00:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjAYFt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 00:49:56 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83A97EDD
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 21:49:52 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c6so16942451pls.4
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 21:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F7NWWsfEqHHyDZklezS24juIUnkNkvB51HK8a8T3c/s=;
        b=FZZM8QT02GXQ8tRCgwkGFTN7B/1lmZQkRx8Zhl9kBUO2LI0kVB1NUuRkvNMkvoyTk2
         dKOVw2fjtF40zwiZKnXoAm8aL19z7WKKnZuue0nIwv2Zuv5zaDGWtqb9/Ty1eqvQ13Br
         E/+p6CdzNZXi1LI+H0gvBCSXIBef8U1V251bDutW38TcfrmEXuEgEzmQorX4NeKF5y2J
         BspyyplYzEPdMTkvzzidg54BoQ641UwErxDFTvTxALrRULLGJdswk2m+dsvx9yvihGC0
         K3Vc4ptozM9iXC+6mgMoZjfzmvRqmxbk/iUDdGe8I8aA7H3TOUXhU4uYOAFJyWWcVr7a
         TjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F7NWWsfEqHHyDZklezS24juIUnkNkvB51HK8a8T3c/s=;
        b=bBos6pee2+k4XDycYTztdAKmY2FHek/QRXWoYI+XzwacgEDwM+mFPL0m08mk2fVciD
         ahP1kOSKQ/4j0y6Ggss15fBnMjBzp99vKh1JWFwBhE3SUI4sdiVbEB5TZ/2cRjqcXvyK
         xTw8CJXybPfTiA8KA5/apXHtpatVWwnSm4iQOM8Syjol+/CTEXfH+Fh3LxWD2/uXFCUK
         HCpFFyvjT7/HTff5gQROZo+aGPbBqGHWtA7FPxwpQKpF6WtHjoGvzmzO7AsM6wKM6vFB
         h1nplJGdDG2Z6tIIXrdZxi8UFpaQAzVIIyRHHdFTaOhgDmmSCWykvJPoIM5xPDgdVoKE
         5Mew==
X-Gm-Message-State: AFqh2kqMJnL3jx+gNLDDnMc3r42BoC30VjMPsV3THqOgA8R9hT3EQ9H7
        KwXY2D//MGIbP61CcNpUyppmHR0qwyBT/+JB
X-Google-Smtp-Source: AMrXdXuckc2rnC5KbMM5HtGuauK8cVhqF/aeRYAf4wGl+Ljn6uZT+Ln47JP5UsGKKqb0/OkLc6fUAg==
X-Received: by 2002:a05:6a20:8407:b0:b8:8fc4:c83e with SMTP id c7-20020a056a20840700b000b88fc4c83emr44713204pzd.25.1674625790564;
        Tue, 24 Jan 2023 21:49:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id je15-20020a170903264f00b001960642b460sm2222608plb.260.2023.01.24.21.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 21:49:50 -0800 (PST)
Message-ID: <63d0c2fe.170a0220.14667.41b8@mx.google.com>
Date:   Tue, 24 Jan 2023 21:49:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.162-1027-gef210438485a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 137 runs,
 76 regressions (v5.10.162-1027-gef210438485a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 137 runs, 76 regressions (v5.10.162-1027-gef=
210438485a)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig         | 1          =

am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | omap2pl=
us_defconfig        | 1          =

at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =

at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =

bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =

beaglebone-black             | arm   | lab-broonie     | gcc-10   | multi_v=
7_defconfig         | 1          =

beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig        | 1          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =

da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =

dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig         | 1          =

fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =

imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =

imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =

meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 2          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-orangepi-one-plus  | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =

sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =

sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =

sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.162-1027-gef210438485a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.162-1027-gef210438485a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef210438485aaf502980605b2414a692e01b9155 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08e25046165ba39915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-=
am57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-=
am57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08e25046165ba39915=
ebb
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08ef856cddc4358915f5f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline=
-am57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline=
-am57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08ef856cddc4358915=
f60
        failing since 0 day (last pass: v5.10.162-950-g0ce90a11c205, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08a7d6e4bb06b7b915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08a7d6e4bb06b7b915=
eba
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08cfdda204cb6ca915ef7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08cfdda204cb6ca915=
ef8
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08e0628702c7ff8915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711=
-rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08e0628702c7ff8915=
ec8
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08f3ab8f5af37ec915ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08f3ab8f5af37ec915=
ee2
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d090ac157eea5ef2915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d090ac157eea5ef2915=
ebb
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08eb7c23aa4ad94915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08eb7c23aa4ad94915=
ec6
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08f93eebed5846e915edd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08f93eebed5846e915=
ede
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d08feaedb9867b1b915edd

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d08feaedb9867=
b1b915ee4
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-25T02:11:41.175212  kern  :alert : 8<--- cut here ---
    2023-01-25T02:11:41.180742  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c25fe400
    2023-01-25T02:11:41.181269  kern  :alert : pgd =3D (ptrval)
    2023-01-25T02:11:41.187341  kern  :alert : [c25fe400] *pgd=3D4241141e(b=
ad)
    2023-01-25T02:11:41.200287  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T02:11:41.205764  kern  :emerg : Process udevd (pid: 101, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T02:11:41.211108  kern  :emerg : Stack: (0xc3de9da8 to 0xc3de=
a000)
    2023-01-25T02:11:41.222310  kern  :emerg : 9da0:                   c20a=
1700 c0a35490 00000000 c222db40 c20a1700 69739684
    2023-01-25T02:11:41.228028  kern  :emerg : 9dc0: c21ac410 c21ac410 ffff=
fdfb 00000000 c1a78968 c1a78960 bf06c024 0000000e
    2023-01-25T02:11:41.238975  kern  :emerg : 9de0: 00020000 c0a31454 0000=
0000 c21ac410 bf06c024 c21ac454 bf06c024 c3984f38 =

    ... (44 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d08feaedb9867=
b1b915ee5
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-25T02:11:41.147503  kern  :alert : 8<--- cut here ---
    2023-01-25T02:11:41.152997  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c21ac410
    2023-01-25T02:11:41.158332  kern  :alert : pgd =3D (ptrval)
    2023-01-25T02:11:41.169794  kern  :alert<8>[   38.544402] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-25T02:11:41.170443   : [c21ac410] *pgd=3D4201141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c6328db91bedf915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c6328db91bedf915=
ec1
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d089c556a6ee8f40915f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-=
da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d089c556a6ee8f40915=
f1b
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d0bda204cb6ca915eff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d0bda204cb6ca915=
f00
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08b3c4df4919ff9915edd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
dove-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
dove-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08b3c4df4919ff9915=
ede
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63d08cd2fcf5996c17915fbc

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d08cd2fcf5996=
c17915fc4
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        11 lines

    2023-01-25T01:58:12.786587  kern  :alert : Unable to handle kernel NULL=
 poin[   13.570328] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d08cd2fcf5996=
c17915fc5
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        2 lines

    2023-01-25T01:58:12.790456  ter dereference at virtual address 00000000=
00000000
    2023-01-25T01:58:12.790755  kern  :alert : Mem abort info:
    2023-01-25T01:58:12.796073  kern  :alert :   ESR =3D 0x96000006
    2023-01-25T01:58:12.806935  kern  :a[   13.590581] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d08e718971a73a96915ecb

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d08e718971a73=
a96915ed2
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        41 lines

    2023-01-25T02:05:20.169807  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T02:05:20.187888  kern  :emerg : Process udevd (pid: 111, sta=
ck limit =3D 0x(ptrval))[    9.641090] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-25T02:05:20.188255     =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d08e718971a73=
a96915ed3
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T02:05:20.127506  kern  :alert : 8<--- cut here ---
    2023-01-25T02:05:20.136368  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2291c20
    2023-01-25T02:05:20.144117  kern  :a[    9.598553] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T02:05:20.144302  lert : pgd =3D (ptrval)
    2023-01-25T02:05:20.144424  kern  :alert : [c2291c20] *pgd=3D1220041e(b=
ad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d1df10c5214e9915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline=
-imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d1df10c5214e9915=
ec3
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08fda447b1d9edb915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08fda447b1d9edb915=
ed6
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08de49f967e970a915f25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-s=
db.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08de49f967e970a915=
f26
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08ebb0bcb1887ff915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08ebb0bcb1887ff915=
edf
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08f73f3a76be375915eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08f73f3a76be375915=
eeb
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08dc77324449bfc915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08dc77324449bfc915=
ec0
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08cb9fcf5996c17915f9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08cb9fcf5996c17915=
f9d
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08e7c5dd0967c44915f13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08e7c5dd0967c44915=
f14
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08e4082915cbf29915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08e4082915cbf29915=
ec8
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c66d1ef607727915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c66d1ef607727915=
ecc
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c91302c28b3ac915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c91302c28b3ac915=
ecc
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08cae24e07564fe915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a=
-x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08cae24e07564fe915=
ebf
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d63d66d009947915ed1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d63d66d009947915=
ed2
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d786945a4aa9e915eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12=
b-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12=
b-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d786945a4aa9e915=
eef
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c8e4129f551df915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b=
-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c8e4129f551df915=
ece
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08dd79f967e970a915efd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08dd79f967e970a915=
efe
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d9fa0e556608b915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d9fa0e556608b915=
ed8
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d8bb13f72d389915ee6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
khadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d8bb13f72d389915=
ee7
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d0a287ae40cf5458915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0a287ae40cf5458915=
ebb
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08cbffcf5996c17915fa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
khadas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
khadas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08cbffcf5996c17915=
fa3
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08caa816de31d49915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
sei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-=
sei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08caa816de31d49915=
eba
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d092bfce45cb4d30915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d092bfce45cb4d30915=
ed4
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08a1ad6cf6cce68915f08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08a1ad6cf6cce68915=
f09
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08ecc165fb98b8c915edd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-od=
roid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08ecc165fb98b8c915=
ede
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d09310568132ca20915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d09310568132ca20915=
ed5
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d706945a4aa9e915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-p=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-p=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d706945a4aa9e915=
ecd
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63d08c937b2233671e915ed7

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-ro=
ck-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-ro=
ck-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d08c937b22336=
71e915ede
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        2 lines =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d08c937b22336=
71e915edf
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-25T01:57:19.176821  kern  :alert : [ffff0000006fd410] pgd=3D000=
000007fff8003, p4d=3D000000007fff8003, pud=3D000000007fff7003, pmd=3D000000=
007fff4003, pte=3D00680000006fd707
    2023-01-25T01:57:19.177365  <8>[   16.059504] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-25T01:57:19.177724  kern  :emerg : Internal error: Oops: 860000=
0f [#1] PREEMPT SMP
    2023-01-25T01:57:19.178049  kern  :emerg : Code: 00739e00 ffff0000 ffff=
ffff 00000000 (00739e00) =

    2023-01-25T01:57:19.178364  <8>[   16.080413] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2023-01-25T01:57:19.178670  + set +x   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d9ba0e556608b915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d9ba0e556608b915=
ecf
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08cfcfd78ee1a7a915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08cfcfd78ee1a7a915=
ecf
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08f0862d4b1e274915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-=
libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-=
libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08f0862d4b1e274915=
eba
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c8ad1ef607727915f29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c8ad1ef607727915=
f2a
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08d84b13f72d389915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-or=
angepi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-or=
angepi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08d84b13f72d389915=
ee1
        failing since 0 day (last pass: v5.10.162-851-g33a0798ae8e3, first =
fail: v5.10.162-1026-g401c1c1d3bf5) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-one-plus  | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08dc17324449bfc915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-or=
angepi-one-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-or=
angepi-one-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08dc17324449bfc915=
eba
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c6f0d2781a88f915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pi=
ne-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pi=
ne-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c6f0d2781a88f915=
ed1
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c881dc0ba7139915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6=
-pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6=
-pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c881dc0ba7139915=
ecc
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08b57f3f7a6c40f915efb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-=
a13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08b57f3f7a6c40f915=
efc
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08b5f182952ab2c915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08b5f182952ab2c915=
ec8
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08c2f4eeae5180d915ee4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08c2f4eeae5180d915=
ee5
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08dbba4b85946a0915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-=
a20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08dbba4b85946a0915=
ec2
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d0939c9433f0f06a915ec8

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d0939c9433f0f=
06a915ed0
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T02:27:26.719823  kern  :alert : 8<--- cut here ---
    2023-01-25T02:27:26.752765  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c21d6c10
    2023-01-25T02:27:26.753206  kern  :alert : pgd =3D (ptrval)
    2023-01-25T02:27:26.753774  kern  :alert : [c21d6c10] *pgd=3D4201141e(b=
ad)
    2023-01-25T02:27:26.754171  <8>[   18.656831] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d0939c9433f0f=
06a915ed1
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T02:27:26.822065  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T02:27:26.822817  kern  :emerg : Process udevd (pid: 120, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T02:27:26.823162  kern  :emerg : Stack: (0xc3da5da8 to 0xc3da=
6000)
    2023-01-25T02:27:26.823467  kern  :emerg : 5da0:                   c22e=
bc80 c0a35490 00000000 c3a58000 c22e<8>[   18.723450] <LAVA_SIGNAL_TESTCASE=
 TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>
    2023-01-25T02:27:26.823791  bd00 4b16e0d0
    2023-01-25T02:27:26.824145  kern  :emerg : 5dc0: c21d6c10 c21d6c10 ffff=
fdfb 00000000 c1a78968 c1a78960 bf0eb024 0000000a   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d0911cb3182cceb1915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0911cb3182cceb1915=
edc
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d08e6c5dd0967c44915eff

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d08e6c5dd0967=
c44915f07
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-25T02:05:13.891350  kern  :alert : 8<--- cut here ---
    2023-01-25T02:05:13.891699  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c22d2810
    2023-01-25T02:05:13.892169  kern  :alert : pgd =3D (ptrval)
    2023-01-25T02:05:13.892393  kern  :alert : [c22d2810] *pgd=3D4221141e(b=
ad)
    2023-01-25T02:05:13.892590  kern  :alert : 8<--- cut here ---
    2023-01-25T02:05:13.892781  kern  :alert : Unable to h[   46.886773] <L=
AVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUR=
EMENT=3D8>
    2023-01-25T02:05:13.892971  andle kernel paging request at virtual addr=
ess c3c08c00
    2023-01-25T02:05:13.893384  kern  :alert : pgd =3D (ptrval)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d08e6c5dd0967=
c44915f08
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-25T02:05:13.894550  kern  :alert : [c3c08c00] *pgd=3D43c1141e(b=
ad)
    2023-01-25T02:05:13.950468  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T02:05:13.950828  kern  :emerg : Process udevd (pid: 175, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T02:05:13.951451  kern  :emerg : Stack: (0xc592dda8 to 0xc592=
e000)
    2023-01-25T02:05:13.951676  kern  :emerg : dda0:                   c219=
5480 c0a35490 00000000 c219b000 c2195500 d9b6e0d3
    2023-01-25T02:05:13.951873  kern  :emerg : ddc0: c22d2810 c22d2810 ffff=
fdfb 00000000 c1a78968 c1a78960 bf202024 0000001c
    2023-01-25T02:05:13.952100  kern  :emerg : dde0: 00020000 c0a31454 0000=
0000 c22d2810 bf202024 c22d2854 bf202024 c2195438
    2023-01-25T02:05:13.993410  kern  :emerg : de00: c592c000 0000017b 0002=
0000 c0a31a30 c22d2810 00000000 c22d2854 c0a31d20
    2023-01-25T02:05:13.993714  kern  :emerg : de20: bf202024 c22d2810 c0a3=
1d28 c592c000 c2195438 c0a31d88 00000000 bf202024
    2023-01-25T02:05:13.994161  kern  :emerg : de40: c0a31d28 c0a2f3a8 c592=
c000 c2083858 c223d5b4 d9b6e0d3 bf202024 bf202024 =

    ... (41 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08afc1c729a9947915f0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a8=
3t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a8=
3t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08afc1c729a9947915=
f10
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d08e2c04b6a8a3c6915ef4

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d08e2c04b6a8a=
3c6915efb
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T02:04:13.361836  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T02:04:13.362316  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T02:04:13.362570  kern  :emerg : Stack: (0xc4639da8 to 0xc463=
a000)
    2023-01-25T02:04:13.362783  kern  :emerg : <8>[    7.565481] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
39>
    2023-01-25T02:04:13.362991  9da0:                   c47bb880 c0a35490 0=
0000000 c23ba900 c734<8>[    7.576580] <LAVA_SIGNAL_ENDRUN 0_dmesg 3206629_=
1.5.2.4.1>
    2023-01-25T02:04:13.363240  df00 b9053f56   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d08e2c04b6a8a=
3c6915efc
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T02:04:13.308416  kern  :alert : 8<--- cut here ---
    2023-01-25T02:04:13.308900  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c213bc10
    2023-01-25T02:04:13.309132  kern  :alert : pgd =3D (ptrval)
    2023-01-25T02:04:13.311955  kern  :alert<8>[    7.514620] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T02:04:13.312216   : [c213bc10] *pgd=3D4201141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08b0dae7d9d5086915ee7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08b0dae7d9d5086915=
ee8
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d08e2b04b6a8a3c6915ee9

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun=
8i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d08e2b04b6a8a=
3c6915ef0
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T02:04:16.246378  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T02:04:16.246740  kern  :emerg : Process udevd (pid: 132, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T02:04:16.246972  kern  :emerg : Stack: (0xc48adda8 to 0xc48a=
e000)
    2023-01-25T02:04:16.247439  kern  :emerg : <8>[    8.892745] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
39>
    2023-01-25T02:04:16.247672  dda0:                   c4819780 c0a35490 0=
0000000 c21f6240 c21f<8>[    8.907464] <LAVA_SIGNAL_ENDRUN 0_dmesg 3206623_=
1.5.2.4.1>
    2023-01-25T02:04:16.247892  5e00 6ee78f77   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d08e2b04b6a8a=
3c6915ef1
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T02:04:16.193541  kern  :alert : 8<--- cut here ---
    2023-01-25T02:04:16.194018  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227bc10
    2023-01-25T02:04:16.194254  kern  :alert : pgd =3D (ptrval)
    2023-01-25T02:04:16.197129  kern  :alert<8>[    8.845340] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-25T02:04:16.197393   : [c227bc10] *pgd=3D4221141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d08af81c729a9947915ed6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d08af81c729a9947915=
ed7
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d09cd5c079ffa2b2915ece

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d09cd5c079ffa=
2b2915ed6
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-25T03:06:40.413989  kern  :alert : 8<--- cut here ---
    2023-01-25T03:06:40.419353  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227b810
    2023-01-25T03:06:40.428494  kern  :ale<8>[   15.100420] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d09cd5c079ffa=
2b2915ed7
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-25T03:06:40.434955  rt : pgd =3D (ptrval)
    2023-01-25T03:06:40.435336  kern  :alert : [c227b810] *pgd=3D4221141e(b=
ad)
    2023-01-25T03:06:40.454339  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-25T03:06:40.465128  kern  :emerg : Process udevd (pid: 121, sta=
ck limit =3D 0x(ptrval))
    2023-01-25T03:06:40.469232  k<8>[   15.141064] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d09a6afa7c96e882915ee9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d09a6afa7c96e882915=
eea
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d0abd71464f6a94f915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-r40-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i=
-r40-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0abd71464f6a94f915=
ebd
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d0a2dad53cdd0564915eda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r4=
0-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.162=
-1027-gef210438485a/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r4=
0-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0a2dad53cdd0564915=
edb
        failing since 0 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =20
