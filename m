Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA23167F8D3
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 15:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjA1Ovk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 09:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjA1Ovj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 09:51:39 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534F02A985
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 06:51:35 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id g9so5078758pfo.5
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 06:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=we06u90oxwr9CaKqwx1BVNlSVZdOqGi2aTCW2huAVaQ=;
        b=6vcLCmwO3u/kvlBYn2OO5ZxWBZKPOh3ERCKzqm740hJTLb/07zsLVu3Cr2V88ExO/1
         qvkicQZEfXnBiU//QbASJyIgkzTCuGuUeqhfCBr5V0wjxhQz6cMsmF9I/006+QCbxY06
         Y1FiB5fdWyyzCAihyEcIiX7kygp5vhNoXOnup+Gp1gZeYiYOXmmHp6+YgOWcMVx8t5OR
         TL/wnt+/eMGbUjPRrO8gqD5mFMsHfWcrfhOzoVfyflLqAEifcXd8cE+t3MbujHM17rpp
         L9GmmFaImQEAHls1/8NniJdcdNXvw2tdrlxuiHYGlmXwgYvOuG9j2mJcWdkm+OOPzeS+
         lEnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=we06u90oxwr9CaKqwx1BVNlSVZdOqGi2aTCW2huAVaQ=;
        b=IUCMwHd9Hb4TEdXjMuKDeA/7A18+jgica3fctkapgwhehfoxI1cKp5uchxTmTt1RgP
         bM3K/LuUwtu9vq/4fxV8AOIQVFqSsL5efoj6Cw4H5a2ZQbXS180Azz0TlhBTV/3hmRGZ
         E7OjZUiorRc+CWL/8myEgdyQrPCKoGpn7XVlYoD4lKkvn6mBfJLDmHDSGDQ925IzfM3q
         03agLKuI7UDPCnrUxHTIfiFUihAWKwDAe+WATbVylqiuiuBOTEBu8nhW/ewNzVfu/Q1I
         64pBYgQ864O1tQti6jx7vAgROtAz81vtwO9J2hDpRR472gaDrOISWVP8gFIAerLvSDB9
         e9jA==
X-Gm-Message-State: AO0yUKWRiXcGzKqUo9YAZpX0dOp8K8V4s8ATUQa2NSEkxZCzEPPCbQ1Q
        OwbXFg+wmMqCY6pvJ1v3Q4SyNkYoNo9E4wK70FEvuQ==
X-Google-Smtp-Source: AK7set+CLNbsS8v6YGa2O8YSz1ejurE78Gi+4pMrpJfXZk4XDd4d7feBnXHgT0qdTv+QT7Fq8SA/Wg==
X-Received: by 2002:aa7:81c1:0:b0:590:68d6:5134 with SMTP id c1-20020aa781c1000000b0059068d65134mr10022010pfn.31.1674917493562;
        Sat, 28 Jan 2023 06:51:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7-20020a62f247000000b00589605fb0a1sm4505178pfl.96.2023.01.28.06.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 06:51:33 -0800 (PST)
Message-ID: <63d53675.620a0220.5be0b.7353@mx.google.com>
Date:   Sat, 28 Jan 2023 06:51:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.165-106-g8f8eaa34edb6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 164 runs,
 78 regressions (v5.10.165-106-g8f8eaa34edb6)
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

stable-rc/queue/5.10 baseline: 164 runs, 78 regressions (v5.10.165-106-g8f8=
eaa34edb6)

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

da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =

da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =

fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =

imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

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

meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
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

rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
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

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.165-106-g8f8eaa34edb6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.165-106-g8f8eaa34edb6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f8eaa34edb612d6a0de71d961931e4e289eb179 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5054fcb1065b6a1915ef1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-a=
m57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5054fcb1065b6a1915=
ef2
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d502dd8ab99a4836915ec7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-=
am57xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/omap2plus_defconfig/gcc-10/lab-linaro-lkft/baseline-=
am57xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d502dd8ab99a4836915=
ec8
        failing since 3 days (last pass: v5.10.162-950-g0ce90a11c205, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63d503baee5143f104915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d503baee5143f104915=
ec2
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d504bfa544f4b2ce915ef1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d504bfa544f4b2ce915=
ef2
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d522b9bcdd9c1b7a915ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rp=
i-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-bcm2711-rp=
i-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d522b9bcdd9c1b7a915=
ee9
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2711-rpi-4-b              | arm64 | lab-linaro-lkft | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5060ccd8ac4c288915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-linaro-lkft/baseline-bcm2711-=
rpi-4-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5060ccd8ac4c288915=
ec1
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50660687fcd03b2915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50660687fcd03b2915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d503b731fa9b4ff3915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d503b731fa9b4ff3915=
ed6
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50563c4c6bd0eaf915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50563c4c6bd0eaf915=
ebb
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beaglebone-black             | arm   | lab-broonie     | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d502f7789a2ab3af915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d502f7789a2ab3af915=
ec3
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 3          =


  Details:     https://kernelci.org/test/plan/id/63d50674687fcd03b2915ee0

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d50674687fcd03b2915ee5
        failing since 1 day (last pass: v5.10.165-76-g5c2e982fcf18, first f=
ail: v5.10.165-77-g4600242c13ed)

    2023-01-28T11:26:17.172281  d00 00000088 c20e2000 c200a400 c03626bc fff=
fe000 c1a1e506
    2023-01-28T11:26:17.177846  kern <8>[   38.638803] <LAVA_SIGNAL_ENDRUN =
0_dmesg 3233225_1.5.2.4.1>
    2023-01-28T11:26:17.183362   :emerg : 3f60: c20a1000 c2096300 c2096180 =
00000000 c20e2000 c0362658 c20a1000 c20d1e9c
    2023-01-28T11:26:17.194476  kern  :emerg : 3f80: c2096324 c036812c 0000=
0001 c2096180 c0367fe0 00000000 00000000 00000000
    2023-01-28T11:26:17.199846  kern  :emerg : 3fa0: 00000000 00000000 0000=
0000 c03001a8 00000000 00000000 00000000 00000000
    2023-01-28T11:26:17.211173  kern  :emerg : 3fc0: 00000000 00000000 0000=
0000 00000000 00000000 00000000 00000000 00000000
    2023-01-28T11:26:17.216721  kern  :emerg : 3fe0: 00000000 00000000 0000=
0000 00000000 00000013 00000000 00000000 00000000
    2023-01-28T11:26:17.227735  kern  :emerg : [<c0862710>] (devm_clk_relea=
se) from [<c0a35eb0>] (devres_release+0x24/0x4c)
    2023-01-28T11:26:17.233137  kern  :emerg : [<c0a35eb0>] (devres_release=
) from [<c0862940>] (devm_clk_put+0x1c/0x40)
    2023-01-28T11:26:17.244518  kern  :emerg : [<c0862940>] (devm_clk_put) =
from [<bf23a0b0>] (bcm_get_resources+0x174/0x21c [hci_uart]) =

    ... (36 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d50674687fcd0=
3b2915ee7
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-28T11:26:16.754328  kern  :alert : 8<--- cut here ---
    2023-01-28T11:26:16.760136  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c22aec00
    2023-01-28T11:26:16.760850  kern  :alert : pgd =3D (ptrval)
    2023-01-28T11:26:16.766749  kern  :alert : [c22aec00] *pgd=3D4221141e(b=
ad)
    2023-01-28T11:26:16.783873  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T11:26:16.789225  kern  :emerg : Process udevd (pid: 101, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T11:26:16.797652  kern  :emerg : Stack: (0xc3ddbda8 to 0xc3dd=
c000)
    2023-01-28T11:26:16.806092  kern  :emerg : bda0:                   c3eb=
b280 c0a35590 00000000 c397fc00 c3ebb280 8bf34fae
    2023-01-28T11:26:16.811495  kern  :emerg : bdc0: c2114410 c2114410 ffff=
fdfb 00000000 c1a78968 c1a78960 bf0ea024 00000011
    2023-01-28T11:26:16.822606  kern  :emerg : bde0: 00020000 c0a31554 0000=
0000 c2114410 bf0ea024 c2114454 bf0ea024 c3ebb238 =

    ... (44 line(s) more)  =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d50674687fcd0=
3b2915ee8
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-28T11:26:16.726752  kern  :alert : 8<--- cut here ---
    2023-01-28T11:26:16.732254  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2114410
    2023-01-28T11:26:16.737763  kern  :alert : pgd =3D (ptrval)
    2023-01-28T11:26:16.749045  kern  :alert<8>[   38.206943] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-28T11:26:16.749850   : [c2114410] *pgd=3D4201141e(bad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50367653f14f285915f33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietr=
uck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50367653f14f285915=
f34
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5046b44d0a37f5b915f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-d=
a850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-d=
a850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5046b44d0a37f5b915=
f1e
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d504d1c9fccdb36b915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da85=
0-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d504d1c9fccdb36b915=
ecf
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63d5054acb1065b6a1915eda

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d5054acb1065b=
6a1915ee2
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        11 lines

    2023-01-28T11:21:20.887125  kern  :alert : Unable to handle kernel NULL=
 poin[   15.646835] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d5054acb1065b=
6a1915ee3
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        2 lines

    2023-01-28T11:21:20.890979  ter dereference at virtual address 00000000=
00000000
    2023-01-28T11:21:20.891277  kern  :alert : Mem abort info:
    2023-01-28T11:21:20.896488  kern  :alert :   ESR =3D 0x96000006
    2023-01-28T11:21:20.907439  kern  :a[   15.667109] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx53-qsrb                   | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5064413ee50c35c915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5064413ee50c35c915=
ecc
        failing since 0 day (last pass: v5.10.157-95-g1114639f8dbf, first f=
ail: v5.10.165-101-ge99d4eb8a3bf) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d5052c30f7b87f9a915eb9

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d5052c30f7b87=
f9a915ec0
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        41 lines

    2023-01-28T11:21:11.704571  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T11:21:11.722547  kern  :emerg : Process udevd (pid: 112, sta=
ck limit =3D 0x(ptrval))[    9.617086] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-28T11:21:11.722822     =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d5052c30f7b87=
f9a915ec1
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-28T11:21:11.662738  kern  :alert : 8<--- cut here ---
    2023-01-28T11:21:11.671599  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c2291c20
    2023-01-28T11:21:11.679418  kern  :a[    9.574872] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-28T11:21:11.679587  lert : pgd =3D (ptrval)
    2023-01-28T11:21:11.679706  kern  :alert : [c2291c20] *pgd=3D1220041e(b=
ad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50554b1add7bce0915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50554b1add7bce0915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d506a83c03e4d777915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d506a83c03e4d777915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d504c4ebf5f9c966915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sd=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d504c4ebf5f9c966915=
ec6
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5055e6c9b7116a6915ef8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5055e6c9b7116a6915=
ef9
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d506b85817758057915eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d506b85817758057915=
eef
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mp-evk                   | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50536c61e01123b915f32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50536c61e01123b915=
f33
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5054beb1118ee69915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5054beb1118ee69915=
ebb
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d501c53ec8738d0f915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d501c53ec8738d0f915=
edf
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d504f63e4c639b5c915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
sei510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
sei510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d504f63e4c639b5c915=
ec1
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d505169165f4f295915ee1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
u200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
u200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d505169165f4f295915=
ee2
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5052196990cbee1915ec9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
x96-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-=
x96-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5052196990cbee1915=
eca
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d505661c42627a31915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d505661c42627a31915=
ebf
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50614cd8ac4c288915ed2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50614cd8ac4c288915=
ed3
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d504f5e7d02ec529915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-=
odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d504f5e7d02ec529915=
ebd
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50949591834b0a8915ebe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50949591834b0a8915=
ebf
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5061afac91cedef915ee6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5061afac91cedef915=
ee7
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d509755465d25f70915edf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d509755465d25f70915=
ee0
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d504f3e7d02ec529915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-s=
ei610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-s=
ei610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d504f3e7d02ec529915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5054acb1065b6a1915ee5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5054acb1065b6a1915=
ee6
        failing since 3 days (last pass: v5.10.162-950-g0ce90a11c205, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50579b1add7bce0915efe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8173-elm-hana.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-mt8173-elm-hana.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50579b1add7bce0915=
eff
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50254300ece7af7915efe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50254300ece7af7915=
eff
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5055f6ef76ab4a7915eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odr=
oid-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5055f6ef76ab4a7915=
eef
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-rock2-square          | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d505c32f08c9c6b3915edf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d505c32f08c9c6b3915=
ee0
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5108c3efd6c3b69915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5108c3efd6c3b69915=
edf
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5065666f470ba38915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5065666f470ba38915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-roc-pc                | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5061a5687afa0a8915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-rk3399-roc-pc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5061a5687afa0a8915=
ecc
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-rock-pi-4b            | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63d5052b96990cbee1915ed5

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-roc=
k-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-roc=
k-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d5052b96990cb=
ee1915edc
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        2 lines

    2023-01-28T11:20:54.430432  kern  :emerg : Internal error: Oops: 860000=
0f [#1] PREEMPT SMP
    2023-01-28T11:20:54.430964  kern  :emerg : Code: 00739e00 ffff0000 ffff=
ffff 00000000 (00739e00) =

    2023-01-28T11:20:54.431315  <8>[   15.856700] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2023-01-28T11:20:54.431644  + set +x
    2023-01-28T11:20:54.431958  <8>[   15.859098] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 8912012_1.5.2.4.1>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d5052b96990cb=
ee1915edd
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-28T11:20:54.403453  kern  :alert : [ffff0000006fd410] pgd=3D000=
000007fff8003, p4d=3D000000007fff8003, pud=3D000000007fff7003, pmd=3D000000=
007fff4003, pte=3D00680000006fd707
    2023-01-28T11:20:54.403959  <8>[   15.834814] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun4i-a10-olinuxino-lime     | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5052596990cbee1915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun4i-a=
10-olinuxino-lime.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5052596990cbee1915=
ecd
        failing since 1 day (last pass: v5.10.157-95-g602512855c6c, first f=
ail: v5.10.165-77-g4600242c13ed) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5050fc6cb2785b9915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5050fc6cb2785b9915=
ed4
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5075504fdcc422c915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-=
pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5075504fdcc422c915=
ed1
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5054d6c9b7116a6915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5054d6c9b7116a6915=
ed8
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d506bab83606c318915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-h5-l=
ibretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d506bab83606c318915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h5-lib...ch-all-h3-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5053ac61e01123b915f38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-h5-li=
bretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5053ac61e01123b915=
f39
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50619cd8ac4c288915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-ora=
ngepi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-ora=
ngepi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50619cd8ac4c288915=
ed9
        failing since 3 days (last pass: v5.10.162-851-g33a0798ae8e3, first=
 fail: v5.10.162-1026-g401c1c1d3bf5) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50501e7d02ec529915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pin=
e-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50501e7d02ec529915=
ed8
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50510c6cb2785b9915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-=
pine-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50510c6cb2785b9915=
ed8
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d503bcee5143f104915ecb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a=
13-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d503bcee5143f104915=
ecc
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50369816a15459f915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50369816a15459f915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50357be80820067915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50357be80820067915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5043c2ee4ea910e915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a=
20-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5043c2ee4ea910e915=
eba
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d50573b1add7bce0915eeb

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a33-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d50573b1add7b=
ce0915ef3
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-28T11:22:11.889625  kern  :alert : 8<--- cut here ---
    2023-01-28T11:22:11.890076  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c21d6c10
    2023-01-28T11:22:11.890653  kern  :alert : pgd =3D (ptrval)
    2023-01-28T11:22:11.890990  kern  :alert : [c21d6c10] *pgd=3D4201141e(b=
ad)
    2023-01-28T11:22:11.891360  <8>[   18.485833] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d50573b1add7b=
ce0915ef4
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-28T11:22:11.949489  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T11:22:11.950214  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T11:22:11.950558  kern  :emerg : Stack: (0xc3bf5da8 to 0xc3bf=
6000)
    2023-01-28T11:22:11.950864  kern  :emerg : <8>[   18.539971] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
39>
    2023-01-28T11:22:11.951203  5da0:                   c3d8f000 c0a35590 0=
0000000 c217cd80 c3d8<8>[   18.552335] <LAVA_SIGNAL_ENDRUN 0_dmesg 387609_1=
.5.2.4.1>
    2023-01-28T11:22:11.951513  f080 074cef04   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5036b95c76b5e5f915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33=
-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5036b95c76b5e5f915=
ed8
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d5056d27f777999d915ede

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a83t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
a83t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d5056d27f7779=
99d915ee6
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        8 lines

    2023-01-28T11:22:09.145114  kern  :alert : 8<--- cut here ---
    2023-01-28T11:22:09.145968  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c22d2810
    2023-01-28T11:22:09.146398  kern  :alert : pgd =3D (ptrval)
    2023-01-28T11:22:09.146729  kern  :alert : [c22d2810] *pgd=3D4221141e(b=
ad)
    2023-01-28T11:22:09.147052  kern  :alert : 8<--- cut here --[   46.7605=
82] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines =
MEASUREMENT=3D8>
    2023-01-28T11:22:09.147352  -
    2023-01-28T11:22:09.147650  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c3bc2c00
    2023-01-28T11:22:09.147938  kern  :alert : pgd =3D (ptrval)
    2023-01-28T11:22:09.148331  kern  :alert : [c3bc2c00] *pgd=3D43a1141e(b=
ad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d5056d27f7779=
99d915ee7
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        73 lines

    2023-01-28T11:22:09.162277  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T11:22:09.204479  kern  :emerg : Process udevd (pid: 176, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T11:22:09.204868  kern  :emerg : Stack: (0xc5157da8 to 0xc515=
8000)
    2023-01-28T11:22:09.205220  kern  :emerg : 7da0:                   c224=
c500 c0a35590 00000000 c2487c00 c224c480 f92e0b73
    2023-01-28T11:22:09.205584  kern  :emerg : 7dc0: c22d2810 c22d2810 ffff=
fdfb 00000000 c1a78968 c1a78960 bf075024 0000001b
    2023-01-28T11:22:09.205905  kern  :emerg : 7de0: 00020000 c0a31554 0000=
0000 c22d2810 bf075024 c22d2854 bf075024 c224c338
    2023-01-28T11:22:09.206282  kern  :emerg : 7e00: c5156000 0000017b 0002=
0000 c0a31b30 c22d2810 00000000 c22d2854 c0a31e20
    2023-01-28T11:22:09.247490  kern  :emerg : 7e20: bf075024 c22d2810 c0a3=
1e28 c5156000 c224c338 c0a31e88 00000000 bf075024
    2023-01-28T11:22:09.247902  kern  :emerg : 7e40: c0a31e28 c0a2f4a8 c515=
6000 c2083858 c223d5b4 f92e0b73 bf075024 bf075024
    2023-01-28T11:22:09.248308  kern  :emerg : 7e60: c224c300 00000000 c19c=
7a28 c0a307e0 bf074494 ffffffff bf075024 00000000 =

    ... (41 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5035189dcd43ca6915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83=
t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5035189dcd43ca6915=
edf
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d5054d6c9b7116a6915ecc

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d5054d6c9b711=
6a6915ed3
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-28T11:21:27.424461  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T11:21:27.424998  kern  :emerg : Process udevd (pid: 118, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T11:21:27.425297  kern  :emerg : Stack: (0xc3f45da8 to 0xc3f4=
6000)
    2023-01-28T11:21:27.425573  kern  :emerg : <8>[    7.541326] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
39>
    2023-01-28T11:21:27.425838  5da0:                   c4844080 c0a35590 0=
0000000 c39c5540 c39b<8>[    7.556029] <LAVA_SIGNAL_ENDRUN 0_dmesg 3233242_=
1.5.2.4.1>
    2023-01-28T11:21:27.426119  9400 7f4d4ea8   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d5054d6c9b711=
6a6915ed4
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-28T11:21:27.349539  kern  :alert : 8<--- cut here ---
    2023-01-28T11:21:27.350088  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227bc10
    2023-01-28T11:21:27.350380  kern  :alert : pgd =3D (ptrval)
    2023-01-28T11:21:27.353159  kern  :alert : [c227bc10] *pgd=3D4221141e(b=
ad<8>[    7.477546] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-28T11:21:27.353462  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5034b89dcd43ca6915edb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5034b89dcd43ca6915=
edc
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d505c5fc31314fc1915ed9

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
h3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d505c5fc31314=
fc1915ee1
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        4 lines

    2023-01-28T11:23:21.412005  kern  :alert : 8<--- cut here ---
    2023-01-28T11:23:21.417504  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address c227b810
    2023-01-28T11:23:21.426734  kern  :ale<8>[   16.000748] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d505c5fc31314=
fc1915ee2
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a)
        39 lines

    2023-01-28T11:23:21.432905  rt : pgd =3D (ptrval)
    2023-01-28T11:23:21.433267  kern  :alert : [c227b810] *pgd=3D4221141e(b=
ad)
    2023-01-28T11:23:21.452087  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-28T11:23:21.462940  kern  :emerg : Process udevd (pid: 130, sta=
ck limit =3D 0x(ptrval))
    2023-01-28T11:23:21.466836  k<8>[   16.040733] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D39>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d503a7916048ec3f915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-=
orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d503a7916048ec3f915=
ed1
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d505c3fc31314fc1915ed6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
r40-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-=
r40-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d505c3fc31314fc1915=
ed7
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d503bbee5143f104915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40=
-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d503bbee5143f104915=
ec6
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50893d8f80e5f2c915ed7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d50893d8f80e5f2c915=
ed8
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
tegra124-nyan-big            | arm   | lab-collabora   | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5072bac04646627915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.165=
-106-g8f8eaa34edb6/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d5072bac04646627915=
ee1
        failing since 3 days (last pass: v5.10.162-950-g7728aa131bf4, first=
 fail: v5.10.162-1026-gd21c032a492a) =

 =20
