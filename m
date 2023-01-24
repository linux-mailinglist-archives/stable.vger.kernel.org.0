Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078AC67A35B
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbjAXTr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbjAXTr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:47:27 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1471CF59
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 11:47:22 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id b6so11997006pgi.7
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 11:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kAY6VGf4PMfFLV9gWS00qKgp6sHb86nFPg9mwI3H6T0=;
        b=Mryh0V3VZfV60cz/R3pUqyttIazrp4jrmaSwiuth2Ca6NAqWVNmOOMhhD/FSSU2kb5
         ndaVT9+CQDzXv5geEUeSSPI4lnYMU5ft6Mz7EXIVO0NLT+SczDdJQCkOusAp5nbqk4hO
         34Y5CcDkvxxgFykQBB4QpPlOkTjDAC+28e9rEw+0JsgFkCXhN6A4sOK/3hKw+i9vdOdp
         XnupqJpismOJiTyHryOtcD9Ek5Scrzj+/Woauvmn3av56C4NPK2zvPYk/Lw3NyrxO/cW
         OCvXSPRoKt17O2315+YJETZ2i1kgw0rlOqmo/pJ+xyWS4NOMUUV3h7zuW8woT+23hytu
         xfZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kAY6VGf4PMfFLV9gWS00qKgp6sHb86nFPg9mwI3H6T0=;
        b=j2QfmW6ku6cA7L6b05ibASLz4RisTQ4b2CaTN0P1UzaoKDCCUmtt2AhZP7ZKmLBV7y
         yZf5915yRs3CDRaWBW2/T5RfaboTp9xsyTyWmJn4cWJe5PO2OBnwk6lWjZqmp99FHbtZ
         16bQ8ob54dO1egh9P75ze/q3Z4qO/iDp3w0hO5ibIKVPYwJXF4bi5NWOdX1+DNWKLxib
         Wb5ZFoEhzoRbmLu+XPzL41mA1ACk+QqPvq0iDep8eGonJFMpxEJ1nu5FN6K5PLILt5E7
         DfAAz0MvRGyp8EsC/INdiix34hgZiiUA5POrmmp3PmImebkIGQU/NtnXOK/oGqxCxH8h
         IvoQ==
X-Gm-Message-State: AFqh2kovqCx9+UDfZ8gc+SpPYG74f+vcBFireLwsEuOssnsdBs4ijGC/
        FgqJ4cmzTxw+DtiTvNmW86Y4J/aQztPtetdrmA4=
X-Google-Smtp-Source: AMrXdXvLBKzGA8SS3h9MlNEVn8R8R3qvD7qYrfVNklXWxzN83OmZwwucii3C9Ix+koHTudPkSjIgPQ==
X-Received: by 2002:a05:6a00:3495:b0:58d:d7b6:cf58 with SMTP id cp21-20020a056a00349500b0058dd7b6cf58mr31307661pfb.7.1674589640991;
        Tue, 24 Jan 2023 11:47:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n22-20020aa79056000000b0058d9b68042fsm2064692pfo.14.2023.01.24.11.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 11:47:20 -0800 (PST)
Message-ID: <63d035c8.a70a0220.3af81.3ffe@mx.google.com>
Date:   Tue, 24 Jan 2023 11:47:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.228-746-g2ac15b81a26b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 141 runs,
 84 regressions (v5.4.228-746-g2ac15b81a26b)
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

stable-rc/queue/5.4 baseline: 141 runs, 84 regressions (v5.4.228-746-g2ac15=
b81a26b)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig         | 2          =

at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =

at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 2          =

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

hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

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

meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
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

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =

sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =

sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.228-746-g2ac15b81a26b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.228-746-g2ac15b81a26b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ac15b81a26b26afe49d38cb041a8e4e2810b6e3 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
am57xx-beagle-x15            | arm   | lab-linaro-lkft | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d000873b8f6b82c9915eda

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am5=
7xx-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-linaro-lkft/baseline-am5=
7xx-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.all-cpus-are-online: https://kernelci.org/test/case/id/=
63d000873b8f6b82c9915ede
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)

    2023-01-24T15:59:53.663876  <8>[   22.810001] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddeferred-probe-empty RESULT=3Dfail>
    2023-01-24T15:59:54.713647  /lava-6090927/1/../bin/lava-test-case
    2023-01-24T15:59:54.714224  <8>[   23.844581] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dfail>   =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63d000873b8f6b82=
