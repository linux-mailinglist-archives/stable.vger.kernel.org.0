Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C231D67D092
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 16:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjAZPrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 10:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjAZPrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 10:47:12 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A4BBBC
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 07:47:07 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso5635236pjg.2
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 07:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7+P2iMVOcCLY0yzRR7xHmgvY7yfBMNIEF80G/3LMGZ8=;
        b=Br/Q05YQhI3iS3wGwOU5A8pKGa2f9AWwzQCkM+VNBAKy6QbPvY049m7Vk0JpJzzkju
         8i0nEYnaQt4L5BPzyO6sPx0sqNIR7uvvfjY31HsyZD9GXAQChGpKfVPjTyD3vKuUJjIO
         EXywiaFqcGZftbkdO6RkMlW+A4TT3h03d9AjDwewOJ+wYkiRepPFTA2WOqkfY7wQFdwD
         M93jnHjf++8/1wpDJFdedYDu+4NuZoe9IPaxf9E5ew03KmLI4nnxbg6QiykBLg3Ez7/S
         wiyn+L5NSpCHIb68Yaegcc8AeMUsrMkXlWl/1Nr34deOAwXUkvdjRej2VDXcdl/CF4kj
         w+ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7+P2iMVOcCLY0yzRR7xHmgvY7yfBMNIEF80G/3LMGZ8=;
        b=ijbF9PqzhLL/74c5PYeKoHUzfFtdMcfh3cLdebNAtp1BSOkB9jHpwspaIl86zSuZgX
         ZFBj4kwMbKurF29wcU4xdLtOUaazpo3QkYcaLoSUa/24wv2Efglt92yYoeq9LGSQ68Yi
         b+ITsK68kk49hpU3rlyK4HtqcYiEzFNrrPenL26WA1bzaP2X1OX0Gw2eT4QOqv1rC2gM
         lMVpHfWsr2mBVhLYkDnFgIMBcVGQ8imckn496QiIL9im8ZXt6CkfDXfIxGcSfj5nXKZm
         wK12ofaNZuJdEl73s6Mpigfp5TnvzrWmcj1Bfq+3TDVpQOzZY08k5wK+VID8Ka2H/wCc
         m/Mw==
X-Gm-Message-State: AO0yUKVLwWe7vT3pSPBccDGRyEppAuEkr7GhAaYRHKDYOFwjZZO5DrDF
        2vc7ppkWj0VROw3a6Q0i8KgQm9uw0DMWm+cVcOsuIQ==
X-Google-Smtp-Source: AK7set/ygYsYOSOZ+eztjSgAejVeI0pJB6s8qbd6UaYXRennN54v0IjUKDW4M0NzXA7UvK5nVkcQUg==
X-Received: by 2002:a17:903:32c2:b0:196:25b1:a044 with SMTP id i2-20020a17090332c200b0019625b1a044mr8823002plr.55.1674748025424;
        Thu, 26 Jan 2023 07:47:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n2-20020a1709026a8200b00194afb5a3ebsm1172332plk.21.2023.01.26.07.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 07:47:04 -0800 (PST)
Message-ID: <63d2a078.170a0220.161f5.1b56@mx.google.com>
Date:   Thu, 26 Jan 2023 07:47:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.165-77-g4600242c13ed
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 165 runs,
 78 regressions (v5.10.165-77-g4600242c13ed)
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

stable-rc/queue/5.10 baseline: 165 runs, 78 regressions (v5.10.165-77-g4600=
242c13ed)

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

bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

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
7_defconfig         | 3          =

cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

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

meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =

mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 2          =

sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
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
nel/v5.10.165-77-g4600242c13ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.165-77-g4600242c13ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4600242c13ed93a8a81283aadc4ae8266ae3832c =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2681b173a37525f915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am=
57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2681b173a37525f915=
eca
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d268af7e7f039d65915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d268af7e7f039d65915=
ebc
        failing since 1 day (last pass: v5.10.162-950-g0ce90a11c205, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26619696ec459f4915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26619696ec459f4915=
ec4
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26aa1817b576978915fe7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26aa1817b576978915=
fe8
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2742a31ed0c7e2c915ee5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rpi=
-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2742a31ed0c7e2c915=
ee6
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26aea0cc0c969cc915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-r=
pi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26aea0cc0c969cc915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2690692c593da14915f05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2690692c593da14915=
f06
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26a631394c80667915f16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26a631394c80667915=
f17
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2686497cafc14b3915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagle=
bone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2686497cafc14b3915=
ecd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d268ccae8fe82094915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d268ccae8fe82094915=
edd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 3          =


  Details:     https://kernelci.org/test/plan/id/63d268e0666efab4ba915ed0

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d268e0666efab4ba915ed5
        new failure (last pass: v5.10.165-76-g5c2e982fcf18)

    2023-01-26T11:49:32.135160  d00 00000088 c20e2000 c200a400 c03625bc fff=
fe000 c1a1e446
    2023-01-26T11:49:32.140756  kern <8>[   38.766634] <LAVA_SIGNAL_ENDRUN =
0_dmesg 3217066_1.5.2.4.1>
    2023-01-26T11:49:32.145997   :emerg : 3f60: c20a1000 c2096300 c2096180 =
00000000 c20e2000 c0362558 c20a1000 c20d1e9c
    2023-01-26T11:49:32.157556  kern  :emerg : 3f80: c2096324 c036802c 0000=
0001 c2096180 c0367ee0 00000000 00000000 00000000
    2023-01-26T11:49:32.162932  kern  :emerg : 3fa0: 00000000 00000000 0000=
0000 c03001a8 00000000 00000000 00000000 00000000
    2023-01-26T11:49:32.174013  kern  :emerg : 3fc0: 00000000 00000000 0000=
0000 00000000 00000000 00000000 00000000 00000000
    2023-01-26T11:49:32.179406  kern  :emerg : 3fe0: 00000000 00000000 0000=
0000 00000000 00000013 00000000 00000000 00000000
    2023-01-26T11:49:32.190745  kern  :emerg : [<c0862610>] (devm_clk_relea=
se) from [<c0a35db0>] (devres_release+0x24/0x4c)
    2023-01-26T11:49:32.196092  kern  :emerg : [<c0a35db0>] (devres_release=
) from [<c0862840>] (devm_clk_put+0x1c/0x40)
    2023-01-26T11:49:32.207237  kern  :emerg : [<c0862840>] (devm_clk_put) =
from [<bf1bc0b0>] (bcm_get_resources+0x174/0x21c [hci_uart]) =

    ... (36 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d268e0666efab=
4ba915ed7
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-26T11:49:31.718233  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2748400
    2023-01-26T11:49:31.726793  kern  :alert : pgd =3D (ptrval)
    2023-01-26T11:49:31.727604  kern  :alert : [c2748400] *pgd=3D4261141e(b=
ad)
    2023-01-26T11:49:31.746825  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-26T11:49:31.752226  kern  :emerg : Process udevd (pid: 102, sta=
ck limit =3D 0x(ptrval))
    2023-01-26T11:49:31.757799  kern  :emerg : Stack: (0xc3df3da8 to 0xc3df=
4000)
    2023-01-26T11:49:31.768950  kern  :emerg : 3da0:                   c3e0=
e200 c0a35490 00000000 c3980780 c3e0e200 174b7db3
    2023-01-26T11:49:31.774378  kern  :emerg : 3dc0: c2114410 c2114410 ffff=
fdfb 00000000 c1a78968 c1a78960 bf011024 0000000e
    2023-01-26T11:49:31.785681  kern  :emerg : 3de0: 00020000 c0a31454 0000=
0000 c2114410 bf011024 c2114454 bf011024 c3e0e1b8
    2023-01-26T11:49:31.791242  kern  :emerg : 3e00: c3df2000 0000017b 0002=
0000 c0a31a30 c2114410 00000000 c2114454 c0a31d20 =

    ... (43 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d268e0666efab=
4ba915ed8
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-26T11:49:31.686869  kern  :alert : 8<--- cut here ---
    2023-01-26T11:49:31.692510  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2114410
    2023-01-26T11:49:31.697929  kern  :alert : pgd =3D (ptrval)
    2023-01-26T11:49:31.701520  kern  :alert : [c2114410] *pgd=3D4201141e(b=
ad)
    2023-01-26T11:49:31.712721  kern  :alert : 8<--- cut here <8>[   38.333=
191] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines=
 MEASUREMENT=3D8>
    2023-01-26T11:49:31.713427  ---   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2667247b7704559915eec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietru=
ck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietru=
ck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2667247b7704559915=
eed
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2668147b7704559915ef2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-do=
ve-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-do=
ve-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2668147b7704559915=
ef3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63d26a451394c80667915ebc

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d26a451394c80=
667915ec4
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        11 lines

    2023-01-26T11:55:26.080113  kern  :alert : Unable to handle kernel NULL=
 poin[   20.539914] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d26a451394c80=
667915ec5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        2 lines

    2023-01-26T11:55:26.083727  ter dereference at virtual address 00000000=
00000000
    2023-01-26T11:55:26.084031  kern  :alert : Mem abort info:
    2023-01-26T11:55:26.089225  kern  :alert :   ESR =3D 0x96000006
    2023-01-26T11:55:26.100226  kern  :a[   20.560014] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d26839173a37525f915ee7

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d2683a173a375=
25f915eee
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        41 lines

    2023-01-26T11:46:41.501024  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-26T11:46:41.518993  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0x(ptrval))[    9.628779] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-26T11:46:41.519160     =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d2683a173a375=
25f915eef
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-26T11:46:41.459145  kern  :alert : 8<--- cut here ---
    2023-01-26T11:46:41.468156  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2291c20
    2023-01-26T11:46:41.475785  kern  :a[    9.586864] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-26T11:46:41.475983  lert : pgd =3D (ptrval)
    2023-01-26T11:46:41.476103  kern  :alert : [c2291c20] *pgd=3D1220041e(b=
ad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d268ee6dc5aee0d6915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d268ee6dc5aee0d6915=
ec6
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26a42891bafa3bf915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26a42891bafa3bf915=
ecf
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d267fdf2e68adef5915ee5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d267fdf2e68adef5915=
ee6
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2687d97cafc14b3915ef5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2687d97cafc14b3915=
ef6
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26c39f2082e9101915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-=
evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26c39f2082e9101915=
ec1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d267eff2e68adef5915ee2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d267eff2e68adef5915=
ee3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d266c6b8c25e1991915ef0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d266c6b8c25e1991915=
ef1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269d5b94058935a915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-s=
ei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269d5b94058935a915=
edc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269fc7087ae1519915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269fc7087ae1519915=
ed3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269f96c580827db915f58

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x=
96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x=
96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269f96c580827db915=
f59
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269f57087ae1519915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269f57087ae1519915=
ecb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26ae69060067e5f915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26ae69060067e5f915=
edd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269d3b94058935a915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-o=
droid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269d3b94058935a915=
ed3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26bf418fa3ec312915efd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26bf418fa3ec312915=
efe
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26bf318fa3ec312915efa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26bf318fa3ec312915=
efb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26af70cc0c969cc915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26af70cc0c969cc915=
ed3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2700ddba65f4cdc915eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2700ddba65f4cdc915=
eef
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26a1ff9e6eb7fb4915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kh=
adas-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26a1ff9e6eb7fb4915=
ebb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269d253e5a6229c915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-se=
i610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-se=
i610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269d253e5a6229c915=
ec0
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d267fff2e68adef5915ee9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson=
8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d267fff2e68adef5915=
eea
        failing since 1 day (last pass: v5.10.162-950-g0ce90a11c205, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269056dc5aee0d6915f03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269056dc5aee0d6915=
f04
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d266e9d0407cf08d915ebb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d266e9d0407cf08d915=
ebc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2683d11cda605ec915ef7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odro=
id-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2683d11cda605ec915=
ef8
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d279204d83fd1d74915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk32=
88-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d279204d83fd1d74915=
ec0
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26a821394c80667915f3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26a821394c80667915=
f3d
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26b02ace33c56da915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26b02ace33c56da915=
edf
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63d26a150102d6e816915f2e

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock=
-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d26a150102d6e=
816915f35
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        2 lines =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d26a150102d6e=
816915f36
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-26T11:54:41.351506  kern  :alert : [ffff0000007ed410] pgd=3D000=
000007fff8003, p4d=3D000000007fff8003, pud=3D000000007fff7003, pmd=3D000000=
007fff4003, pte=3D00680000007ed707
    2023-01-26T11:54:41.352019  <8>[   15.789416] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-26T11:54:41.352472  kern  :emerg : Internal error: Oops: 860000=
0f [#1] PREEMPT SMP
    2023-01-26T11:54:41.352870  kern  :emerg : Code: 00739d80 ffff0000 ffff=
ffff 00000000 (00739d80) =

    2023-01-26T11:54:41.353254  <8>[   15.810451] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2023-01-26T11:54:41.353639  + set +x   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2659e19189981c2915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a1=
0-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a1=
0-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2659e19189981c2915=
ecd
        new failure (last pass: v5.10.157-95-g602512855c6c) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269f86c580827db915f55

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269f86c580827db915=
f56
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26aa0817b576978915fe4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26aa0817b576978915=
fe5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26a9209a54bc22c915eda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26a9209a54bc22c915=
edb
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26b35a47cb4d3e7915ef8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26b35a47cb4d3e7915=
ef9
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269f66c580827db915f51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-lib=
retech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269f66c580827db915=
f52
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26b0327f48c423f915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26b0327f48c423f915=
ec2
        failing since 1 day (last pass: v5.10.162-851-g33a0798ae8e3, first =
fail: v5.10.162-1026-g401c1c1d3bf5) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-one-plus  | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26a0c0102d6e816915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-one-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-oran=
gepi-one-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26a0c0102d6e816915=
ec9
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269e96c580827db915f28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine=
-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269ea6c580827db915=
f29
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d269f56c580827db915f4b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-p=
ine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d269f56c580827db915=
f4c
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d265b2da41a6e6ce915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a1=
3-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a1=
3-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d265b2da41a6e6ce915=
ed0
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d265831da8adbcd8915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d265831da8adbcd8915=
ee1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d265701da8adbcd8915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-=
cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-=
cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d265701da8adbcd8915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26670925c83b08c915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a2=
0-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26670925c83b08c915=
ec7
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d2682d173a37525f915eda

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d2682d173a375=
25f915ee2
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-26T11:46:20.697075  kern  :alert : 8<--- cut here ---
    2023-01-26T11:46:20.697510  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c21d6c10
    2023-01-26T11:46:20.698118  kern  :alert : pgd =3D (ptrval)
    2023-01-26T11:46:20.698462  kern  :alert : [c21d6c10] *pgd=3D4201141e(b=
ad)
    2023-01-26T11:46:20.698817  <8>[   18.588499] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d2682d173a375=
25f915ee3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-26T11:46:20.758242  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-26T11:46:20.758921  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0x(ptrval))
    2023-01-26T11:46:20.759274  kern  :emerg : Stack: (0xc3c8dda8 to 0xc3c8=
e000)
    2023-01-26T11:46:20.759579  kern  :emerg : dda0:                   c3d3=
d180 c0a35490 00000000 c2317780 c3d3<8>[   18.647993] <LAVA_SIGNAL_TESTCASE=
 TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>
    2023-01-26T11:46:20.759908  d200 6395fc00
    2023-01-26T11:46:20.760273  kern  :emerg : ddc0: c21d6c10 c21d6c10 ffff=
fdfb 00000000 c1a78968 c1a78960 bf04f024 00000009   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d26584245b0b244c915ee9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-=
olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-=
olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d26584245b0b244c915=
eea
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d26826173a37525f915ecd

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a=
83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d26826173a375=
25f915ed5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-26T11:46:28.898766  kern  :alert : 8<--- cut here ---
    2023-01-26T11:46:28.899261  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c22d2810
    2023-01-26T11:46:28.899865  kern  :alert : pgd =3D (ptrval)
    2023-01-26T11:46:28.900200  kern  :alert : [c22d2810] *pgd=3D4221141e(b=
ad)
    2023-01-26T11:46:28.900517  kern  :alert : 8<--- cut here --[   46.1939=
23] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines =
MEASUREMENT=3D8>
    2023-01-26T11:46:28.900812  -
    2023-01-26T11:46:28.901124  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c3bdac00
    2023-01-26T11:46:28.901412  kern  :alert : pgd =3D (ptrval)
    2023-01-26T11:46:28.901746  kern  :alert : [c3bdac00] *pgd=3D43a1141e(b=
ad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d26826173a375=
25f915ed6
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-26T11:46:28.957847  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-26T11:46:28.958327  kern  :emerg : Process udevd (pid: 156, sta=
ck limit =3D 0x(ptrval))
    2023-01-26T11:46:28.958912  kern  :emerg : Stack: (0xc4e59da8 to 0xc4e5=
a000)
    2023-01-26T11:46:28.959258  kern  :emerg : 9da0:                   c243=
c880 c0a35490 00000000 c24420c0 c243c900 600e4996
    2023-01-26T11:46:28.959583  kern  :emerg : 9dc0: c22d2810 c22d2810 ffff=
fdfb 00000000 c1a78968 c1a78960 bf085024 0000001b
    2023-01-26T11:46:28.959878  kern  :emerg : 9de0: 00020000 c0a31454 0000=
0000 c22d2810 bf085024 c22d2854 bf085024 c243c838
    2023-01-26T11:46:29.000821  kern  :emerg : 9e00: c4e58000 0000017b 0002=
0000 c0a31a30 c22d2810 00000000 c22d2854 c0a31d20
    2023-01-26T11:46:29.001231  kern  :emerg : 9e20: bf085024 c22d2810 c0a3=
1d28 c4e58000 c243c838 c0a31d88 00000000 bf085024
    2023-01-26T11:46:29.001832  kern  :emerg : 9e40: c0a31d28 c0a2f3a8 c4e5=
8000 c2083858 c223d5b4 600e4996 bf085024 bf085024
    2023-01-26T11:46:29.002161  kern  :emerg : 9e60: c243c800 00000000 c19c=
7968 c0a306e0 bf084494 c1008dd8 bf085024 00000000 =

    ... (41 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d265563eddcba58e915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t=
-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t=
-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d265563eddcba58e915=
ebd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d26817ff7d73ffb7915ef5

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d26817ff7d73f=
fb7915efc
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-26T11:46:06.085283  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-26T11:46:06.085757  kern  :emerg : Process udevd (pid: 119, sta=
ck limit =3D 0x(ptrval))
    2023-01-26T11:46:06.085989  kern  :emerg : Stack: (0xc46cbda8 to 0xc46c=
c000)
    2023-01-26T11:46:06.086244  kern  :emerg : <8>[    7.682525] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
39>
    2023-01-26T11:46:06.086463  bda0:                   c3a7a080 c0a35490 0=
0000000 c7562300 c46e<8>[    7.697578] <LAVA_SIGNAL_ENDRUN 0_dmesg 3217073_=
1.5.2.4.1>
    2023-01-26T11:46:06.086675  4100 0bc4421a   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d26817ff7d73f=
fb7915efd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-26T11:46:06.032733  kern  :alert : 8<--- cut here ---
    2023-01-26T11:46:06.033208  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c213bc10
    2023-01-26T11:46:06.033442  kern  :alert : pgd =3D (ptrval)
    2023-01-26T11:46:06.036265  kern  :alert<8>[    7.635623] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-26T11:46:06.036522   : [c213bc10] *pgd=3D4201141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2657f27a0759029915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2=
-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2=
-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2657f27a0759029915=
ee1
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d2681511cda605ec915ebb

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d2681511cda60=
5ec915ec2
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-26T11:46:05.629515  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-26T11:46:05.630005  kern  :emerg : Process udevd (pid: 127, sta=
ck limit =3D 0x(ptrval))
    2023-01-26T11:46:05.630244  kern  :emerg : Stack: (0xc4063da8 to 0xc406=
4000)
    2023-01-26T11:46:05.630468  kern  :emerg : 3da0:                   c41e=
9b00 c0a35490 00000000 c3a62540 c3a7<8>[    8.670046] <LAVA_SIGNAL_TESTCASE=
 TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>
    2023-01-26T11:46:05.630688  0b00 dab66dad
    2023-01-26T11:46:05.630945  kern  :emerg : 3dc0: c227bc10 c227bc10 ffff=
fdfb 0<8>[    8.685309] <LAVA_SIGNAL_ENDRUN 0_dmesg 3217069_1.5.2.4.1>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d2681511cda60=
5ec915ec3
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-26T11:46:05.554066  kern  :alert : 8<--- cut here ---
    2023-01-26T11:46:05.554677  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227bc10
    2023-01-26T11:46:05.555036  kern  :alert : pgd =3D (ptrval)
    2023-01-26T11:46:05.557635  kern  :alert : [c227bc10] *pgd=3D4221141e(b=
ad<8>[    8.599153] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-26T11:46:05.558007  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d2656b27a0759029915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3=
-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d2656b27a0759029915=
eba
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d268905b7cdc9f25915ecc

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d268905b7cdc9=
f25915ed4
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-26T11:48:08.037835  kern  :alert : 8<--- cut here ---
    2023-01-26T11:48:08.043293  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227b810
    2023-01-26T11:48:08.052506  kern  :ale<8>[   14.742058] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d268905b7cdc9=
f25915ed5
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-26T11:48:08.058865  rt : pgd =3D (ptrval)
    2023-01-26T11:48:08.059244  kern  :alert : [c227b810] *pgd=3D4221141e(b=
ad)
    2023-01-26T11:48:08.077715  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-26T11:48:08.088647  kern  :emerg : Process udevd (pid: 126, sta=
ck limit =3D 0x(ptrval))
    2023-01-26T11:48:08.092427  k<8>[   14.781936] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d265c0da41a6e6ce915ef3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-o=
rangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d265c0da41a6e6ce915=
ef4
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d268925b7cdc9f25915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r=
40-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r=
40-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d268925b7cdc9f25915=
ed8
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d265d4345f342c89915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-=
bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-77-g4600242c13ed/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-=
bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d265d4345f342c89915=
ebd
        failing since 1 day (last pass: v5.10.162-950-g7728aa131bf4, first =
fail: v5.10.162-1026-gd21c032a492a) =

 =20