c9915ee1
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        1 lines

    2023-01-24T15:59:51.509976  / # =

    2023-01-24T15:59:51.519347  =

    2023-01-24T15:59:51.624071  / # #
    2023-01-24T15:59:51.631178  #
    2023-01-24T15:59:51.732927  / # export SHELL=3D/bin/sh
    2023-01-24T15:59:51.743042  export SHELL=3D/bin/sh
    2023-01-24T15:59:51.844518  / # . /lava-6090927/environment
    2023-01-24T15:59:51.854847  . /lava-6090927/environment
    2023-01-24T15:59:51.956331  / # /lava-6090927/bin/lava-test-runner /lav=
a-6090927/0
    2023-01-24T15:59:51.966689  /lava-6090927/bin/lava-test-runner /lava-60=
90927/0 =

    ... (8 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | at91_dt=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffceb9115b44d57915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffceb9115b44d57915=
ed9
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
at91sam9g20ek                | arm   | lab-broonie     | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff81371eca97a2915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff81371eca97a2915=
ec6
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 2          =


  Details:     https://kernelci.org/test/plan/id/63cfffa6b32097118b915eca

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63cfffa6b320971=
18b915ed1
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        26 lines

    2023-01-24T15:56:05.456400  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T15:56:05.461744  kern  :emerg : Process udevd (pid: 98, stac=
k limit =3D 0x(ptrval))
    2023-01-24T15:56:05.467605  kern  :emerg : Stack: (0xc986fd48 to 0xc987=
0000)
    2023-01-24T15:56:05.484237  kern  :emerg : fd40:                   c995=
2e80 c06226e4 00000000 c9994680<8>[   23.988372] <LAVA_SIGNAL_TESTCASE TEST=
_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D26>
    2023-01-24T15:56:05.484957   c9952d00 f791228d   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63cfffa6b320971=
18b915ed2
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        4 lines

    2023-01-24T15:56:05.392471  kern  :alert : 8<--- cut here ---
    2023-01-24T15:56:05.398024  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ce20e810
    2023-01-24T15:56:05.403605  kern  :alert : pgd =3D (ptrval)
    2023-01-24T15:56:05.409595  kern  :alert : [ce20e810] *pgd=3D8e20041e(b=
ad)
    2023-01-24T15:56:05.415830  <8>[   23.924468] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d00238e493093e9d915ebb

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d00238e493093=
e9d915ec2
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        41 lines

    2023-01-24T16:07:07.940630  kern  :alert : 8<--- cut here ---
    2023-01-24T16:07:07.946992  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee5de000
    2023-01-24T16:07:07.947698  kern  :alert : pgd =3D (ptrval)
    2023-01-24T16:07:07.952855  kern  :alert : [ee5de000] *pgd=3D6e41141e(b=
ad)
    2023-01-24T16:07:07.969550  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T16:07:07.975123  kern  :emerg : Process udevd (pid: 101, sta=
ck limit =3D 0x(ptrval))
    2023-01-24T16:07:07.980586  kern  :emerg : Stack: (0xed62dd88 to 0xed62=
e000)
    2023-01-24T16:07:07.991840  kern  :emerg : <8>[   37.583835] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
41>   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d00238e493093=
e9d915ec3
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        8 lines

    2023-01-24T16:07:07.912683  kern  :alert : 8<--- cut here ---
    2023-01-24T16:07:07.918361  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee16c010
    2023-01-24T16:07:07.923916  kern  :alert : pgd =3D (ptrval)
    2023-01-24T16:07:07.935181  kern  :alert : [ee16c010] *pgd=3D6e01141e(b=
ad<8>[   37.524279] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D8>
    2023-01-24T16:07:07.935844  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
cubietruck                   | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff38d89c3fba0a915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruc=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-cubietruc=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff38d89c3fba0a915=
ecb
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | davinci=
_all_defconfig      | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffccfc9bdfa5373915ee7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffccfc9bdfa5373915=
ee8
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
da850-lcdk                   | arm   | lab-baylibre    | gcc-10   | multi_v=
5_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe85b116ea7223915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-=
lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v5_defconfig/gcc-10/lab-baylibre/baseline-da850-=
lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe85b116ea7223915=
ed1
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
dove-cubox                   | arm   | lab-pengutronix | gcc-10   | mvebu_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002821be519cc51915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dov=
e-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/mvebu_v7_defconfig/gcc-10/lab-pengutronix/baseline-dov=
e-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002821be519cc51915=
ec9
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
fsl-ls1088a-rdb              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 2          =


  Details:     https://kernelci.org/test/plan/id/63cfff46b307a0afd6915ec4

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63cfff46b307a0a=
fd6915ecc
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        11 lines

    2023-01-24T15:54:24.403992  kern  :alert : Unable to handle kernel NULL=
 poin[   13.953881] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D11>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63cfff46b307a0a=
fd6915ecd
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        2 lines

    2023-01-24T15:54:24.407717  ter dereference at virtual address 00000000=
00000000
    2023-01-24T15:54:24.407971  kern  :alert : Mem abort info:
    2023-01-24T15:54:24.413398  kern  :alert :   ESR =3D 0x96000006
    2023-01-24T15:54:24.424358  kern  :a[   13.973324] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffd0cba8bbe899b915ec9

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/63cffd0cba8bbe89=
9b915ed2
        failing since 97 days (last pass: v5.4.219-270-gde284a6cd1e4, first=
 fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-01-24T15:44:55.928341  / # =

    2023-01-24T15:44:55.928931  =

    2023-01-24T15:44:57.995891  / # #
    2023-01-24T15:44:57.996917  #
    2023-01-24T15:45:00.008853  / # export SHELL=3D/bin/sh
    2023-01-24T15:45:00.009663  export SHELL=3D/bin/sh
    2023-01-24T15:45:02.024073  / # . /lava-3201628/environment
    2023-01-24T15:45:02.024453  . /lava-3201628/environment
    2023-01-24T15:45:04.040679  / # /lava-3201628/bin/lava-test-runner /lav=
a-3201628/0
    2023-01-24T15:45:04.042579  /lava-3201628/bin/lava-test-runner /lava-32=
01628/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6dl-riotboard             | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d00053a50cd77821915ef2

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6dl-riotboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d00053a50cd77=
821915ef9
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        25 lines

    2023-01-24T15:59:08.211575  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T15:59:08.229677  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0x(ptrval))[    7.863960] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=
=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D25>
    2023-01-24T15:59:08.229886     =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d00053a50cd77=
821915efa
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        4 lines

    2023-01-24T15:59:08.170913  kern  :alert : 8<--- cut here ---
    2023-01-24T15:59:08.179751  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eea69420
    2023-01-24T15:59:08.187421  kern  :a[    7.823262] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-24T15:59:08.187687  lert : pgd =3D (ptrval)
    2023-01-24T15:59:08.187822  kern  :alert : [eea69420] *pgd=3D3ea0041e(b=
ad)   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d000b67db10a1234915ee4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d000b67db10a1234915=
ee5
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6qp-wandboard-revd1       | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d00052177c5af2dc915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6qp-wandboard-revd1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d00052177c5af2dc915=
ed9
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63d000e0bad66ce28d915f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d000e0bad66ce28d915=
f22
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx7d-sdb                    | arm   | lab-nxp         | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d00081ce29e2d19a915f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d00081ce29e2d19a915=
f1a
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d0165b0b31d3d712915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0165b0b31d3d712915=
ec0
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff0f9a6d8d6579915ee0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff0f9a6d8d6579915=
ee1
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d001427b8557144c915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d001427b8557144c915=
ec3
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
jetson-tk1                   | arm   | lab-baylibre    | gcc-10   | tegra_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d000fbcb058ceea5915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d000fbcb058ceea5915=
edd
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-sei510            | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffed943af78c7be915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-se=
i510.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffed943af78c7be915=
ec3
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-u200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff10d38dba62d7915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-u2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff10d38dba62d7915=
ecf
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12a-x96-max           | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff13c29ea34f15915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-x9=
6-max.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff13c29ea34f15915=
ecd
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffff492fb8c9ed8915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffff492fb8c9ed8915=
ec9
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffff887a62c184f915ec2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a=
311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffff887a62c184f915=
ec3
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-g12b-odroid-n2         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff50200fe21604915ec8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff50200fe21604915=
ec9
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxbb-p200              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d0051171c7e415ee915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0051171c7e415ee915=
edf
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff12d57fe6d7bb915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff12d57fe6d7bb915=
eba
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff4b091f263125915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff4b091f263125915=
ed0
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff18b07dee2e95915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff18b07dee2e95915=
eba
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff24d57fe6d7bb915ecf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-meson-gxl-s905x=
-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff24d57fe6d7bb915=
ed0
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-khadas-vim2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffefd39a413ecab915efa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kha=
das-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffefd39a413ecab915=
efb
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-gxm-q200               | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d02983bd22f1705c915ebc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d02983bd22f1705c915=
ebd
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-khadas-vim3l       | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff3aead81c51ad915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-kha=
das-vim3l.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff3aead81c51ad915=
ebe
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson-sm1-sei610             | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffedb0087d5a1cb915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-sm1-sei=
610.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffedb0087d5a1cb915=
ecf
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
meson8b-odroidc1             | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d00066ce29e2d19a915ef4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meson8=
b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d00066ce29e2d19a915=
ef5
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe89b116ea7223915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-=
xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe89b116ea7223915=
edd
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d000b1a9445ffdda915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroi=
d-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d000b1a9445ffdda915=
ebb
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d000145de5fda781915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d000145de5fda781915=
ed5
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002d15a509a19a9915efb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002d15a509a19a9915=
efc
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffffc87a62c184f915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffffc87a62c184f915=
ec6
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002a41cdb6f046e915ec0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002a41cdb6f046e915=
ec1
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d00015dc0d839beb915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d00015dc0d839beb915=
edd
        failing since 259 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002d45c9de7366c915ec1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002d45c9de7366c915=
ec2
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002a6d19d47f42f915eb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002a6d19d47f42f915=
eba
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d00017aef6882375915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d00017aef6882375915=
ebb
        failing since 259 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002d75c9de7366c915ec6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002d75c9de7366c915=
ec7
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002a7d19d47f42f915ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002a7d19d47f42f915=
ec0
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63d000137a9b1414b6915ecd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d000137a9b1414b6915=
ece
        failing since 259 days (last pass: v5.4.191-77-g1a3b249e415b, first=
 fail: v5.4.191-125-g5917d1547e6e) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre    | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002d585bb077e90915edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002d585bb077e90915=
edd
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d0029fd56efbed1f915ece

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d0029fd56efbed1f915=
ecf
        failing since 182 days (last pass: v5.4.180-77-g7de29e82b9db, first=
 fail: v5.4.207-73-ga2480f1b1dda1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/63d002f8cfa4dc8428915ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d002f8cfa4dc8428915=
ed5
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-bananapi-m64      | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff208baec0fc4c915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff208baec0fc4c915=
ebb
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-a64-pine64-plus       | arm64 | lab-broonie     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffeed52f1a51d3d915ed8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pin=
e64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffeed52f1a51d3d915=
ed9
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-3         | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffff81551bb2ceb915ed5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orang=
epi-3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orang=
epi-3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffff81551bb2ceb915=
ed6
        new failure (last pass: v5.4.228-622-ge3f2d3701743) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-orangepi-one-plus  | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cfff80b9719c6d87915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orang=
epi-one-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-orang=
epi-one-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cfff80b9719c6d87915=
ec4
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-clabbe      | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffef639a413ecab915ede

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-=
h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-h6-pine-=
h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffef639a413ecab915=
edf
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun50i-h6-pine-h64           | arm64 | lab-collabora   | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffeff9a6d8d6579915ec3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm64/defconfig/gcc-10/lab-collabora/baseline-sun50i-h6-pi=
ne-h64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffeff9a6d8d6579915=
ec4
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun5i-a13-olinuxino-micro    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe9345284b7cf0915ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun5i-a13=
-olinuxino-micro.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe9345284b7cf0915=
ed4
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe710683978725915ecc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-cubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-cubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe710683978725915=
ecd
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-cubieboard2        | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe68145b76dad6915f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun7i-a20-c=
ubieboard2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe68145b76dad6915=
f1b
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun7i-a20-olinuxino-lime2    | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63d00e12a1356f69bd915eba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun7i-a20=
-olinuxino-lime2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d00e12a1356f69bd915=
ebb
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d000840c2019c8cd915f1b

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a3=
3-olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d000840c2019c=
8cd915f23
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        4 lines

    2023-01-24T15:59:39.788591  kern  :alert : 8<--- cut here ---
    2023-01-24T15:59:39.789005  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9ba810
    2023-01-24T15:59:39.789604  kern  :alert : pgd =3D (ptrval)
    2023-01-24T15:59:39.789938  kern  :alert : [ee9ba810] *pgd=3D6e81141e(b=
ad)
    2023-01-24T15:59:39.790307  <8>[   18.100729] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d000840c2019c=
8cd915f24
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        24 lines

    2023-01-24T15:59:39.863581  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T15:59:39.864018  kern  :emerg : Process udevd (pid: 110, sta=
ck limit =3D 0x(ptrval))
    2023-01-24T15:59:39.864610  kern  :emerg : Stack: (0xedcc9d88 to 0xedcc=
a000)
    2023-01-24T15:59:39.864923  kern  :emerg : <8>[   18.165037] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
24>
    2023-01-24T15:59:39.865263  9d80:                   ee935700 c098917c 0=
0000000 ee93a000 ee935780 09068ce6
    2023-01-24T15:59:39.865632  kern  :emerg : 9da0: ee832a80 ee9ba810 0000=
0000 c<8>[   18.184039] <LAVA_SIGNAL_ENDRUN 0_dmesg 384890_1.5.2.4.1>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a33-olinuxino          | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe7c145b76dad6915f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-o=
linuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a33-o=
linuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe7c145b76dad6915=
f23
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d0007c3b8f6b82c9915eca

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a8=
3t-bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a8=
3t-bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d0007c3b8f6b8=
2c9915ed2
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        8 lines

    2023-01-24T15:59:32.268007  kern  :alert : 8<--- cut here ---
    2023-01-24T15:59:32.268443  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee2b1c10
    2023-01-24T15:59:32.269036  kern  :alert : pgd =3D (ptrval)
    2023-01-24T15:59:32.269347  kern  :alert : [ee2b1c10] *pgd=3D6e21141e(b=
ad)
    2023-01-24T15:59:32.269663  kern  :alert : 8<--- cut here --[   44.2391=
25] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines =
MEASUREMENT=3D8>
    2023-01-24T15:59:32.269958  -
    2023-01-24T15:59:32.270266  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ed3f3c00
    2023-01-24T15:59:32.270550  kern  :alert : pgd =3D (ptrval)
    2023-01-24T15:59:32.270883  kern  :alert : [ed3f3c00] *pgd=3D6d21141e(b=
ad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d0007c3b8f6b8=
2c9915ed3
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        41 lines

    2023-01-24T15:59:32.316995  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T15:59:32.317695  kern  :emerg : Process udevd (pid: 156, sta=
ck limit =3D 0x(ptrval))
    2023-01-24T15:59:32.318043  kern  :emerg : Stack: (0xeb8a5d88 to 0xeb8a=
6000)
    2023-01-24T15:59:32.318348  kern  :em[   44.297771] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D41>
    2023-01-24T15:59:32.318669  erg : 5d80:                   ee386500 c098=
917c 00000000 ee38c00[   44.309556] <LAVA_SIGNAL_ENDRUN 0_dmesg 384888_1.5.=
2.4.1>
    2023-01-24T15:59:32.318965  0 ee386580 2390bc27   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-a83t-bananapi-m3       | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe4cb1d33fff76915ee3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-=
bananapi-m3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-a83t-=
bananapi-m3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe4cb1d33fff76915=
ee4
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d00078ce29e2d19a915f0d

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h2-plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d00078ce29e2d=
19a915f14
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        24 lines

    2023-01-24T15:59:35.284020  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T15:59:35.284495  kern  :emerg : Process udevd (pid: 124, sta=
ck limit =3D 0x(ptrval))
    2023-01-24T15:59:35.284730  kern  :emerg : Stack: (0xc42e5d88 to 0xc42e=
6000)
    2023-01-24T15:59:35.284987  kern  :emerg : <8>[    8.043589] <LAVA_SIGN=
AL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D=
24>
    2023-01-24T15:59:35.285207  5d80:                   c4475380 c098917c 0=
0000000 c39979c0 c3b7<8>[    8.058977] <LAVA_SIGNAL_ENDRUN 0_dmesg 3201740_=
1.5.2.4.1>
    2023-01-24T15:59:35.285423  2b00 6830fe27   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d00078ce29e2d=
19a915f15
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        4 lines

    2023-01-24T15:59:35.215209  kern  :alert : 8<--- cut here ---
    2023-01-24T15:59:35.215682  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address db19b010
    2023-01-24T15:59:35.215918  kern  :alert : pgd =3D (ptrval)
    2023-01-24T15:59:35.218825  kern  :alert : [db19b010] *pgd=3D5b01141e(b=
ad<8>[    7.981363] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-24T15:59:35.219097  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h2-plus...ch-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe60145b76dad6915f0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h2-=
plus-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe60145b76dad6915=
f0e
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d000650c2019c8cd915ecb

  Results:     4 PASS, 2 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d000650c2019c=
8cd915ed2
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        24 lines

    2023-01-24T15:59:24.265778  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T15:59:24.266036  kern  :emerg : Process udevd (pid: 110, sta=
ck limit =3D 0x(ptrval))
    2023-01-24T15:59:24.266483  kern  :emerg : Stack: (0xede8bd88 to 0xede8=
c000)
    2023-01-24T15:59:24.266711  kern  :emerg : bd80:                   ed07=
7000 c098917c 00000000 ede3f0c<8>[    6.926231] <LAVA_SIGNAL_TESTCASE TEST_=
CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D24>
    2023-01-24T15:59:24.266927  0 eea0f600 228d1f66
    2023-01-24T15:59:24.267160  kern  :emerg : bda0: ee834980 eea23010 0000=
0000 c19e4ec8 fffffdfb c19e4ec4 bf116180 00000015   =


  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d000650c2019c=
8cd915ed3
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        4 lines

    2023-01-24T15:59:24.206748  kern  :alert : 8<--- cut here ---
    2023-01-24T15:59:24.207220  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address eea23010
    2023-01-24T15:59:24.207454  kern  :alert : pgd =3D (ptrval)
    2023-01-24T15:59:24.210299  kern  :alert : [eea23010] *pgd=3D6ea1141e(b=
ad<8>[    6.870359] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfai=
l UNITS=3Dlines MEASUREMENT=3D4>
    2023-01-24T15:59:24.210557  )   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre    | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffe5d0683978725915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-=
libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h3-=
libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffe5d0683978725915=
ec6
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 2          =


  Details:     https://kernelci.org/test/plan/id/63d000d4bad66ce28d915efb

  Results:     3 PASS, 3 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3=
-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/63d000d4bad66ce=
28d915f03
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        4 lines

    2023-01-24T16:01:02.598141  kern  :alert : 8<--- cut here ---
    2023-01-24T16:01:02.603638  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address ee9e2c10
    2023-01-24T16:01:02.612661  kern  :ale<8>[   15.347965] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/63d000d4bad66ce=
28d915f04
        new failure (last pass: v5.4.228-674-g4e406b22c6e0)
        24 lines

    2023-01-24T16:01:02.619172  rt : pgd =3D (ptrval)
    2023-01-24T16:01:02.619522  kern  :alert : [ee9e2c10] *pgd=3D6e81141e(b=
ad)
    2023-01-24T16:01:02.636698  kern  :emerg : Internal error: Oops: 800000=
0d [#1] SMP ARM
    2023-01-24T16:01:02.647556  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0x(ptrval))
    2023-01-24T16:01:02.651329  k<8>[   15.386467] <LAVA_SIGNAL_TESTCASE TE=
ST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D24>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-h3-orangepi-pc         | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffeb8f60286d9ad915f0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffeb8f60286d9ad915=
f0b
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63d000d6b4fc6caf43915eca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r4=
0-bananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r4=
0-bananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63d000d6b4fc6caf43915=
ecb
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sun8i-r40-bananapi-m2-ultra  | arm   | lab-clabbe      | gcc-10   | sunxi_d=
efconfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/63cffecc0087d5a1cb915ebd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-b=
ananapi-m2-ultra.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.228-7=
46-g2ac15b81a26b/arm/sunxi_defconfig/gcc-10/lab-clabbe/baseline-sun8i-r40-b=
ananapi-m2-ultra.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63cffecc0087d5a1cb915=
ebe
        new failure (last pass: v5.4.228-674-g4e406b22c6e0) =

 =20
